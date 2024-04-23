----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2020 05:59:43 PM
-- Design Name: 
-- Module Name: clock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.round;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
		   duty_cycle : in std_logic_vector(31 downto 0); -- Decides pulse width
		   pulse_cycles : in std_logic_vector(31 downto 0); -- Decides frequency
           count_temp : out std_logic_vector(31 downto 0);
           clk_1 : out STD_LOGIC;
           clk_2 : out STD_LOGIC
           );
end clock;

architecture Behavioral of clock is
-- SIGNAL ALLOCATION
    signal clk_1_temp : std_logic := '0';
    signal clk_1_out : std_logic := '0';
    signal clk_2_temp : std_logic := '0';
    signal count_1 : std_logic_vector (31 downto 0):= (others => '0') ;
    signal count_2 : std_logic_vector (31 downto 0):= (others => '0') ;    
    signal dcc_filler :  unsigned (63 downto 0):=  (others => '0')    ;
    signal duty_cycle_count :  std_logic_vector (31 downto 0) := (others => '0');
-- END OF SIGNAL ALLOCATION
begin

    dcc_filler <= ((unsigned(pulse_cycles)*unsigned(duty_cycle))/10000); -- ORIGINALLY 'X/100' (CHANGED TO 10000 FOR MORE PRECISION)
    duty_cycle_count <=  std_logic_vector(dcc_filler(31 downto 0));
    
    process(clk,reset)
    begin 
        if(rising_edge(clk)) then 
            if(unsigned(count_1) < unsigned(pulse_cycles)) then 
                 count_1 <= count_1 + 1;
            else
                count_1 <= std_logic_vector(to_unsigned(1,32)); -- 'count_1' has hit 'pulse_cycles'
                clk_1_temp <= not clk_1_temp;   
            end if;
        end if;
    end process; 
    
    process (clk,clk_1_temp) 
    begin 
        if(rising_edge(clk)) then 
            if(clk_1_temp = '1') then 
                if(unsigned(count_1) < unsigned(duty_cycle_count)) then
                    clk_1_out	<= '1'; 
             else	
                    clk_1_out	<= '0';
                end if;
            end if;
        end if;
    end process;
    
    clk_1 <= clk_1_out;
    clk_2 <= clk_1_temp;
    count_temp <= duty_cycle_count;

end Behavioral;
