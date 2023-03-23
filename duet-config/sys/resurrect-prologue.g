M98 P"0:/sys/meltingplot/align_z_axis"  ; home z by using the maximum
G28 X Y                                 ; home x and y
T0                                      ; select T0
M116                                    ; wait for heaters
M83                                     ; relative extrusion
;G1 E20 F1000 ; undo retraction from M911 power down script