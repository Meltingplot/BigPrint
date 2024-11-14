; homez.g
; called to home the Z axis
;
M98 P"0:/sys/meltingplot/check_doors_closed"
if global.bed_aligned == true
  ; when homeall or home z is called, the homing of the zaxis is lost
  ; if the bed was aligned, we can skip the alignment of the z axis
  set global.bed_aligned_since = state.upTime
G91                                                                                                                         ; relative positioning
M98 P"0:/sys/bed.g"                                                                                                         ; run true bed leveling
G90                                                                                                                         ; absolute positioning
G1 X{105-sensors.probes[0].offsets[0]} Y{move.kinematics.tiltCorrection.screwY[0]-sensors.probes[0].offsets[1]} F14400
G1 Z5 G30                                                                                                                   ; after z compensation probe z-distance again