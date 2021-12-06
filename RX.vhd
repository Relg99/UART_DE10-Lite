library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity RX is
    generic (
        n_bitsdata  : positive := 8
    );
    port (
        clk             : in std_logic;
        reset           : in std_logic;
        rx_d            : in std_logic;
        data_package    : out std_logic_vector(n_bitsdata-1 downto 0)
    );
end entity;

architecture rtl of RX is

    type status is (Rx_Idle, Rx_Start, Rx_Data, Rx_Stop);

    signal next_status       : status;
    signal register_dataRx  : std_logic_vector (n_bitsdata-1 downto 0);
    signal buffer_Rx        : std_logic_vector (n_bitsdata-1 downto 0);
    signal counter_bits     : unsigned (3 downto 0);
    signal counter_pulse    : unsigned (3 downto 0);
    
    constant baud_rate      : integer := 115200;
    constant pulses_count   : integer := (24000000/baud_rate)-1;

begin

    Rx:process(clK) 
    begin 
        if rising_edge(clk) then

            if reset='1' then

                register_dataRx     <= (others => '0');
                buffer_Rx           <= (others => '0');
                next_status         <= Rx_Idle;

            else 
                case next_status is
                
                    when Rx_Idle =>

                    counter_bits     <= (others => '0');
                    counter_pulse    <= (others => '0');
                    register_dataRx  <= (others => '0');

                        if rx_d = '0' then

                            next_status <= Rx_Start;

                        end if;
                        
                    when Rx_Start =>

                        if counter_pulse <  (pulses_count/2) then

                            counter_pulse <= counter_pulse+1;

                        else 

                            counter_pulse <= (others => '0');

                            if rx_d = '0' then

                                next_status <= Rx_Data;

                            else 

                                next_status <= Rx_Idle;

                            end if;

                        end if; 

                    when Rx_Data =>

                        if counter_pulse   <  pulses_count then

                            counter_pulse   <= counter_pulse+1;
                            
                        else 

                            counter_pulse   <= (others => '0');

                            if counter_bits <   n_bitsdata then

                                register_dataRx <= rx_d & register_dataRx(n_bitsdata-1 downto 1);
                                counter_bits <= counter_bits +1;

                            else 

                                counter_bits <= (others => '0');
                                next_status <= Rx_Stop;

                            end if;

                        end if;
                        
                    when Rx_Stop =>

                        if counter_pulse < pulses_count then

                            counter_pulse <= counter_pulse+1;

                        else 

                            counter_pulse   <= (others => '0');
                            buffer_Rx       <= register_dataRx;
                            next_status     <= Rx_Idle;

                        end if;
                        
                end case;

            end if;

        end if;

    end process Rx;

    data_package <= buffer_Rx;

end architecture;