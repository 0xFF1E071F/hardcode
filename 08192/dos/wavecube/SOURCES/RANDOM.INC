;浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�               RANDOM PROCEDURE by Agent Orange // trx               �
;藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
	IDEAL;
;-------------------------------------------------------------------------------

Proc	Random
	mov ax,[cs:Seed1]
	add ax,1000100010001000b
	ror ax,3
	mov [cs:Seed1],ax
	ret
Seed1	dw	00000h
Endp	Random

;-------------------------------------------------------------------------------

Proc	Randomize
	mov ah,2Ch
	int 21h
	mov [cs:Seed1],dx
	ret
EndP