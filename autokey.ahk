#Persistent
#NoEnv
#SingleInstance force

; --- BAGIAN 1: SCRIPT OTOMATIS JADI ADMIN ---
; Cek apakah script sudah jalan sebagai Admin. Jika belum, restart sebagai Admin.
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}                    
; -----------------------------------------      --

; Path file trigger (di folder yang sama dengan autokey.exe)
TriggerFile := A_ScriptDir . "./trigger.txt"

SetTimer, CheckTrigger, 100
Return

CheckTrigger:
IfExist, %TriggerFile%
{
    ; Hapus file trigger dulu biar nggak spam
    FileDelete, %TriggerFile%
    
    ; --- BAGIAN 2: TEKNIK TAHAN TOMBOL ---
    ; Tahan tombol Enter selama 150ms agar ETS2 sempat membacanya
    Send, {Enter down}
    Sleep, 150
    Send, {Enter up}
    ; -------------------------------------

    TrayTip, ETS2 Toll, ENTER pressed via BAT!, 1000, 1
}
Return