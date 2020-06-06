;podzielniki tonow 1 oktawy
DzC equ 36151 ;1193000/33
DzD equ 32343 ;1193000/37
DzE equ	29097 ;1193000/41
DzF equ	27113 ;1193000/44
DzG equ 24346 ;1193000/49
DzA equ 21690 ;1193000/55
DzH equ 19241 ;1193000/62
;podzielniki poltonow 1 oktawy
CiS equ 34085 ;1193000/35
Dis equ 30589 ;1193000/39
Eis equ 28404 ;1193000/42
Fis equ 25934 ;1193000/46
Gis equ 22942 ;1193000/52
Ais equ 20568 ;1193000/58
;dlugosci dzwiekow
Cal equ 16
Pol	equ 8
Cw	equ 4
Os	equ 2
Sz	equ	1
Pz equ 1
Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

start:          mov     ax,dane
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt
				
;------------------------------------------------------------------------------------------------
				;pobranie adresu segmentu PSP(Program Segment Prefix) do rejestru BX
				mov		ah,62h
				int		21h
				
				;pobranie dlugosci argumentu z PSP
				mov		es,bx
				mov		cl,es:[80h]
				
				;sprawdzanie czy w PSP jest argument
				cmp		cl,0
				jz		sciezka
				
				;zmniejszenie dlugosci o 1 (bo lancuch zawiera spacje)
				dec		cl
				
				;kopiowanie argumentu
				mov		si,0
				mov		bx,offset plik
petla1:			mov		al,es:[82h]+si
				mov		ds:[bx]+si,al
				inc		si
				loop	petla1
				jmp		dalej1
				
				;wczytanie sciezki z klawiatury
sciezka:		mov		ah,09h
				mov		dx,offset podajPlik
				int		21h

				mov		ah,0ah
				mov		dx,offset max
				int 	21h
				
				;usluga otwierania plikow wymaga 0 na koncu sciezki
				mov		bh,0             
				mov		bl,len           
				mov 	plik[bx],0
				
;------------------------------------------------------------------------------------------------				
				;obsluga plikow
				
				;otwieramy plik
dalej1:			mov		al,0 ; 0 - tryb do odczytu
				mov		ah,3dh
				mov		dx,offset plik
				int		21h
				jc		blad1 ; CY=1 jesli nie udalo sie pobrac uchwytu
				jmp		s1

blad1:			jmp		blad2
				
s1:				mov		bx,ax
				mov		dx,offset melodia
				
petla2:			mov 	cx,03h ; ile bajtow pobrac
				mov		ah,3fh
				int		21h
				jc		blad1 ; CY=1 jesli nie udalo sie pobrac danych
				
				cmp		ax,1 ; sprawdzamy czy koniec
				jz		dalej2				
				add		dx,ax ; przesuwamy sie na nastepny dzwiek
				jmp		petla2

				;zamykamy plik
dalej2:			mov		ah,3eh
				int		21h
				
;------------------------------------------------------------------------------------------------	
				;praca na melodii
			
				cld
				mov		si,offset melodia
petla4:			lodsb
				xor		bx,bx
				
				;sprawdzamy czy koniec
				cmp		al,'K'
				jz		koniec2
				jmp		s2
				
koniec2:		jmp		koniec				
				
				;sprawdzamy tony
s2:				cmp		al,'C'
				jz		dzwiekC
				cmp		al,'D'
				jz		dzwiekD
				cmp		al,'E'
				jz		dzwiekE
				cmp		al,'F'
				jz		dzwiekF
				cmp		al,'G'
				jz		dzwiekG
				cmp		al,'A'
				jz		dzwiekA
				cmp		al,'H'
				jz		dzwiekH
				cmp		al,'S'
				jz		pauza				
				
				;sprawdzamy poltony
				cmp		al,'c'
				jz		dzwiekCis
				cmp		al,'d'
				jz		dzwiekDis
				cmp		al,'e'
				jz		dzwiekEis
				cmp		al,'f'
				jz		dzwiekFis
				cmp		al,'g'
				jz		dzwiekGis
				cmp		al,'a'
				jz		dzwiekAis
				
				;ladowanie dzwieku
dzwiekC:		mov		bx,DzC
				jmp		oktawa
dzwiekD:		mov		bx,DzD
				jmp		oktawa
dzwiekE:		mov		bx,DzE
				jmp		oktawa
dzwiekF:		mov		bx,DzF
				jmp		oktawa
dzwiekG: 		mov		bx,DzG
				jmp		oktawa
dzwiekA:		mov		bx,DzA
				jmp		oktawa
dzwiekH:		mov		bx,DzH
				jmp		oktawa
dzwiekCis:		mov		bx,Cis
				jmp		oktawa
dzwiekDis:		mov		bx,Dis
				jmp		oktawa
dzwiekEis:		mov		bx,Eis
				jmp		oktawa
dzwiekFis:		mov		bx,Fis
				jmp		oktawa
dzwiekGis:		mov		bx,Gis
				jmp		oktawa
dzwiekAis:		mov		bx,Ais
				jmp		oktawa
pauza:			mov		bx,Pz
				inc		si
				jmp		dlugosc
				
				;sprawdzamy oktawy
oktawa:			lodsb
				mov		cl,al ; zapamietanie oktawy
				sub		cl,'0' ; odejmujemy '0' by otrzymac wartosc liczbowa
				dec		cl
				shr		bx,cl ; modyfikujemy podzielnik
				
				;sprawdzamy dlugosc
dlugosc:		lodsb
				cmp		al,'N'
				jz		calN
				cmp		al,'P'
				jz		polN
				cmp		al,'Q'
				jz		cwN
				cmp		al,'O'
				jz		osemka
				cmp		al,'Z'
				jz		szesn
								
				;ladowanie dlugosci dzwieku
calN:			mov		cl,Cal
				jmp		odtworz
polN:			mov		cl,Pol	
				jmp		odtworz
cwN:			mov		cl,Cw
				jmp		odtworz
osemka:			mov		cl,Os
				jmp		odtworz
szesn:			mov		cl,Sz				
				
				;przesyłamy podzielnik
odtworz:		mov		ax,bx
				out		42h,al
				mov		al,ah
				out		42h,al
				
				;odblokowanie glosnika
				in		al,61h
				or		al,00000011b
				out		61h,al						
				
				;czekanie
petla3:			mov		dx,65535 ; okolo 1/16 sekundy
				push	cx
				xor		cx,cx
				mov		al,0
				mov		ah,86h
				int		15h
				pop		cx
				loop	petla3	
								
				;blokowanie glosnika
				in		al,61h
				and 	al,11111100b
				out		61h,al				
				jmp		petla4
				
				;konczenie programu
koniec:			mov     ah,4ch
				mov	    al,0
				int	    21h

				;komunikat o bledzie pliku
blad2:			mov		ah,09h
				mov		dx,offset linia
				int		21h
				mov		ah,09h
				mov		dx,offset tekst
				int		21h
				jmp		koniec
								
Progr           ends

dane            segment
max				db		127
len				db		?
plik			db		127 dup(0)
podajPlik		db		'Podaj sciezke do pliku: $'
tekst			db		'Blad pliku.$'
linia			db		0ah,0dh,'$'
melodia			db		1000h dup(0)
dane            ends

stosik          segment
                dw    	100h dup(0)
szczyt          Label word
stosik          ends

end start