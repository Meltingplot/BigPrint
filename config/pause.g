; pause.g
; called when a print from SD card is paused
;
; generated by RepRapFirmware Configuration Tool v2.1.4 on Mon Dec 23 2019 10:22:33 GMT+0100 (Mitteleuropäische Normalzeit)
M83            ; relative extruder moves
G1 E-12.5 F2000  ; retract 32mm3 of filament
G91            ; relative positioning
G1 Z100 F1200     ; lift Z by 100mm
G90            ; absolute positioning
G1 X750 Y100 F6000 ; go to X=750 Y=0
