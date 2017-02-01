library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_2D is
generic(
	CONST_BITS: integer := 13;
	PASS1_BITS: integer := 2
);
port(
  signal clk: in std_logic;				-- CPU system clock (always required)
  signal reset: in std_logic;

  signal i_row0 : in std_logic_vector(15 downto 0);
  signal i_row1 : in std_logic_vector(15 downto 0);
  signal i_row2 : in std_logic_vector(15 downto 0);
  signal i_row3 : in std_logic_vector(15 downto 0);
  signal i_row4 : in std_logic_vector(15 downto 0);
  signal i_row5 : in std_logic_vector(15 downto 0);
  signal i_row6 : in std_logic_vector(15 downto 0);
  signal i_row7 : in std_logic_vector(15 downto 0);
  signal i_trigger_row : in std_logic;
  signal i_read_row : in std_logic;

  signal o_row0 : out std_logic_vector(15 downto 0);
  signal o_row1 : out std_logic_vector(15 downto 0);
  signal o_row2 : out std_logic_vector(15 downto 0);
  signal o_row3 : out std_logic_vector(15 downto 0);
  signal o_row4 : out std_logic_vector(15 downto 0);
  signal o_row5 : out std_logic_vector(15 downto 0);
  signal o_row6 : out std_logic_vector(15 downto 0);
  signal o_row7 : out std_logic_vector(15 downto 0);
  signal o_row_ready : out std_logic
);
end entity idct_2D;

architecture main of idct_2D is
  type row is array (0 to 7) of std_logic_vector(15 downto 0);
  type column is array(0 to 7) of std_logic_vector(15 downto 0);
  type blk is array(0 to 7) of row;

  signal temp_block : blk;

  signal next_output_column : unsigned (2 downto 0);
  signal next_column_to_compute : unsigned (2 downto 0);

  signal state : unsigned (3 downto 0);
  signal count : unsigned (2 downto 0);
  signal row_being_outputed : unsigned (2 downto 0);

  --
  -- current state, either is_rowing = 0, is_columning = 1, is_flushing = 2
  --
  signal current_activity : unsigned(1 downto 0);

  signal i0 : std_logic_vector(15 downto 0);
  signal i1 : std_logic_vector(15 downto 0);
  signal i2 : std_logic_vector(15 downto 0);
  signal i3 : std_logic_vector(15 downto 0);
  signal i4 : std_logic_vector(15 downto 0);
  signal i5 : std_logic_vector(15 downto 0);
  signal i6 : std_logic_vector(15 downto 0);
  signal i7 : std_logic_vector(15 downto 0);

  signal o0 : std_logic_vector(15 downto 0);
  signal o1 : std_logic_vector(15 downto 0);
  signal o2 : std_logic_vector(15 downto 0);
  signal o3 : std_logic_vector(15 downto 0);
  signal o4 : std_logic_vector(15 downto 0);
  signal o5 : std_logic_vector(15 downto 0);
  signal o6 : std_logic_vector(15 downto 0);
  signal o7 : std_logic_vector(15 downto 0);

  signal internal_reset : std_logic;
  signal pass : std_logic;
begin

  i1d : entity work.idct_1D port map (
    clk => clk,
    pass => pass,

    i0 => i0,
    i1 => i1,
    i2 => i2,
    i3 => i3,
    i4 => i4,
    i5 => i5,
    i6 => i6,
    i7 => i7,

    o0 => o0,
    o1 => o1,
    o2 => o2,
    o3 => o3,
    o4 => o4,
    o5 => o5,
    o6 => o6,
    o7 => o7
  );

  --
  -- State
  --
  process
  begin
    wait until rising_edge(clk);

    if (internal_reset = '1') then
      state <= x"0";
    else
      state(3 downto 1) <= state(2 downto 0);

      if ((i_trigger_row = '1' and current_activity = 0) or (current_activity = 1)) then
	state(0) <= '1';
      else 
	state(0) <= '0';
      end if;
    end if;
  end process;

  --
  -- Count
  --
  process
  begin
    wait until rising_edge(clk);

    if (internal_reset = '1') then
      count <= to_unsigned(7, count'length);
    elsif (state(2) = '1') then
      count <= count + 1;
    end if;
  end process;

  --
  -- Rowing?
  --
  process
  begin
    wait until rising_edge(clk);

    if (internal_reset = '1') then
      -- By default first thing to do is the rows
      current_activity <= to_unsigned(0, current_activity'length);
    elsif (count = 7) then   
      -- After 8 rows or columns update activity
      current_activity <= current_activity + 1;
    end if;
  end process;

  --
  -- 
  --
  process
  begin
    wait until rising_edge(clk);

    if (internal_reset = '1') then
      -- By default first thing to do is the rows
      next_column_to_compute <= to_unsigned(0, next_column_to_compute'length);
    elsif (current_activity = 1) then
      next_column_to_compute <= next_column_to_compute + 1;
    end if;
  end process;

  --
  -- Input to 1D IDCT
  --
  process
  begin
    wait until rising_edge(clk);

    if (current_activity = 0) then
      -- Calculating first pass
      i0 <= i_row0;
      i1 <= i_row1;
      i2 <= i_row2;
      i3 <= i_row3;
      i4 <= i_row4;
      i5 <= i_row5;
      i6 <= i_row6;
      i7 <= i_row7;
    else
      -- calculating second pass
      i0 <= temp_block(0)(to_integer(next_column_to_compute));
      i1 <= temp_block(1)(to_integer(next_column_to_compute));
      i2 <= temp_block(2)(to_integer(next_column_to_compute));
      i3 <= temp_block(3)(to_integer(next_column_to_compute));
      i4 <= temp_block(4)(to_integer(next_column_to_compute));
      i5 <= temp_block(5)(to_integer(next_column_to_compute));
      i6 <= temp_block(6)(to_integer(next_column_to_compute));
      i7 <= temp_block(7)(to_integer(next_column_to_compute));
    end if;
  end process;

  --
  -- Output from 1D IDCT
  --
  process
  begin
    wait until rising_edge(clk);

    if ((state(3) = '1') AND (current_activity = 0)) then
      temp_block(to_integer(count))(0) <= o0;
      temp_block(to_integer(count))(1) <= o1;
      temp_block(to_integer(count))(2) <= o2;
      temp_block(to_integer(count))(3) <= o3;
      temp_block(to_integer(count))(4) <= o4;
      temp_block(to_integer(count))(5) <= o5;
      temp_block(to_integer(count))(6) <= o6;
      temp_block(to_integer(count))(7) <= o7;
    elsif ((state(3) = '1') AND (current_activity = 1)) then
      temp_block(0)(to_integer(count)) <= o0;
      temp_block(1)(to_integer(count)) <= o1;
      temp_block(2)(to_integer(count)) <= o2;
      temp_block(3)(to_integer(count)) <= o3;
      temp_block(4)(to_integer(count)) <= o4;
      temp_block(5)(to_integer(count)) <= o5;
      temp_block(6)(to_integer(count)) <= o6;
      temp_block(7)(to_integer(count)) <= o7;
    end if;
  end process;

  --
  --  Flushing row
  --
  process
  begin
    wait until rising_edge(clk);

    if (internal_reset = '1') then
      o_row_ready <= '0';
    elsif (current_activity = 2) then
      o_row_ready <= '1';

      o_row0 <= temp_block(to_integer(row_being_outputed))(0);
      o_row1 <= temp_block(to_integer(row_being_outputed))(1);
      o_row2 <= temp_block(to_integer(row_being_outputed))(2);
      o_row3 <= temp_block(to_integer(row_being_outputed))(3);
      o_row4 <= temp_block(to_integer(row_being_outputed))(4);
      o_row5 <= temp_block(to_integer(row_being_outputed))(5);
      o_row6 <= temp_block(to_integer(row_being_outputed))(6);
      o_row7 <= temp_block(to_integer(row_being_outputed))(7);
    end if;
  end process;

  --
  -- Update row to be flushed
  --
  process
  begin
    wait until rising_edge(clk);

    if (current_activity /= 2) then 
      row_being_outputed <= to_unsigned(0, row_being_outputed'length);
    elsif (i_read_row = '1') then
      row_being_outputed <= row_being_outputed + 1;
    end if; 
  end process;


  internal_reset <= '1' when (reset = '0' OR (i_read_row = '1' AND row_being_outputed = 7)) else '0';
  pass <= '1' when (current_activity = 1) else '0';

end architecture main;
