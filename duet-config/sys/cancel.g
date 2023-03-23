; cancel.g
; called when a print is cancelled after a pause.

G10                                 ; retract filament

G10 P0 R0 S0                        ; disable heater
M140 P0 S0                          ; disable bed heater
M107                                ; disable fan

G90                                 ; absolute position

if (sensors.gpIn[2].value == 1 && sensors.gpIn[3].value == 1 )
  G1 Z{(move.axes[2].max-1)} F1250    ; lift z  ; move only if both doors are closed