library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D is
generic(
	CONST_BITS: integer := 13;
	PASS1_BITS: integer := 2
);
port(
	signal clk: in std_logic;				-- CPU system clock (always required)
	signal reset: in std_logic;

	signal i_row0 : in std_logic_vector(15 downto 0);
	signal i_row1 : in std_logic_vector(15 downto 0);
	signal i_row2 : in std_logic_vector(15 downto 0);
	signal i_row3 : in std_logic_vector(15 downto 0);
	signal i_row4 : in std_logic_vector(15 downto 0);
	signal i_row5 : in std_logic_vector(15 downto 0);
	signal i_row6 : in std_logic_vector(15 downto 0);
	signal i_row7 : in std_logic_vector(15 downto 0);
	signal i_trigger_row : in std_logic;
	signal i_read_row : in std_logic;

	signal o_row0 : out std_logic_vector(15 downto 0);
	signal o_row1 : out std_logic_vector(15 downto 0);
	signal o_row2 : out std_logic_vector(15 downto 0);
	signal o_row3 : out std_logic_vector(15 downto 0);
	signal o_row4 : out std_logic_vector(15 downto 0);
	signal o_row5 : out std_logic_vector(15 downto 0);
	signal o_row6 : out std_logic_vector(15 downto 0);
	signal o_row7 : out std_logic_vector(15 downto 0);
	signal o_row_ready : out std_logic
);
end entity idct_2D;

architecture main of idct_2D is
	type row is array (0 to 7) of std_logic_vector(15 downto 0);
	type column is array(0 to 7) of std_logic_vector(15 downto 0);
	type blk is array(0 to 7) of row;
	type current_activity_state is (COMPUTING_ROWS,
		COMPUTING_COLUMNS, OUTPUTTING_ROWS);

	signal temp_block : blk;

	signal next_column_to_compute : unsigned (2 downto 0);

	signal state : unsigned (2 downto 0);
	signal count : unsigned (2 downto 0);
	signal processing_count : unsigned (3 downto 0);
	signal row_being_outputed : unsigned (2 downto 0);

	signal current_activity : current_activity_state;

	signal i0 : std_logic_vector(15 downto 0);
	signal i1 : std_logic_vector(15 downto 0);
	signal i2 : std_logic_vector(15 downto 0);
	signal i3 : std_logic_vector(15 downto 0);
	signal i4 : std_logic_vector(15 downto 0);
	signal i5 : std_logic_vector(15 downto 0);
	signal i6 : std_logic_vector(15 downto 0);
	signal i7 : std_logic_vector(15 downto 0);

	signal o0 : std_logic_vector(15 downto 0);
	signal o1 : std_logic_vector(15 downto 0);
	signal o2 : std_logic_vector(15 downto 0);
	signal o3 : std_logic_vector(15 downto 0);
	signal o4 : std_logic_vector(15 downto 0);
	signal o5 : std_logic_vector(15 downto 0);
	signal o6 : std_logic_vector(15 downto 0);
	signal o7 : std_logic_vector(15 downto 0);

	signal internal_reset : std_logic;
	signal pass : std_logic;
begin

	--
	-- 1D IDCT entity
	--
	i1d : entity work.idct_1D(a_idct_1D)
	port map (
		clk => clk,
		pass => pass,

		i0 => i0,
		i1 => i1,
		i2 => i2,
		i3 => i3,
		i4 => i4,
		i5 => i5,
		i6 => i6,
		i7 => i7,

		o0 => o0,
		o1 => o1,
		o2 => o2,
		o3 => o3,
		o4 => o4,
		o5 => o5,
		o6 => o6,
		o7 => o7
	);

	--
	-- State
	--
	process
	begin
		wait until rising_edge(clk);

		if (internal_reset = '1') then
			state <= (others => '0');
		else
			state(2 downto 1) <= state(1 downto 0);

			if ((processing_count /= 8)
				AND (((i_trigger_row = '1') AND (current_activity = COMPUTING_ROWS))
					OR (current_activity = COMPUTING_COLUMNS))) then
				state(0) <= '1';
			else
				state(0) <= '0';
			end if;
		end if;
	end process;

	--
	-- Count of IDCT 1D outputting CALCULATED values (DONE going through the)
	-- IDCT 1D module
	--
	process
	begin
		wait until rising_edge(clk);

		if (internal_reset = '1') then
			count <= to_unsigned(7, count'length);
		elsif (state(1) = '1') then
			count <= count + 1;
		end if;
	end process;

	--
	--
	--
	process
	begin
		wait until rising_edge(clk);

		if ((internal_reset = '1') OR ((count = 7) AND (state(2) = '1'))) then
			processing_count <= to_unsigned(0, processing_count'length);
		elsif ((processing_count /= 8)
			AND ((i_trigger_row = '1' and current_activity = COMPUTING_ROWS)
				OR (current_activity = COMPUTING_COLUMNS))) then
			processing_count <= processing_count + 1;
		end if;
	end process;

	--
	-- Current Activity
	--
	process
	begin
		wait until rising_edge(clk);

		if (internal_reset = '1') then
			-- By default first thing to do is the rows
			current_activity <= COMPUTING_ROWS;
		elsif ((count = 7) AND (state(2) = '1')) then
			-- After 8 rows or columns update activity
			if (current_activity = COMPUTING_COLUMNS) then
				current_activity <= OUTPUTTING_ROWS;
			else
				current_activity <= COMPUTING_COLUMNS;
			end if;
		end if;
	end process;

	--
	-- Next column to compute
	--
	process
	begin
		wait until rising_edge(clk);

		if (internal_reset = '1') then
			-- By default first thing to do is the rows
			next_column_to_compute <= to_unsigned(0,
				next_column_to_compute'length);
		elsif (current_activity = COMPUTING_COLUMNS) then
			next_column_to_compute <= next_column_to_compute + 1;
		end if;
	end process;

	--
	-- Input to 1D IDCT
	--
	i0 <= i_row0 when (current_activity = COMPUTING_ROWS)
		else temp_block(0)(to_integer(processing_count(2 downto 0)));
	i1 <= i_row1 when (current_activity = COMPUTING_ROWS)
		else temp_block(1)(to_integer(processing_count(2 downto 0)));
	i2 <= i_row2 when (current_activity = COMPUTING_ROWS)
		else temp_block(2)(to_integer(processing_count(2 downto 0)));
	i3 <= i_row3 when (current_activity = COMPUTING_ROWS)
		else temp_block(3)(to_integer(processing_count(2 downto 0)));
	i4 <= i_row4 when (current_activity = COMPUTING_ROWS)
		else temp_block(4)(to_integer(processing_count(2 downto 0)));
	i5 <= i_row5 when (current_activity = COMPUTING_ROWS)
		else temp_block(5)(to_integer(processing_count(2 downto 0)));
	i6 <= i_row6 when (current_activity = COMPUTING_ROWS)
		else temp_block(6)(to_integer(processing_count(2 downto 0)));
	i7 <= i_row7 when (current_activity = COMPUTING_ROWS)
		else temp_block(7)(to_integer(processing_count(2 downto 0)));

	--
	-- Output from 1D IDCT
	--
	process
	begin
		wait until rising_edge(clk);

		if ((state(2) = '1') AND (current_activity = COMPUTING_ROWS)) then
			temp_block(to_integer(count))(0) <= o0;
			temp_block(to_integer(count))(1) <= o1;
			temp_block(to_integer(count))(2) <= o2;
			temp_block(to_integer(count))(3) <= o3;
			temp_block(to_integer(count))(4) <= o4;
			temp_block(to_integer(count))(5) <= o5;
			temp_block(to_integer(count))(6) <= o6;
			temp_block(to_integer(count))(7) <= o7;
		elsif ((state(2) = '1')
			AND (current_activity = COMPUTING_COLUMNS)) then
			temp_block(0)(to_integer(count)) <= o0;
			temp_block(1)(to_integer(count)) <= o1;
			temp_block(2)(to_integer(count)) <= o2;
			temp_block(3)(to_integer(count)) <= o3;
			temp_block(4)(to_integer(count)) <= o4;
			temp_block(5)(to_integer(count)) <= o5;
			temp_block(6)(to_integer(count)) <= o6;
			temp_block(7)(to_integer(count)) <= o7;
		end if;
	end process;

	--
	-- Outputs
	--
	--
	-- Update row to be flushed
	--
	process
	begin
		wait until rising_edge(clk);

		if (current_activity /= OUTPUTTING_ROWS) then
			row_being_outputed <= to_unsigned(0, row_being_outputed'length);
		elsif (i_read_row = '1') then
			row_being_outputed <= row_being_outputed + 1;
		end if;
	end process;

	o_row_ready <= '1' when (current_activity = OUTPUTTING_ROWS) else '0';

	o_row0 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(0);
	o_row1 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(1);
	o_row2 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(2);
	o_row3 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(3);
	o_row4 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(4);
	o_row5 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(5);
	o_row6 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(6);
	o_row7 <= temp_block(to_integer(row_being_outputed(2 downto 0)))(7);


	internal_reset <= '1' when (reset = '0' OR (row_being_outputed = 7)) else '0';
	pass <= '1' when (current_activity = COMPUTING_COLUMNS) else '0';

end architecture main;
