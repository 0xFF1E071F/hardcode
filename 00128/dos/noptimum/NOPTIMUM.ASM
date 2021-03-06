.model tiny
.code
.startup
.radix 16
; NOPTIMUM v0.34
; Production of Future Hackers in 1996
; Coded by Vladimir "Dr.Bug" Medeiko
; Participant of D.D. 128b intro compo
;.386
%RANDOM = 16f
%STPOS = 0140*0b8+8*8
%SPEED = 3
  mov al,13
@INIT_VIDEO_MODE:
  int 10
  xchg ax,bp
; mov ah,9
  mov dx,offset ILLUMINATION
  int 21

  xchg ax,si
@1:
  mov dx,3c8
  out dx,al
  inc dx
  xchg ax,bx
  out dx,al
  xchg ax,bx
  out dx,al
  out dx,al
  dec ax
  jnz @1

  mov bl,0fbh

  mov ah,0a0
  mov ds,ax
  xor si,si
  mov di,%STPOS
  mov cx,0a00


@CREATING_TEXT:
  lodsb
  mov cs:[di],ax
  scasw
  loop @CREATING_TEXT
  
  push ds
  pop es

  mov ah,80
  mov ds,ax
  

  jmp short @PAINTER

  
@WRITE_TEXT:
  mov ch,80
  rep movsw

  mov di,%STPOS
@0:
  cmp byte ptr cs:[di],7
  jne @3
  mov byte ptr es:[di],bl;6f	;63;159;103;79
@3:
  inc di
  jnz @0




@00:
  mov dl,0da
  in al,dx
  test al,8
  jz @00

  mov cx,140*%SPEED
@PAINTER:
@L1:
  add ah,byte ptr ds:[si-13f]
  shr ah,1
  add bx,%RANDOM
  cmp bl,40
  ja @L2
  and bh,dh     ;3
  dec bh
  add ah,bh
@L2:
  mov byte ptr ds:[si],ah
  inc si
  loop @L1

;  in al,60h
;  cmp al,1
;  or ah,ah
  jne @WRITE_TEXT
  

  mov ax,3
;  mov al,3
  jmp short @INIT_VIDEO_MODE
;  int 10h
;  retn

ILLUMINATION:
  db '�FH NOPTIMUM$'
; 0DB in ascii is �
; FH is abbreviation of Future Hackers

end
 
