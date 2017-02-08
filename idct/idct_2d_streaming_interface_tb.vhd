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

  signal clk : std_logic := '0';
  signal reset : std_logic := '0';

  signal dest_data : std_logic_vector(31 downto 0) := (others => '0');
  signal dest_valid : std_logic := '0';
  signal dest_ready : std_logic;

  signal src_data : std_logic_vector(31 downto 0);
  signal src_valid : std_logic;
  signal src_ready : std_logic := '0';
begin

  idct_2d_streamer : entity work.idct_2D_streaming_interface(main)
  port map (
    clk => clk,
    reset => reset,

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

    --
    -- T1: Row 0
    --
    dest_data(15 downto 0) <= std_logic_vector(to_signed(100, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(dest_ready);
    report("Time for T1 Input");

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 1
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(100, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 2
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(100, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 3
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(100, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 4
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(100, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 5
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(100, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 6
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(100, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T1: Row 7
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(100, 16));

    wait until rising_edge(clk);
    wait for 1 ns;
    assert(dest_ready = '0') report("dest_ready should be '0'");

    --
    -- T2: Row 0
    --
    dest_data(15 downto 0) <= std_logic_vector(to_signed(1240, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(dest_ready);
    report("Time for T2 Input");

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(-10, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 1
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(-24, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(-12, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 2
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(-14, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(-13, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 3
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 4
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 5
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 6
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- T2: Row 7
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    wait until rising_edge(clk);
    wait for 1 ns;
    assert(dest_ready = '0') report("dest_ready should be '0'");

    -- Data for first 2 blocks of Row 0 of Test n
    --
    -- wait until rising_edge(dest_ready);
    -- report("Time for Tn Input");

    -- wait until rising_edge(clk);
    -- rest of the blocks in groups of 2 after rising_edge(clk)

    
    report("Done Inputs");
    wait;
  end process;

  --
  -- Outputs
  --
  process
  begin
    src_ready <= '1';

    --
    -- Wait for module to be done processing our row data
    --
    wait until rising_edge(src_valid);
    report("Time for T1 Output");

    --
    -- T1: Row 0
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report(
      "[T1] Output Row0/Column0: src_data(15 downto 0) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row0/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row0/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row0/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row0/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row0/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row0/Column6: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row0/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 1
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row1/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 100) report(
      "[T1] Output Row1/Column1: src_data(31 downto 16) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row1/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row1/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row1/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row1/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row1/Column6: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row1/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 2
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row2/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row2/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report(
      "[T1] Output Row2/Column2: src_data(15 downto 0) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row2/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row2/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row2/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row2/Column6: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row2/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 3
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row3/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row3/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row3/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 100) report(
      "[T1] Output Row3/Column3: src_data(31 downto 16) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row3/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row3/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row3/Column6: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row3/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 4
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row4/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row4/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row4/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row4/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report(
      "[T1] Output Row4/Column4: src_data(15 downto 0) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row4/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row4/Column6: src_data(15 downto 0) should be 0; It was "
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row4/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 5
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row5/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0)))));
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row5/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row5/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0)))));
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row5/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row5/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 100) report(
      "[T1] Output Row5/Column5: src_data(31 downto 16) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row5/Column6: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row5/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 6
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row6/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row6/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row6/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row6/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row6/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row6/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report(
      "[T1] Output Row6/Column6: src_data(15 downto 0) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row6/Column7: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T1: Row 7
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row7/Column0: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row7/Column1: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row7/Column2: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row7/Column3: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row7/Column4: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 0) report(
      "[T1] Output Row7/Column5: src_data(31 downto 16) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report(
      "[T1] Output Row7/Column6: src_data(15 downto 0) should be 0; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 100) report(
      "[T1] Output Row7/Column7: src_data(31 downto 16) should be 100; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '0');
    --
    -- Wait for module to be done processing our row data
    --
    wait until rising_edge(src_valid);
    report("Time for T2 Output");

    --
    -- T2: Row 0
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 141) report(
      "[T2] Output Row0/Column0: src_data(15 downto 0) should be 141; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 143) report(
      "[T2] Output Row0/Column1: src_data(31 downto 16) should be 143; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 146) report(
      "[T2] Output Row0/Column2: src_data(15 downto 0) should be 146; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 149) report(
      "[T2] Output Row0/Column3: src_data(31 downto 16) should be 149; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 151) report(
      "[T2] Output Row0/Column4: src_data(15 downto 0) should be 151; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 153) report(
      "[T2] Output Row0/Column5: src_data(31 downto 16) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 153) report(
      "[T2] Output Row0/Column6: src_data(15 downto 0) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 153) report(
      "[T2] Output Row0/Column7: src_data(31 downto 16) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 1
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 145) report(
      "[T2] Output Row1/Column0: src_data(15 downto 0) should be 145; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 147) report(
      "[T2] Output Row1/Column1: src_data(31 downto 16) should be 147; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 149) report(
      "[T2] Output Row1/Column2: src_data(15 downto 0) should be 149; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 151) report(
      "[T2] Output Row1/Column3: src_data(31 downto 16) should be 151; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 153) report(
      "[T2] Output Row1/Column4: src_data(15 downto 0) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 153) report(
      "[T2] Output Row1/Column5: src_data(31 downto 16) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 153) report(
      "[T2] Output Row1/Column6: src_data(15 downto 0) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 153) report(
      "[T2] Output Row1/Column7: src_data(31 downto 16) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 2
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 152) report(
      "[T2] Output Row2/Column0: src_data(15 downto 0) should be 152; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 153) report(
      "[T2] Output Row2/Column1: src_data(31 downto 16) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 154) report(
      "[T2] Output Row2/Column2: src_data(15 downto 0) should be 154; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 155) report(
      "[T2] Output Row2/Column3: src_data(31 downto 16) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 155) report(
      "[T2] Output Row2/Column4: src_data(15 downto 0) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 155) report(
      "[T2] Output Row2/Column5: src_data(31 downto 16) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 153) report(
      "[T2] Output Row2/Column6: src_data(15 downto 0) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 152) report(
      "[T2] Output Row2/Column7: src_data(31 downto 16) should be 152; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 3
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 157) report(
      "[T2] Output Row3/Column0: src_data(15 downto 0) should be 157; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 158) report(
      "[T2] Output Row3/Column1: src_data(31 downto 16) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 158) report(
      "[T2] Output Row3/Column2: src_data(15 downto 0) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 159) report(
      "[T2] Output Row3/Column3: src_data(31 downto 16) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 158) report(
      "[T2] Output Row3/Column4: src_data(15 downto 0) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 156) report(
      "[T2] Output Row3/Column5: src_data(31 downto 16) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 154) report(
      "[T2] Output Row3/Column6: src_data(15 downto 0) should be 154; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 152) report(
      "[T2] Output Row3/Column7: src_data(31 downto 16) should be 152; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 4
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 160) report(
      "[T2] Output Row4/Column0: src_data(15 downto 0) should be 160; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 160) report(
      "[T2] Output Row4/Column1: src_data(31 downto 16) should be 160; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 161) report(
      "[T2] Output Row4/Column2: src_data(15 downto 0) should be 161; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 160) report(
      "[T2] Output Row4/Column3: src_data(31 downto 16) should be 160; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 159) report(
      "[T2] Output Row4/Column4: src_data(15 downto 0) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 157) report(
      "[T2] Output Row4/Column5: src_data(31 downto 16) should be 157; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 154) report(
      "[T2] Output Row4/Column6: src_data(15 downto 0) should be 154; It was "
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 153) report(
      "[T2] Output Row4/Column7: src_data(31 downto 16) should be 153; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 5
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 160) report(
      "[T2] Output Row5/Column0: src_data(15 downto 0) should be 160; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0)))));
    assert(signed(src_data(31 downto 16)) = 160) report(
      "[T2] Output Row5/Column1: src_data(31 downto 16) should be 160; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 161) report(
      "[T2] Output Row5/Column2: src_data(15 downto 0) should be 161; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0)))));
    assert(signed(src_data(31 downto 16)) = 160) report(
      "[T2] Output Row5/Column3: src_data(31 downto 16) should be 160; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 159) report(
      "[T2] Output Row5/Column4: src_data(15 downto 0) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 157) report(
      "[T2] Output Row5/Column5: src_data(31 downto 16) should be 157; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 155) report(
      "[T2] Output Row5/Column6: src_data(15 downto 0) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 154) report(
      "[T2] Output Row5/Column7: src_data(31 downto 16) should be 154; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 6
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 157) report(
      "[T2] Output Row6/Column0: src_data(15 downto 0) should be 157; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 158) report(
      "[T2] Output Row6/Column1: src_data(31 downto 16) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 159) report(
      "[T2] Output Row6/Column2: src_data(15 downto 0) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 159) report(
      "[T2] Output Row6/Column3: src_data(31 downto 16) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 159) report(
      "[T2] Output Row6/Column4: src_data(15 downto 0) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 158) report(
      "[T2] Output Row6/Column5: src_data(31 downto 16) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 156) report(
      "[T2] Output Row6/Column6: src_data(15 downto 0) should be 156; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 155) report(
      "[T2] Output Row6/Column7: src_data(31 downto 16) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    --
    -- T2: Row 7
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 155) report(
      "[T2] Output Row7/Column0: src_data(15 downto 0) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 156) report(
      "[T2] Output Row7/Column1: src_data(31 downto 16) should be 156; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 158) report(
      "[T2] Output Row7/Column2: src_data(15 downto 0) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 158) report(
      "[T2] Output Row7/Column3: src_data(31 downto 16) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 159) report(
      "[T2] Output Row7/Column4: src_data(15 downto 0) should be 159; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 158) report(
      "[T2] Output Row7/Column5: src_data(31 downto 16) should be 158; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 156) report(
      "[T2] Output Row7/Column6: src_data(15 downto 0) should be 156; It was " 
      & integer'image(to_integer(signed(src_data(15 downto 0))))
    );
    assert(signed(src_data(31 downto 16)) = 155) report(
      "[T2] Output Row7/Column7: src_data(31 downto 16) should be 155; It was " 
      & integer'image(to_integer(signed(src_data(31 downto 16))))
    );

    wait until rising_edge(clk);
    assert(src_valid = '0');
    
    --
    -- Wait for module to be done processing our row data
    --
    --wait until rising_edge(src_valid);
    --report("Time for Tn Output");

    --wait until rising_edge(clk);

    report("Done Outputs");
    wait;
  end process;

end architecture main;