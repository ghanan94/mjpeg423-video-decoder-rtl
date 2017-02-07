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

  -- test
  process 
  begin
    wait until rising_edge(clk);
    reset <= '0';
    wait until rising_edge(clk);
    reset <= '1';

    --
    -- Row 0
    --
    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_valid <= '1';
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

    wait until rising_edge(clk);
    assert(dest_ready = '1') report("dest_ready should be '1'");
    dest_data(15 downto 0) <= std_logic_vector(to_signed(0, 16));
    dest_data(31 downto 16) <= std_logic_vector(to_signed(0, 16));

    --
    -- Row 1
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
    -- Row 2
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
    -- Row 3
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
    -- Row 4
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
    -- Row 5
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
    -- Row 6
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
    -- Row 7
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
    assert(dest_ready = '0') report("A dest_ready should be '0'");

    --
    -- Wait for module to be done processing our row datas
    --
    wait until rising_edge(src_valid);

    wait until rising_edge(clk);
    assert(dest_ready = '0') report("dest_ready should be '0'");
    assert(src_valid = '1') report("src_valid should be '1'");
    src_ready <= '1';

    --
    -- Output Row 0
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report ("[T1] Output Row0/Column0: src_data(15 downto 0) should be 100");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row0/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row0/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row0/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row0/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row0/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row0/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row0/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 1
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row1/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 100) report ("[T1] Output Row1/Column1: src_data(15 downto 0) should be 100");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row1/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row1/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row1/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row1/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row1/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row1/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 2
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row2/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row2/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report ("[T1] Output Row2/Column2: src_data(15 downto 0) should be 100");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row2/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row2/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row2/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row2/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row2/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 3
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row3/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row3/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row3/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 100) report ("[T1] Output Row3/Column3: src_data(15 downto 0) should be 100");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row3/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row3/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row3/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row3/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 4
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row4/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row4/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row4/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row4/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report ("[T1] Output Row4/Column4: src_data(15 downto 0) should be 100");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row4/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row4/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row4/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 5
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row5/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row5/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row5/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row5/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row5/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 100) report ("[T1] Output Row5/Column5: src_data(15 downto 0) should be 100");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row5/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row5/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 6
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row6/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row6/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row6/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row6/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row6/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row6/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 100) report ("[T1] Output Row6/Column6: src_data(15 downto 0) should be 100");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row6/Column7: src_data(15 downto 0) should be 0");

    --
    -- Output Row 7
    --
    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row7/Column0: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row7/Column1: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row7/Column2: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row7/Column3: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row7/Column4: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 0) report ("[T1] Output Row7/Column5: src_data(15 downto 0) should be 0");

    wait until rising_edge(clk);
    assert(src_valid = '1') report("src_valid should be '1'");
    assert(signed(src_data(15 downto 0)) = 0) report ("[T1] Output Row7/Column6: src_data(15 downto 0) should be 0");
    assert(signed(src_data(31 downto 16)) = 100) report ("[T1] Output Row7/Column7: src_data(15 downto 0) should be 100");

    wait until rising_edge(clk);
    assert(src_valid = '0');

    report("Done");
    wait;
  end process;

end architecture main;