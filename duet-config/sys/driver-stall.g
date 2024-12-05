; driver-stall.g
; called to home x and y after stall detection
;
echo "driver stall - "^{param.B}^"."^{param.D}^" : "^{param.P}^" ,"^{param.S}

if !exists(global.event_driver_stall)
  global event_driver_stall = true

if job.file.fileName != null
  set global.event_driver_stall = true
  
  M25                                                                 ; pause print and rehome X and Y
  M207 Z{tools[0].retraction.zHop+0.2}                                ; raise z-hop 0.2mm to prevent further crashes
  M24                                                                 ; resume print