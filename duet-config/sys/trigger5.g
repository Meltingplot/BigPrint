; THIS FILE CONTAINS CE RELEVANT CONFIGURATIONS, ANY CHANGES TO THIS FILE MAY RESULT IN A LOST OF THE CE DECLARATION
; Left and right door closed
if (sensors.gpIn[2].value == 1 && sensors.gpIn[3].value == 1 )
  M203 Z1200.0 ; revert z movement
  M220 S100 ; revert speed to 100%

  if state.status == "paused" || state.status == "pausing"
    M581 T3 P2:3 S1 R0                                      ; configure E2:3 as door switch (door closed)
    M24 ; resume current print