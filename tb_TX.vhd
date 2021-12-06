library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity tb_TX is
end entity;
------------------CONNECTION-------------------------
architecture Behavioral of tb_TX is
component TX is
generic (n_bitsdata : positive :=  8;
			baud_rate  : integer  :=  115200);
port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        sending : in  std_logic;
        tx_d    : out std_logic);
end component TX;
-------------------SIGNALS------------------------------
constant NBITS          : integer :=   8;
signal clk_int          : std_logic:= '1';
signal reset_int        : std_logic:= '1';
signal sending_int      : std_logic:= '0';
signal tx_d_int         : std_logic:= '1';

constant frequency : integer  :=24; --MHz
constant periode   : time     := 1 us/frequency;--ns
signal   stop      : boolean  := false;

begin 
-----------------MAPEO I/O---------------------------------
DUT: TX 
generic map ( n_bitsdata => NBITS)
PORT MAP (
         clk          => clk_int,
			reset        => reset_int,
			tx_d         => tx_d_int,
			sending      => sending_int);
----------------ESTIMULATION---------------------------------
clock:process 
begin
clk_int<= '1', '0'after periode/2;
wait for periode;
if stop then 
	wait;
	end if;
end process clock;
reset_int <= '1', '0' after periode*3/2;

sending_int <= '0', '1' after 50 us, '0' after 790 us, '1' after 900 us;

PRUEBA:process
begin

for i in 0 to 23453 loop   ---ciclo de simulacion e 985000 ns/ (periodo de clock=42 ns (aprox) = 2345 redondeado
	wait for 3 ns;
	wait until rising_edge (clk_int);
	wait for 2 ns;
end loop;

stop <= true;
wait;
end process PRUEBA;
end architecture Behavioral;