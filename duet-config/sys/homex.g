; homex.g
; called to home the X axis
;
if move.axes[2].homed
  if exists(global.clearanceHeight)
    G90                                                             ; absolute positioning
    G1 Z{max(move.axes[2].machinePosition,global.clearanceHeight)}  ; lift z to clearance height 
  else
    G91                                                             ; relative positioning
    G1 H2 Z0.5 F600                                                 ; lift Z relative to current position

if move.axes[0].drivers[0] == "50.0"
  M569 P50.0 D5                                                       ; switch to assissted open loop mode to ensure the drive will not move
if move.axes[1].drivers[0] == "51.0"
  M569 P51.0 D5                                                       ; switch to assissted open loop mode to ensure the drive will not move

G91                                                                 ; relative positioning
G1 H1 X{(move.axes[0].max+10)*-1} F1800                             ; move quickly to X axis endstop and stop there (first pass)
G1 H2 X5 Y5 F6000                                                   ; go back a few mm
G1 H1 X-20 F360                                                     ; move slowly to X axis endstop once more (second pass)

if !exists(global.clearanceHeight) && move.axes[2].homed
  G91                                                               ; relative positioning
  G1 H2 Z-0.5 F600                                                  ; lower Z again

G90                                                                 ; absolute positioning

if move.axes[0].drivers[0] == "50.0"
  M569 P50.0 D4                                                       ; switch back to closed loop mode
if move.axes[1].drivers[0] == "51.0"
  M569 P51.0 D4                                                       ; switch back to closed loop mode