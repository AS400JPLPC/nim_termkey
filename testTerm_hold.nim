import termkey
import os
import strformat

var curson:bool = false
var keyget:bool = false
var keyc : TKey
var tchar : string
var line,col:Natural
proc main() =
  clsTerm()
  initTerm(30,132)
  gotoXY(29,01)
  writeStyled("F3= Exit F4=cls/Title F6=getTkey F7=Resize(30,80)    F12=Display variable  F8=OnCursor/onMouse F9=offCuror/offMouse")
  gotoXY(30,01)
  writeStyled("F13= eraseLineStart F14=eraseLineEnd  F15=eraseDown    F16=eraseUp  F17=eraseLine")

  while true:
    if not keyget : keyc = getFunc(curson)
    else : (keyc,tchar) = getTkey()

    case keyc
      of TKey.F3:
        #....#
        break

      of TKey.F12:
        clsTerm()
        resizeTerm(30,132)
        gotoXY(1,1)
        writeStyled("getEnv USER :")

        gotoXY(1,20)
        writeStyled(getEnv("USER"))

        gotoXY(2,1)
        writeStyled("getEnv PATH :")

        gotoXY(2,20)
        writeStyled(getEnv("PATH"))


        gotoXY(10,1)
        writeStyled("getHomeDir :")

        gotoXY(10,20)
        writeStyled(getHomeDir())

        gotoXY(12,1)
        writeStyled("getTempDir :")

        gotoXY(12,20)
        writeStyled(getTempDir())

        gotoXY(14,1)
        writeStyled("getCurrentDir :")

        gotoXY(14,20)
        writeStyled(getCurrentDir())

        gotoXY(16,1)
        writeStyled("getConfigDir :")

        gotoXY(16,20)
        writeStyled(getConfigDir())

        gotoXY(17,1)
        writeStyled("paramCount() :")

        gotoXY(17,20)
        writeStyled(fmt"{paramCount()}")

        gotoXY(18,1)
        writeStyled("commandLineParams() :")

        gotoXY(18,20)
        writeStyled($commandLineParams())

        gotoXY(19,1)
        writeStyled("getAppDir() :")
        
        gotoXY(19,20)
        writeStyled($getAppDir())

        gotoXY(29,01)
        writeStyled("F3= Exit F4=cls/Title F6=getTkey F7=Resize(30,80)    F12=Display variable  F8=OnCursor/onMouse F9=offCuror/offMouse")
        gotoXY(30,01)
        writeStyled("F13= eraseLineStart F14=eraseLineEnd  F15=eraseDown    F16=eraseUp  F17=eraseLine")

        if keyget  :
          gotoXY(22,1)
          stdout.write(fmt"char :")

      of TKey.F4:
        titleTerm("TERM3270")
        clsTerm()
      of TKey.F6:
          # get ( Tkey,Tchar)
      
          if not keyget  : 
            keyget = true
            gotoXY(22,1)
            stdout.write(fmt"char :")
          else: 
            keyget = false
      of TKey.F7:
          resizeTerm(30,80)


      of TKey.F8:
          defCursor(cBlink)
          onCursor()
          onMouse()
          curson=true
      of TKey.F9:
          offCursor()
          offMouse()
          curson=off

      of TKey.F13:
          eraseLineStart()
      of TKey.F14:
          eraseLineEnd()
      of TKey.F15:
          eraseDown()
      of TKey.F16:
          eraseUp()
      of TKey.F17:
          eraseLine()

      of TKey.Up:
          cursorUp()

      of TKey.Down:
          cursorDown()

      of TKey.Left:
          cursorBackward()

      of TKey.Right:
          cursorForward()
          
      of TKey.Mouse : 
        let mi = getMouse()
        if mi.action == MouseButtonAction.mbaPressed:

          # work this first /.../ bla bla 
          case mi.button
          of mbLeft:
            gotoXY(mi.x,mi.y)

          of mbMiddle:
            gotoXY(mi.x,mi.y)
          of mbRight:
            gotoXY(mi.x,mi.y)
          else: discard
        elif mi.action == MouseButtonAction.mbaReleased:
            gotoXY(mi.x,mi.y)
            
        stdout.write fmt"CursX > {mi.x} CursY > {mi.y}"
        gotoXY(mi.x,mi.y)
      
      of TKey.Char:
        gotoXY(22,1)
        stdout.write(fmt"char :{tchar}")
        if tchar == $Tcar.Expo2 :       
          gotoXY(22,1)
          stdout.write(fmt"char :{tchar}  Tcar.Expo2")
        getCursor(line,col)
        gotoXY(line,col-1)

      else: discard
    stdout.flushFile
main()
closeTerm()
