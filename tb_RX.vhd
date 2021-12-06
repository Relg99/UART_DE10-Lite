library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_RX is
end entity;

architecture sim of tb_RX is

component RX is 
generic (n_bitsdata :positive := 8);
port(
		clk:          in std_logic;
		reset:        in std_logic;
		rx_d:         in std_logic;
		data_package: out std_logic_vector(n_bitsdata-1 downto 0));
end component;

constant NBITS:           integer := 8;
signal clk_int :          std_logic:= '1';
signal reset_int :        std_logic:= '1';
signal rx_d_int :         std_logic:='1';
signal data_package_int : std_logic_vector(NBITS-1 downto 0);

constant frequency : integer  :=24; --MHz
constant periode   : time     := 1 us/frequency;--ns
signal   stop      : boolean  := false;

begin 

    DUT: RX 
    generic map ( n_bitsdata => NBITS)
    PORT MAP (
                clk          => clk_int,
                reset        => reset_int,
                rx_d         => rx_d_int,
                data_package => data_package_int);

    clock:process 
    begin  

        clk_int<= '1', '0'after periode/2;
        wait for periode;

        if stop then

            wait;
            
        end if;
    end process clock;

    reset_int <= '1', '0' after periode*3/2;

    PRUEBA:process
    begin

        rx_d_int <= '1';
        wait for 8681 ns;

        rx_d_int <= '0';
        wait for 8681 ns;


        rx_d_int <= '0';    --bit 0 => 0
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 1 => 0
        wait for 8681 ns;
        
        rx_d_int<= '0';     --bit 2 => 0
        wait for 8681 ns;
        
        rx_d_int <= '1';    --bit 3 => 1
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 4 => 0
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 5 => 0
        wait for 8681 ns;
        
        rx_d_int<= '1';     --bit 6 => 1
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 7 => 0
        wait for 8681 ns;

        rx_d_int<= '1' ;
        wait for 8681 ns;
        
        
        

        rx_d_int <= '1';
        wait for 8681 ns;

        rx_d_int <= '0';
        wait for 8681 ns;


        rx_d_int <= '1';    --bit 0 => 1
        wait for 8681 ns;
        
        rx_d_int <= '1';    --bit 1 => 1
        wait for 8681 ns;
        
        rx_d_int<= '1';     --bit 2 => 1
        wait for 8681 ns;
        
        rx_d_int <= '1';    --bit 3 => 1
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 4 => 0
        wait for 8681 ns;
        
        rx_d_int <= '1';    --bit 5 => 1
        wait for 8681 ns;
        
        rx_d_int<= '1';     --bit 6 => 1
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 7 => 0
        wait for 8681 ns;

        rx_d_int<= '1' ;
        wait for 8681 ns;
        
        
        

        
        rx_d_int <= '1';
        wait for 8681 ns;
        
        

        rx_d_int <= '0';
        wait for 8681 ns;


        rx_d_int <= '1';    --bit 0 => 1
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 1 => 0
        wait for 8681 ns;
        
        rx_d_int<= '0';     --bit 2 => 0
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 3 => 0
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 4 => 0
        wait for 8681 ns;
        
        rx_d_int <= '1';    --bit 5 => 1
        wait for 8681 ns;
        
        rx_d_int<= '1';     --bit 6 => 1
        wait for 8681 ns;
        
        rx_d_int <= '0';    --bit 7 => 0
        wait for 8681 ns;

        rx_d_int<= '1' ;
        wait for 8681 ns;
        

        rx_d_int <= '1';
        wait for 8681 ns;

    stop <=true;
    wait;
    end process PRUEBA;
    
end architecture;