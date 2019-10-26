
;                 ������������������������������������������
;                 �            -  f l a m e  -             �
;                 �        A 160 byte fire routine         �
;                 �    Copyright 1996 Gaffer/PRoMETHEUS    �
;                 �         email: gaffer@ar.com.au        �
;                 ������������������������������������������

.MODEL TINY
.386

UDATASEG
Buffer DB 320*203 dup(?)

CODESEG
ORG 100h
LOCALS



;�����������������������������������������������������������������������������
;��   INITIALIZATION - Set mode & palette, setup vidmode, palette & stuff   ��
;�����������������������������������������������������������������������������
    .STARTUP

;���������������Ŀ
;� SETUP VGA SEG �
;�����������������
    push 0A000h
    pop es

;�������������������Ŀ
;� INIT VGA MODE 13h �
;���������������������
    mov al,13h
    int 10h

;������������������Ŀ
;� GENERATE PALETTE �
;��������������������
    mov al,63
    mov cx,768+2
    mov di,63*3+2
    push di
    rep stosb                         ; fill palette with white

    pop di
    xor ax,ax
    call PaletteGen                   ; Green   ->    _(_)/*
    inc ah                                                          
    call PaletteGen                   ;         ->    __(/)*    
	
    xor di,di
    call PaletteGen                   ; Red     ->    (/)***

    inc di
    call PaletteGen                   ; Blue    ->    _(/)**
	
    
;�������������Ŀ
;� SET PALETTE �
;���������������
    mov ax,1012h
    cwd                               ; equivalent to 'xor dx,dx'
    mov cl,255
    int 10h


;�����������������������������������������������������������������������������
;��        MAIN LOOP - Cycle through flame animation until keypressed       ��    
;�����������������������������������������������������������������������������
MainLoop:

;�����������������Ŀ
;� FLAME ANIMATION �
;�������������������
    inc cx
    mov di,OFFSET Buffer
    mov bl,99
@@L1:
    mov al,[di+639]                   ; Average it out...
    mov dl,[di+640]
    add ax,dx
    mov dl,[di+641]
    add ax,dx
    mov dl,[di+1280]
    add ax,dx
    shr ax,2
    jz @@ZERO                         ; Cool a bit...
    dec ax         
@@ZERO:            
    mov [di],al
    mov dl,[di+1280]
    add ax,dx
    shr ax,1
    mov [di+320],al                   ; double the height
    inc di         
    loop @@L1      
    mov cx,320     
    add di,cx      
    dec bx        
    jnz @@L1       
                    

;���������������������Ŀ
;� FLAME GENERATOR BAR �
;�����������������������
    ; assumes cx=320
    ; assumes di=generator bar offset (bottom of flame buffer)
@@L2:     
    in  ax,40h                        ; read from timer
    add ax,ds:[100h]
    add word ptr ds:[100h],ax         ; "seed" is first two bytes of code
    mov ah,al                         ; cheesy hack :)
    mov [di],ax
    mov [di+2],ax
    add di,4
    loop @@L2
    xor ax,ax                         ; clear ah now ...

;������������������������Ŀ
;� OUTPUT FLAME TO SCREEN �
;��������������������������
    xor di,di
    mov si,OFFSET Buffer + 320
    mov cx,(320/4)*95*2
    rep movsd                       

;�����������������Ŀ
;� CHECK FOR KBHIT �
;�������������������
    in al,60h
    das
    jc mainloop                       ; thanks goes to icepick! *8)


;�����������������������������������������������������������������������������
;��             DOS EXIT CODE - Switch to textmode, return to DOS           ��    
;�����������������������������������������������������������������������������
    mov al,03h                        ; textmode
    int 10h

    ; ret to dos (use palette gen ret... saves 1 byte)



;�����������������������������������������������������������������������������
;��   PALETTE GEN FUNCTION - simple 64 color step 3 palette gen thingo *8)  ��    
;�����������������������������������������������������������������������������
PaletteGen:     
    mov cl,64
@@L2:
    stosb                             ; uses vid mem as palette temp buffer ;)
    add al,ah
    inc di
    inc di                            ; di incs by 3 each loop (stosb)
    loop @@L2
    ret

END
