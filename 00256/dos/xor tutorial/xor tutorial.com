��q1ɶ����I��´�!d�l@d;l}���0��0�h ������@1���1�$ ��`��u��push A000h
pop es
mov al,13h
int 10h
mov ax,di
mov bx,140h
xor dx,dx
div bx
xor ax,dx
and al,1Fh
add al,20h
stosb
in al,60h
dec al
jnz $-14h
ret
;Press any key to run.