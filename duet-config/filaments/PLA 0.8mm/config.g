M572 D0 S0.07                       ; set pressure advance
M592 D0 A0.005 B0.0001 L0.2         ; non linear extrusion
M207 S0.80 R0.0 F2100 T840 Z0.25    ; retract for PLA
M92  E815 							; e-step for PLA