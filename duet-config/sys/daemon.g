while true
  ; use it to check the e-stop and door switch conditions
  ; check every channel individual
  ; the switches are configured as NC (normally closed)
  ; - test the current state of the switch M582 Tx
  ; - disable trigger M581 T2 P-1
  ; - reconfigure pin as active low, disabled pull-up resistor M950 J0 C"!e0stop"
  ; - test the current state of the switch M582 Tx
  ; - check current pin configuration, enable pull up resistor active high M950 J0 C"^e0stop" 
  ; - check if the switch is configured as active high M581 T2 P0 S1 R0
  ; - test the current state of the switch M582 Tx

  if ( sensors.gpIn[0].value != 0 || sensors.gpIn[1].value != 0 )
    M117 "Enable E-Stop Check in Production! Go to /sys/daemon and enable M112"
    ; M112 ; emergency shutdown

  ; test if doorswitch #1 or #2 is opened
  if (sensors.gpIn[2].value == 0 || sensors.gpIn[3].value == 0 ) && abs(move.axes[2].machinePosition - state.restorePoints[5].coords[2]) > 6.0
    ; Bed has moved more than 6mm while door is opened 
    M112 ; emergency stop

  var upTime = state.upTime

  if state.status == "paused"
    if mod(var.upTime,20) >= 10
      M42 P0 S{1.0-((mod(var.upTime,20)-10)/10.0)}
    else
      M42 P0 S{max(0.1, mod(var.upTime,10)/10.0)}
  elif state.status == "idle"
    M42 P0 S0.3
  else
    M42 P0 S1.0 ; turn LED on 100%

  if exists(global.mfmbackoff) && exists(global.lastMFMBackoffCheck) && global.mfmbackoff < 3 && ((global.lastMFMBackoffCheck + 60) < var.upTime)
    M220 S{50+25*global.mfmbackoff} ; increase speed in steps of 50 + 0*25, 1*25 2*25
    set global.mfmbackoff = global.mfmbackoff + 1
    set global.lastMFMBackoffCheck = var.upTime

  if exists(global.bed_aligned)
    var z_homed = move.axes[2].homed
    var bed_aligned = global.bed_aligned
    if var.bed_aligned == true && var.z_homed == true:
      set global.bed_aligned_since = var.upTime
    elif var.bed_aligned == true && var.z_homed == false:
      if (var.upTime - global.bed_aligned_since) > 30
        set global.bed_aligned = false

  if exists(global.resume_deferred) && global.resume_deferred > 0 && global.resume_deferred < var.upTime
    if state.status == "paused"
      M24 ; resume print
      set global.resume_deferred = 0

  G4 P100 ; wait 100ms
  if iterations > 598 ; around 60 seconds break and restart the loop 
    break