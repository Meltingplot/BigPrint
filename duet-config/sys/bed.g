; bed.g
; called to perform automatic bed compensation via G32
;

M561                                      ; clear any bed transform
G29 S2                                    ; Clear height compensation
M290 R0 S0                                ; clear babystepping
M98 P"0:/sys/meltingplot/align_z_axis"    ; align z axis
if move.axes[0].homed == false            ; check if x is homed
  M98 P"0:/sys/homex.g"                   ; home x axis
if move.axes[1].homed == false            ; check if y is homed
  M98 P"0:/sys/homey.g"                   ; home y axis
G1 Z20 F3600                              ; raise z to probe

G30 P0 X{sensors.probes[0].offsets[0]} Y{sensors.probes[0].offsets[1]} Z-99999               ; probe near a leadscrew, half way along Y axis
G30 P1 X{sensors.probes[0].offsets[0]} Y{(move.axes[1].max/2)} Z-99999                       ; probe near a leadscrew, half way along Y axis
G30 P2 X{sensors.probes[0].offsets[0]} Y{move.axes[1].max} Z-99999                           ; probe near a leadscrew, half way along Y axis
G30 P3 X{move.axes[0].max-10} Y{move.kinematics.tiltCorrection.screwY[1]} Z-99999            ; probe near sec. leadscrew
G30 P4 X{move.axes[0].max-10} Y{move.kinematics.tiltCorrection.screwY[2]} Z-99999 S3         ; probe near third leadscrew and calibrate 2 motors

; G29  ; probe the bed and enable compensation

G29 S1                                    ; load stored height map
