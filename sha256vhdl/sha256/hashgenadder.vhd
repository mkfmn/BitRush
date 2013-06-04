----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:32 06/02/2013 
-- Design Name: 
-- Module Name:    hashgenadder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.array64.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use 

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hashgenadder is
			Generic ( numofhashers : integer);
			Port(	clk: in STD_LOGIC;
					founcnonce: out STD_LOGIC_VECTOR(31 downto 0):= (others=>'0');
					foundit: out STD_LOGIC:='0');

end hashgenadder;

architecture Behavioral of hashgenadder is
		 COMPONENT pythonjob
			Port(	clk: in STD_LOGIC;
					letters_out,hvalues: out letterarray;
					temp_out,chunk32_2,chunk32_4,chunk32_5,chunk32_6,chunk32_7,chunk32_8,chunk32_9,chunk32_10,chunk32_11,chunk32_12,chunk32_13,chunk32_14,chunk32_15,chunk32_16,chunk32_17: out STD_LOGIC_VECTOR(31 downto 0));
		 END COMPONENT;	
		COMPONENT custom512
			Port(	clk: in STD_LOGIC;
					wordsext: in arrayofvectors61;
					letters_in: in letterarray;
					temp_in: in STD_LOGIC_VECTOR(31 downto 0);
					hvalues: in letterarray;
					chunkhash: out STD_LOGIC_VECTOR(255 downto 0):= (others=>'0'));
			END COMPONENT;

		
		 COMPONENT custextendto64
			Port(	clk: in STD_LOGIC;
					chunk32_2,chunk32_3,chunk32_4,chunk32_5,chunk32_6,chunk32_7,chunk32_8,chunk32_9,chunk32_10,chunk32_11,chunk32_12,chunk32_13,chunk32_14,chunk32_15,chunk32_16,chunk32_17: in STD_LOGIC_VECTOR(31 downto 0);
					extpart : out arrayofvectors61 := (others=> (others=> '0')));
		 END COMPONENT;
		 COMPONENT hashadder
			generic ( numofhashers,thishasher : integer );
			Port(	clk: in STD_LOGIC;
				nonce: out STD_LOGIC_VECTOR(31 downto 0):= std_logic_vector(to_unsigned(2147483647/numofhashers+thishasher,32)));
		 END COMPONENT;
		signal letters_out : letterarray;
		signal wordsext : arrayofvectors61 :=(others=> (others =>'0'));
		signal firsthash : STD_LOGIC_VECTOR(255 downto 0);
		signal temp_out,schunk32_2,schunk32_4,schunk32_5,schunk32_6,schunk32_7,schunk32_8,schunk32_9,schunk32_10,schunk32_11,schunk32_12,schunk32_13,schunk32_14,schunk32_15,schunk32_16,schunk32_17 : STD_LOGIC_VECTOR(31 downto 0);
		signal nonce : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
		signal hvalues : letterarray; 
begin

--					letters_out: in letterarray;
--					temp_out,chunk32_4,chunk32_5,chunk32_6,chunk32_7,chunk32_8,chunk32_9,chunk32_10,chunk32_11,chunk32_12,chunk32_13,chunk32_14,chunk32_15,chunk32_16,chunk32_17: in STD_LOGIC_VECTOR(31 downto 0);
		 
		 
		 txrx: pythonjob PORT MAP(
					clk         => clk,
					letters_out => letters_out,
					hvalues     => hvalues,
					temp_out    => temp_out,
					chunk32_2   => schunk32_2,
					chunk32_4   => schunk32_4,
					chunk32_5   => schunk32_5,
					chunk32_6   => schunk32_6,
					chunk32_7   => schunk32_7,
					chunk32_8   => schunk32_8,
					chunk32_9   => schunk32_9,
					chunk32_10  => schunk32_10,
					chunk32_11  => schunk32_11,
					chunk32_12  => schunk32_12,
					chunk32_13  => schunk32_13,
					chunk32_14  => schunk32_14,
					chunk32_15  => schunk32_15,
					chunk32_16  => schunk32_16,
					chunk32_17  => schunk32_17);
					
		makehashers: for I in 0 to numofhashers generate
			wordsext(3)<=nonce;
			ux: custextendto64 PORT MAP(
					clk         => clk,
					chunk32_2   => schunk32_2,
					chunk32_3   => nonce,
					chunk32_4   => schunk32_4,
					chunk32_5   => schunk32_5,
					chunk32_6   => schunk32_6,
					chunk32_7   => schunk32_7,
					chunk32_8   => schunk32_8,
					chunk32_9   => schunk32_9,
					chunk32_10  => schunk32_10,
					chunk32_11  => schunk32_11,
					chunk32_12  => schunk32_12,
					chunk32_13  => schunk32_13,
					chunk32_14  => schunk32_14,
					chunk32_15  => schunk32_15,
					chunk32_16  => schunk32_16,
					chunk32_17  => schunk32_17,
					extpart     => wordsext);		
		 uxn: hashadder 
			GENERIC MAP(
				numofhashers => numofhashers,
				thishasher   => I)
			PORT MAP(
				clk   => clk,
				nonce => nonce);
			first512hash : custom512
			port map (
				clk        => clk,
				wordsext   => wordsext,
				letters_in => letters_out,
				temp_in    => temp_out,
				hvalues    => hvalues,
				chunkhash  => firsthash);				
		end generate makehashers;
		
		

		
		

		
		

end Behavioral;

