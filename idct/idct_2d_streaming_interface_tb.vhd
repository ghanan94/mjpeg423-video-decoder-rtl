library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D_streaming_interface_tb is
  generic (
    PERIOD : real := 20.0
  );
end entity idct_2D_streaming_interface_tb;

architecture main of idct_2D_streaming_interface_tb is
  constant CLK_PERIOD : time := PERIOD * 1 ns;

  constant NUM_TESTS : integer := 2;
  constant WORD_LENGTH : integer := 32;

  constant TEST_DATA_INPUT_LENGTH : integer := 1024;
  constant TEST_DATA_INPUT_WORDS : integer := (TEST_DATA_INPUT_LENGTH / WORD_LENGTH);
  type input_data is array(0 to 1) of std_logic_vector((TEST_DATA_INPUT_LENGTH - 1) downto 0);
  constant TEST_DATA_INPUT : input_data := (
    X"6400_0000_0000_0000_0000_0000_0000_0000"
    & X"0000_6400_0000_0000_0000_0000_0000_0000"
    & X"0000_0000_6400_0000_0000_0000_0000_0000"
    & X"0000_0000_0000_6400_0000_0000_0000_0000"
    & X"0000_0000_0000_0000_6400_0000_0000_0000"
    & X"0000_0000_0000_0000_0000_6400_0000_0000"
    & X"0000_0000_0000_0000_0000_0000_6400_0000"
    & X"0000_0000_0000_0000_0000_0000_0000_6400"

    , X"D804_0000_F6FF_0000_0000_0000_0000_0000"
    & X"E8FF_F4FF_0000_0000_0000_0000_0000_0000"
    & X"F2FF_F3FF_0000_0000_0000_0000_0000_0000"
    & X"0000_0000_0000_0000_0000_0000_0000_0000"
    & X"0000_0000_0000_0000_0000_0000_0000_0000"
    & X"0000_0000_0000_0000_0000_0000_0000_0000"
    & X"0000_0000_0000_0000_0000_0000_0000_0000"
    & X"0000_0000_0000_0000_0000_0000_0000_0000"
  );

  constant TEST_DATA_OUTPUT_LENGTH : integer := 512;
  constant TEST_DATA_OUTPUT_WORDS : integer := (TEST_DATA_OUTPUT_LENGTH / WORD_LENGTH);
  type output_data is array(0 to 1) of std_logic_vector((TEST_DATA_OUTPUT_LENGTH - 1) downto 0);
  constant TEST_DATA_OUTPUT : output_data := (
    X"64_00_00_00_00_00_00_00"
    & X"00_64_00_00_00_00_00_00"
    & X"00_00_64_00_00_00_00_00"
    & X"00_00_00_64_00_00_00_00"
    & X"00_00_00_00_64_00_00_00"
    & X"00_00_00_00_00_64_00_00"
    & X"00_00_00_00_00_00_64_00"
    & X"00_00_00_00_00_00_00_64"

    , X"8D_8F_92_95_97_99_99_99"
    & X"91_93_95_97_99_99_99_99"
    & X"98_99_9A_9B_9B_9B_99_98"
    & X"9D_9E_9E_9F_9E_9C_9A_98"
    & X"A0_A0_A1_A0_9F_9D_9A_99"
    & X"A0_A0_A1_A0_9F_9D_9B_9A"
    & X"9D_9E_9F_9F_9F_9E_9C_9B"
    & X"9B_9C_9E_9E_9F_9E_9C_9B"
  );

  signal clk : std_logic := '0';
  signal reset : std_logic := '0';

  signal dest_data : std_logic_vector(31 downto 0) := (others => '0');
  signal dest_valid : std_logic := '0';
  signal dest_ready : std_logic;

  signal src_data : std_logic_vector(31 downto 0);
  signal src_valid : std_logic;
  signal src_ready : std_logic := '0';

  signal expected_src_data : std_logic_vector(31 downto 0);
begin

  idct_2d_streamer : entity work.idct_2D_streaming_interface(main)
  port map (
    clk => clk,
    reset_n => reset,

    o_data => src_data, 
    o_valid => src_valid,
    i_ready => src_ready, 

    i_data => dest_data, 
    i_valid => dest_valid, 
    o_ready => dest_ready
  );

  -- clock
  process
  begin
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  -- reset
  process 
  begin
    wait until rising_edge(clk);
    reset <= '0';
    wait until rising_edge(clk);
    reset <= '1';
    wait;
  end process;

  --
  -- Input data (Dest)
  --
  process
  begin
    dest_valid <= '1';
    
    for test_num in 0 to (NUM_TESTS - 1) loop
      report("Input Test #" & integer'image(test_num));

      for i in 0 to (TEST_DATA_INPUT_WORDS - 1) loop
        dest_data <= TEST_DATA_INPUT(test_num)((TEST_DATA_INPUT_LENGTH - (i * WORD_LENGTH) - 1) 
            downto (TEST_DATA_INPUT_LENGTH - (i * WORD_LENGTH) - WORD_LENGTH));

        wait until rising_edge(clk) and dest_ready = '1';
      end loop;
    end loop;

    report("Done Inputs");
    wait;
  end process;

  --
  -- Outputs
  --
  process
  begin
    src_ready <= '1';

    for test_num in 0 to (NUM_TESTS - 1) loop
      report("Output Test #" & integer'image(test_num));

      for i in 0 to (TEST_DATA_OUTPUT_WORDS - 1) loop
          expected_src_data <= TEST_DATA_OUTPUT(test_num)((TEST_DATA_OUTPUT_LENGTH - (i * WORD_LENGTH) - 1) 
              downto (TEST_DATA_OUTPUT_LENGTH - (i * WORD_LENGTH) - WORD_LENGTH));

          wait until rising_edge(clk) and src_valid = '1';
          assert(src_data = expected_src_data) report("ASSERT FAILED: Got " 
                  & integer'image(to_integer(unsigned(src_data))) & " when expected was " 
                  & integer'image(to_integer(unsigned(expected_src_data))));
      end loop;
    end loop;

    report("Done Outputs");
    wait;
  end process;

end architecture main;