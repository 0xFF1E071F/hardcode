.MODEL SMALL
.STACK 200h
 Stackgr��e=200h
.386
.CODE
Start:
 push	@DATA
 pop	ds
 push	ds
 pop	es
 call	Optionen_lesen
 jmp	Men�
