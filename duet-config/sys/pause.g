; pause.g
; called when a print from SD card is paused
;
M83                                                                 ; relative extruder moves
G10                                                                 ; retract move
G1 E-12.5 F2000                                                     ; retract 12.5mm of filament

if move.axes[2].homed
  if exists(global.clearanceHeight)
    G90                                                             ; absolute positioning
    G1 Z{max(move.axes[2].machinePosition,global.clearanceHeight)}  ; lift z to clearance height 
  else
    G91                                                             ; relative positioning
    G1 Z5 F1200                                                     ; lift Z relative to current position

G90                                                                 ; absolute positioning
T-1 P0                                                              ; put current tool into standby without toolchange

; if pause is called from driver-stall.g it needs to rehome
if (exists(global.event_driver_stall) && global.event_driver_stall == true)
  G28 X Y; home X Y axes
  set global.event_driver_stall = false
else
  G53 G1 X{(move.axes[0].max-5)} Y{(move.axes[1].max-5)} F6000      ; go to X=max Y=max

M106 S0                                                             ; disable fan