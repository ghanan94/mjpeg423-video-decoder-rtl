library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ycbcr_to_rgb_tb is
generic (
    PERIOD : real := 20.0
);
end entity ycbcr_to_rgb_tb;

architecture main of ycbcr_to_rgb_tb is
	constant CLK_PERIOD : time := PERIOD * 1 ns;

	signal clk : std_logic := '0';
	signal reset : std_logic := '0';

	signal i_y : std_logic_vector(7 downto 0);
	signal i_cb : std_logic_vector(7 downto 0);
	signal i_cr : std_logic_vector(7 downto 0);
	signal i_valid : std_logic;
	signal o_ready : std_logic;

	signal i_ready : std_logic;
	signal o_valid : std_logic;
	signal o_red : std_logic_vector(7 downto 0);
	signal o_green : std_logic_vector(7 downto 0);
	signal o_blue : std_logic_vector(7 downto 0);
	signal o_alpha : std_logic_vector(7 downto 0);
begin
	ycbr_to_rgb_inst : entity work.ycbcr_to_rgb(main) 
	port map (
		clk => clk,
		reset_n => reset,

		i_y => i_y,
		i_cb => i_cb,
		i_cr => i_cr,
		i_valid => i_valid,
		o_ready => o_ready,

		i_ready => i_ready,
		o_valid => o_valid,
		o_red => o_red,
		o_green => o_green,
		o_blue => o_blue,
		o_alpha => o_alpha
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
		wait until rising_edge(clk);
		reset <= '1';
		wait;
	end process;


end architecture main;
