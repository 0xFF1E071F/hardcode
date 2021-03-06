;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
; "BURN" intro klubu SGA                                                    �
; autor: Lukasz Sterkowicz vel Gutz                                         �
;        gutz@mops.uci.agh.edu.pl                                           �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様郵
; Oto kod zrodowy intra BURN. Pokazuje technike tworzenia realistycznego    �
; ognia, skalowanie, nakladanie tekstury itp.                               �
;                                                                           �
; Wszystkie czesci programu moga byc uzyte bezplatnie. Autor nie ponosi     �
; odpowiedzialnosci za szkody wynikle ze zlego funkcjonowania programu.     �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕

%include 'header.inc'

CR            equ 13
NL            equ 10
STACK_SIZE    equ 1024

;陳陳陳陳陳陳 dlugosc kolejki liter
QUEUE_L       equ 50
;陳陳陳陳陳陳 maksymalne lewe wychylenie
LEFT_SP       equ -80
;陳陳陳陳陳陳 maksymalne prawe wychylenie
RIGHT_SP      equ 320 - LEFT_SP
;陳陳陳陳陳陳 odleglosc od obserwatora (w potegach dwojki)
OBSERVER      equ 9

START_PROGRAM


;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
; segment kodu                                                              �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様郵
  section .text                                                           ; �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕

;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; przygotowanie pamieci                                                     �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 przygotowanie segmentu danych
              cld
              mov ax,cs
              add ax,TEXT_SIZE / 16
              mov ds,ax
;陳陳陳陳陳陳 zmniejszenie przydzielonej pamieci
              mov bx,es
              add bx,(0x200 + TEXT_SIZE + DATA_SIZE + BSS_SIZE + STACK_SIZE) / 16
              mov ah,0x4A
              int 0x21
;陳陳陳陳陳陳 przydzielenie dodatkowej pamieci
              mov bx,0x2500
              mov ah,0x48
              int 0x21
              jnc short mem_ok
;陳陳陳陳陳陳 wyswietlenie bledu
              mov dx,no_mem
              mov ah,9
              int 0x21
              mov ax,0x4C01
              int 0x21
;陳陳陳陳陳陳 przygotowanie segmentu masek
mem_ok:       mov fs,ax
              add ax,320 * (67 * 2 + 132) / 16
              mov gs,ax
              mov es,ax
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; rozpakowanie masek bitowych                                               �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 rozpakowanie napisu SGA
              mov si,sga_mask
              xor di,di
              mov bp,260
              mov bh,40
              call unpack
;陳陳陳陳陳陳 rozpakowanie kolejnych liter
              mov bx,let_width
let_1:        movzx bp,byte [bx]
              or bp,bp
              je short add_space
              push bx
              mov bh,38
              call unpack
              pop bx
              inc bx
              jmp short let_1
;陳陳陳陳陳陳 dodanie spacji
add_space:    mov byte [bx],50
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; zapisanie adresow buforow                                                 �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              mov ax,fs
              mov [buf1],ax
              add ax,320 * 67 * 2 / 16
              mov [buf2],ax
              push ds
              pop es
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; przygotowanie tekstu do wyswietlania                                      �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 konwersja tekstu scrollowanego
prep_text:    mov si,scroll
conv_1:       lodsb
              cmp al,-1
              je short pointers
              mov di,let_def
              mov cx,let_def - let_width
              repne scasb
              sub di,let_def + 1
              mov ax,di
              mov [si - 1],al
              jmp short conv_1
;陳陳陳陳陳陳 wyznaczenie wskaznikow do liter
pointers:     mov si,let_width
              mov di,let_point
              mov cx,let_def - let_width - 1
              mov bl,38
              xor ax,ax
              mov dx,40 * 260
              jmp short pointers_2
pointers_1:   lodsb
              mul bl
pointers_2:   add ax,dx
              mov dx,ax
              stosw
              loop pointers_1
              mov ax,-1
              stosw
;陳陳陳陳陳陳 wyzerowanie kolejki
              mov di,queue_p
              mov cx,QUEUE_L + 1
              rep stosw
;陳陳陳陳陳陳 pierwsza litera (spacja)
              mov word [queue_x + QUEUE_L],RIGHT_SP
              mov word [queue_w + QUEUE_L],50
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; wygenerowanie funkcji sinus                                               �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              mov si,sinus + 255
              lea di,[si + 1]
;陳陳陳陳陳陳 uzupelnienie sinusa do pi
              mov cx,256
sinus_1:      std
              lodsb
              cld
              stosb
              loop sinus_1
              inc si
;陳陳陳陳陳陳 uzupelnienie sinusa do 2*pi
              mov cx,512
sinus_2:      lodsb
              not al
              stosb
              loop sinus_2
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; wygenerowanie gruntu                                                      �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              mov si,sinus
              mov di,ground
              xor dx,dx
              mov cx,320
ground_1:     xor ax,ax
              mov bx,cx
;陳陳陳陳陳陳 pierwsza funkcja harmoniczna [ sin(4x) ]
              shl bx,2
              and bh,3
              mov al,[si + bx]
;陳陳陳陳陳陳 druga funkcja harmoniczna [ sin(8x) ]
              shl bx,1
              and bh,3
              add al,[si + bx]
              adc ah,dl
              shr ax,1
              stosb
              dec cx
              jne short ground_1
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; wygenerowanie palety ognia                                                �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              mov di,fire_pal
              xor cx,cx
make_pal:     mov ax,cx
              or al,al
              je short write_color
              cmp al,0xC0
              jae short write_color
              dec ax
              je short write_color
              cmp al,0x80
              jae short write_color
              sub al,2
              jbe short black
              cmp al,0x40
              jae short write_color
              sub al,5
              jae short write_color
black:        xor al,al
write_color:  stosb
              inc cl
              jne short make_pal
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; inicjacja trybu graficznego                                               �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 wlaczenie trybu
              mov ax,0x13
              int 0x10
;陳陳陳陳陳陳 przygotowanie karty do zapisu palety
              mov dx,0x3C8
              xor al,al
              out dx,al
              inc dx
;陳陳陳陳陳陳 ustawienie kolorow ognia
              mov si,fire_pal
              mov cx,64
palette_1:    movzx ax,[si]
              cmp al,0x80
              jbe short palette_1a
              mov ah,al
              add ah,al
palette_1a:   shr al,2
              out dx,al
              mov al,ah
              shr al,2
              out dx,al
              xor al,al
              out dx,al
              add si,4
              dec cx
              jne palette_1
;陳陳陳陳陳陳 ustawienie kolorow tekstury
              mov si,txt_pal
              mov cx,60
palette_2:    lodsb
              shr al,2
              out dx,al
              lodsb
              shr al,2
              out dx,al
              lodsb
              shr al,2
              out dx,al
              dec cx
              jne palette_2
;陳陳陳陳陳陳 ustawienie kolorow duzych gwiazd
              mov cx,4
              mov ah,0x2F
palette_3:    mov al,ah
              out dx,al
              out dx,al
              mov al,0x3F
              out dx,al
              add ah,4
              dec cx
              jne palette_3
;陳陳陳陳陳陳 ustawienie kolorow odbicia ognia
              mov si,fire_pal
              mov cx,64
palette_4:    movzx ax,[si]
              cmp al,0x80
              jbe short palette_4a
              mov ah,al
              add ah,al
palette_4a:   shr al,3
              out dx,al
              mov al,ah
              shr al,3
              out dx,al
              xor al,al
              out dx,al
              add si,4
              dec cx
              jne palette_4
;陳陳陳陳陳陳 ustawienie kolorow odbicia tekstury
              mov si,txt_pal
              mov cx,60
palette_5:    lodsb
              shr al,3
              out dx,al
              lodsb
              shr al,3
              out dx,al
              lodsb
              shr al,3
              out dx,al
              dec cx
              jne palette_5
;陳陳陳陳陳陳 ustawienie kolorow malych gwiazd
              mov cx,4
              mov ah,0x17
palette_6:    mov al,ah
              out dx,al
              out dx,al
              mov al,0x1F
              out dx,al
              add ah,2
              dec cx
              jne palette_6
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; wyrysowanie duzych gwiazd                                                 �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 wyczyszczenie bufora
              push fs
              pop es
              xor di,di
              mov cx,320 * 68 / 4
              xor eax,eax
              rep stosd
;陳陳陳陳陳陳 losowanie pozycji
              mov ax,[seed]
              mov bp,8903
              mov cx,45
big_stars:    mul bp
              inc ax
              push ax
              xor dx,dx
              mov bx,3
              div bx
              mov di,ax
;陳陳陳陳陳陳 losowanie koloru
              pop ax
              mul bp
              inc ax
              push ax
;陳陳陳陳陳陳 wyrysowanie gwiazdy
              shr ax,14
              or al,0x7C
              mov [es:di],al
              or al,0x80
              mov [es:di - 320],al
              mov [es:di + 320],al
              mov [es:di - 1],al
              mov [es:di + 1],al
              pop ax
              dec cx
              jne near big_stars
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; wyrysowanie malych gwiazd                                                 �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 losowanie pozycji
              mov cx,70
small_stars:  mul bp
              inc ax
              push ax
              xor dx,dx
              mov bx,3
              div bx
              mov di,ax
;陳陳陳陳陳陳 losowanie koloru
              pop ax
              mul bp
              inc ax
              push ax
;陳陳陳陳陳陳 wyrysowanie gwiazdy
              shr ax,14
              or al,0xFC
              stosb
              pop ax
              dec cx
              jne short small_stars
              mov [seed],ax
;陳陳陳陳陳陳 zapisanie bufora na ekran
              push word 0xA000
              pop es
              mov cx,320 * 68 / 4
              xor si,si
              xor di,di
              fs rep movsd
;陳陳陳陳陳陳 wyczyszczenie bufora
              push fs
              pop es
              xor di,di
              mov cx,320 * 67 * 2 / 4
              xor eax,eax
              rep stosd
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; przygotowanie systemu odmierzania czau                                    �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 podmiana procedury obslugi przerwania zegarowego
              push word 0
              pop es
              mov ax,cs
              shl eax,16
              mov ax,int8
              xchg eax,[es:8 * 4]
              mov [old_int8],eax
;陳陳陳陳陳陳 zaprogramowanie ukladu odmierzania czasu
              mov al,110100b
              out 43h,al
              xor ax,ax
              out 40h,al
              mov al,0x20
              out 40h,al


;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; wygenerowanie podstawy ognia                                              �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
main_loop:    mov es,[buf1]
              mov di,320 * 2 * 66
              mov cx,320 / 8
              mov ax,[seed]
              mov bp,8903
;陳陳陳陳陳陳 wylosowanie koloru
bottom:       push cx
              mul bp
              inc ax
              push ax
              or ah,0x80
              shr ax,8
;陳陳陳陳陳陳 zapisanie na 8 punktach
              mov cx,8
              rep stosw
              pop ax
              pop cx
              dec cx
              jne short bottom
              mov [seed],ax
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; rysowanie plomieni                                                        �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              mov di,2
              mov cx,66
flame:        push cx
              mov cx,318
;陳陳陳陳陳陳 obliczenie sredniej z czterech punktow
line:         mov bx,[es:di]
              add bx,[es:di + 319 * 2]
              add bx,[es:di + 320 * 2]
              add bx,[es:di + 321 * 2]
              shr bx,2
              movzx ax,byte [fire_pal + bx]
;陳陳陳陳陳陳 zapisanie koloru
              stosw
              dec cx
              jne short line
              add di,4
              pop cx
              dec cx
              jne short flame
;陳陳陳陳陳陳 skopiowanie czesci plomieni do bufora roboczego
              mov fs,[buf1]
              mov es,[buf2]
              xor si,si
              xor di,di
              mov cx,320 * 56
copy_flame:   fs lodsw
              shr al,2
              stosb
              dec cx
              jne short copy_flame
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; rysowanie gruntu                                                          �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 porownanie ze wzorcem gruntu
              mov dl,-1
make_grnd:    mov bx,320
line_grnd:    cmp byte [ground + bx - 1],dl
              jb short not_grnd
              add si,2
              xor ax,ax
              jmp short check_grnd
;陳陳陳陳陳陳 jezeli nie grunt skopiowanie plomieni
not_grnd:     fs lodsw
              shr al,2
check_grnd:   stosb
              dec bx
              jne short line_grnd
              sub dl,32
              ja short make_grnd
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; rysowanie tekstu                                                          �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              xor bx,bx
;陳陳陳陳陳陳 wyswietlanie od zewnatrz do srodka
one_letter:   push bx
              cmp bx,QUEUE_L
              jb short take_pointer
              neg bx
              add bx,QUEUE_L * 3
;陳陳陳陳陳陳 pobranie wskaznika maski litery
take_pointer: movzx esi,word [queue_p + bx]
              inc si
              je near next_letter
              dec si
;陳陳陳陳陳陳 pobranie dlugosci litery i wspolrzednej x
              movzx ax,[queue_w + bx]
              mov [width],ax
              mov [right],ax
              movsx ebx,word [queue_x + bx]
              push ebx
;陳陳陳陳陳陳 wyznaczenie wskaznika do tekstury
              mov di,texture + 56 / 2
              shr ax,1
              sub di,ax
;陳陳陳陳陳陳 wyznaczenie pozycji na fali
              add bx,ax
              shl bx,2
              add bx,[sin_add]
              and bx,0x3FF
              movzx eax,byte [sinus + bx]
              push ax
              not al
              shr al,1
              mov [wave_pos],al
              pop ax
;陳陳陳陳陳陳 obliczenie wspolczynnika pomniejszenia
              add ax,1 << OBSERVER
              mov ebx,eax
              shl eax,16 - OBSERVER
              mov [scale],eax
;陳陳陳陳陳陳 obliczenie odchylenia w pionie
              mov ax,(1 << OBSERVER) * 38 / 2
              cwd
              div bx
              neg ax
              add ax,(38 / 2) + 14
              shl ax,6
              mov bp,ax
              shl ax,2
              add bp,ax
;陳陳陳陳陳陳 obliczenie odchylenia w poziomie
              pop eax
              sub eax,320 / 2
              shl eax,OBSERVER
              cdq
              idiv ebx
              add ax,320 / 2
              mov cx,[width]
;陳陳陳陳陳陳 sprawdzenie czy liera wystaje na lewo
              cmp ax,0
              jg short check_right
              neg ax
              cmp ax,cx
              jae near next_letter
              jmp short save_left
;陳陳陳陳陳陳 sprawdzenie czy liera wystaje na prawo
check_right:  cmp ax,320
              jae near next_letter
              add bp,ax
              mov bx,ax
              add bx,cx
              xor ax,ax
              sub bx,319
              jb short save_left
              sub cx,bx
              mov [right],cx
save_left:    mov [left],ax
;陳陳陳陳陳陳 zapisanie poczatku litery i tekstury
              xor ecx,ecx
              mov [let_start],si
              mov [txt_start],di
one_line:     xor ebx,ebx
              push bp
;陳陳陳陳陳陳 sprawdzenie czy punkt miesci sie na ekranie
one_pixel:    cmp bx,[left]
              jb short next_pixel
              cmp bx,[right]
              ja short next_pixel
;陳陳陳陳陳陳 sprawdzenie maski litery
              mov al,[gs:si + bx]
              inc al
              je short empty
;陳陳陳陳陳陳 sprawdzenie czy ogien przeslania punkt
              mov al,[es:bp]
              cmp al,0x40
              jae short not_empty
              cmp al,0x20
              jbe short not_empty
              shl al,3
              cmp al,[wave_pos]
              ja short empty
;陳陳陳陳陳陳 przepisanie punktu z tekstury
not_empty:    mov al,[di + bx]
              or al,0x40
              mov [es:bp],al
;陳陳陳陳陳陳 skalowanie w poziomie
empty:        inc bp
next_pixel:   ror ebx,16
              add ebx,[scale]
              ror ebx,16
              cmp bx,[width]
              jb short one_pixel
;陳陳陳陳陳陳 skalowanie w pionie
              mov si,[let_start]
              mov di,[txt_start]
              ror ecx,16
              add ecx,[scale]
              ror ecx,16
              mov ax,cx
              push ax
              mul word [width]
              add si,ax
              pop ax
              shl ax,3
              mov dx,ax
              shl ax,3
              sub ax,dx
              add di,ax
;陳陳陳陳陳陳 przejscie do kolejnej lini
              pop bp
              add bp,320
              cmp cx,38
              jb near one_line
;陳陳陳陳陳陳 przejscie do kolejnej litery
next_letter:  pop bx
              add bx,2
              cmp bx,QUEUE_L * 2
              jna near one_letter
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; rysowanie wody                                                            �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 skopiowanie plomieni w lustrzanym odbiciu
              mov si,320 * 58
              mov di,320 * 64
mirror_1:     mov cx,320 / 4
mirror_2:     es lodsd
;陳陳陳陳陳陳 wyblakly kolor
              or eax,0x80808080
;陳陳陳陳陳陳 zapisanie czterech pikseli
              stosd
              dec cx
              jne short mirror_2
              sub si,320 * 2
              jae short mirror_1
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; rysowanie napisu SGA                                                      �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              xor si,si
              mov di,320 * 74 + 30
              mov bp,40
SGA_1:        mov cx,260 / 4
;陳陳陳陳陳陳 sprawdzenie maski i wyzerowanie punktu jezeli napis
SGA_2:        gs lodsd
              and [es:di],eax
              add di,4
              dec cx
              jne short SGA_2
              add di,60
              dec bp
              jne short SGA_1
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; przesuwanie tekstu                                                        �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
              push ds
              pop es
;陳陳陳陳陳陳 przesuniecie fali
              add word [sin_add],10
              and word [sin_add],0x3FF
;陳陳陳陳陳陳 przesuniecie liter o jeden piksel w lewo
              mov si,[first]
              push si
turn_left:    dec word [queue_x + si]
              add si,2
              cmp si,[last]
              jna short turn_left
;陳陳陳陳陳陳 sprawdzenie czy pobrac nowa litere
              mov ax,[queue_x + si - 2]
              add ax,[queue_w + si - 2]
              cmp ax,RIGHT_SP
              jg short check_lt
;陳陳陳陳陳陳 pobranie indeksu litery
              mov bx,[char_no]
take_char:    movsx di,byte [scroll + bx]
              inc bx
              inc di
              jne short save_pos
              xor bx,bx
              jmp short take_char
save_pos:     mov [char_no],bx
              dec di
;陳陳陳陳陳陳 pobranie wlasciwosci litery
              movzx ax,byte [let_width + di]
              mov [queue_w + si],ax
              shl di,1
              mov ax,[let_point + di]
              mov [queue_p + si],ax
              mov word [queue_x + si],RIGHT_SP
              add word [last],2
;陳陳陳陳陳陳 sprawdzenie czy wyrzucic litere
check_lt:     pop si
              mov ax,[queue_x + si]
              add ax,[queue_w + si]
              add ax,-LEFT_SP
              jg short check_sft
              mov word [queue_p + si],-1
              add word [first],2
;陳陳陳陳陳陳 sprawdzenie czy przesunac kolejke
check_sft:    cmp word [queue_x + QUEUE_L],320 / 2
              ja short to_screen
;陳陳陳陳陳陳 przesuniecie kolejki
              mov cx,QUEUE_L
              push cx
              push cx
              mov si,queue_p + 2
              mov di,queue_p
              rep movsw
              pop cx
              mov si,queue_x + 2
              mov di,queue_x
              rep movsw
              pop cx
              mov si,queue_w + 2
              mov di,queue_w
              rep movsw
              sub word [first],2
              sub word [last],2
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; zamkniecie glownej petli                                                  �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 zapisanie obrazu do pamieci karty
to_screen:    mov fs,[buf2]
              push word 0xA000
              pop es
              xor si,si
              mov di,320 * 68
              mov cx,320 * 64 / 4
              fs rep movsd
              add di,320 * 8
              mov cx,320 * 58 / 4
              fs rep movsd
;陳陳陳陳陳陳 sprawdzenie czy wcisniety klawisz
check_key:    mov ah,01h
              int 16h
              jne short exit
;陳陳陳陳陳陳 oczekiwanie na przerwanie zegara
              cmp byte [allow],1
              jne short check_key
              mov byte [allow],0
              jmp main_loop


;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; posprzatanie po sobie i wyjscie                                           �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 pobranie klawisza
exit:         xor ah,ah
              int 16h
;陳陳陳陳陳陳 zaprogramowanie ukladu odmierzania czasu
              mov al,110100b
              out 43h,al
              mov al,-1
              out 40h,al
              out 40h,al
;陳陳陳陳陳陳 przywrocenie starej procedury zegara
              push word 0
              pop es
              mov eax,[old_int8]
              mov [es:8 * 4],eax
;陳陳陳陳陳陳 ustawienie trybu tekstowego i wypisanie informacji
exit_1:       mov ax,3
              int 0x10
              mov dx,end_text
              mov ah,9
              int 0x21
;陳陳陳陳陳陳 opuszczenie proramu
              mov ax,0x4C00
              int 0x21
;             陳陳陳陳陳陳陳陳陳陳> DOS


;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; procedura obslugi przerwania zegarowego (0x8)                             �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
;陳陳陳陳陳陳 zezwolenie na wykonanie petli
int8:         mov byte [cs:TEXT_SIZE + allow],1
;陳陳陳陳陳陳 wywolanie starej procedury co osiem razy
              inc byte [cs:TEXT_SIZE + counter]
              test byte [cs:TEXT_SIZE + counter],7
              jne short send_EOI
              jmp far [cs:TEXT_SIZE + old_int8]
;陳陳陳陳陳陳 sygnal EOI
send_EOI:     push ax
              mov al,0x20
              out 0x20,al
              pop ax
              iret
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
; procedura rozpakowujaca maske bitowa                                      �
;陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
unpack:       mov dx,bp
;陳陳陳陳陳陳 zamiana pojedynczego bitu na bajt
unpack_1:     lodsb
              mov bl,al
              mov cx,8
unpack_2:     xor al,al
              rcl bl,1
              adc al,-1
              stosb
              dec cx
              dec dx
              je short unpack_3
              jcxz unpack_1
              jmp short unpack_2
unpack_3:     dec bh
              jne short unpack
              ret


;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
; segment danych                                                            �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様郵
  section .data                                                           ; �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕

;陳陳陳陳陳陳 komunikaty
no_mem:       db 'Za malo dostepnej pamieci',CR,NL,'$'
end_text:     db 'BURN -+- intro klubu SGA -+- kod Gutz 1999',CR,NL,CR,NL
              db 'SGA 陳堕陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕',CR,NL
              db '      � http://sga.koti.com.pl           �',CR,NL
              db '      青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰',CR,NL
              db 'Gutz 賃陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�',CR,NL
              db '      � gutz@mops.uci.agh.edu.pl         �',CR,NL
              db '      � http://mops.uci.agh.edu.pl/~gutz �',CR,NL
              db '      青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰',CR,NL,'$'
;陳陳陳陳陳陳 tekst scrollowany
scroll:       db '   KLUB SGA PRZEDSTAWIA INTRO         =BURN=         '
              db 'SUPEROWA GRUPA ASMOWA ZRZESZA MIlOsNIKoW ASEMBLERA. '
              db 'ZAPRASZAMY DO UCZESTNICTWA POCZaTKUJaCYCH I ZAAWANSOWANYCH '
              db 'W CELU WYMIANY POGLaDoW I DOsWIADCZEn ORAZ POMOCY. WIeCEJ '
              db 'INFORMACJI ZNAJDZIESZ NA STRONIE KLUBU.         KOD GUTZ.  '
              db 'POZDROWIENIA DLA WSZYSTKICH KLUBOWICZoW ORAZ  QUO  '
              db 'GRAZBUHER  POP  DICKTA  GHAD  ZGRED  STAWROGIN  RUFF  '
              db 'BATT  BORG  I TYCH KToRYCH PRZEZ PRZYPADEK POMINalEM. '
              db '          ',-1
;陳陳陳陳陳陳 seed generatora liczb losowych
seed:         dw 0x575
;陳陳陳陳陳陳 przesuniecie funkcji sinus
sin_add:      dw 30
;陳陳陳陳陳陳 numer pobieranego znaku
char_no:      dw 0
;陳陳陳陳陳陳 zezwolenie na ponowne wykonanie petli glownej
allow:        db 0
;陳陳陳陳陳陳 pierwszy i ostatni znak kolejki
first:        dw QUEUE_L
last:         dw QUEUE_L
;陳陳陳陳陳陳 licznik procedury przerwania zegarowego
counter:      db 0
;陳陳陳陳陳陳 dlugosci poszczegolnych liter i ich kody
              %include 'letters.inc'
;陳陳陳陳陳陳 tekstura liter
texture:      incbin 'texture.bin'
;陳陳陳陳陳陳 paleta kolorow tekstury
txt_pal:      incbin 'palette.bin'
;陳陳陳陳陳陳 wartosci funkcji sinus (0 - pi/2)
              align 16,db 0
              %include 'sinus.inc'


;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
; segment danych niezainicjowanych                                          �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様郵
  section .bss                                                            ; �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕

;陳陳陳陳陳陳 wartosci funkcji sinus (pi/2 - 2*pi)
              resb 3 * 256
;陳陳陳陳陳陳 grunt
ground:       resb 320
;陳陳陳陳陳陳 paleta ognia
fire_pal:     resb 256
;陳陳陳陳陳陳 wskazniki do liter
let_point:    resw let_def - let_width
;陳陳陳陳陳陳 kolejka wyswietlanych liter (wskaznik, x wsp, dlugosc)
queue_p:      resw QUEUE_L + 1
queue_x:      resw QUEUE_L + 1
queue_w:      resw QUEUE_L + 1
;陳陳陳陳陳陳 adresy buforow
buf1:         resw 1
buf2:         resw 1
;陳陳陳陳陳陳 chwilowe dane dotyczace wyswietlanej litery
scale:        resd 1
width:        resw 1
right:        resw 1
left:         resw 1
let_start:    resw 1
txt_start:    resw 1
wave_pos:     resb 1
;陳陳陳陳陳陳 wskaznik do starej procedury przerwania 0x8
old_int8      resd 1
;陳陳陳陳陳陳 zarezerwowanie miejsca na dane includowane
              align 1024 * 10,resb 1


;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
; pseudo segment danych includowanych                                       �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様郵
  section .include                                                        ; �
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕

;陳陳陳陳陳陳 maska bitowa napisu sga
sga_mask:     incbin 'sga.bin'
;陳陳陳陳陳陳 maska bitowa liter
let_mask:     incbin 'letters.bin'


END_PROGRAM
