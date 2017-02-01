library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D_tb_1 is
	generic (
    	PERIOD : real := 20.0
    );
end idct_2D_tb_1;

architecture main of idct_2D_tb_1 is
	constant CLK_PERIOD : time := PERIOD * 1 ns;

	signal clock : std_logic := '0';
	signal reset : std_logic := '1';

	signal i0: std_logic_vector(15 downto 0) := (others => '0');
	signal i1: std_logic_vector(15 downto 0) := (others => '0');
	signal i2: std_logic_vector(15 downto 0) := (others => '0');
	signal i3: std_logic_vector(15 downto 0) := (others => '0');
	signal i4: std_logic_vector(15 downto 0) := (others => '0');
	signal i5: std_logic_vector(15 downto 0) := (others => '0');
	signal i6: std_logic_vector(15 downto 0) := (others => '0');
	signal i7: std_logic_vector(15 downto 0) := (others => '0');

	signal o0: std_logic_vector(15 downto 0);
	signal o1: std_logic_vector(15 downto 0);
	signal o2: std_logic_vector(15 downto 0);
	signal o3: std_logic_vector(15 downto 0);
	signal o4: std_logic_vector(15 downto 0);
	signal o5: std_logic_vector(15 downto 0);
	signal o6: std_logic_vector(15 downto 0);
	signal o7: std_logic_vector(15 downto 0);

	signal trigger_row : std_logic := '0';
	signal read_row : std_logic := '0';
	signal row_ready : std_logic;
begin

	i2d : entity work.idct_2D port map (
		clk => clock,
		reset => reset,

		i_row0 => i0,
		i_row1 => i1,
		i_row2 => i2,
		i_row3 => i3,
		i_row4 => i4,
		i_row5 => i5,
		i_row6 => i6,
		i_row7 => i7,
		i_trigger_row => trigger_row,
		i_read_row => read_row,

		o_row0 => o0,
		o_row1 => o1,
		o_row2 => o2,
		o_row3 => o3,
		o_row4 => o4,
	    o_row5 => o5,
		o_row6 => o6,
		o_row7 => o7,
		o_row_ready => row_ready
	);


	-- clock
	process
	begin
		clock <= '0';
		wait for CLK_PERIOD / 2;
		clock <= '1';
		wait for CLK_PERIOD / 2;
	end process;

	-- test
	process
	begin
		wait until rising_edge(clock);
		reset <= '0';
		wait until rising_edge(clock);
		reset <= '1';
		wait until rising_edge(clock);

		--
		-- PASS 1
		--
		report("PASS 1");

		wait until rising_edge(clock);
		trigger_row <= '1';

		i0 <= std_logic_vector(to_signed(100, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(100, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(100, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(100, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(100, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(100, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(100, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(100, i7'length));

		wait until rising_edge(clock);

		trigger_row <= '0';

		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);

		read_row <= '1';

		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait until rising_edge(clock);

		report(integer'image(to_integer(signed(o0)))
			& " " & integer'image(to_integer(signed(o1)))
			& " " & integer'image(to_integer(signed(o2)))
			& " " & integer'image(to_integer(signed(o3)))
			& " " & integer'image(to_integer(signed(o4)))
			& " " & integer'image(to_integer(signed(o5)))
			& " " & integer'image(to_integer(signed(o6)))
			& " " & integer'image(to_integer(signed(o7)))
		);

		wait; -- finished sim
	end process;

end main;
