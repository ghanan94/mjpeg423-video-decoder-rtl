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
	type current_activity_states is (COMPUTING_ROWS,
		COMPUTING_COLUMNS, OUTPUTTING_ROWS);

	signal temp_block : blk;

	signal idct_1d_pineline_tracker : unsigned (2 downto 0);
	signal done_processing_count : unsigned (2 downto 0);
	signal started_processing_count : unsigned (3 downto 0);
	signal current_activity : current_activity_states;

	signal idct_1d_i0 : std_logic_vector(15 downto 0);
	signal idct_1d_i1 : std_logic_vector(15 downto 0);
	signal idct_1d_i2 : std_logic_vector(15 downto 0);
	signal idct_1d_i3 : std_logic_vector(15 downto 0);
	signal idct_1d_i4 : std_logic_vector(15 downto 0);
	signal idct_1d_i5 : std_logic_vector(15 downto 0);
	signal idct_1d_i6 : std_logic_vector(15 downto 0);
	signal idct_1d_i7 : std_logic_vector(15 downto 0);

	signal idct_1d_o0 : std_logic_vector(15 downto 0);
	signal idct_1d_o1 : std_logic_vector(15 downto 0);
	signal idct_1d_o2 : std_logic_vector(15 downto 0);
	signal idct_1d_o3 : std_logic_vector(15 downto 0);
	signal idct_1d_o4 : std_logic_vector(15 downto 0);
	signal idct_1d_o5 : std_logic_vector(15 downto 0);
	signal idct_1d_o6 : std_logic_vector(15 downto 0);
	signal idct_1d_o7 : std_logic_vector(15 downto 0);

	signal internal_reset : std_logic;
	signal pass : std_logic;
	signal idct_1d_done : std_logic;
	signal idct_1d_almost_done : std_logic;
begin

	--
	-- 1D IDCT entity
	--
	i1d : entity work.idct_1D(a_idct_1D)
	port map (
		clk => clk,
		pass => pass,

		i0 => idct_1d_i0,
		i1 => idct_1d_i1,
		i2 => idct_1d_i2,
		i3 => idct_1d_i3,
		i4 => idct_1d_i4,
		i5 => idct_1d_i5,
		i6 => idct_1d_i6,
		i7 => idct_1d_i7,

		o0 => idct_1d_o0,
		o1 => idct_1d_o1,
		o2 => idct_1d_o2,
		o3 => idct_1d_o3,
		o4 => idct_1d_o4,
		o5 => idct_1d_o5,
		o6 => idct_1d_o6,
		o7 => idct_1d_o7
	);

	--
	-- IDCT 1D Pineline tracker
	--
	process
	begin
		wait until rising_edge(clk);

		if (internal_reset = '1') then
			idct_1d_pineline_tracker <= (others => '0');
		else
			idct_1d_pineline_tracker(2 downto 1) <= idct_1d_pineline_tracker(1 downto 0);

			if ((started_processing_count /= 8)
				AND (((i_trigger_row = '1') AND (current_activity = COMPUTING_ROWS))
					OR (current_activity = COMPUTING_COLUMNS))) then
				idct_1d_pineline_tracker(0) <= '1';
			else
				idct_1d_pineline_tracker(0) <= '0';
			end if;
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
		elsif ((done_processing_count = 7) AND (idct_1d_done = '1')) then
			-- After 8 rows or columns update activity

			--
			-- No need to set to COMPUTING_ROWS because when we are done
			-- outputting rows, internal_reset will be asserted (which sets
			--  current_activity to COMPUTING_ROWS)
			--
			if (current_activity = COMPUTING_COLUMNS) then
				current_activity <= OUTPUTTING_ROWS;
			else
				current_activity <= COMPUTING_COLUMNS;
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
			done_processing_count <= to_unsigned(7, done_processing_count'length);
		elsif (idct_1d_almost_done = '1') then
			done_processing_count <= done_processing_count + 1;
		end if;
	end process;

	--
	--
	--
	process
	begin
		wait until rising_edge(clk);

		if ((internal_reset = '1')
			OR ((done_processing_count = 7) AND (idct_1d_done = '1'))) then
			started_processing_count <= to_unsigned(0, started_processing_count'length);
		elsif ((started_processing_count /= 8)
			AND ((i_trigger_row = '1' and current_activity = COMPUTING_ROWS)
				OR (current_activity = COMPUTING_COLUMNS)
				OR ((current_activity = OUTPUTTING_ROWS) AND (i_read_row = '1')))) then
			started_processing_count <= started_processing_count + 1;
		end if;
	end process;

	--
	-- Input to 1D IDCT
	--
	idct_1d_i0 <= i_row0 when (current_activity = COMPUTING_ROWS)
		else temp_block(0)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i1 <= i_row1 when (current_activity = COMPUTING_ROWS)
		else temp_block(1)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i2 <= i_row2 when (current_activity = COMPUTING_ROWS)
		else temp_block(2)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i3 <= i_row3 when (current_activity = COMPUTING_ROWS)
		else temp_block(3)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i4 <= i_row4 when (current_activity = COMPUTING_ROWS)
		else temp_block(4)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i5 <= i_row5 when (current_activity = COMPUTING_ROWS)
		else temp_block(5)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i6 <= i_row6 when (current_activity = COMPUTING_ROWS)
		else temp_block(6)(to_integer(started_processing_count(2 downto 0)));
	idct_1d_i7 <= i_row7 when (current_activity = COMPUTING_ROWS)
		else temp_block(7)(to_integer(started_processing_count(2 downto 0)));

	--
	-- Output from 1D IDCT
	--
	process
	begin
		wait until rising_edge(clk);

		if ((idct_1d_done = '1')
			AND (current_activity = COMPUTING_ROWS)) then
			temp_block(to_integer(done_processing_count))(0) <= idct_1d_o0;
			temp_block(to_integer(done_processing_count))(1) <= idct_1d_o1;
			temp_block(to_integer(done_processing_count))(2) <= idct_1d_o2;
			temp_block(to_integer(done_processing_count))(3) <= idct_1d_o3;
			temp_block(to_integer(done_processing_count))(4) <= idct_1d_o4;
			temp_block(to_integer(done_processing_count))(5) <= idct_1d_o5;
			temp_block(to_integer(done_processing_count))(6) <= idct_1d_o6;
			temp_block(to_integer(done_processing_count))(7) <= idct_1d_o7;
		elsif ((idct_1d_done = '1')
			AND (current_activity = COMPUTING_COLUMNS)) then
			temp_block(0)(to_integer(done_processing_count)) <= idct_1d_o0;
			temp_block(1)(to_integer(done_processing_count)) <= idct_1d_o1;
			temp_block(2)(to_integer(done_processing_count)) <= idct_1d_o2;
			temp_block(3)(to_integer(done_processing_count)) <= idct_1d_o3;
			temp_block(4)(to_integer(done_processing_count)) <= idct_1d_o4;
			temp_block(5)(to_integer(done_processing_count)) <= idct_1d_o5;
			temp_block(6)(to_integer(done_processing_count)) <= idct_1d_o6;
			temp_block(7)(to_integer(done_processing_count)) <= idct_1d_o7;
		end if;
	end process;

	--
	-- Outputs
	--
	o_row_ready <= '1' when (current_activity = OUTPUTTING_ROWS) else '0';

	o_row0 <= temp_block(to_integer(started_processing_count(2 downto 0)))(0);
	o_row1 <= temp_block(to_integer(started_processing_count(2 downto 0)))(1);
	o_row2 <= temp_block(to_integer(started_processing_count(2 downto 0)))(2);
	o_row3 <= temp_block(to_integer(started_processing_count(2 downto 0)))(3);
	o_row4 <= temp_block(to_integer(started_processing_count(2 downto 0)))(4);
	o_row5 <= temp_block(to_integer(started_processing_count(2 downto 0)))(5);
	o_row6 <= temp_block(to_integer(started_processing_count(2 downto 0)))(6);
	o_row7 <= temp_block(to_integer(started_processing_count(2 downto 0)))(7);


	internal_reset <= '1' when ((reset = '0')
		OR ((current_activity = OUTPUTTING_ROWS)
			AND (started_processing_count = 7))) else '0';
	pass <= '1' when (current_activity = COMPUTING_COLUMNS) else '0';
	idct_1d_done <= idct_1d_pineline_tracker(2);
	idct_1d_almost_done <= idct_1d_pineline_tracker(1);

end architecture main;
