library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D_tb is
	generic (
    	PERIOD : real := 20.0
    );
end idct_2D_tb;

architecture main of idct_2D_tb is
	constant CLK_PERIOD : time := PERIOD * 1 ns;

	constant NUM_TESTS : integer := 2;

	type input_data is array(0 to 1) of std_logic_vector(1023 downto 0);
	constant TEST_DATA_INPUT_LENGTH : integer := 1024;
	constant TEST_DATA_INPUT_ROWS : integer := 8;
	constant TEST_DATA_INPUT_ROW_LENGTH : integer := 128;
	constant TEST_DATA_INPUT : input_data := (
		X"0064_0000_0000_0000_0000_0000_0000_0000"
		& X"0000_0064_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0064_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0064_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0064_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0064_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0064_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0064"

		, X"04D8_0000_FFF6_0000_0000_0000_0000_0000"
		& X"FFE8_FFF4_0000_0000_0000_0000_0000_0000"
		& X"FFF2_FFF3_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0000"
	);

	type output_data is array(0 to 1) of std_logic_vector(1023 downto 0);
	constant TEST_DATA_OUTPUT_ROWS : integer := 8;
	constant TEST_DATA_OUTPUT_ROW_LENGTH : integer := 128;
	constant TEST_DATA_OUTPUT_LENGTH : integer := 1024;
	constant TEST_DATA_OUTPUT : output_data := (
		X"0064_0000_0000_0000_0000_0000_0000_0000"
		& X"0000_0064_0000_0000_0000_0000_0000_0000"
		& X"0000_0000_0064_0000_0000_0000_0000_0000"
		& X"0000_0000_0000_0064_0000_0000_0000_0000"
		& X"0000_0000_0000_0000_0064_0000_0000_0000"
		& X"0000_0000_0000_0000_0000_0064_0000_0000"
		& X"0000_0000_0000_0000_0000_0000_0064_0000"
		& X"0000_0000_0000_0000_0000_0000_0000_0064"

		, X"008D_008F_0092_0095_0097_0099_0099_0099"
		& X"0091_0093_0095_0097_0099_0099_0099_0099"
		& X"0098_0099_009A_009B_009B_009B_0099_0098"
		& X"009D_009E_009E_009F_009E_009C_009A_0098"
		& X"00A0_00A0_00A1_00A0_009F_009D_009A_0099"
		& X"00A0_00A0_00A1_00A0_009F_009D_009B_009A"
		& X"009D_009E_009F_009F_009F_009E_009C_009B"
		& X"009B_009C_009E_009E_009F_009E_009C_009B"
	);

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

	signal expected_o0: std_logic_vector(15 downto 0);
	signal expected_o1: std_logic_vector(15 downto 0);
	signal expected_o2: std_logic_vector(15 downto 0);
	signal expected_o3: std_logic_vector(15 downto 0);
	signal expected_o4: std_logic_vector(15 downto 0);
	signal expected_o5: std_logic_vector(15 downto 0);
	signal expected_o6: std_logic_vector(15 downto 0);
	signal expected_o7: std_logic_vector(15 downto 0);

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

		for test_num in 0 to (NUM_TESTS - 1) loop
			report("Test #" & integer'image(test_num));
			trigger_row <= '1';

			for i in 0 to (TEST_DATA_INPUT_ROWS - 1) loop
				i0 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 1) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 16));
				i1 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 17) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 32));
				i2 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 33) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 48));
				i3 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 49) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 64));
				i4 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 65) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 80));
				i5 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 81) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 96));
				i6 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 97) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 112));
				i7 <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 113) 
					downto (TEST_DATA_INPUT_LENGTH - (i * TEST_DATA_INPUT_ROW_LENGTH) - 128));

				wait until rising_edge(clock);
			end loop;

			trigger_row <= '0';

			for i in 0 to 6 loop
				wait until rising_edge(clock);
			end loop;

			read_row <= '1';

			for i in 0 to 6 loop
				wait until rising_edge(clock);
			end loop;

			for i in 0 to (TEST_DATA_OUTPUT_ROWS - 1) loop
				expected_o0 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 1) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 16));
				expected_o1 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 17) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 32));
				expected_o2 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 33) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 48));
				expected_o3 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 49) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 64));
				expected_o4 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 65) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 80));
				expected_o5 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 81) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 96));
				expected_o6 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 97) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 112));
				expected_o7 <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 113) 
					downto (TEST_DATA_OUTPUT_LENGTH - (i * TEST_DATA_OUTPUT_ROW_LENGTH) - 128));

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

				assert(signed(o0) = signed(expected_o0)) report("o0 is not " & integer'image(to_integer(signed(expected_o0))));
				assert(signed(o1) = signed(expected_o1)) report("o1 is not " & integer'image(to_integer(signed(expected_o1))));
				assert(signed(o2) = signed(expected_o2)) report("o2 is not " & integer'image(to_integer(signed(expected_o2))));
				assert(signed(o3) = signed(expected_o3)) report("o3 is not " & integer'image(to_integer(signed(expected_o3))));
				assert(signed(o4) = signed(expected_o4)) report("o4 is not " & integer'image(to_integer(signed(expected_o4))));
				assert(signed(o5) = signed(expected_o5)) report("o5 is not " & integer'image(to_integer(signed(expected_o5))));
				assert(signed(o6) = signed(expected_o6)) report("o6 is not " & integer'image(to_integer(signed(expected_o6))));
				assert(signed(o7) = signed(expected_o7)) report("o7 is not " & integer'image(to_integer(signed(expected_o7))));
			end loop;

			read_row <= '0';

			wait until rising_edge(clock);
		end loop;

		report("Tests done");
		wait; -- finished sim
	end process;

end main;
