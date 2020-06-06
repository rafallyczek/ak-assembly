Progr           		segment
                		assume  cs:Progr, ds:dane, ss:stosik

start:          		mov     ax,dane
                		mov     ds,ax
                		mov     ax,stosik
                		mov     ss,ax
                		mov     sp,offset szczyt
				
				;wypisanie lancucha etykieta1 na ekran
				mov		ah,09h
				mov 	dx,offset etykieta1
				int		21h
				
				;wczytanie ciagu znakow
				mov 	ah,0ah
				mov 	dx,offset max
				int 	21h

;------------------------------------------------------------------------------------------------				
				;sprawdzanie czy ciag jest liczba
				mov		si,0
				mov		ch,0   ;do cx przesylamy dlugosc lancucha
				mov		cl,len ; -,,-				
spr1:				mov		bx,offset tekst				
				mov 	al,[bx]+si ;pobieranie znaku
				inc		si
				sub		al,48 ; 48 - kod znaku '0'
				cmp		al,10
				jnc		blad1
				loop 	spr1
				jmp		dalej1
				
				;wyswietlenie komunikatu o bledzie (jesli nie jest liczba)
blad1:				mov		ah,09h
				mov		dx,offset nowalinia
				int		21h
				mov		ah,09h
				mov		dx,offset bladL
				int		21h
				jmp		koniec

;------------------------------------------------------------------------------------------------				
				;sprawdzanie czy liczba miesci sie w zakresie
dalej1:				mov		si,0
				mov		ch,0   ;do cx przesylamy dlugosc lancucha
				mov		cl,len ; -,,-
				mov		ax,0 ;inicjalizacja sumy wartoscia 0				
spr2:				mov		bx,offset tekst
				mov		dx,10
				mul		dx ;mnozenie sumy przez 10
				jc		blad2
				push		ax
				mov		ah,0
				mov		al,[bx]+si ;pobieranie znaku
				inc		si
				sub		al,48 ; 48 - kod znaku '0'
				pop		bx
				add		ax,bx ;zwiekszamy sume
				jc		blad2
				loop		spr2
				push 		ax
				jmp		dalej2
				
				;wyswietlenie komunikatu o bledzie (poza zakresem)
blad2:				mov		ah,09h
				mov		dx,offset nowalinia
				int		21h		
				mov		ah,09h
				mov		dx,offset bladZ
				int		21h
				jmp		koniec
				
;------------------------------------------------------------------------------------------------
				;wypisanie wartosci w systemie dec					
dalej2:				mov		ah,09h
				mov 		dx,offset nowalinia
				int		21h
				
				mov		ah,09h
				mov		dx,offset liczbadec
				int 		21h
				
				;wpisanie '$' na koniec ciagu
				mov		bh,0             ;do bx przesylamy dlugosc lancucha
				mov		bl,len           ; -,,-
				mov 		tekst[bx],'$'    ;wstawiamy znak '$' na koniec lancucha
			
				;wypisanie ciagu na ekran
				mov		ah,09h
				mov 		dx,offset tekst
				int		21h				

;------------------------------------------------------------------------------------------------				
				;konwersja na hex
				pop		ax
				mov		si,0
				mov		ch,0
				mov		cl,4				
				mov		dx,ax
				push		dx
konw1:				mov		bx,000fh				
				rol		ax,4
				and		bx,ax
				mov		dl,znakihex[bx]
				mov		hex[si],dl
				inc		si
				loop 		konw1
				
;------------------------------------------------------------------------------------------------				
				;wypisanie wartosci w systemie hex
				mov		ah,09h
				mov 		dx,offset nowalinia
				int		21h
				
				mov		ah,09h
				mov		dx,offset liczbahex
				int 		21h
				
				mov		ah,09h
				mov 		dx,offset hex
				int		21h
				
;------------------------------------------------------------------------------------------------				
				;konwersja na bin
				
				pop		ax
				mov		si,0
				mov		ch,0
				mov		cl,16
konw2:				rol		ax,1
				jc		jeden
				jnc		zero
jeden:				mov		bin[si],'1'
				inc		si
				loop		konw2
				jmp		dalej3
zero:				mov		bin[si],'0'
				inc		si
				loop		konw2
;------------------------------------------------------------------------------------------------				
				;wypisanie wartosci w systemie bin				
dalej3:				mov		ah,09h
				mov 		dx,offset nowalinia
				int		21h
				
				mov		ah,09h
				mov		dx,offset liczbabin
				int 		21h
				
				mov		ah,09h
				mov 		dx,offset bin
				int		21h

				;konczenie programu
koniec:				mov     	ah,4ch
				mov	    	al,0
				int	    	21h
				
Progr           		ends

dane            		segment
max				db		6
len				db		?
tekst				db		6 dup(0)
etykieta1			db		'Podaj ciag znakow : $'
nowalinia			db 		0ah,0dh,'$'
bladL				db		'Ciag nie jest liczba.$'
bladZ				db		'Liczba poza zakresem.$'
liczbadec			db		'Dec: $'
liczbahex			db		'Hex: $'
liczbabin			db		'Bin: $'
znakihex			db		'0123456789ABCDEF$'
hex				db		'0000$'
bin				db		'0000000000000000$'
dane            		ends

stosik          		segment
                		dw    	100h dup(0)
szczyt          		Label word
stosik          		ends

end start
