import termkey
import strformat
import std/math


initTerm(20,80,"Test KEYBOARD")
#initTerm()
setBackgroundColor(bgBlue)
eraseTerm()
var cX,cY:Natural
var scrollX,scrollY,scrollP,scrollI,scrollL,scrollM,scrollN,scrollR:Natural
var bScroll : bool = false



# table
type records = ref object
  CID    : int64
  NOM    : string

var enrg : seq[records] = @[]




defCursor(cBlink)
onCursor()
gotoXY(1,1)
onMouse()

while true:
  var (key, chr)  = getTKey()
  #gotoXY(1,1)
  #stdout.write(fmt"                       ")

  case key
    of TKey.Escape: closeTerm()

    of TKey.F1 : onMouse()

    of TKey.F2 : offMouse()



    of TKey.F3 :
        offCursor()

        for i in 2..20:
          gotoXY(i,1)
          stdout.write(fmt"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

        scrollP = 10        # nbr line /page
        scrollI = 6         # init posx
        scrollM = scrollP + scrollI - 1       # max line
        scrollY = 10        # cursorY

        scrollX = scrollI - 1 # posX line
        scrollN = 0         # text n° line
        scrollR = 0         # max n° Line
        scrollL = 0         # last n° Line
        bScroll = onScroll(scrollI,scrollM)  # 6 =  start ligne     nbr ligne  par page = 10

        gotoXY(scrollX,scrollY)

    of TKey.F4 :
      # origine
      resizeTerm(42,132)
      titleTerm("VTE-TERM3270")
      eraseTerm()


    of TKey.F5:
      if bScroll :

        if ( scrollX < scrollM ) :
          inc(scrollX)
          scrollL = 0
          enrg.add(records(CID:scrollR+1,NOM:fmt" num {scrollR+1}"))
          gotoXY(scrollX,scrollY)
          stdout.write(fmt"{enrg[scrollR].CID}   {enrg[scrollR].NOM}")
          inc(scrollR)
          scrollN = scrollR

    of TKey.PageUp:
      if bScroll :
        clearScrool(scrollP)    # clear page
        if scrolln > 0 :
          scrollL = 0
          if scrollN >= scrollP : scrollX = scrollM

          var p  = floordiv(scrollN,scrollP)
          var r  = floormod(scrollN,scrollP)
          if p == 0:
            for i in 1..scrollP:
              if scrollN == 1 : break
              dec(scrollN)

          if p >= 1 and r > 0 :
            for i in 1..scrollP + r - 1:
              if scrollN == 1 : break
              dec(scrollN)
          elif p >= 1 and r == 0 :
            for i in 1..scrollP * 2:
              if scrollN == 1 : break
              dec(scrollN)




          scrollL = scrollN

          for i in scrollI..scrollM:
            gotoXY(i,scrollY)
            stdout.write(fmt"{enrg[scrollL-1].CID}   {enrg[scrollL-1].NOM}")
            scrollX = i
            if scrollL == scrollR   : break
            inc(scrollL)


    of TKey.PageDown:
      if bScroll :
        clearScrool(scrollP) #clear page
        if scrollN < scrollR and scrollL > 0 : scrollN = scrollL
        if scrollN <= scrollR :
          scrollL = 0
          for i in scrollI..scrollM:
            gotoXY(i,scrollY)
            stdout.write(fmt"{enrg[scrollN-1].CID}   {enrg[scrollN-1].NOM}")  # simulation file display
            scrollX = i
            if scrollN == scrollR   : break
            inc(scrollN)


        # /.../  F5 manuel ;)

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



    of TKey.F11:
      titleTerm("Test KEYBOARD")

    of TKey.F12 :
      getCursor(cX , cY)
      stdout.write(fmt"CursX > {cX} CursY > {cY}")
      gotoXY(cX , cY)

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

      #elif mi.action == MouseButtonAction.mbaReleased:
        #gotoXY(mi.x,mi.y)

      case mi.scrollDir :
          of sdDown : gotoXY(1,30)
          of sdUp   : gotoXY(1,30)
          else: discard

      stdout.write fmt"CursX > {mi.x} CursY > {mi.y}"   # attention  scrollDir
      gotoXY(mi.x,mi.y)
      key = getMouseBtn()
      let zkey = getFunc(true)

    of TKey.Char:
      gotoXPos(1)
      stdout.write(fmt"char :{chr} ")

      if chr == $Tcar.Expo2 :
        gotoXPos(1)
        stdout.write(fmt"char :{chr}  Tcar.Expo2")

    else : discard

  if not bScroll :
    gotoXY(1,1)
    stdout.write(fmt"               ")
    gotoXY(1,1)
    stdout.write(fmt"key  :{key} {'\n'}")
  stdout.flushFile
  stdin.flushFile
