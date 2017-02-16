library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ycbcr_to_rgb is
port(
	signal clk: in std_logic;				-- CPU system clock (always required)
	signal reset_n: in std_logic;

	signal i_y : in std_logic_vector(7 downto 0);
	signal i_cb : in std_logic_vector(7 downto 0);
	signal i_cr : in std_logic_vector(7 downto 0);
	signal i_valid : in std_logic;
	signal o_ready : out std_logic;

	signal i_ready : in std_logic;
	signal o_valid : out std_logic;
	signal o_red : out std_logic_vector(7 downto 0);
	signal o_green : out std_logic_vector(7 downto 0);
	signal o_blue : out std_logic_vector(7 downto 0);
	signal o_alpha : out std_logic_vector(7 downto 0)
);
end entity ycbcr_to_rgb;

architecture main of ycbcr_to_rgb is
	constant w_size : unsigned(15 downto 0) := to_unsigned(640, 16); 
	signal store_row : unsigned(2 downto 0);
	signal store_col : unsigned(2 downto 0);
	signal store_block : unsigned(6 downto 0);

	signal ready : std_logic;
	signal valid : std_logic;

	--type row_mem is array(0 to 639) of unsigned(7 downto 0);
	--type block_mem is array(0 to 7) of row_mem;
	type block_mem is array(0 to 5119) of unsigned(7 downto 0);
	signal red_mem  : block_mem;
	signal green_mem  : block_mem;
	signal blue_mem  : block_mem;

	signal store_ok : std_logic;
	signal output_ok : std_logic;

	type current_activity_states is (STORING, OUTPUTTING);
	signal current_state : current_activity_states;
begin

	process
	begin
		wait until rising_edge(clk);
		if (reset_n = '0') then
			current_state <= STORING;
		else
			if (current_state = STORING AND store_row = 7 AND store_col = 7 AND store_block = 79 AND store_ok = '1') then
				current_state <= OUTPUTTING;
			elsif (current_state = OUTPUTTING AND store_row = 7 AND store_col = 7 AND store_block = 79 AND output_ok = '1') then
				current_state <= STORING;
			end if;
		end if;
	end process;

	process
	begin
		wait until rising_edge(clk);

		if (reset_n = '0') then
			store_row <= to_unsigned(0, store_row'length);
		elsif ((current_state = STORING AND store_col = 7 AND store_ok = '1') 
			OR (current_state = OUTPUTTING AND store_col = 7 AND store_block = 79 AND output_ok = '1')) then
			store_row <= store_row + 1;
		end if;
	end process;

	process
	begin
		wait until rising_edge(clk);

		if (reset_n = '0') then
			store_col <= to_unsigned(0, store_col'length);
		elsif ((current_state = STORING AND store_ok = '1')
			OR (current_state = OUTPUTTING AND output_ok = '1')) then
			store_col <= store_col + 1;
		end if;
	end process;

	process
	begin
		wait until rising_edge(clk);

		if (reset_n = '0') then
			store_block <= to_unsigned(0, store_block'length);
		elsif ((current_state = STORING AND store_row = 7 AND store_col = 7 AND store_ok = '1')
			OR (current_state = OUTPUTTING AND store_col = 7 AND output_ok = '1')) then

			if (store_block = 79) then
				store_block <= to_unsigned(0, store_block'length);
			else
				store_block <= store_block + 1;
			end if;
		end if;
	end process;

	process
	begin
		wait until rising_edge(clk);

		if (current_state = STORING) then
			red_mem(to_integer(((("0000000" & store_row) * 80) + ("000" & store_block)) & store_col)) <= unsigned(i_cr);
			green_mem(to_integer(((("0000000" & store_row) * 80) + ("000" & store_block)) & store_col)) <= unsigned(i_y);
			blue_mem(to_integer(((("0000000" & store_row) * 80) + ("000" & store_block)) & store_col)) <= unsigned(i_cb);
		end if;
	end process;

	o_alpha <= (others => '0');
	o_red <= std_logic_vector(red_mem(to_integer(((("0000000" & store_row) * 80) + ("000" & store_block)) & store_col)));
	o_green <= std_logic_vector(green_mem(to_integer(((("0000000" & store_row) * 80) + ("000" & store_block)) & store_col)));
	o_blue <= std_logic_vector(blue_mem(to_integer(((("0000000" & store_row) * 80) + ("000" & store_block)) & store_col)));


	store_ok <= '1' when (i_valid = '1' and ready = '1') else '0';
	output_ok <= '1' when (valid = '1' and i_ready = '1') else '0';

	ready <= '1' when (current_state = STORING AND reset_n = '1') else '0';
	valid <= '1' when (current_state = OUTPUTTING AND reset_n = '1') else '0';

	o_valid <= valid;
	o_ready <= ready;

end architecture main;
