				ORG 800H  
				LXI H,ETYK1  
				RST 3  
				RST 5  
				LXI H,ETYK2  
POW 	 			RST 3  
				RST 2  
				CPI 2BH ;sprawdzenie czy +  
				JZ DOD  
				CPI 2DH ;sprawdzenie czy -  
				JZ ODEJM  
				CPI 6EH ;sprawdzenie czy n  
				JZ NEG  
				STC  
				CMC  
				JMP POW  
DOD 	 			LXI H,ETYK4 ;dodawanie  
				RST 3  
				MOV H,D  
				MOV L,E  
				RST 5  
				MVI A,10  
				RST 1  
				MVI A,13  
				RST 1  
				DAD D  
				MVI A,00H  
				ADC B  
				RST 4  
				MOV A,H  
				RST 4  
				MOV A,L  
				RST 4  
				HLT  
ODEJM 	 			LXI H,ETYK4 ;odejmowanie  
				RST 3  
				MOV H,D  
				MOV L,E  
				RST 5  
				MVI A,10  
				RST 1  
				MVI A,13  
				RST 1  
				MOV A,H  
				CMP D  
				JC WAR1  
				MOV A,L  
				CMP E  
				JC WAR2  
				MOV A,H ;wykonaj jeśli SB1 i MB1 > od SB2 i MB2  
				SUB D  
				RST 4  
				MOV A,L  
				SUB E  
				RST 4  
				HLT
WAR1 	 			STC  
				CMC  
				MOV A,L  
				CMP E
				JZ WAR3 ;skok jeśli SB1 < SB2 i MB1 = MB2  
				JC WAR3  
				MVI A,'-' ;wykonaj jeśli SB1 < SB2 i MB1 > MB2  
				RST 1  
				MOV A,D  
				SUB H  
				DCR A ; -1 bo pożyczka  
				RST 4  
				MOV A,E  
				SUB L  
				RST 4  
				HLT  
WAR2 	 			MOV A,H ;wykonaj jeśli SB1 > SB2 i MB1 < MB2  
				SUB D
				JZ WAR3 ;skok jeśli SB1 = SB2 i MB1 < MB2  
				DCR A ; -1 bo pożyczka  
				RST 4  
				MOV A,L  
				SUB E  
				RST 4  
				HLT  
WAR3 	 			MVI A,'-' ;wykonaj jeśli SB1 < SB2 i MB1 < MB2  
				RST 1  
				MOV A,D  
				SUB H  
				RST 4  
				MOV A,E  
				SUB L  
				RST 4  
				HLT  
NEG 	 			LXI H,ETYK3 ;negacja  
				RST 3  
				MOV A,D  
				CMA  
				RST 4  
				MOV A,E  
				CMA  
				RST 4  
				HLT  
ETYK1 	 			DB 'Podaj wartosc 1 operandu > ','@'             
ETYK2 	 			DB 10,13,'Podaj operator dzialania > ','@'       
ETYK3 	 			DB 10,13,'@'                                                    
ETYK4 	 			DB 10,13,'Podaj wartosc 2 operandu > ','@' 
