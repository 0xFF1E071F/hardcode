;512b intro
;
;'Sharoids'           '��ந��'   ;)
;
;by zZz //[KCN]research group
;aka Anatoliy Samara
;
;almost finished on 28.06.2000
;(hehe, Ukraine Constitution Day:)
;
;tasm 4.1 511b

; ���. ��ࢠ� ��� ����� �ଠ� 512�. �த�⢮ ����筮. �� �� � ⠪, ���
; �஡� ��� ��ါ. ����, � ����� �� �ᯮ�짮���� �⠭����� 3D �孮�����.
; ��� ��⠥��� �� ��㫠� (����� ᪠����, �� �� ���ᥫ쭠� ��䨪�).
; �����⢥���� �⫨稥 - ���ᥫ쭠� ���� ����� �� �࠭����, � ��� �������
; ���� ����������. � ����� ᭠砫� �����뢠� ������ ���. ����
; ��⠫�� ~10ᥪ:)). ��⮬ ���-⠪� �訫 ����� �� ��ப��. � �� �窠�
; ��⠫ ��� ���������� ���짮����� ��㫠�� �� ⮫쪮 "�ந���".
; ��, �� � � �������� �ਤ㬠�. � ��饬 � ���� ��� ���� �뫨, �� ��
; ᠬ�-ᮡ�� �ᯠਫ���, ����� ࠧ��� �ਦ���� � 511 ���⠬.

.model tiny
.code
.386
org 100h

zcoord=word ptr [data+2]
ycoord=word ptr [data+4]

xcentr equ 0
ycentr equ 2
zcentr equ 4
radius equ 6
color  equ 7
;mult_a equ 8

zmax equ 200
ymax equ 200
xmax equ 320

sph_size equ 8
sph_count equ 4   ;spher count-1

Start:
       mov      ax,13h
       int      10h

       mov      ah,4ah       ;�ᠩ��� ᥡ�
       mov      bx,01001h
       int      21h

       mov      ah,48h       ;ᮧ���� ����� �� 65535
       int      21h
       mov      es,ax

       mov      ah,48h       ;ᮧ���� z-����� �� 65535
       int      21h
       mov      gs,ax

       mov      ah,48h       ;ᮧ���� ����� ��� ⠡���� ��୥� �� 65535
       int      21h
       mov      fs,ax

lp1:
       mov      dx,3c8h
       mov      al,cl
       out      dx,al
       inc      dx

       xor      ax,ax
       xor      bh,bh
       mov      bl,cl
       shr      bl,6
       jz       jp_color1
       cmp      bl,1
       je       jp_color2
       cmp      bl,2
       je       jp_color3
       mov      bh,cl
       sub      bh,10
jp_color2:
       mov      ah,cl
       jmp      jp_colorout
jp_color3:
       mov      ah,cl
jp_color1:
       mov      al,cl
jp_colorout:
       out      dx,al
       xchg     al,ah
       out      dx,al
       xchg     al,bh
       out      dx,al

       loop     lp1

       xor      bx,bx
lp_sqrt_1:
       mov      word ptr data,bx
       fild     word ptr [data]
       fsqrt
       fistp    word ptr [data]
       mov      al,byte ptr data
       mov      fs:[bx],al
       inc      bx
       jnz      lp_sqrt_1
lpZ_1:
;-------------------------��⨬ �����
       xor      di,di
       xor      eax,eax
       mov      cx,4000h
jp_clear_1:
       mov      gs:[di],eax
       stosd
       dec      cx
       jnz      jp_clear_1
;-------------------------
       mov      zcoord,0
lp1_1:
       mov      ycoord,ymax
lp1_2:
;-------------------------�஢��塞 ���
;-------------------------��।��塞 ���न���� �� ��࠭�
       mov      ax,ycoord
       mov      di,zcoord
       shr      di,2
       sub      ax,di
       mov      dx,xmax
       mul      dx
       mov      di,ax
;-------------------------��ࠡ�⪠ �ந���
       lea      bp,spher+sph_count*sph_size
lpSpher_1:
;-------------------------------------------
       push     di
       xor      ah,ah
       xor      bh,bh
       mov      al,[bp+radius]      ;r
       mul      ax
       mov      si,ax
       mov      ax,ycoord    ;(y-y0)^2
       sub      ax,[bp+ycentr]
       imul     ax
       sub      si,ax
       js       jp_next_sph
       mov      ax,zcoord    ;(z-z0)^2
       sub      ax,[bp+zcentr]
       imul     ax
       sub      ax,si
       jns      jp_next_sph
       neg      ax
;       mov      bl,[bp+mult_a]
;       idiv     bx
       xchg     ax,si

       mov      dl,fs:[si]
       xor      dh,dh

       mov      ax,[bp+xcentr]
       sub      ax,dx
       shl      dx,1
;---------------------����� �� ��࠭
       mov      bl,[bp+color]
       mov      cl,1
       call     drawline
jp_next_sph:
       pop      di
       sub      bp,sph_size
       cmp      bp,offset spher
       jae      lpSpher_1
;-------------------------���᪮�⮨��
       cmp      byte ptr ycoord,ymax
       jne      jp_next_cycle
       mov      dx,xmax
       xor      ax,ax
       mov      bl,255
       mov      cl,2
       call     drawline
;--------------------------------------------------------
jp_next_cycle:
       dec      byte ptr ycoord
       jnz      lp1_2
       inc      byte ptr zcoord
       cmp      byte ptr zcoord,zmax
       jbe      lp1_1

;----------------------------------����� �� ��࠭
       push     fs
       mov      bx,0a000h
       mov      fs,bx
       xor      si,si
lp_copy_1:
       mov      eax,es:[si]
       mov      fs:[si],eax
       add      si,4
       jnz      lp_copy_1
       pop      fs
;----------------------------------������஢� ����䨪�樨
       mov      si,3600
       mov      ax,x1
       mov      word ptr [spher+0*sph_size+xcentr],ax
       add      word ptr [spher+0*sph_size+xcentr],160
       mov      byte ptr [spher+0*sph_size+zcentr],al
       add      byte ptr [spher+0*sph_size+zcentr],100
       mov      word ptr [spher+2*sph_size+xcentr],ax
       add      word ptr [spher+2*sph_size+xcentr],100
       mov      byte ptr [spher+3*sph_size+ycentr],al
       add      byte ptr [spher+3*sph_size+ycentr],120
       mul      ax
       sub      si,ax
       mov      al,fs:[si]
       mov      bl,dir1
       test     bl,bl
       jns      jp_mk1
       neg      al
jp_mk1:
       mov      cl,al
       neg      cl
       add      cl,80
       add      al,120

       mov      byte ptr [spher+0*sph_size+ycentr],al
       mov      byte ptr [spher+2*sph_size+ycentr],cl

       add      cl,115
       mov      byte ptr [spher+4*sph_size+xcentr],cl
       sub      cl,115

       mov      al,bl
       cbw
       add      x1,ax
       cmp      x1,60
       jne      jp_mk1_1
       neg      dir1
jp_mk1_1:
       cmp      x1,-60
       jne      jp_mk1_2
       neg      dir1
jp_mk1_2:
       shr      cl,1
       add      cl,70
       mov      byte ptr [spher+1*sph_size+zcentr],cl
jx1:
;----------------------------------�஢�ઠ ������
       in       al,60h
       test     al,1
       jz       lpZ_1

       mov      ax,03h
       int      10h

       ret

drawline proc near
;ax - ��砫� �����
;bl - 梥�
;cl - ������� ����饭����
;dx - �����
;-------------------------��㥬 ���ᥫ� � �����
jp_draw:
       add      di,ax
       test     dx,dx
       jz       jp_return
;-----------------�����뢠�� 梥�
       mov      bh,bl
       mov      ax,zcoord
       mov      ch,cl
       shl      ch,7
       sub      ch,18
       cmp      al,ch
       jb       jp_draw2
       mov      al,ch
jp_draw2:
       shr      al,cl
       sub      bl,al
       mov      ch,bl
;-----------------� � ����� ���, ����
lp_draw_1:
       cmp      byte ptr gs:[di],0  ;z-buffer?
       jne      jp_dont_put         ;yes, jmp
jp_put:
       not      byte ptr gs:[di]    ;z-buffer
       mov      byte ptr es:[di],bl ;di ��⠭����� ���
jp_dont_put:
       inc      di
       dec      dx
       jnz      lp_draw_1
jp_return:
       ret
drawline endp

;---------------------------data section
;---------------------------�ந��;)
spher:
;====����
  dw 160,180,80      ;xcentr, ycentr, zcentr
  db 40,63           ;radius,color
;====������
  dw 160,120,80     ;xcentr, ycentr, zcentr
  db 60,127          ;radius,color
;====�����
  dw 100,20,90      ;xcentr, ycentr, zcentr
  db 30,191          ;radius,color
;====ᨭ��
  dw 180,120,80    ;xcentr, ycentr, zcentr
  db 35,0         ;radius,color
;====4
  dw 135,80,60     ;xcentr, ycentr, zcentr
  db 20,240          ;radius,color
;====
;---------------------------��㣠� ����
dir1 db 5h
x1 dw 0
data:
end start