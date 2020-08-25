; homez.g
; called to home the Z axis
;

M120                                                            ; push current settings on stack
G91                                                             ; relative positioning
M98 P"0:/sys/bed.g"                                             ; run true bed leveling
G90                                                             ; absolute positioning
G1 X{105-sensors.probes[0].offsets[0]} Y{move.kinematics.tiltCorrection.screwY[0]-sensors.probes[0].offsets[1]} F5000
M121                                                            ; pop stored settings from stack