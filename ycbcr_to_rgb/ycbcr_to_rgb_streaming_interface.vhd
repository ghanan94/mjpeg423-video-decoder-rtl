library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ycbcr_to_rgb_streaming_interface is
port(
  signal clk: in std_logic;				-- CPU system clock (always required)
  signal reset_n: in std_logic;

--
-- Data SINK Streaming Interface (YBlock)
--
  signal i_y_data : in std_logic_vector(31 downto 0);
  signal i_y_valid : in std_logic;
  signal o_y_ready : out std_logic;

--
-- Data SINK Streaming Interface (CrBlock)
--
  signal i_cr_data : in std_logic_vector(31 downto 0);
  signal i_cr_valid : in std_logic;
  signal o_cr_ready : out std_logic;

--
-- Data SINK Streaming Interface (CbBlock)
--
  signal i_cb_data : in std_logic_vector(31 downto 0);
  signal i_cb_valid : in std_logic;
  signal o_cb_ready : out std_logic;

--
-- Data SOURCE Streaming Interface (outputbuffer rgb_pixel)
--
  signal o_rgb_data : out std_logic_vector(31 downto 0);
  signal o_rgb_valid : out std_logic;
  signal i_rgb_ready : in std_logic
);
end entity ycbcr_to_rgb_streaming_interface;

architecture main of ycbcr_to_rgb_streaming_interface is
  signal ycbr_to_rgb_inst_i_y : std_logic_vector(7 downto 0);
  signal ycbr_to_rgb_inst_i_cb : std_logic_vector(7 downto 0);
  signal ycbr_to_rgb_inst_i_cr : std_logic_vector(7 downto 0);
  signal ycbr_to_rgb_inst_i_valid : std_logic;
  signal ycbr_to_rgb_inst_o_ready : std_logic;
  signal ycbr_to_rgb_inst_i_ready : std_logic;
  signal ycbr_to_rgb_inst_o_valid : std_logic;
  signal ycbr_to_rgb_inst_o_red : std_logic_vector(7 downto 0);
  signal ycbr_to_rgb_inst_o_green : std_logic_vector(7 downto 0);
  signal ycbr_to_rgb_inst_o_blue : std_logic_vector(7 downto 0);
  signal ycbr_to_rgb_inst_o_alpha : std_logic_vector(7 downto 0);

  signal y_data : std_logic_vector(31 downto 0);
  signal cr_data : std_logic_vector(31 downto 0);
  signal cb_data : std_logic_vector(31 downto 0);

  signal word_offset : unsigned(1 downto 0);

  signal valid_y_word : std_logic;
  signal valid_cb_word : std_logic;
  signal valid_cr_word : std_logic;
  signal valid_words : std_logic;

  signal y_ready : std_logic;
  signal cb_ready : std_logic;
  signal cr_ready : std_logic;
begin
  ycbr_to_rgb_inst : entity work.ycbcr_to_rgb(main) 
  port map (
    clk => clk,
    reset_n => reset_n,

    i_y => ycbr_to_rgb_inst_i_y,
    i_cb => ycbr_to_rgb_inst_i_cb,
    i_cr => ycbr_to_rgb_inst_i_cr,
    i_valid => ycbr_to_rgb_inst_i_valid,
    o_ready => ycbr_to_rgb_inst_o_ready,

    i_ready => ycbr_to_rgb_inst_i_ready,
    o_valid => ycbr_to_rgb_inst_o_valid,
    o_red => ycbr_to_rgb_inst_o_red,
    o_green => ycbr_to_rgb_inst_o_green,
    o_blue => ycbr_to_rgb_inst_o_blue,
    o_alpha => ycbr_to_rgb_inst_o_alpha
  );

  ycbr_to_rgb_inst_i_y <= y_data((to_integer(word_offset & "111")) downto (to_integer(word_offset & "000")));
  ycbr_to_rgb_inst_i_cb <= cb_data((to_integer(word_offset & "111")) downto (to_integer(word_offset & "000")));
  ycbr_to_rgb_inst_i_cr <= cr_data((to_integer(word_offset & "111")) downto (to_integer(word_offset & "000")));
  ycbr_to_rgb_inst_i_valid <= valid_words;

  o_rgb_data(7 downto 0) <= ycbr_to_rgb_inst_o_alpha;
  o_rgb_data(15 downto 8) <= ycbr_to_rgb_inst_o_red;
  o_rgb_data(23 downto 16) <= ycbr_to_rgb_inst_o_green;
  o_rgb_data(31 downto 24) <= ycbr_to_rgb_inst_o_blue;
  o_rgb_valid <= ycbr_to_rgb_inst_o_valid;
  ycbr_to_rgb_inst_i_ready <= i_rgb_ready;

  process
  begin
    if (reset_n = '0') then
      valid_y_word <= '0';
    elsif (word_offset = 3) then
      valid_y_word <= '0';
    elsif (i_y_valid = '1' AND y_ready = '1') then
      valid_y_word <= '1';
    end if;
  end process;

  process
  begin
    if (reset_n = '0') then
      valid_cb_word <= '0';
    elsif (word_offset = 3) then
      valid_cb_word <= '0';
    elsif (i_y_valid = '1' AND cb_ready = '1') then
      valid_cb_word <= '1';
    end if;
  end process;

  process
  begin
    if (reset_n = '0') then
      valid_cr_word <= '0';
    elsif (word_offset = 3) then
      valid_cr_word <= '0';
    elsif (i_y_valid = '1' AND cr_ready = '1') then
      valid_cr_word <= '1';
    end if;
  end process;

  process
  begin
    if (reset_n = '0') then
      word_offset <= to_unsigned(0, word_offset'length);
    elsif (ycbr_to_rgb_inst_o_ready = '1' AND valid_words = '1') then
      word_offset <= word_offset + 1;
    end if;
  end process;

  valid_words <= (valid_y_word AND valid_cr_word AND valid_cb_word);
  
  y_ready <= '1' when (valid_y_word = '0') else '0';
  cb_ready <= '1' when (valid_cb_word = '0') else '0';
  cr_ready <= '1' when (valid_cr_word = '0') else '0';
  o_y_ready <= y_ready;
  o_cb_ready <= cb_ready;
  o_cr_ready <= cr_ready;

end architecture main;