-- 2d_idct_accel.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity 2d_idct_accel is
	port (
		reset_n   : in  std_logic                     := '0';             -- reset_n.reset_n
		clk       : in  std_logic                     := '0';             --   clock.clk
		dst_data  : out std_logic_vector(31 downto 0);                    --     dst.data
		dst_ready : in  std_logic                     := '0';             --        .ready
		dst_valid : out std_logic;                                        --        .valid
		src_data  : in  std_logic_vector(31 downto 0) := (others => '0'); --     src.data
		src_ready : out std_logic;                                        --        .ready
		src_valid : in  std_logic                     := '0'              --        .valid
	);
end entity 2d_idct_accel;

architecture rtl of 2d_idct_accel is
begin

	-- TODO: Auto-generated HDL template

	dst_valid <= '0';

	dst_data <= "00000000000000000000000000000000";

	src_ready <= '0';

end architecture rtl; -- of 2d_idct_accel
