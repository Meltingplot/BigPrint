; homeall.g
; called to home all axes
;
M98 P"0:/sys/meltingplot/check_doors_closed"

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
G1 H1 X{(move.axes[0].max+10)*-1} Y{move.axes[1].max+10} F3200      ; drive XY until endstop hit
G1 H1 X{(move.axes[0].max)*-1}                                      ; home Y axis
G1 H1 Y{move.axes[1].max+10}                                        ; home Y axis
G4 P0                                                               ; wait for moves
G1 H2 X-5 Y5 F6000                                                  ; go y back a few mm
G1 H2 X5 Y5 F6000                                                   ; go x back a few mm
G1 H1 X-20 F360                                                     ; move slowly to X axis endstop once more (second pass)
G1 H1 Y20 F360                                                      ; then move slowly to Y axis endstop
G90                                                                 ; absolute positioning
if move.axes[0].drivers[0] == "50.0"
  M569 P50.0 D4                                                       ; switch back to closed loop mode
if move.axes[1].drivers[0] == "51.0"
  M569 P51.0 D4                                                       ; switch back to closed loop mode
M98 P"0:/sys/homez.g"                                               ; home z