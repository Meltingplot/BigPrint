; homex.g
; called to home the X axis
;
G91                                     ; relative positioning
G1 H2 Z0.5 F600                         ; lift Z relative to current position
G1 H1 X{(move.axes[0].max+10)*-1} F1800 ; move quickly to X axis endstop and stop there (first pass)
G1 H2 X5 Y5 F6000                       ; go back a few mm
G1 H1 X-20 F360                         ; move slowly to X axis endstop once more (second pass)
G1 H2 Z-0.5 F600                        ; lower Z again
G90                                     ; absolute positioning

