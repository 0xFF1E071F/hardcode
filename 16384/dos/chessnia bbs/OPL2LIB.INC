; 께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께�
;   Compatible LIB with Chicken HSC player, but now it's my player ;)
; 께께께께께께께께께께께께께께께께께께께께� By Spanish Lords April 95 께�
; 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
;   V A R I A B L E S  for OPL2 Player
; 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
RESET DB 00h
ERROR DB 00h
INCLUDE PLAYER.INC
; 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
;   D E T E C T     A D L I B
;   Out : RESET = 1
;         ERROR = 1 If not exits an OPL2 chip ;)
; 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
DetectAdlib PROC
            CALL    DetectOPL2  ; do NOT work with GUS.
            JNC    @@NoError
            MOV    ERROR,1
            JS     @@End
  @@NoError:
            MOV    ERROR,0
  @@End:
            MOV    RESET,01
            RET
DetectAdlib ENDP
; 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
;   S T A R T   M U S I C
;   In : BL    - Playing polling? (1 Yes 0 No)
;        ES:SI - The Song.
;   StartMusic PROC FAR Poll:Byte,Segm:Word,Offs:Word
; 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
StartMusic  PROC
            CMP    RESET,01
            JE     @@Yet
            CALL   DetectAdlib
            CMP    ERROR,1
            JE     @@End
 @@Yet:
            CALL   NewSong     ; � bl-PollingOnOff    � es:si-music data
 @@End:
            RET
StartMusic  ENDP
