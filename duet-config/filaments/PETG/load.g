; Load T0 with PETG
G10 P0 S215 R160                                ; set temperatures for PETG
T0                                              ; select tool
M116                                            ; wait for temp
M98 P"0:/macros/tse/load_filament_sensorless"   ; load filament