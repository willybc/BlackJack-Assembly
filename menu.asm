.8086
.model small
.stack 100h
.data
    bienv db "________________________________________________________________________________", 0dh, 0ah
   bit001 db "                                                               ", 0dh, 0ah
   bit002 db "                                                               ", 0dh, 0ah
    bit04 db "                       __    __      __     ____   _   _       ", 0dh, 0ah
    bit05 db "                      | _\  | |     /  \   |  __| | |_/ |      ", 0dh, 0ah
    bit06 db "                      | _ < | |__  / __ \  | |__  |  _  /      ", 0dh, 0ah
    bit07 db "                      |__/  |___| /_/  \_\ |____| |_| |_|      ", 0dh, 0ah
    bit08 db "                                                               ", 0dh, 0ah
    bit09 db "                          _     __     ____   _   _            ", 0dh, 0ah
    bit10 db "                         | |   /  \   |  __| | |_/ |           ", 0dh, 0ah
    bit11 db "                       __| |  / __ \  | |__  |  _  /           ", 0dh, 0ah
    bit12 db "                      |____| /_/  \_\ |____| |_| |_|           ", 0dh, 0ah
    bit13 db "                                                               ", 0dh, 0ah
    bit14 db "                               _______________                 ", 0dh, 0ah
    bit15 db "                              |               |                ", 0dh, 0ah
    bit16 db "                              |  PRESS SPACE  |                ", 0dh, 0ah
    bit17 db "                              |_______________|                ", 0dh, 0ah
   bit003 db "                                                               ", 0dh, 0ah
   bit004 db "                                                               ", 0dh, 0ah
    bit19 db "________________________________________________________________________________", 0dh, 0ah,24h
.code
public Start_Menu

Start_Menu proc
    mov ah,9
    mov dx, offset bienv
    int 21h
    ret
Start_Menu endp
end