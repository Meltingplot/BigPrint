
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

  if state.status == "paused"
    if mod(state.upTime,20) >= 10
      M42 P0 S{1.0-((mod(state.upTime,20)-10)/10.0)}
    else
      M42 P0 S{max(0.1, mod(state.upTime,10)/10.0)}
  elif state.status == "idle"
    M42 P0 S0.3
    ; elif (state.status == "processing" || state.status == "pausing" || state.status == "resuming" || state.status == "starting")
    ;   M42 P0 S1.0 ; turn LED on 100%
  else
    M42 P0 S1.0 ; turn LED on 100%

  ; this file is called every 1 second in RFF 3.1.0 < 3.3
  ; from 3.3 on this file is called every 10 seconds
  ; to compensate this, loop 8 times and wait 1 second
  ; and then leave this loop/file
  if iterations > 8
    break
  G4 S1 ; wait one second