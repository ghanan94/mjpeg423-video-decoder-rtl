-- Code your testbench here
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idct_1D_tb is
	generic (
    	PERIOD : real := 20.0
    );
end idct_1D_tb;

architecture main of idct_1D_tb is
	constant CLK_PERIOD : time := PERIOD * 1 ns;

  signal clock : std_logic := '0';
  signal pass : std_logic := '0';

  signal i0: std_logic_vector(15 downto 0);
	signal i1: std_logic_vector(15 downto 0);
	signal i2: std_logic_vector(15 downto 0);
	signal i3: std_logic_vector(15 downto 0);
	signal i4: std_logic_vector(15 downto 0);
	signal i5: std_logic_vector(15 downto 0);
	signal i6: std_logic_vector(15 downto 0);
	signal i7: std_logic_vector(15 downto 0);

	signal o0: std_logic_vector(15 downto 0);
	signal o1: std_logic_vector(15 downto 0);
	signal o2: std_logic_vector(15 downto 0);
	signal o3: std_logic_vector(15 downto 0);
	signal o4: std_logic_vector(15 downto 0);
	signal o5: std_logic_vector(15 downto 0);
	signal o6: std_logic_vector(15 downto 0);
	signal o7: std_logic_vector(15 downto 0);
begin

	i1d : entity work.idct_1D port map (
    clk => clock,
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
    --
    -- PASS 1
    --
    report("PASS 1");
  	wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(100, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

    wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(100, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

    wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(100, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

    wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(100, i7'length));

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

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(100, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(100, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

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

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(100, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(100, i7'length));

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

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

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

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(100, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(100, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(100, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(100, i7'length));

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

    --
    -- PASS 2
    --
    report("PASS 2");
  	wait until rising_edge(clock);
    pass <= '1';
    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(100, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

    wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(100, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

    wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(100, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

    wait until rising_edge(clock);

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(100, i7'length));

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

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(100, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(100, i3'length));
    i4 <= std_logic_vector(to_signed(0, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(0, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

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

    i0 <= std_logic_vector(to_signed(0, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(0, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(100, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(100, i7'length));

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

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(0, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(0, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(0, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(0, i7'length));

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

    i0 <= std_logic_vector(to_signed(100, i0'length));
    i1 <= std_logic_vector(to_signed(100, i1'length));
    i2 <= std_logic_vector(to_signed(100, i2'length));
    i3 <= std_logic_vector(to_signed(100, i3'length));
    i4 <= std_logic_vector(to_signed(100, i4'length));
    i5 <= std_logic_vector(to_signed(100, i5'length));
    i6 <= std_logic_vector(to_signed(100, i6'length));
    i7 <= std_logic_vector(to_signed(100, i7'length));

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

    wait; -- finished sim
  end process;

end main;
