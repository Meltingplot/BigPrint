; Configuration file for Duet WiFi (firmware version 3.5.3)
; executed by the firmware on start-up

; General preferences
G90                                                     ; send absolute coordinates...
M83                                                     ; ...but relative extruder moves

M669 K1 S2 T1                                           ; select CoreXY mode and enable segmentation

; Network Ethernet
M551 P"meltingplot"                                      ; set password

; Drives
; disabled in closed loop mode as X and Y are driven by external drivers
;M569 P0 S0                                              ; physical drive 0 goes backwards (x - front)
;M569 P1 S1                                              ; physical drive 1 goes forwards (y - rear)
M569 P2 S0                                              ; physical drive 2 goes backwards (left)
M569 P3 S0                                              ; physical drive 3 goes backwards (rear right)
M569 P4 S0                                              ; physical drive 4 goes backwards (front right)
M569 P5 S1                                              ; physical drive 5 goes forwards (extruder)

G4 S1                                                   ; wait for expansion boards

;          Y 51.0 +------------------------------------+
;                /                                    /|
;               /                                    / |
;              /                                    /  |
;      X 50.0 +------------------------------------+   |
;             |                                    |   |
;             |                                    |  /
;             |               front                | /
;             |                                    |/
;             +------------------------------------+

; Configure the Duet 3 Expansion 1HCL board at CAN address 50 with a Duet 3 magnetic encoder, warn if 2 fullstep threshold exceeded, error if 4 full steps threshold exceeded.
M569.1 P50.0 T3 E2.0:4.0 S200 R210 I1500 D0.04 V600 A300000 H0.3
M569 P50.0 D4 S0 ; Configure the motor on the Duet 3 Expansion 1HCL controller at can address 50 as being in closed-loop drive mode (D4) and reversed (S0)

; Configure the Duet 3 Expansion 1HCL board at CAN address 51 with a Duet 3 magnetic encoder, warn if 2 fullstep threshold exceeded, error if 4 full steps threshold exceeded.
M569.1 P51.0 T3 E2.0:4.0 S200 R210 I1500 D0.04 V600 A250000 H0.3
M569 P51.0 D4 S1 ; Configure the motor on the Duet 3 Expansion 1HCL controller at can address 51 as being in closed-loop drive mode (D4) reversed (S1)

M584 X50.0 Y51.0 Z2:3:4 E5                              ; set drive mapping

M350 E16 I1                                             ; configure microstepping with interpolation
M350 Z16 I1                                             ; configure microstepping with interpolation
M350 X16 Y16 I1                                         ; configure microstepping without interpolation
M92 X80 Y80 Z400 E807.5                                 ; set steps per mm

M566 X600.0 Y600.0 Z12.00 E240.00 P1                    ; set maximum instantaneous speed changes (mm/min) and apply jerk on every move
M593 P"zvddd" F40                                       ; cancle ringing at 40Hz zvddd will cover a range from around 20 - 60 hz
M203 X18000.00 Y18000.00 Z1200.00 E3600.00              ; set maximum speeds (mm/min)
M201 X4000.00 Y4000.00 Z72.00 E3000.00                  ; set accelerations (mm/s^2)
M204 P1500 T4000                                        ; Set printing and travel accelerations
M906 X1900 Y1900 Z2000 E1400 I30                        ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                                 ; Set idle timeout
M917 X10 Y10                                            ; set idle current to 10% for X and Y
M917 E50                                                ; set idle current to 50% for E

; Axis Limits
M208 X0 Y0 Z0 S1                                        ; set axis minima
M208 X851 Y405 Z1396 S0                                 ; set axis maxima

; Endstops
M574 X1 S1 P"io5.in"                                    ; configure active-high endstop for low end on X via pin io5.in
M574 Y2 S1 P"io6.in"                                    ; configure active-high endstop for high end on Y via pin io6.in
M574 Z2 S4                                              ; configure sensorless endstop on high end of Z

; Led
M950 P0 C"out3"                                         ; Configure P0 as output for LED Strip
M42 P0 S0.25                                            ; Set LEDs to 25%

; ATX PS_ON
; M80 enable ATX power
; M81 disable ATX power
; our PSU uses an inverted PS_ON logic
;M80 C"!pson" ; inverts the PS_ON output

; Heaters
M950 H0 C"nil"
M950 H1 C"nil"

; Bed Heaters
M308 S0 P"temp0" Y"thermistor" T100000 B4598 C8.68e-08 A"bed" ; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out7" T0 Q10                                  ; create bed heater output on out7 and map it to sensor 0 and set PWM 10Hz
M307 H0 R0.15 K0.224:0.000 D2.17 E1.35 S1.00 B0         ; disable bang-bang mode for the left bed heater and set PWM limit
M140 P0 H0                                              ; map heater0 to bed
M143 H0 S120                                            ; set temperature limit for heater 0 to 120C
M570 H0 P5 T10 S10                                      ; Enable heater fault detection (Trigger Time 5sec, temp deviation 10°, cancel print after 10min) 

; Hotend
M308 S2 P"spi.cs0" Y"rtd-max31865" A"hotend"            ; configure sensor 2 as rtd PT100 on pin spi.cs0
M950 H1 C"out1" T2                                      ; create nozzle heater output on out1 and map it to sensor 2
M143 H1 S350                                            ; set temperature limit for heater 2 to 350C
M307 H1 R1.962 K0.205:0.114 D5.81 E1.35 S1.00 B0 V24.0  ; disable bang-bang mode for the nozzle heater and set PWM limit
M570 H1 P5 T15 S10                                      ; Enable heater fault detection (Trigger Time 5sec, temp deviation 15°, cancel print after 10min) 

M308 S3 Y"mcu-temp" A"mcu-temp"                         ; configure sensor 3 as temp sens for the mcu

; Fans
M950 F0 C"out5" Q250                                    ; create fan 0 (cooling fan) on pin fan0 and set its frequency
M106 P0 S0 H-1                                          ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"out4" Q250                                    ; create fan 1 (radiator fan) on pin fan1 and set its frequency
M106 P1 H2 T45 L1.0 X1.0 B0.0                           ; set fan 1 value. Thermostatic control is turned on
M950 F2 C"out9" Q250                                    ; create fan 2 (duet internal fan) on pin fan0 and set its frequency
M106 P2 S1 H3 T30:45 L0.35 X1.0 B0.25                   ; set fan 2 value. Thermostatic control is turned on

; Tools
M563 P0 D0 H1 F0                                        ; define tool 0
G10 P0 X0 Y0 Z0                                         ; set tool 0 axis offsets
G10 P0 R0 S0                                            ; set initial tool 0 active and standby temperatures to 0C

; Z-Probe
M558 P8 C"io1.in" H6 F240 T14400 A3                     ; set Z probe type to unmodulated and the dive height + speeds probe every point three times
G31 P500 X8.6 Y25.5 Z2.0 T0.00118 S87.5 H0              ; set Z probe trigger value, offset and trigger height, try to set it to whole number of x/8mm pitch/200 steps-rev / 16 micro-step 
M557 X{sensors.probes[0].offsets[0],move.axes[0].max-sensors.probes[0].offsets[0]} Y{sensors.probes[0].offsets[1],move.axes[1].max-sensors.probes[0].offsets[1]} P18:8                        ; define mesh grid
M376 H15                                                ; taper out z correction over 15mm height

;M915 X Y S8 F0 R3 H200                                  ; configure stall detection on X and Y without Filter (1 Full Steps)
                                                        ; and min 200 steps/sec (40mm/sec) (concider motor current 1A) and execute rehome.g on stall
M915 Z S4 F0 R0                                         ; configure stall detection on Z for sensor less homing

M404 N2.85                                              ; set filament diameter to 2.85mm
M200 D2.85 S0                                           ; set filament diameter to 2.85mm
M207 S0.2 R0.0 F1620 T840 Z0.1                          ; Use Firmware retract with 0.2mm retract, 0.0mm additional unretract at retract 1620 mm/min, 840 unretract and 0.1 Z-Lift

M911 S23.4 R23.8 P"M913 X0 Y0 Z10 E10 G91 M83 G1 Z1390 E-20 F1500" ; configure power safe mode
M671 X-150.0:915.0:915.0 Y208.5:373.5:43.5 S10          ; Z leadscrews are at (-150,215.5), (915,50.5) and (915,380.5)

M572 D0 S0.035                                          ; set pressure advance
M592 D0 A0.00 B0.0112 L0.2                              ; non linear extrusion

; Miscellaneous
M501                                                    ; load saved parameters from non-volatile memory
G31 T0.00118 S87.5 H0                                   ; temp coefficent and calib temp are not stored in override
M929 P"0:/eventlog.log" S1                              ; Enable Event Logging

M98 P"0:/sys/meltingplot/machine-override"              ; Load Machine specific overrides
M98 P"0:/sys/meltingplot/ce-declaration"                ; Load CE Requirements

M98 P"0:/sys/meltingplot/globals"                       ; Load Global Variables