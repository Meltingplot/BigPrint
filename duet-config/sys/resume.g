; resume.g
; called before a print from SD card is resumed
;
; generated by RepRapFirmware Configuration Tool v2.1.4 on Mon Dec 23 2019 10:22:33 GMT+0100 (Mitteleuropäische Normalzeit)
G1 R1 X0 Y0 Z5 F6000 ; go to 5mm above position of the last print move
G1 R1 X0 Y0          ; go back to the last print move
M83                  ; relative extruder moves
G1 E13.5 F2000         ; extrude 30mm3 of filament 32mm3 where retracted but compensate ozzing
