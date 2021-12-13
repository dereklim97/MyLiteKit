{
  Project: EE-7 Assignment
  Platform: Parallax Project USB Board & RoboClaw
  Revision: 1.1
  Author: Derek
  Date: 15th Nov 2021
  Log:
        15/11/2021: Added objects into program
        20/11/2021: Added CommControl.spin as object
        24/11/2021: Added conditions for moving between SensorControl.spin,
                    CommControl.spin and MotorControl.spin
}


CON

  _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001 = _ConClkFreq / 1_000

  sigForward    = 1 'signal to move forward
  sigReverse    = 2 'signal to reverse
  sigLeft       = 3 'signal to turn left
  sigRight      = 4 'signal to turn right
  sigStop       = 5 'signal to stop

  ultrasafe = 240 'safe value for ultrasonic sensors
  tofsafe = 180 'safe value for tof sensors

VAR
  long  mainUltra1Add, mainUltra2Add, mainTof1Add, mainTof2Add, signal, action

OBJ
  ToMove        : "MotorControl.spin"
  ToSense       : "SensorControl.spin"
  ToComm        : "CommControl.spin"

PUB Main

  ToSense.Start(_Ms_001, @mainUltra1Add, @mainUltra2Add, @mainTof1Add, @mainTof2Add) 'starts sensor core
  ToComm.Start(_Ms_001, @signal) 'starts comms core
  ToMove.Start(_Ms_001, @action) 'starts motor core
  Pause(1000)

  repeat
    case signal 'using signal to determine action
      sigForward:
        if (mainultra1add > ultrasafe AND maintof1add < tofsafe) 'checks front sensors
          action := sigforward
        else
          action := sigstop
      sigReverse:
        if (mainultra2add > ultrasafe AND maintof2add < tofsafe) 'check rear sensors
          action := sigReverse
        else
          action := sigstop
      sigLeft:
        action := sigLeft
      sigRight:
        action := sigRight
      sigStop:
        action := sigStop
    Pause(50)

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return