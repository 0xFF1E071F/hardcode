;1 kanal, 1 instrument (ladovanej jen na zacatku tune)

;Program by mel delat zhruba toto:
;var
;  x,y:integer;
;  tim:word;
;begin
;  asm mov ax,13h; int 10h; end;
;  for x:=0 to 63 do pal(x,x,x,x);
;  tim:=0;
;  repeat
;   for x:=0 to 127 do
;    for y:=0 to 79 do
;     putpixel(x*2,20+y*2,
;     trunc(
;      (abs(sin(
;               (sin(x*x/512+tim/8)*32+(y-40)*3) *6.28/(250-x)
;              )*64
;          )
;      ) *(127-x)/127
;     ),SegA000);
;   waitticks(1);
;   inc(tim);
;  until keypressed;
;end.
;
; vyraz: (abs(sin((sin(x*x/512+tim/8)*32+(y-40)*3)*6.28/(250-x))*64))
;        *(127-x)/128)
;
; je infixove:
;
;      (abs( sin(
;                ( sin(
;                       x
;                      *x
;                      /512
;                     +tim
;                      /8
;                     )
;                   *32
;                 + (y-40)
;                  *3
;                )
;                *6.28
;                /(250-x)
;               )
;           *64
;          )
;      )
;      *(127-x)
;      /128
;
; nebo:
;
;                                   trunc
;                                     �
;                                     * ����������������������Ŀ
;                                     �                        �
;                                    abs                   ��� / ���Ŀ
;                                     �                  � � �       2
;                                     �                 127  x
;                                    sin
;                                     �
;                            �������� * ��������������Ŀ
;                            �                         �
;                   �������� + ���������Ŀ        ���� / ��Ŀ
;                   �                    �        �         �
;              ���� * ���Ŀ          ��� * �Ŀ    PI    ��� - �Ŀ
;              �          �          �       �          �       �
;             sin         64      �� - Ŀ    6         250      x
;              �                  y     40
;              /�����8
;        ����� + ������Ŀ
;        �              �
;      x*x/64          tim
;
;

.386
crs segment use16
assume es:crs,cs:crs,ss:crs,ds:crs
org 100h
all:
;�����������������������������������������������������������������������������
MAXY  EQU 79
MAXX  EQU 127
;�����������������������������������������������������������������������������
 mov  al,13h
 int  10h
 push 0A000h
 pop  es
 mov  al,3Fh
@pal:
 mov  dx,03C8h
 out  dx,al
 inc  dx
 out  dx,al
 out  dx,al
 out  dx,al
 dec  ax
 jnz  @pal
 mov  bx,offset work
 fInit
 mov  si,offset zaTune  ;si=adresa pristi noty

@MAINLOOP:
 mov  di,20*320+320
 mov  ch,MAXY
@ForY:
 mov  cl,MAXX
@ForX:

 mov  al,127
 sub  al,cl
 mul  al
 shr  ax,6              ;ax=(127-x)*(127-x)/64
 add  ax,[bx+2]
 mov  [bx],ax           ;work=(127-x)*(127-x)/64+tim
 fild word ptr [bx]     ;fstack: (127-x)*(127-x)/64+tim
 fidiv word ptr [bx-4]  ;fstack: ((127-x)*(127-x)/64+tim)/8

 fsin
 fimul word ptr [bx-2]  ;fstack: sin(((127-x)*(127-x)/64+tim)/8)*64

 mov al,ch
 sub al,40
 cbw
 imul ax,ax,6           ;ax=(y-40)*6
 mov [bx],ax
 fiadd word ptr [bx]    ;fstack: sin(((127-x)*(127-x)/64+tim)/8)*64 + (y-40)*6

 mov  ax,123
 add  al,cl             ;ax=123+x
 mov  [bx],ax           ;work=123+x
 fldpi                  ;fstack: pi,sin(((127-x)*(127-x)/64+tim)/8)*64 + (y-40)*6
 fidiv word ptr [bx]    ;fstack: pi/(123+x),sin(((127-x)*(127-x)/64+tim)/8)*64 + (y-40)*6
 fmulp                  ;fstack: pi/(123+x) * (sin(((127-x)*(127-x)/64+tim)/8)*64 + (y-40)*6)
 fsin
 fabs                   ;fstack: abs(sin( pi/(123+x) * (sin(((127-x)*(127-x)/64+tim)/8)*64 + (y-40)*6) ))

;ted' chceme do [bx] dostat cl/2
;mov  al,cl
;shr  al,1
;mov  [bx],ax
 mov  [bx],cl
 shr  word ptr [bx],1

 fimul word ptr [bx]    ;fstack: x div 2 * abs(sin( pi/(123+x) * (sin(((127-x)*(127-x)/64+tim)/8)*64 + (y-40)*6) ))
 fistp word ptr es:[di] ;ve work je barva pixelu, ktera prijde na [x,y]
 scasw

 dec  cl
 jnz  @ForX
 add  di,320+66
 dec  ch
 jnz  @ForY
 inc  word ptr [bx+2]

     ;ceka na paprsek
;     mov dx,3dah
;@r2: in al,dx
;     test al,8
;     jz @r2
;@r1: in al,dx
;     test al,8
;     jnz @r1

     ;kazdej nekolikatej snimek zahraje notu
     shl bp,1
     jnz @pause
     push bx
     call NextNote
     pop bx
     mov bp,4h
     @pause:

 in   al,60h
 das
 jb   @MAINLOOP
 retn
;�����������������������������������������������������������������������������
;[ADLIBovy veci]

RestartTune:
        mov     si,offset Data
@1:     lodsw
        call    Adlib
        cmp     ah,6
        jnz     @1

NextNote: ;{vstup si=adresa noty, nici ax,bx,cx=0,dx=389h,si=adresa pristi noty}
        lodsb
        or      al,al
        jz      RestartTune
        mov     ah,8+3
        rol     ax,8+2
        mov     bx,0a0b0h
        xchg    bh,al
        call    Adlib ;frequency low byte
        xchg    ax,bx
;       call    Adlib ;frequency high byte

Adlib:  ;{input al=port, ah=data, destroys al,cx=0,dx=389h}
        mov     dx,388h
        call    write
        inc     dx
        mov     al,ah
write:  out     dx,al
        mov     ch,1
@3:     in      al,dx
        loop    @3
        ret

data    dw      02001h  ;{}
;       dw      00008h  ;{lze vynechat, nastaveni nema vliv}
;       dw      000bdh  ;{udela key off...nelze behem hrani}

ins1    db      176,0   ; key off
        db      32 ,1   ; 1. modulator frequency multiple, misc flags
        db      35 ,192 ; 2. modulator frequency multiple, misc flags
        db      64 ,224 ; 1. output level
        db      67 ,67  ; 2. output level
        db      96 ,0e9h; 1. attack+decay
        db      99 ,061h; 2. attack+decay
        db      128,05fh; 1. sustain+release
        db      131,05bh; 2. sustain+release
;       db      224,3   ; 1. waveform select   nema slysitelny vliv
        db      227,2   ; 2. waveform select
        db      192,6   ; feedback+algorithm

tune    db      740/4,554/4,370/4,740/4
        db      740/4,554/4,370/4,740/4
        db      880/4,659/4,440/4,880/4
        db      988/4,659/4,494/4,988/4
zatune  db      0
;�����������������������������������������������������������������������������
_8      dw 0008h
_64     dw 0040h
work    dw ?    ;odtud si koprocesor cte vstupni data
tim     dw ?
;�����������������������������������������������������������������������������
crs ends
end all

;na zaver:
;projit ;*!
;podivat se, jestli se v kodu (vyjma promennych) nahodou nevyskytuje
;"20 00", "40 00" nebo "DB 0F C9 40". Pokud ano, znicit promennou _NNN a
;nahradit jeji adresu adresou tohoto mista v kodu.

;"amplitudu" vln zmeni parametr v instrukci "imul ax,ax,6"
;"perioda" vln: zmena vice zpusoby, napr. dosazenim jineho cisla za "_8"
