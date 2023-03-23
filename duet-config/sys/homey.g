; homey.g
; called to home the Y axis
;
G91                                 ; relative positioning
G1 H2 Z0.5 F600                     ; lift Z relative to current position
G1 H1 Y{move.axes[1].max+10} F1800  ; move quickly to Y axis endstop and stop there (first pass)
G1 H2 X-5 Y5 F6000                  ; go back a few mm
G1 H1 Y20 F360                      ; move slowly to Y axis endstop once more (second pass)
G1 H2 Z-0.5 F600                    ; lower Z again
G90                                 ; absolute positioning

