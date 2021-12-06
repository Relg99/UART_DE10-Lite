library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity TX is
    generic (
        n_bitsdata : positive :=  8;
        baud_rate  : integer  :=  115200
        );
    port(
        clk: in std_logic;
        reset: in std_logic;
        sending: in std_logic;
        tx_d: out std_logic
        );
end entity TX;


architecture rtl of TX is 
type status is (Tx_Idle, Tx_Start, TX_Data, Tx_Stop);

signal next_status      : status; 

signal register_dataTx  :  std_logic_vector (n_bitsdata-1 downto 0);
signal buffer_Tx        : std_logic_vector (n_bitsdata-1 downto 0);
signal counter_bits     :  integer range 0 to 8; 
signal indice           :  integer range 0 to 2;
signal counter_pulse    :  unsigned (7 downto 0);

constant pulses_count   : integer:=(24000000/baud_rate);

type msg is array (0 to 2) of std_logic_vector (n_bitsdata-1 downto 0);

constant message: msg := (
    "01001000",
								
    "01101111",
								
    "01100001"
    );

begin 

Tx: process (clk) begin

	if rising_edge (clk) then

		if reset='1' then

			tx_d            <= '1';
			indice          <= 0;
			buffer_Tx       <= (others => '0');
			register_dataTx <= (others => '0');
			next_status     <= Tx_Idle;
		else 
			case next_status is 
			
				when Tx_Idle =>

					tx_d <= '1';

					if sending = '1' then

						register_dataTx <= message(indice);

						if indice<message'length-1 then

							indice <= indice + 1;

						else 

							indice <= 0;

						end if;

						counter_pulse <= (others => '0');
						counter_bits  <= 0;
						
						next_status <= Tx_Start;

					end if;
					
				when Tx_Start =>

					tx_d <= '0';
					next_status <= Tx_Data; 
					
				when Tx_Data =>

					if counter_pulse < pulses_count-1 then

						counter_pulse <= counter_pulse+1;

					else

						tx_d            <= register_dataTx(counter_bits);
						counter_pulse   <= (others => '0');

						if counter_bits < n_bitsdata-1 then

							counter_bits <= counter_bits+1;

						else 

							counter_bits    <= 0;
							next_status     <= Tx_Stop;

						end if;
					end if;
					
				when Tx_Stop =>

					if counter_pulse < pulses_count-1 then

						counter_pulse <= counter_pulse+1;

					else 

						tx_d            <= '1';
						counter_pulse   <= (others => '0');
						buffer_Tx       <= register_dataTx;
						next_status      <= Tx_Idle;

					end if;
					
			end case;

		end if;

	end if;

end process Tx;

end architecture;