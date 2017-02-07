library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D_streaming_interface is
port(
  signal clk: in std_logic;				-- CPU system clock (always required)
  signal reset: in std_logic;

--
-- Data SOURCE Streaming Interface
--
  signal o_data : out std_logic_vector(31 downto 0);
  signal o_valid : out std_logic;
  signal i_ready : in std_logic;

--
-- Data SINK Streaming Interface
--
  signal i_data : in std_logic_vector(31 downto 0);
  signal i_valid : in std_logic;
  signal o_ready : out std_logic
);
end entity idct_2D_streaming_interface;

architecture main of idct_2D_streaming_interface is
  type row is array (0 to 7) of std_logic_vector(15 downto 0);
  signal temp_i_row : row;
  signal temp_o_row : row;

  signal i_trigger_row : std_logic;
  signal i_read_row : std_logic;
  signal o_row_ready : std_logic;
  signal input_row_offset : unsigned (2 downto 0);
  signal input_row_count : unsigned (3 downto 0);
  signal internal_o_ready : std_logic;
  signal input_row_offset_MSB_prev : std_logic;
  
  begin

  i2d : entity work.idct_2D port map (
  	clk => clk,
  	reset => reset,

    i_row0 => temp_i_row(0),
    i_row1 => temp_i_row(1),
    i_row2 => temp_i_row(2),
    i_row3 => temp_i_row(3),
    i_row4 => temp_i_row(4),
    i_row5 => temp_i_row(5),
    i_row6 => temp_i_row(6),
    i_row7 => temp_i_row(7),
    i_trigger_row => i_trigger_row,
    i_read_row => i_read_row,

    o_row0 => temp_o_row(0),
    o_row1 => temp_o_row(1),
    o_row2 => temp_o_row(2),
    o_row3 => temp_o_row(3),
    o_row4 => temp_o_row(4),
    o_row5 => temp_o_row(5),
    o_row6 => temp_o_row(6),
    o_row7 => temp_o_row(7),
    o_row_ready => o_row_ready
  );

process
begin
  wait until rising_edge(clk);

  if (reset = '0') then
	input_row_offset <= (others => '0');
  elsif (i_valid = '1' AND internal_o_ready = '1') then
	input_row_offset <= input_row_offset + 1;
  end if;
end process;

i_trigger_row <= (input_row_offset(2) XOR input_row_offset_MSB_prev);

--
-- Update input_row_count
--
process
begin
  wait until rising_edge(clk);

  if (reset = '0') then
	input_row_count <= (others => '0');
  elsif (i_valid = '1' AND internal_o_ready = '1' AND input_row_offset(1 downto 0) = 3) then
	input_row_count <= input_row_count + 1;
  end if;
end process;

internal_o_ready <= (reset AND NOT input_row_count(3));
o_ready <= internal_o_ready;

--
-- Data
--
process
begin
  wait until rising_edge(clk);

  temp_i_row(to_integer((input_row_offset(1 downto 0) & '0'))) <= i_data(15 downto 0);
  temp_i_row(to_integer((input_row_offset(1 downto 0) & '1'))) <= i_data(31 downto 16);
end process;

--
-- Edge detector flip flop
--
process
begin
  wait until rising_edge(clk);

  if (reset = '0') then
	input_row_offset_MSB_prev <= '0';
  else
    input_row_offset_MSB_prev <= input_row_offset(2);
  end if;
end process;

end architecture main;