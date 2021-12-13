{  Project: EE-8 Assignment  Platform: Parallax Project USB Board & RoboClaw  Revision: 1.1  Author: Derek  Date: 20th Nov 2021  Log:        20/11/2021: Added objects into program        24/11/2021: Added CommCore for cog        28/11/2021: Implement signal to be sended to MyLiteKit in CommCore}CON  commRxPin     = 21  commTxPin     = 20  commBaud      = 9600  commStart     = $7A  commForward   = $01  commReverse   = $02  commLeft      = $03  commRight     = $04  commStopAll   = $AAVAR  long cogCommID, cogCommStack[128]  long  _Ms_001OBJ  Comm          : "FullDuplexSerial.spin"PUB Start (mainMSVal, signal)  _Ms_001 := mainMSVal  StopCore  cogCommID := cognew(CommCore(signal), @cogCommStack) + 1PUB CommCore(signal) | commRes  Comm.Start(commTxPin, commRxPin, 0, commBaud)  Pause(2000)  repeat    commRes := Comm.Rx    'Checks byte          '    if (commRes == commStart)  'if byte is $7A (signal to ON)      repeat        commRes := Comm.Rx  'Checks byte again        case commRes          commForward:            long[signal] := 1          commReverse:            long[signal] := 2          commLeft:            long[signal] := 3          commRight:            long[signal] := 4          commStopAll:            long[signal] := 5        Pause(50)  returnPUB StopCore  if cogCommID    cogstop(cogCommID~ -1)PRI Pause(ms) | t  t := cnt - 1088  repeat (ms #> 0)    waitcnt(t += _Ms_001)  return