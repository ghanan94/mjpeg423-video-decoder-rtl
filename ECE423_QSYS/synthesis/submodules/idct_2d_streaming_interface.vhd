library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D_streaming_interface is
port(
  signal clk: in std_logic;				-- CPU system clock (always required)
  signal reset_n: in std_logic;

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

  signal output_row_offset : unsigned (1 downto 0);
  signal output_row_count : unsigned (3 downto 0);

  signal internal_reset : std_logic;

  type arr is array (0 to 3) of signed(15 downto 0);
  signal intermediate_o : arr;
  
  begin

  i2d : entity work.idct_2D port map (
  	clk => clk,
  	reset => reset_n,

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

--
-- Update input_row_offset
--
process
begin
  wait until rising_edge(clk);

  if (internal_reset = '1') then
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

  if (internal_reset = '1') then
	input_row_count <= (others => '0');
  elsif (i_valid = '1' AND internal_o_ready = '1' AND input_row_offset(1 downto 0) = 3) then
	input_row_count <= input_row_count + 1;
  end if;
end process;

internal_o_ready <= (reset_n AND NOT input_row_count(3));
o_ready <= internal_o_ready;

--
-- Data
--
process
begin
  wait until rising_edge(clk);

  -- When data comes in from the MM - ST interface, it comes in as big endian.
  temp_i_row(to_integer(input_row_offset(1 downto 0) & '0'))(15 downto 8) <= i_data(23 downto 16);
  temp_i_row(to_integer(input_row_offset(1 downto 0) & '0'))(7 downto 0) <= i_data(31 downto 24);

  temp_i_row(to_integer(input_row_offset(1 downto 0) & '1'))(15 downto 8) <= i_data(7 downto 0);
  temp_i_row(to_integer(input_row_offset(1 downto 0) & '1'))(7 downto 0) <= i_data(15 downto 8);
end process;

--
-- Edge detector flip flop
--
process
begin
  wait until rising_edge(clk);

  if (internal_reset = '1') then
	input_row_offset_MSB_prev <= '0';
  else
    input_row_offset_MSB_prev <= input_row_offset(2);
  end if;
end process;

--
-- Update output_row_offset
--
process
begin
  wait until rising_edge(clk);

  if (internal_reset = '1') then
	output_row_offset <= (others => '0');
  elsif (i_ready = '1' AND o_row_ready = '1') then
	output_row_offset <= output_row_offset + 1;
  end if;
end process;

--
-- Update output_row_count
--
process
begin
  wait until rising_edge(clk);

  if (internal_reset = '1') then
	output_row_count <= (others => '0');
  elsif (i_read_row = '1') then
	output_row_count <= output_row_count + 1;
  end if;
end process;

o_valid <= o_row_ready;
i_read_row <= '1' when (i_ready = '1' AND o_row_ready = '1' AND output_row_offset(0) = '1') else '0';

internal_reset <= '1' when ((i_read_row = '1' AND output_row_count = 7) OR reset_n = '0') else '0';

--
-- O_data
--
intermediate_o(0) <= signed(temp_o_row(to_integer(unsigned'(output_row_offset(0) & "00"))));
intermediate_o(1) <= signed(temp_o_row(to_integer(unsigned'(output_row_offset(0) & "01"))));
intermediate_o(2) <= signed(temp_o_row(to_integer(unsigned'(output_row_offset(0) & "10"))));
intermediate_o(3) <= signed(temp_o_row(to_integer(unsigned'(output_row_offset(0) & "11"))));

o_data(31 downto 24) <= (others => '0') when (intermediate_o(0) < 0) else
(others => '1') when (intermediate_o(0) > 255) else
std_logic_vector(intermediate_o(0)(7 downto 0));

o_data(23 downto 16) <= (others => '0') when (intermediate_o(1) < 0) else
(others => '1') when (intermediate_o(1) > 255) else
std_logic_vector(intermediate_o(1)(7 downto 0));

o_data(15 downto 8) <= (others => '0') when (intermediate_o(2) < 0) else
(others => '1') when (intermediate_o(2) > 255) else
std_logic_vector(intermediate_o(2)(7 downto 0));

o_data(7 downto 0) <= (others => '0') when (intermediate_o(3) < 0) else
(others => '1') when (intermediate_o(3) > 255) else
std_logic_vector(intermediate_o(3)(7 downto 0));

end architecture main;