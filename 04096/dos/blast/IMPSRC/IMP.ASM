;
;      ���  ��� ���  ��� ��� ��� ���  ��� �������� ���     ��� ���  ���     
;      ���  ��� �������� ��� ��� �������� ���  ��� ���     ��� ��������     
;      ���  ��� ��� ���� ��� ��� ��� ���� ���  ��� ���     ��� ��� ����     
;      ���  ��� ���  ��� ������� ���  ��� ���  ��� ���     ��� ���  ���     
;      ���  ��� ���  ��� ��� ��� ���  ��� ���  ��� ���     ��� ���  ���     
;      ���  ��� ���  ��� ��� ��� ���  ��� ���  ��� ���  �  ��� ���  ���     
;      ���  ��� ���  ��� ��� ��� ���  ��� ���  ��� ����������� ���  ���     
;      �������� ���  ��� ��� ��� ���  ��� �������� ����   ���� ���  ���     
;
;      O.K., here is my contribution to the Imphobia #11 Coding Compo
;
;      This will generate a COM of 30bytes. Later, using CRACK.C (after
;      converting the program to an array), it will generate a 56 bytes
;      long EXE file (beat this PKLITE!). Use TLINK /t to link this to a 
;      COM file (only TASM compilable... convert it to MASM if you want to)
;
;      (c) Jcl of Unknown 1996
;

        MODEL TINY
        .286        ;Really needed?

        .CODE
        ORG 100h
        ASSUME CS:@CODE,DS:@CODE
start:
        lea dx,String
        mov ah,9
        int 21h
        mov ah,4ch
        int 21h

        String db 'ImphobiaCoderCompo$'
END start

