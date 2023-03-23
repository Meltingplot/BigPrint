; resume.g
; called before a print from SD card is resumed
;
T R1                    ; put last tool into active
M106 R1                 ; enable fan in its last state

M98 P"0:/sys/meltingplot/check_doors_closed"

M116 P0                 ; wait for T0
G1 R1 X0 Y0 Z2.5 F14400 ; go to 2.5mm above position of the last print move
G1 R1 X0 Y0 Z0 F1000    ; go back to the last print move
M83                     ; relative extruder moves
G11                     ; unretract
G1 E12.7 F2000          ; extrude 12.7mm of filament to revert retraction of pause

