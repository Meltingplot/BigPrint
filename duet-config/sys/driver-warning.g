if param.B > 0 && param.D == 0 && move.axes[0].homed == false && move.axes[1].homed == false
  M99 ; ignore warning when drives are not homed

echo "driver warning - " ^ {param.S}

if !exists(global.event_driver_stall)
  global event_driver_stall = true

if job.file.fileName != null
  set global.event_driver_stall = true
  
  M25                                                                 ; pause print and rehome X and Y
  M207 Z{tools[0].retraction.zHop+0.2}                                ; raise z-hop 0.2mm to prevent further crashes
  M24                                                                 ; resume print