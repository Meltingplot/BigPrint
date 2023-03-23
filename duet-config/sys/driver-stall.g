; driver-stall.g
; called to home x and y after stall detection
;
G91                                                                 ; relative positioning
G1 Z5 F600                                                          ; lift Z relative to current position
G1 H1 X{(move.axes[0].max+10)*-1} Y{move.axes[1].max+10} F3200      ; drive XY until endstop hit
G1 H1 X{(move.axes[0].max)*-1}                                      ; home Y axis
G1 H1 Y{move.axes[1].max+10}                                        ; home Y axis
G4 P0                                                               ; wait for moves
G1 H2 X-5 Y5 F6000                                                  ; go y back a few mm
G1 H2 X5 Y5 F6000                                                   ; go x back a few mm
G1 H1 X-20 F360                                                     ; move slowly to X axis endstop once more (second pass)
G1 H1 Y20 F360                                                      ; then move slowly to Y axis endstop
G90                                                                 ; absolute positioning
M207 Z{tools[0].retraction.zHop+0.2}                                ; raise z-hop 0.2mm to prevent further crashes