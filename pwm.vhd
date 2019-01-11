LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is       
  PORT( 
      pwm_out   : OUT STD_LOGIC;
		i_out : OUT STD_LOGIC);  		          							       --pwm output
END pwm;

ARCHITECTURE logic OF pwm IS
  CONSTANT sys_clk         : INTEGER := 50e6;  --system clock frequency in Hz
  CONSTANT pwm_freq        : INTEGER := 1e6;   --PWM switching frequency in Hz
  CONSTANT duty : INTEGER := 2;                                             --duty_cycle=1/duty
  CONSTANT ClockPeriod    : time    := 1000 ms / sys_clk;
  CONSTANT clock :  INTEGER := sys_clk/pwm_freq;                            --number of clocks in one pwm period  
  CONSTANT no_clock : INTEGER := clock/duty;
  signal Clk    : std_logic := '1';

BEGIN
 Clk <= not Clk after ClockPeriod / 2;
 assert 2 < 5 report "unexpected value. no_clock = " & integer'image(no_clock);
 process (Clk)
    VARIABLE i : INTEGER := 0; 
	 VARIABLE flag : STD_LOGIC; 
    BEGIN 
		IF(rising_edge(Clk)) THEN
        IF(i = clock) THEN                                                  --end of period reached
          i := 0;                                                           --reset counter
		    flag := '0';
		  ELSE                                                                --end of period not reached
          i := i + 1;                                                       --increment counter
          flag := '1';
		  END IF;
		  i_out <= flag;
        IF(i < no_clock+1) THEN                                          
          pwm_out  <= '1';                                                  --assert the pwm output
        ELSE                        
          pwm_out <= '0';                                                   --deassert the pwm output
        END IF;
		END IF;
 END process;
END logic;