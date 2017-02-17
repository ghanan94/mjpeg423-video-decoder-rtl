library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ycbcr_to_rgb_streaming_interface_tb is
  generic (
    PERIOD : real := 20.0
  );
end entity ycbcr_to_rgb_streaming_interface_tb;

architecture main of ycbcr_to_rgb_streaming_interface_tb is
  constant CLK_PERIOD : time := PERIOD * 1 ns;

  signal clk : std_logic := '0';
  signal reset_n : std_logic := '0';

  signal i_y_data : std_logic_vector(31 downto 0) := (others => '0');
  signal i_y_valid : std_logic := '0';
  signal o_y_ready : std_logic;

  signal i_cr_data : std_logic_vector(31 downto 0) := (others => '0');
  signal i_cr_valid : std_logic := '0';
  signal o_cr_ready : std_logic;

  signal i_cb_data : std_logic_vector(31 downto 0) := (others => '0');
  signal i_cb_valid : std_logic := '0';
  signal o_cb_ready : std_logic;

  signal o_rgb_data : std_logic_vector(31 downto 0);
  signal o_rgb_valid : std_logic;
  signal i_rgb_ready : std_logic := '1';
begin
  ycbr_to_rgb_streaming_interface_inst : entity work.ycbcr_to_rgb_streaming_interface(main) 
  port map (
    clk => clk,
    reset_n => reset_n,

    i_y_data => i_y_data,
    i_y_valid => i_y_valid,
    o_y_ready => o_y_ready,

    i_cr_data => i_cr_data,
    i_cr_valid => i_cr_valid,
    o_cr_ready => o_cr_ready,

    i_cb_data => i_cb_data,
    i_cb_valid => i_cb_valid,
    o_cb_ready => o_cb_ready,

    o_rgb_data => o_rgb_data,
    o_rgb_valid => o_rgb_valid,
    i_rgb_ready => i_rgb_ready
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
    reset_n <= '0';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    reset_n <= '1';
    wait;
  end process;

  process
  begin
    wait until rising_edge(reset_n);
    wait for 0.1ns;
    assert(o_y_ready = '1') report("o_y_ready is not 1");
    assert(o_cr_ready = '1') report("o_cr_ready is not 1");
    assert(o_cb_ready = '1') report("o_cb_ready is not 1");
    i_y_valid <= '1';
    i_cb_valid <= '1';
    i_cr_valid <= '1';
    i_y_data <= x"01234567";
    i_cb_data <= x"ABCDEF01";
    i_cr_data <= x"569812CF";

    wait until rising_edge(clk);
    wait for 0.1ns;
    assert(o_y_ready = '0') report("o_y_ready is not 0");
    assert(o_cr_ready = '0') report("o_cr_ready is not 0");
    assert(o_cb_ready = '0') report("o_cb_ready is not 0");

    wait until rising_edge(clk);
    assert(o_y_ready = '0') report("o_y_ready is not 0");
    assert(o_cr_ready = '0') report("o_cr_ready is not 0");
    assert(o_cb_ready = '0') report("o_cb_ready is not 0");

    wait until rising_edge(clk);
    assert(o_y_ready = '0') report("o_y_ready is not 0");
    assert(o_cr_ready = '0') report("o_cr_ready is not 0");
    assert(o_cb_ready = '0') report("o_cb_ready is not 0");

    wait until rising_edge(clk);
    assert(o_y_ready = '0') report("o_y_ready is not 0");
    assert(o_cr_ready = '0') report("o_cr_ready is not 0");
    assert(o_cb_ready = '0') report("o_cb_ready is not 0");

    wait until rising_edge(clk);
    wait for 0.1ns;
    assert(o_y_ready = '1') report("o_y_ready is not 1");
    assert(o_cr_ready = '1') report("o_cr_ready is not 1");
    assert(o_cb_ready = '1') report("o_cb_ready is not 1");

    wait;
  end process;

end architecture main;