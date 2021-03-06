;<<<Computer_ziehen>>>
;Der Computer macht einen Zug
;Ein: -
;Aus: -
Computer_ziehen:
 pusha
 mov	[Im_Schach],0
 call	Zugliste_erstellen
 call	Schlagliste_Bauern
 call	Schachuhr_Zeit_zeichnen_6
 mov	ax,[Anzahl_m�glicher_Schl�ge]
 test	ax,ax			;Keine gegnerische Figur schlagbar?
 jz	Computer_ziehen_4
 call	Schlagliste_beste_M�glichkeit	;���
 mov	cx,fs
 test	cx,cx			;G�nstige Schlagm�glichkeit entdeckt?
 jz	Computer_ziehen_11
 mov	si,fs
 jmp	Computer_ziehen_12
Computer_ziehen_11:
 lea	si,Schlagliste
 xchg	ax,bx			;�� Zuf�llige Figur schlagen
 call	Zufallszahl2
 shl	ax,2
 add	si,ax
Computer_ziehen_12:
 lodsw
 mov	[Figur_ausgew�hlt],ax
 lodsw
 mov	word ptr[Cursor],ax
 call	Figur_Bauer
 test	ax,ax
 jnz	Computer_ziehen_7
 call	Bauernumwandlung
Computer_ziehen_7:
 popa
 call	Bemerkung_Schlagen
 jmp	Figur_l�schen		;Figur schlagen
Computer_ziehen_4:
 mov	ax,[Anzahl_m�glicher_Z�ge]
 test	ax,ax			;Patt?
 jnz	Computer_ziehen_6
 lea	dx,Bemerkung1
 call	Bemerkung_zeichnen
 jmp	Spielende
Computer_ziehen_6:
 call	Deckungsliste_auswerten
 call	Deckungsliste_sortieren
 lea	si,Zugliste
 xchg	ax,bx			;�� Zuf�lligen Zug machen
 call	Zufallszahl2
 shl	ax,2
 add	si,ax
 lodsw
 mov	[Figur_ausgew�hlt],ax
 lodsw
 mov	word ptr[Cursor],ax
 call	Figur_Bauer
 test	ax,ax
 jnz	Computer_ziehen_8
 call	Bauernumwandlung
Computer_ziehen_8:
 lea	bx,Cursor
 call	Figur_suchen
 cmp	si,Offset Turm1s
 jnz	Computer_ziehen_5
 mov	[Turm1s_bewegt],1
 jmp	Computer_ziehen_3
Computer_ziehen_5:
 cmp	si,Offset Turm2s
 jnz	Computer_ziehen_9
 mov	[Turm2s_bewegt],1
 jmp	Computer_ziehen_3
Computer_ziehen_9:
 cmp	si,Offset K�nigs
 jnz	Computer_ziehen_3
 mov	[K�nigs_bewegt],1
; mov	ax,[si]
; mov	bx,[Cursor]
; cmp	ax,bx
; ja	Computer_ziehen_10
; xchg	ax,bx
;Computer_ziehen_10:
; sub	ax,bx
; cmp	ax,2			;Rochade?
;���
Computer_ziehen_3:
 popa
 jmp	Ein_Spieler_20		;Figur r�cken
Computer_ziehen_2:
 popa
 call	Anderer_Spieler
 jmp	Ein_Spieler_2

;<<<Stellungsbewertung>>>	:�� F�r unterschiedliche Farben machen
;Bewertet die zentrale Stellung der Figuren
;Ein: -
;Aus: bx=Stellungspunkte
Stellungsbewertung:
 lea	si,Bauer1w
 xor	bx,bx
Stellungsbewertung_2:
 lodsw
 test	ax,ax			;Figur existiert nicht mehr?
 jz	Stellungsbewertung_3
 dec	al
 jz	Stellungsbewertung_3
 dec	ah
 jz	Stellungsbewertung_3
 dec	al
 jz	Stellungsbewertung_6
 dec	ah
 jz	Stellungsbewertung_6
 dec	al
 jz	Stellungsbewertung_5
 dec	ah
 jz	Stellungsbewertung_5
 inc	bx
 inc	bx
Stellungsbewertung_5:
 inc	bx
Stellungsbewertung_6:
 inc	bx
Stellungsbewertung_3:
 cmp	si,Offset Cursor	;Alle Figuren bewertet?
 jnz	Stellungsbewertung_2
 ret

;<<<Koordinaten_m�glich>>>
;Pr�ft ob Koordinaten auf dem Schachbrett liegen
;Ein: ax=Koordinaten
;Aus: ax=0 wenn wahr
Koordinaten_m�glich:
 push	cx
 mov	cx,2
Koordinaten_m�glich_3:
 test	al,al
 jz	Koordinaten_m�glich_2
 cmp	al,8
 ja	Koordinaten_m�glich_2
 xchg	al,ah
 loop	Koordinaten_m�glich_3
 xor	ax,ax
 jmp	Koordinaten_m�glich_4
Koordinaten_m�glich_2:
 dec	ax
Koordinaten_m�glich_4:
 pop	cx
 ret

;<<<M�gliche_Z�ge_Bauers>>>
;Erstellt eine Liste aller m�glichen Z�ge der schwarzen Bauern
;Ein: di=Zeiger auf Puffer
;Aus: -
M�gliche_Z�ge_Bauers:
 lea	si,Bauer1s
 mov	cx,8			;8 Bauern
M�gliche_Z�ge_Bauers_3:
 lodsw
 test	ax,ax			;Figur existiert nicht mehr?
 jz	M�gliche_Z�ge_Bauers_2
 stosw
 inc	ah
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld vor Bauern ist nicht besetzt?
 jz	M�gliche_Z�ge_Bauers_4
 dec	di
 dec	di
 pop	si
 jmp	M�gliche_Z�ge_Bauers_2
M�gliche_Z�ge_Bauers_4:
 pop	si
 stosw
 cmp	ah,3			;An Startposition?
 jnz	M�gliche_Z�ge_Bauers_2
 inc	ah
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;zweites Feld vor Bauern ist nicht besetzt?
 jnz	M�gliche_Z�ge_Bauers_5
 pop	si
 push	ax
 sub	ah,2
 stosw
 pop	ax
 stosw
 push	si
M�gliche_Z�ge_Bauers_5:
 pop	si
M�gliche_Z�ge_Bauers_2:
 loop	M�gliche_Z�ge_Bauers_3
 ret

;<<<M�gliche_Z�ge_gerade>>>
;Erstellt Liste aller geraden Z�ge einer Figur
;Ein: di=Puffer f�r Z�ge,si=Zeiger auf Koordinaten der Figur
;Aus: -
M�gliche_Z�ge_gerade:
 lodsw
 mov	bp,ax
 test	ax,ax			;Figur existiert nicht mehr?
 jz	M�gliche_Z�ge_gerade_5
M�gliche_Z�ge_gerade_3:
 inc	ah			;nach unten pr�fen
 cmp	ah,8			;unten angekommen?
 ja	M�gliche_Z�ge_gerade_2
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_gerade_4
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_gerade_2
M�gliche_Z�ge_gerade_4:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_gerade_3
M�gliche_Z�ge_gerade_2:
 mov	ax,[si-2]
M�gliche_Z�ge_gerade_6:
 dec	ah			;nach oben pr�fen
 test	ah,ah			;oben angekommen?
 jz	M�gliche_Z�ge_gerade_7
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_gerade_8
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_gerade_7
M�gliche_Z�ge_gerade_8:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_gerade_6
M�gliche_Z�ge_gerade_7:
 mov	ax,[si-2]
M�gliche_Z�ge_gerade_9:
 inc	ax			;nach rechts pr�fen
 cmp	al,8			;rechts angekommen?
 ja	M�gliche_Z�ge_gerade_10
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_gerade_11
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_gerade_10
M�gliche_Z�ge_gerade_11:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_gerade_9
M�gliche_Z�ge_gerade_10:
 mov	ax,[si-2]
M�gliche_Z�ge_gerade_12:
 dec	ax			;nach links pr�fen
 test	al,al			;links angekommen?
 jz	M�gliche_Z�ge_gerade_5
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_gerade_13
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_gerade_5
M�gliche_Z�ge_gerade_13:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_gerade_12
M�gliche_Z�ge_gerade_5:
 ret

;<<<M�gliche_Z�ge_schr�g>>>
;Erstellt Liste aller schr�gen Z�ge einer Figur
;Ein: di=Puffer f�r Z�ge,si=Zeiger auf Koordinaten der Figur
;Aus: -
M�gliche_Z�ge_schr�g:
 lodsw
 mov	bp,ax
 test	ax,ax			;Figur existiert nicht mehr?
 jz	M�gliche_Z�ge_schr�g_5
M�gliche_Z�ge_schr�g_3:
 inc	ah			;nach rechts unten pr�fen
 inc	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_schr�g_2
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_schr�g_4
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_schr�g_2
M�gliche_Z�ge_schr�g_4:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_schr�g_3
M�gliche_Z�ge_schr�g_2:
 mov	ax,[si-2]
M�gliche_Z�ge_schr�g_6:
 dec	ah			;nach links oben pr�fen
 dec	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_schr�g_7
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_schr�g_8
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_schr�g_7
M�gliche_Z�ge_schr�g_8:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_schr�g_6
M�gliche_Z�ge_schr�g_7:
 mov	ax,[si-2]
M�gliche_Z�ge_schr�g_9:
 dec	ah			;nach rechts oben pr�fen
 inc	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_schr�g_10
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_schr�g_11
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_schr�g_10
M�gliche_Z�ge_schr�g_11:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_schr�g_9
M�gliche_Z�ge_schr�g_10:
 mov	ax,[si-2]
M�gliche_Z�ge_schr�g_12:
 inc	ah			;nach links unten pr�fen
 dec	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_schr�g_5
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_schr�g_13
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_schr�g_5
M�gliche_Z�ge_schr�g_13:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
 jmp	M�gliche_Z�ge_schr�g_12
M�gliche_Z�ge_schr�g_5:
 ret

;<<<M�gliche_Z�ge_Turms>>>
;Erstellt eine Liste aller m�glichen Z�ge der schwarzen T�rme
;Ein: di=Zeiger auf Puffer
;Aus: -
M�gliche_Z�ge_Turms:
 lea	si,Turm1s
 call	M�gliche_Z�ge_gerade
 call	M�gliche_Z�ge_gerade
 ret

;<<<M�gliche_Z�ge_L�ufers>>>
;Erstellt eine Liste aller m�glichen Z�ge der schwarzen L�ufer
;Ein: di=Zeiger auf Puffer
;Aus: -
M�gliche_Z�ge_L�ufers:
 lea	si,L�ufer1s
 call	M�gliche_Z�ge_schr�g
 call	M�gliche_Z�ge_schr�g
 ret

;<<<M�gliche_Z�ge_Dames>>>
;Erstellt eine Liste aller m�glichen Z�ge der schwarzen Dame
;Ein: di=Zeiger auf Puffer
;Aus: -
M�gliche_Z�ge_Dames:
 lea	si,Dames
 mov	cx,8
M�gliche_Z�ge_Dames_2:
 push	cx
 call	M�gliche_Z�ge_gerade
 dec	si
 dec	si
 call	M�gliche_Z�ge_schr�g
 pop	cx
 loop	M�gliche_Z�ge_Dames_2
 ret

;<<<M�gliche_Z�ge_K�nigs>>>
;Erstellt eine Liste aller m�glichen Z�ge des schwarzen K�nigs
;Ein: di=Zeiger auf Puffer
;Aus: -
M�gliche_Z�ge_K�nigs:
 lea	si,K�nigs
 call	M�gliche_Z�ge_Feld_weiter	;���
; mov	ax,[K�nigs]
; mov	word ptr[Figur_ausgew�hlt],ax
; lea	bx,Cursor
; mov	word ptr[bx],103h
; call	Figur_suchen
; call	Rochade
; test	ax,ax			;Rochade durchf�hrbar?
; jnz	M�gliche_Z�ge_K�nigs_2
; mov	ax,[K�nigs]
; stosw
; mov	ax,103h
; stosw
;M�gliche_Z�ge_K�nigs_2:
; lea	bx,Cursor
; mov	word ptr[bx],107h
; call	Figur_suchen
; call	Rochade
; test	ax,ax			;Rochade durchf�hrbar?
; jnz	M�gliche_Z�ge_K�nigs_3
; mov	ax,[K�nigs]
; stosw
; mov	ax,107h
; stosw
M�gliche_Z�ge_K�nigs_3:
 ret

;<<<M�gliche_Z�ge_Springers>>>
;Erstellt eine Liste aller m�glichen Z�ge der schwarzen Springer
;Ein: di=Zeiger auf Puffer
;Aus: -
M�gliche_Z�ge_Springers:
 lea	si,Springer1s
 call	M�gliche_Z�ge_Ecksprung
 call	M�gliche_Z�ge_Ecksprung
 ret

;<<<M�gliche_Z�ge_Feld_weiter>>>
;Erstellt Liste aller Z�ge auf die benachbarten Felder einer Figur
;Ein: di=Puffer f�r Z�ge,si=Zeiger auf Koordinaten der Figur
;Aus: -
M�gliche_Z�ge_Feld_weiter:
 lodsw
 mov	bp,ax
 test	ax,ax			;Figur existiert nicht mehr?
 jz	M�gliche_Z�ge_Feld_weiter_2
 inc	ax			;nach rechts pr�fen
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_3
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_4
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_3
M�gliche_Z�ge_Feld_weiter_4:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_3:
 mov	ax,[si-2]
 dec	ax			;nach links pr�fen
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_5
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_6
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_5
M�gliche_Z�ge_Feld_weiter_6:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_5:
 mov	ax,[si-2]
 inc	ah			;nach unten pr�fen
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_7
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_8
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_7
M�gliche_Z�ge_Feld_weiter_8:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_7:
 mov	ax,[si-2]
 dec	ah			;nach oben pr�fen
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_9
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_10
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_9
M�gliche_Z�ge_Feld_weiter_10:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_9:
 mov	ax,[si-2]
 dec	ah			;nach oben rechts pr�fen
 inc	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_11
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_12
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_11
M�gliche_Z�ge_Feld_weiter_12:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_11:
 mov	ax,[si-2]
 dec	ah			;nach oben links pr�fen
 dec	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_13
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_14
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_13
M�gliche_Z�ge_Feld_weiter_14:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_13:
 mov	ax,[si-2]
 inc	ah			;nach unten rechts pr�fen
 inc	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_15
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_16
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_15
M�gliche_Z�ge_Feld_weiter_16:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_15:
 mov	ax,[si-2]
 inc	ah			;nach unten links pr�fen
 dec	ax
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Feld_weiter_2
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Feld_weiter_18
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Feld_weiter_2
M�gliche_Z�ge_Feld_weiter_18:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Feld_weiter_2:
 ret

;<<<M�gliche_Z�ge_Ecksprung>>>
;Erstellt Liste aller Ecksprungz�ge einer Figur
;Ein: di=Puffer f�r Z�ge,si=Zeiger auf Koordinaten der Figur
;Aus: -
M�gliche_Z�ge_Ecksprung:
 lodsw
 mov	bp,ax
 test	ax,ax			;Figur existiert nicht mehr?
 jz	M�gliche_Z�ge_Ecksprung_2
 dec	ax			;Zwei links eins hoch pr�fen
 dec	ax
 dec	ah
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_3
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_4
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_3
M�gliche_Z�ge_Ecksprung_4:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_3:
 mov	ax,[si-2]
 dec	ax			;Eins links zwei hoch pr�fen
 sub	ah,2
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_5
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_6
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_5
M�gliche_Z�ge_Ecksprung_6:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_5:
 mov	ax,[si-2]
 inc	ax			;Eins rechts zwei hoch pr�fen
 sub	ah,2
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_7
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_8
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_7
M�gliche_Z�ge_Ecksprung_8:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_7:
 mov	ax,[si-2]
 inc	ax			;Zwei rechts eins hoch pr�fen
 inc	ax
 dec	ah
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_9
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_10
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_9
M�gliche_Z�ge_Ecksprung_10:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_9:
 mov	ax,[si-2]
 dec	ax			;Zwei links eins runter pr�fen
 dec	ax
 inc	ah
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_11
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_12
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_11
M�gliche_Z�ge_Ecksprung_12:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_11:
 mov	ax,[si-2]
 dec	ax			;Eins links zwei runter pr�fen
 add	ah,2
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_13
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_14
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_13
M�gliche_Z�ge_Ecksprung_14:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_13:
 mov	ax,[si-2]
 inc	ax			;Eins rechts zwei runter pr�fen
 add	ah,2
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_15
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_16
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_15
M�gliche_Z�ge_Ecksprung_16:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_15:
 mov	ax,[si-2]
 inc	ax			;Zwei rechts eins runter pr�fen
 inc	ax
 inc	ah
 mov	bx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	M�gliche_Z�ge_Ecksprung_2
 xchg	ax,bx
 lea	bx,Cursor
 mov	[bx],ax
 push	si
 call	Figur_suchen
 cmp	si,Offset Cursor	;Feld ist nicht besetzt?
 jz	M�gliche_Z�ge_Ecksprung_18
 call	Schlagliste_erweitern
 pop	si
 jmp	M�gliche_Z�ge_Ecksprung_2
M�gliche_Z�ge_Ecksprung_18:
 pop	si
 mov	ax,[si-2]
 stosw
 xchg	ax,bx
 stosw
M�gliche_Z�ge_Ecksprung_2:
 ret

;<<<Zugliste_erstellen>>>
;Erstellt eine Liste aller m�glichen Z�ge
;Ein: -
;Aus: -
Zugliste_erstellen:
 mov	[Anzahl_m�glicher_Schl�ge],0
 mov	[Anzahl_m�glicher_Deckungen],0
 lea	di,Zugliste
 push	word ptr[Cursor]
 push	[Figur_ausgew�hlt]
 call	M�gliche_Z�ge_Bauers	;�� Anordnung ver�ndern f�r anderes Spiel
 call	M�gliche_Z�ge_Springers
 call	M�gliche_Z�ge_L�ufers
 call	M�gliche_Z�ge_Turms
 call	M�gliche_Z�ge_Dames
 call	M�gliche_Z�ge_K�nigs
 pop	[Figur_ausgew�hlt]
 pop	word ptr[Cursor]
 mov	ax,di			;Anzahl der m�glichen Z�ge herausfinden
 sub	ax,Offset Zugliste
 shr	ax,2
 mov	[Anzahl_m�glicher_Z�ge],ax
 ret

;<<<Schlagliste_erweitern>>>
;F�gt der Schlagliste oder Deckungsliste eine weitere M�glichkeit hinzu
;Ein: -
;Aus: -
Schlagliste_erweitern:
 pusha
 push	bx
 lea	bx,Cursor
 call	Figur_weiss
 pop	bx
 mov	cl,[Farbe_ausgew�hlt]
 cmp	al,cl			;gegnerische Figur wird bedroht?
 jz	Schlagliste_erweitern_2
 lea	di,Deckungsliste
 mov	ax,[Anzahl_m�glicher_Deckungen]
 inc	ax
 mov	[Anzahl_m�glicher_Deckungen],ax
 jmp	Schlagliste_erweitern_3
Schlagliste_erweitern_2:
 lea	di,Schlagliste
 mov	ax,[Anzahl_m�glicher_Schl�ge]
 inc	ax
 mov	[Anzahl_m�glicher_Schl�ge],ax
Schlagliste_erweitern_3:
 dec	ax
 shl	ax,2
 add	di,ax
 mov	ax,bp
 stosw
 xchg	ax,bx
 stosw
 popa
 ret

;<<<Schlagliste_Bauern>>>
;Erstellt Schlagliste aller Bauern
;Ein: -
;Aus: -
Schlagliste_Bauern:		;�� F�r beide Farben machen
 pusha
 lea	bp,Bauer1s
Schlagliste_Bauern_2:
 mov	si,bp
 lodsw
 mov	bp,si
 test	ax,ax			;Die Figur gibt es nicht mehr?
 jz	Schlagliste_Bauern_3
 mov	bx,ax
 inc	ax			;links unten
 inc	ah
 mov	cx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	Schlagliste_Bauern_3
 push	bx
 lea	bx,Cursor
 mov	[bx],cx
 call	Figur_suchen
 pop	bx
 cmp	si,Offset Cursor	;keine Figur bedroht?
 jz	Schlagliste_Bauern_3
 pusha
 mov	bp,bx
 xchg	ax,bx
 call	Schlagliste_erweitern
 popa
Schlagliste_Bauern_3:
 mov	ax,bx
 inc	ah			;rechts unten
 dec	ax
 mov	cx,ax
 call	Koordinaten_m�glich
 test	ax,ax
 jnz	Schlagliste_Bauern_4
 push	bx
 lea	bx,Cursor
 mov	[bx],cx
 call	Figur_suchen
 pop	bx
 cmp	si,Offset Cursor	;keine Figur bedroht?
 jz	Schlagliste_Bauern_4
 pusha
 mov	bp,bx
 xchg	ax,bx
 call	Schlagliste_erweitern
 popa
Schlagliste_Bauern_4:
 cmp	bp,Offset Turm1s	;Alle Bauern gepr�ft?
 jnz	Schlagliste_Bauern_2
 popa
 ret

;<<<Deckungsliste_auswerten>>>
;Erstellt Liste mit allen ungedeckten Figuren
;Ein: -
;Aus: -
Deckungsliste_auswerten:
 pusha
 lea	si,Deckungsliste
 lea	di,Temp
 lea	dx,Temp2
 xor	cx,cx
 mov	[Anzahl_ungedeckter_Figuren],cx
Deckungsliste_auswerten_2:
 lodsw
 call	Koordinaten_m�glich
 test	ax,ax			;Kein g�ltiger Wert?
 jnz	Deckungsliste_auswerten_3
 lodsw
 stosw
 inc	cx
 jmp	Deckungsliste_auswerten_2
Deckungsliste_auswerten_3:
 lea	si,Bauer1s
 mov	bp,cx
Deckungsliste_auswerten_5:
 lodsw
 test	ax,ax			;Figur existiert nicht mehr?
 jz	Deckungsliste_auswerten_5
 lea	di,Temp
 mov	cx,bp
 cmp	ax,[K�nigs]		;K�nig nicht mit machen
 jz	Deckungsliste_auswerten_7
Deckungsliste_auswerten_4:
 mov	bx,[di]
 inc	di
 inc	di
 cmp	ax,bx			;Figur ist gedeckt?
 jz	Deckungsliste_auswerten_6
 loop	Deckungsliste_auswerten_4
 mov	bx,dx
 mov	[bx],ax
 inc	dx
 inc	dx
Deckungsliste_auswerten_6:
 cmp	si,Offset Dame8s-1	;Alle Figuren gecheckt? (K�nig braucht nicht
 jna	Deckungsliste_auswerten_5	; gedeckt zu werden)
Deckungsliste_auswerten_7:
 sub	dx,Offset Temp2
 shr	dx,1
 mov	[Anzahl_ungedeckter_Figuren],dx
 popa
 ret

;<<<Schlagliste_beste_M�glichkeit>>>
;Sucht aus der Schlagliste den g�nstigsten von Punktwerten her heraus
;Ein: -
;Aus: fs=Speicherstelle des Schlags,sonst 0
Schlagliste_beste_M�glichkeit:
 push	ax
 push	bx
 xor	ax,ax
 mov	fs,ax
 mov	ax,[Anzahl_m�glicher_Schl�ge]
 test	ax,ax			;Nichts zu schlagen?
 jz	Schlagliste_beste_M�glichkeit_2
 xchg	ax,cx
 lea	bp,Schlagliste+2
 xor	di,di
Schlagliste_beste_M�glichkeit_4:
 mov	bx,bp
 call	Figur_suchen
 call	Figurenwert
 cmp	ax,di			;Die Figur ist mehr wert?
 jna	Schlagliste_beste_M�glichkeit_3
 mov	di,ax
 dec	bp
 dec	bp
 mov	fs,bp
 inc	bp
 inc	bp
Schlagliste_beste_M�glichkeit_3:
 add	bp,4
 loop	Schlagliste_beste_M�glichkeit_4
Schlagliste_beste_M�glichkeit_2:
 pop	bx
 pop	ax
 ret

