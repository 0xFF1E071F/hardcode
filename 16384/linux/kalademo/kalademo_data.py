# -*- coding: utf-8 -*-

def pikkukala(reverse=False):
    if reverse:
        return ["<(((-< "]
    else:
        return [" >-)))>"]

def keskikala(ch, reverse=False):
    if reverse:
        return [" "+ch*3+"   ", ch*5+"< ", " "+ch*3+"   "]
    else:
        return ["   "+ch*3+" ", " >"+ch*5, "   "+ch*3+" "]

def isokala(ch, reverse=False):
    if reverse:
        return [" "+ch*5+"  ", "  "+ch*3+"   ", ch*7+"< ", " "+ch*5+"  ", "  "+ch*3+"   ",]
    else:
        return ["   "+ch*5+"  ", "    "+ch*3+"   ", " >"+ch*7, "   "+ch*5+"  ", "    "+ch*3+"   ",]

def jattikala(ch, reverse=False):
    if reverse:
        return [" "+ch*7+"  ", "  "+ch*5+"   ", ch*9+"< ", " "+ch*7+"  ", "  "+ch*5+"   ",]
    else:
        return ["   "+ch*7+"  ", "    "+ch*5+"   ", " >"+ch*9, "   "+ch*7+"  ", "    "+ch*5+"   ",]

def koordinaattikala(reverse=False):
    if reverse:
        return ["<(00,00)-< "]
    else:
        return [" >-(00,00)>"]


apua=[
" ******",
"* !!!! *",
" ******"]

hoh=[
" ++++++",
"+  :(  +",
" ++++++"]

jee=[
" ++++++",
"+  :)  +",
" ++++++"]

otsikko = [
" ###   ###     #####      ###           #####     ######     ##########  #####     #####     #####    ",
" ###  ###     ### ###     ###          ### ###    ########   ##########  ######   ######   #########  ",
" ### ###     ###   ###    ###         ###   ###   ###   ###  ###         ### ### ### ###  ###     ### ",
" ######     ###########   ###        ###########  ###   ###  #######     ###  #####  ###  ###     ### ",
" ### ###    ###########   ###        ###########  ###   ###  ###         ###   ###   ###  ###     ### ",
" ###  ###   ###     ###   #########  ###     ###  ########   ##########  ###         ###   #########  ",
" ###   ###  ###     ###   #########  ###     ###  ######     ##########  ###         ###     #####    "]


vesikasvit1 =[
"  s       s     s     s  "*4,
"   S     S     S       S "*4,
"  s       s     s     s  "*4,
" S       S       S    s  "*4,
"  s     s       s      S "*4,
"  S      s     S      S  "*4,
" s      S      s     S   "*4,
"  s     s       S    s   "*4,
" S       S     S     S   "*4,
"S       S     s       S  "*4,
" S       s     S     S   "*4][::-1]

vesikasvit2 =[
"   s     s     s       s "*4,
"  S       S     S     S  "*4,
"   s     s     s       s "*4,
"  S       S    S      s  "*4,
"   s     s      s      S "*4,
"  S     s        S    S  "*4,
" s      S        s   S   "*4,
"  s      s      S     s  "*4,
" S       S     S      S  "*4,
"  S       S     s    S   "*4,
" S       s     S      S  "*4][::-1]


koordinaatisto =[
"  |",
"  |",
"  |",
"----------------------------------------------------------------------------------------------------->",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  |",
"  ^"]

kiitos=[
" ###         #####     #######    ########   ###    ### ",
" ###       #########   #########  #########  ###    ### ",
" ###      ###     ###  ###    ##  ###    ##  ###    ### ",
" ###      ###     ###  #########  #########  ###    ### ",
" ###      ###     ###  #######    #######    ###    ### ",
" ########  #########   ###        ###         ########  ",
" ########    #####     ###        ###          ######   "][::-1]