;for fasm
;framed abyss
;code: sensenstahl
;www.sensenstahl.com

org 100h
use16

start:   push 09000h
         pop fs
         push 08000h
         pop es

         mov ax,1112h  ; Set up 80x50 text mode
         ;xor bl,bl    ;assuming bl = 0
         int 10h

         mov ax,1003h  ;disable blink (128) ---> full 16 bg colors (=
         int 10h

main:    xor di,di
f_loop:  mov al,[fs:di]
         adc al,[fs:di+2]
         adc ah,0
         adc al,[fs:di+160]
         adc ah,0
         adc al,[fs:di-2]
         adc ah,0
         shr ax,2
         cmp ax,7 ;must be same value as-----------------|
         jna f01                                        ;|
                                                        ;|
         sub al,7 ;change for higher/lower flames  <-----|
f01:     cmp di,160*51 ;reached bottom? BOTTOMLINE AT 51 so outside of screen!
         jnae noline   ;nope
         in al,40h     ;reached, so new char
         noline:
         mov [fs:di-160],al ;draw new pixel above the current one
         inc di
         inc di
         cmp di,160*52 ;bottomline + 1 --> so bottomline can be drawn completely!
         jnae  f_loop
         ;no more fire

         ;not useful here
         ;wait for vsync because of speed
         ;mov dx, 3dah  ;port on vga to check retrace
         ;vsync1:
         ;in al,dx
         ;test al,8
         ;jz vsync1     ;0 = not in retrace; loop until 1

         ;--- get some + shaderwork-------
         mov di,160*25 ;only copy 1/2 of screen
         flip:
         mov al,byte [fs:di+160*25] ;grab correct byte from bottom of vscreen (line 50)
         ;mov bh,al ;-----> to see chars not blocks ;)
         ;<shader> 17*14=255 --> :)
         mov bl,15
         div bl    ;-->ah=rest of division
         xor ah,ah
         mov si,ax
         shl si,1 ;mul 2 to get right shadervalues
         mov cx,word [shader17+si] ;chr + col+bg
         ;</shader>
         mov word [es:di+160*25-2],cx
         ;mov cl,bh ;-----> to see chars not blocks ;)
         neg di  ;yeah running out of si and di
         mov word [es:di+160*25],cx ;right pos to get a 1:1 mirrored copy
         neg di
         dec di
         dec di
         jnz flip

         ;left and right
         ;xor di,di ;di = 0 here
         xor si,si
         xor bx,bx
         testing:
         mov cx,word [es:si] ;grab word
         cmp bl, 25
         ja funk_you ;if above y = 25 then always draw something!
         cmp byte [es:di+1],0 ;emptyness to draw anything into?
         jne nein             ;nope, so don't draw anything
         funk_you:
         cmp ch,0 ;is col+bg of grabbed char = 0 ?
         je nein  ;it is ---> don't draw emptyness!
         ;mov cx,word [es:si] ;grab word --> went upwards
         mov word [es:di],cx ;draw on left side
         neg di ;yeah running out of si and di again
         mov word [es:di+2*160*25-2],cx ;mirror on the right side
         neg di
         nein:
         add di,160 ;line down
         inc bl
         inc si
         inc si
         cmp bl,51    ;bottom?
         jnae testing ;y=51 ---> gtfo
         sub di,160*51
         inc di
         inc di
         sub si,51*2
         add si,160
         xor bl,bl
         inc bh
         cmp bh,25
         jne testing

         ;flip to screen
         push 0B800h
         pop fs
         xor di,di
         flip2:
         mov al,[es:di]
         mov [fs:di],al
         inc di
         jnz flip2
         push 09000h
         pop fs

         ;-----------------------------------------------------------

         mov ah,01h            ;read keyboard
         int 16h               ;read, dammit!
         jz main               ;nothing so go on

         ;mov ax,03h             ;keep it clean ---> i tried but it were 257b ._.
         ;int 10h
         ret

;shadevalue   =   co+bg*16
;           chr co bg
shader17 db 219,00+00*16 ;{black}
shader16 db 176,04+00*16
shader15 db 177,04+00*16
shader14 db 178,04+00*16
shader13 db 219,04+04*16 ;{dark red}
shader12 db 176,12+04*16
shader11 db 177,12+04*16
shader10 db 178,12+04*16
shader09 db 219,12+12*16 ;{bright red}
shader08 db 176,14+12*16
shader07 db 177,14+12*16
shader06 db 178,14+12*16
shader05 db 219,14+14*16 ;{yellow}
shader04 db 176,15+14*16
shader03 db 177,15+14*16
shader02 db 178,15+14*16
shader01 db 219,15+14*16 ;{white}