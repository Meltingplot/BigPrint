M572 D0 S0.05                       ; set pressure advance
M592 D0 A-0.0046 B0.0033 L0.2          ; non linear extrusion
M207 S1.60 R0.0 F2100 T840 Z0.5     ; retract for PLA
M92  E860 							; e-step for PLA