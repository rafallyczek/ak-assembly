Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

start:          mov     ax,dane
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt
				
;------------------------------------------------------------------------------------------------
				;pobranie czasu systemowego
petla:			xor		ax,ax				
				int		1ah	; czas zapisuje się w DX (młodsza cześć) i CX (starsza część)			
				
				;losowanie linii w terminalu
				mov		dh,0
				mov		si,dx
				mov		bl,liczby[si] ; pobieramy losową liczbę				
				mov		al,160 ; jedna linia to 160B				
				mul		bl     ; wyznaczamy numer linii
				
;------------------------------------------------------------------------------------------------
				;kopiowanie wylosowanej linii do zmiennej kopia
				mov		cx,80
				push	ds
				pop		es
				push	ds
				mov		si,ax
				push	ax ;zapisanie numeru linii na stosie
				mov		di,offset kopia
				mov		ax,0b800h
				mov		ds,ax				
				rep		movsw
				
;------------------------------------------------------------------------------------------------
				;zasłanianie linii w terminalu				
				mov		cx,80
				mov		es,ax
				pop		di
				push	di
				mov		al,32 ; 32 - kod spacji
				mov		ah,01110111b ; 01110111 - jasno-szary kolor tła oraz jasno-szary kolor znaku
				rep		stosw
				
				;czekanie 0,5s
				mov		cx,8
				xor		dx,dx
				xor		ax,ax
				mov		ah,86h
				int		15h
				
;------------------------------------------------------------------------------------------------				
				;wypisywanie linii ze zmiennej kopia
				mov		cx,80
				pop		di
				pop		ds
				mov		si,offset kopia
				rep		movsw
				
				;sprawdzanie czy przycisk zostal wcisniety
				mov		ah,01h
				int		16h
				jnz		koniec
				jmp		petla
				
				;konczenie programu
koniec:			mov     ah,4ch
				mov	    al,0
				int	    21h
				
Progr           ends

dane            segment
kopia			db		160 dup(?)
liczby			db		7, 1, 3, 2, 7, 23, 0, 13, 9, 23, 19, 19, 7, 24, 19, 20, 4, 5, 13, 12, 21, 23, 9, 5, 9, 12, 24, 20, 8, 11, 19, 6, 23, 19, 7, 8, 23, 16, 10, 9, 0, 20, 1, 12, 17, 22, 3, 10, 20, 8, 5, 0, 20, 15, 13, 11, 10, 14, 9, 24, 6, 14, 5, 8, 13, 2, 13, 22, 14, 21, 21, 19, 19, 1, 22, 10, 14, 1, 20, 20, 11, 9, 17, 22, 23, 24, 12, 23, 0, 24, 20, 0, 14, 7, 15, 14, 22, 13, 20, 5, 2, 11, 12, 1, 11, 20, 24, 9, 5, 10, 4, 1, 1, 1, 9, 3, 6, 3, 2, 18, 2, 21, 15, 5, 6, 17, 3, 4, 17, 0, 2, 22, 14, 20, 15, 5, 5, 4, 18, 20, 12, 22, 16, 20, 11, 6, 23, 19, 14, 24, 0, 6, 8, 12, 14, 15, 13, 13, 9, 2, 6, 3, 3, 0, 4, 14, 2, 21, 19, 8, 10, 7, 19, 3, 8, 4, 1, 12, 22, 12, 24, 20, 11, 19, 5, 18, 17, 2, 2, 17, 0, 20, 10, 13, 19, 15, 24, 20, 22, 0, 13, 22, 15, 4, 10, 7, 0, 21, 11, 23, 21, 2, 7, 16, 4, 5, 13, 17, 20, 18, 22, 8, 0, 16, 12, 2, 13, 11, 12, 4, 6, 21, 18, 4, 10, 4, 13, 2, 6, 23, 8, 19, 6, 10, 0, 2, 9, 16, 18, 0, 22, 6, 0, 18, 13, 17
dane            ends

stosik          segment
                dw    	100h dup(0)
szczyt          Label word
stosik          ends

end start