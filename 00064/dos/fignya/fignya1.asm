;��࠭�� � ���� ���⢮ �� ���� � ����� ��� ��䥪�
.486p ;                                         ڿ
; by Zen  from Vladivostok      ��������Ŀ     ����   �Ŀ ڿ    ڿ ڿ   ڿ
;Sorry its only ugly effect      �   ��������������������������������������
; i use it to generate texture       �    �����    ���      ���� ��   ��  ��
; zen333@rambler.ru                                   ڿ
; look at :                                 Ŀ       ����   ڿ       ڿ  ڿ
; fan333.chat.ru                             ��������������������������������
; for more my releases in 256b and smaller    � �� ��     ��  ��   ��  ��
seg_a           segment public byte use16
                assume  cs:seg_a
                org     100h

rad             proc    far
start:
                les     bp,[bx]
                mov     al,13h   ;vga_init
                int     10h                ;
            push 06000h
            pop ds
        mov dx,3C9h
        mov cl,64
pal:
        xor al,al
;        shr al,cl
        out dx,al
        sub al,cl
        out dx,al
        out dx,al
        loop pal

loc_1:       ;��砫� ��饣� 横��
hlt                           ;time waiting
smoot:
mov di,cx
mov al,ds:[di+1]
add al,ds:[di-320]
add al,ds:[di+320]
add al,ds:[di-1]
inc al
shr al,2
inc al
mov ds:[di],al
stosb ;to screen
loop smoot

loc_5:          in      al,60h                  ; port 60h, keybd scan or sw1
                dec     al
                jnz  short loc_1
exit:
                mov     al,3
                 int     10h
                  retn
rad             endp
seg_a           ends
                end     start





