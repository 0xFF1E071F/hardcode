@echo off
mode 80
echo �������������                                             ������������������
echo             ��                                           ��
echo              � ����������������������������������������� �
echo              �                                      ���� �
echo              �                                         � �
echo              �                                           �
echo ܱ�������  ܱ���  ��  ܱ�������  ܱ�������  ܱ�������  ܱ�������  ܱ�������
echo ۲���   �� ۲���   �� ۲���   �� ۲���   �� ۲���   �� ۲���   �� ۲���   ��
echo �۲��    � �۲��   �� �۲��    � �۲��   �� �۲��   �� �۲��   �� �۲��   ��
echo ���������� �����   �� ���������� �����   �� ���������� �����   �� �����   ��
echo ����� ���  ����� ���  ����� ���  ����� ���  ����� ���  �����  ��  ����� ���
echo  ������     ������     ������    �������     ������     ����  �    ������
echo              � �                 �����                   �
echo              � ����                                 ^ins �
echo              � ����������������������������������������� �
echo             ��            . p R E S E N T s .            ��
echo �������������             "trace your mind 2"             ������������������
echo    ��                                                              ߲
echo    �                      1) 320 x 80 x 16bpp                       �
echo    �                      2) 160 x 80 x 16bpp                       �
echo    �                      3) 160 x 40 x 16bpp                       �
echo    �                      4)  80 x 40 x 16bpp                       �
echo    �                      5) exit                                   �
choice /c:12345 /n /t:4,20 �  �                      select resolution: 
IF ERRORLEVEL 5 GOTO FUCK
IF ERRORLEVEL 4 GOTO RES4
IF ERRORLEVEL 3 GOTO RES3
IF ERRORLEVEL 2 GOTO RES2
trm2_328.exe
GOTO FUCK

:RES2
trm2_168.exe
GOTO FUCK

:RES3
trm2_164.exe
GOTO FUCK

:RES4
trm2_84.exe

:FUCK
