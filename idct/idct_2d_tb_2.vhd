library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D_tb_2 is
	generic (
    	PERIOD : real := 20.0
    );
end idct_2D_tb_2;

architecture main of idct_2D_tb_2 is
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
		
		trigger_row <= '1';

		i0 <= std_logic_vector(to_signed(1240, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(-10, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(-24, i0'length));
		i1 <= std_logic_vector(to_signed(-12, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(-14, i0'length));
		i1 <= std_logic_vector(to_signed(-13, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

		wait until rising_edge(clock);

		i0 <= std_logic_vector(to_signed(0, i0'length));
		i1 <= std_logic_vector(to_signed(0, i1'length));
		i2 <= std_logic_vector(to_signed(0, i2'length));
		i3 <= std_logic_vector(to_signed(0, i3'length));
		i4 <= std_logic_vector(to_signed(0, i4'length));
		i5 <= std_logic_vector(to_signed(0, i5'length));
		i6 <= std_logic_vector(to_signed(0, i6'length));
		i7 <= std_logic_vector(to_signed(0, i7'length));

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

		assert(signed(o0) = 141) report("o0 is not " & integer'image(141));
		assert(signed(o1) = 143) report("o1 is not " & integer'image(143));
		assert(signed(o2) = 146) report("o2 is not " & integer'image(146));
		assert(signed(o3) = 149) report("o3 is not " & integer'image(149));
		assert(signed(o4) = 151) report("o4 is not " & integer'image(151));
		assert(signed(o5) = 153) report("o5 is not " & integer'image(153));
		assert(signed(o6) = 153) report("o6 is not " & integer'image(153));
		assert(signed(o7) = 153) report("o7 is not " & integer'image(153));

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

		assert(signed(o0) = 145) report("o0 is not " & integer'image(145));
		assert(signed(o1) = 147) report("o1 is not " & integer'image(147));
		assert(signed(o2) = 149) report("o2 is not " & integer'image(149));
		assert(signed(o3) = 151) report("o3 is not " & integer'image(151));
		assert(signed(o4) = 153) report("o4 is not " & integer'image(153));
		assert(signed(o5) = 153) report("o5 is not " & integer'image(153));
		assert(signed(o6) = 153) report("o6 is not " & integer'image(153));
		assert(signed(o7) = 153) report("o7 is not " & integer'image(153));

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

		assert(signed(o0) = 152) report("o0 is not " & integer'image(152));
		assert(signed(o1) = 153) report("o1 is not " & integer'image(153));
		assert(signed(o2) = 154) report("o2 is not " & integer'image(154));
		assert(signed(o3) = 155) report("o3 is not " & integer'image(155));
		assert(signed(o4) = 155) report("o4 is not " & integer'image(155));
		assert(signed(o5) = 155) report("o5 is not " & integer'image(155));
		assert(signed(o6) = 153) report("o6 is not " & integer'image(153));
		assert(signed(o7) = 152) report("o7 is not " & integer'image(152));

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

		assert(signed(o0) = 157) report("o0 is not " & integer'image(157));
		assert(signed(o1) = 158) report("o1 is not " & integer'image(158));
		assert(signed(o2) = 158) report("o2 is not " & integer'image(158));
		assert(signed(o3) = 159) report("o3 is not " & integer'image(159));
		assert(signed(o4) = 158) report("o4 is not " & integer'image(158));
		assert(signed(o5) = 156) report("o5 is not " & integer'image(156));
		assert(signed(o6) = 154) report("o6 is not " & integer'image(154));
		assert(signed(o7) = 152) report("o7 is not " & integer'image(152));

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

		assert(signed(o0) = 160) report("o0 is not " & integer'image(160));
		assert(signed(o1) = 160) report("o1 is not " & integer'image(160));
		assert(signed(o2) = 161) report("o2 is not " & integer'image(161));
		assert(signed(o3) = 160) report("o3 is not " & integer'image(160));
		assert(signed(o4) = 159) report("o4 is not " & integer'image(159));
		assert(signed(o5) = 157) report("o5 is not " & integer'image(157));
		assert(signed(o6) = 154) report("o6 is not " & integer'image(154));
		assert(signed(o7) = 153) report("o7 is not " & integer'image(153));

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

		assert(signed(o0) = 160) report("o0 is not " & integer'image(160));
		assert(signed(o1) = 160) report("o1 is not " & integer'image(160));
		assert(signed(o2) = 161) report("o2 is not " & integer'image(161));
		assert(signed(o3) = 160) report("o3 is not " & integer'image(160));
		assert(signed(o4) = 159) report("o4 is not " & integer'image(159));
		assert(signed(o5) = 157) report("o5 is not " & integer'image(157));
		assert(signed(o6) = 155) report("o6 is not " & integer'image(155));
		assert(signed(o7) = 154) report("o7 is not " & integer'image(154));

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

		assert(signed(o0) = 157) report("o0 is not " & integer'image(157));
		assert(signed(o1) = 158) report("o1 is not " & integer'image(158));
		assert(signed(o2) = 159) report("o2 is not " & integer'image(159));
		assert(signed(o3) = 159) report("o3 is not " & integer'image(159));
		assert(signed(o4) = 159) report("o4 is not " & integer'image(159));
		assert(signed(o5) = 158) report("o5 is not " & integer'image(158));
		assert(signed(o6) = 156) report("o6 is not " & integer'image(156));
		assert(signed(o7) = 155) report("o7 is not " & integer'image(155));

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

		assert(signed(o0) = 155) report("o0 is not " & integer'image(155));
		assert(signed(o1) = 156) report("o1 is not " & integer'image(156));
		assert(signed(o2) = 158) report("o2 is not " & integer'image(158));
		assert(signed(o3) = 158) report("o3 is not " & integer'image(158));
		assert(signed(o4) = 159) report("o4 is not " & integer'image(159));
		assert(signed(o5) = 158) report("o5 is not " & integer'image(158));
		assert(signed(o6) = 156) report("o6 is not " & integer'image(156));
		assert(signed(o7) = 155) report("o7 is not " & integer'image(155));

		wait; -- finished sim
	end process;

end main;
