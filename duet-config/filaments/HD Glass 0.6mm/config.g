M572 D0 S0.15                    ; pressure advance
M592 D0 A0.005 B0.0085 L0.2		; non linear extrusion            
M207 S0.8 R0.0 F1250 T840 Z0.25 ; retract for PETG
M92 E834						; E-Step PETG

if fileexists({"0:/filaments/" ^ {move.extruders[0].filament} ^ "/config-auto-esteps.g"})
  M98 P{"0:/filaments/" ^ {move.extruders[0].filament} ^ "/config-auto-esteps.g"}

if fileexists({"0:/filaments/" ^ {move.extruders[0].filament} ^ "/config-auto-nle.g"})
  M98 P{"0:/filaments/" ^ {move.extruders[0].filament} ^ "/config-auto-nle.g"}