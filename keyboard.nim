import termkey
import strformat



initTerm(20,80,"Test KEYBOARD")
#initTerm()
setBackgroundColor(bgBlue)
eraseTerm()
var cX,cY:Natural
var scrollX,scrollY,scrollP,scrollC:Natural
var bScroll : bool = false
onCursor()
gotoXY(1,1)


while true:
  let (key, chr)  = getTKey()
  gotoXPos(1)
  stdout.write(fmt"                       ")

  case key
    of TKey.Escape: closeTerm()

    of TKey.F1 : onMouse()

    of TKey.F2 : offMouse()

    of TKey.F3 :
        offCursor() 
        scrollP = 10
        scrollX = 6
        scrollY = 10
        scrollC = 1
        bScroll = onScroll(scrollX,scrollP)  # 6 =  start ligne     nbr ligne  par page = 10   

        gotoXY(scrollX,scrollY)

    of TKey.F4 :
      # origine
      resizeTerm(42,132)  
      titleTerm("VTE-TERM3270")
      eraseTerm()
    of TKey.F5:
      if bScroll :
        if ( scrollC <= scrollP) : 
          gotoXY(scrollX,scrollY)
          stdout.write(fmt"{scrollC} ligne ")
          inc(scrollX)
          inc(scrollC)


    of TKey.F6 :
      bScroll = offScroll()
      bScroll = false
      scrollX = 1
      scrollY = 1
      onCursor()

    of TKey.F7 :
      var mask : string

      for u in 1..132 :
        mask = mask & "."

      for i in 1..50 : 
        gotoXY(i , 1)
        stdout.write(mask)
        gotoXY(i , 1)
        stdout.write(fmt"{i} ")

      gotoXY(1 , 1) 

    of TKey.F8: offCursor()

    of TKey.F9: onCursor()

    of TKey.F10:
      resizeTerm(20,80)  
      titleTerm("Test KEYBOARD")


    of TKey.F11:
        titleTerm("Test KEYBOARD")

    of TKey.F12 :
      getCursor(cX , cY)
      gotoXY(42 , 1)
      stdout.write(fmt"CursX > {cX} CursY > {cY}")
      gotoXY(cX , cY
      )
    of TKey.PageUp:
      if bScroll :
          upScrool(scrollP)
          scrollX = 6
          scrollC = 1
          # /.../ F5 manuel ;)

    of TKey.PageDown:
      if bScroll :
        downScrool(scrollP)
        scrollX = 6
        scrollC = 1
        # /.../  F5 manuel ;)

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
      gotoXPos(1)
      stdout.write(fmt"char :{chr} ")

      if chr == $Tcar.Expo2 :       
        gotoXPos(1)
        stdout.write(fmt"char :{chr}  Tcar.Expo2")

    else :
      gotoXPos(1)
      stdout.write(fmt"key  :{key} ")

  stdout.flushFile
  stdin.flushFile
