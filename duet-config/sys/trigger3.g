; THIS FILE CONTAINS CE RELEVANT CONFIGURATIONS, ANY CHANGES TO THIS FILE MAY RESULT IN A LOST OF THE CE DECLARATION
; Left and right door closed
if (sensors.gpIn[2].value == 1 && sensors.gpIn[3].value == 1 )
  M203 Z1200.0 ; revert z movement
  M220 S100 ; revert speed to 100%