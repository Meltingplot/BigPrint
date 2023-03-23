; pause.g
; called when a print from SD card is paused
;
M83                                                     ; relative extruder moves
G10                                                     ; retract move
G1 E-12.5 F2000                                         ; retract 12.5mm of filament
G91                                                     ; relative positioning
G1 Z5 F1200                                             ; lift Z by 5mm
G90                                                     ; absolute positioning
T-1 P0                                                  ; put current tool into standby without toolchange
G1 X{(move.axes[0].max)} Y{(move.axes[1].max)} F6000    ; go to X=max Y=max
M106 S0                                                 ; disable fan