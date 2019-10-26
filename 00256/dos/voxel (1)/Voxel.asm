;**************************************************************************
; LandScape over my fractal - Alberto Garcia-Baquero, Jul'96
;
; WiseFoX - AlieN '96.
;**************************************************************************
;==========================================================================
; CONSTANTES
;==========================================================================
VGA	       EQU 0A000h	;Segmento de la posici�n de inicio de la VGA
AnchoPanta     EQU 320
AltoPanta      EQU 200
Linea	       EQU    111	;���  Linea a generar.

	      .MODEL TINY
	      .386
	      .CODE
	       ORG 100h

;========================================================================
; CODIGO
;========================================================================

Main	PROC
	MOV	AL,13h			;��� Modo 320x200 256c. VGA
	INT	10h			;���
	MOV BH,1			;��� Reserva 256*16 = 4 Kb
	MOV AH,4Ah			;��� Modifica el tama�o del bloque reservado
	INT 21h 			;��� al segmento indicado en ES.Ahora ES = Seg.Programa
	PUSH VGA			;���
	POP  FS 			;���
	MOV BX,8096			;��� N�mero de p�rrafos. 64k/16 bytes por p�rrafo
	MOV AH,48h			;���
	INT 21h 			;��� Reserva memoria
	MOV	ES,AX			;��� Ajustamos segmentos
	MOV	DS,AX			;���
	XOR	CX,CX			;���
	MOV	AX,CX			;��� Limpiamos el segmento.
	DEC	CX			;���
	REP	STOSB			;���
					;���
        MOV    DX,03C8H                 ;��� Definimos la paleta.
        OUT    DX,al                    ;���
        INC    DX
        MOV    CL,128                   ;���
       @BUCLE_DAC:                      ;���
        xor    ax,ax                    ;���
        OUT    DX,al                    ;���
        mov    al,cl                    ;���
        neg    al                       ;���
        OUT    DX,AL                    ;���
        neg    al                       ;���
        OUT    DX,AL                    ;���
        LOOP   @BUCLE_DAC               ;���

BUCLE1: MOV	ch,1			;��� CX = 256... 1 linea.
	mov	di,Linea*256		;��� DI = Linea * 256
        mov     dx,40h                  ;���
        rep     insb                    ;��� Pone linea aleatoria.
;    kk: MOV     AX, SEED                            ; linear congruence
;        XOR     AX,0AA55h                           ; random generation
;        SHL     AX,1                                ; 7 clock ticks (486)!
;        ADC     AX,118h
;        MOV     SEED, AX                            ; keep result as next seed
;        stosb
;        loop    kk

	add	di,256*19		;��� Sube 19 lineas
	mov	ch,    27		;��� Retrocedera 27.
	MEDIA:				  ;���
;        mov   al,[di+256   ]             ;���
         mov   al,[di+256   ]             ;���
         add   al,[di+256-1 ]             ;���
	 add   al,[di]			  ;���
         add   al,[di+1]                  ;���
         shr   aL, 2                      ;��� Hace la media.
	 mov   [di],al			  ;���
	 dec   di			  ;���
	loop  media			  ;���
	mov  si,256			;��� Hace scroll
	mov  di,cx			;��� de una linea.
	dec  cx 			;��� CX = ffffh
	rep  movsb			;���

       ;����������������������������������������
	mov	Dl, 1
	OTRA_X: ;��� for( ; DX<  320; dx++ )
	mov	di,(320*199)	  ;���
	add	di,dx		  ;��� DI = Punto inferior de la pantalla.
	mov	bx,128*256	  ;���	X inicial de la camara.
	mov	si, 2		  ;���	Z = SI = 2  . Empieza desde Z =2
	mov	bp,200		  ;���
	OTRA_Z: 		  ;��� for(; Z <  160; Z++, Xt += (Xp-160)  )
           PUSH    BX               ;���
           PUSH    DX               ;���
            mov     bl, 0            ;���  ax = ((Xt>>8))<<8
	    add     bx,si	     ;���  ax += Z
	    xchg    bh,bl	     ;���
	    mov     al,[bx]	     ;���  al = Datos[ ax ];
            mov     bl,al            ;���  bl = color = Datos[abs(Xt>>8)][(Z+rY)];
	    cbw 		     ;���
            neg     ax               ;���
            inc     ah               ;���
	    shl     ax,4	     ;���  ax = color<<6;
	    cwd 		     ;���
	    idiv    si		     ;���  ax /= Z;
            cmp     ax,bp            ;���  ax=Yp = (color<<6)/(Z))
	    jge     NO_PINTA	     ;���
		mov	cx, bp	       ;���
                sub     cx, ax         ;���
                mov     bp, ax         ;��� LastY = Yp;
            eti:mov     fs:[di],bl     ;���
		sub	di,320	       ;���
		LOOP	eti	       ;���
	    NO_PINTA:		     ;���
           POP     DX               ;���
           POP     BX               ;���
           add     bx,dx            ;���
           sub     bx,160           ;���
           inc     si               ;��� Z++
           cmp     si,Linea-10      ;���
           jl      OTRA_Z           ;��� Hasta que Z llegue hasta el limite.
        inc     DX                  ;��� Xp++
        cmp     DX,319              ;��� Hasta que Xp llegue a la derecha .. 300
	jl	OTRA_X		  ;���
	;����������������������������������������
	; Miramos el teclado
	;����������������������������������������
	mov    ah,01h
	int    16h
	jz    BUCLE1
	;�����������������������������������������������������������
ADIOS:	MOV	AX,03h	       ;��� Modo 80x20 texto
	INT	10h	       ;�����������������������������
        MOV  AX,4C00h          ;���  N� de ifunci�n de la INT 21 a utilizar
        INT  21h               ;���  Vuelta al DOS

Main	ENDP
SEED    dw (?)
	END	Main
