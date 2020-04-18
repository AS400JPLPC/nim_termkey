# base https://github.com/johnnovak/illwill
# base https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50
# https://en.wikipedia.org/wiki/Windows-1252 and Other


#======================================================
#	work get-keyboard and Mouse 
#		Linux
#
#		30/03/2020
#
# Inspiration johnnovak/illwill and JPLAS400PC C++
# retrieve keyboard Basic Latin 1252 or extend ISO-8859-15
# ADD utilitaire for sigle Print
#
# tank you open-source for studie and inspiration
#======================================================


import  posix,tables, terminal, termios , bitops
import  strformat ,strutils

type
  Key* {.pure.} = enum
    None  = (-1, "None")
    Char = (0, "Char"),

    # Special ASCII characters
    CtrlA  = (1, "CtrlA"),
    CtrlB  = (2, "CtrlB"),
    CtrlC  = (3, "CtrlC"),
    CtrlD  = (4, "CtrlD"),
    CtrlE  = (5, "CtrlE"),
    CtrlF  = (6, "CtrlF"),
    CtrlG  = (7, "CtrlG"),
    CtrlH  = (8, "CtrlH"),
    Tab    = (9, "Tab"),     # Ctrl-I
    CtrlJ  = (10, "CtrlJ"),
    CtrlK  = (11, "CtrlK"),
    CtrlL  = (12, "CtrlL"),
    Enter  = (13, "Enter"),  # Ctrl-M
    CtrlN  = (14, "CtrlN"),
    CtrlO  = (15, "CtrlO"),
    CtrlP  = (16, "CtrlP"),
    CtrlQ  = (17, "CtrlQ"),
    CtrlR  = (18, "CtrlR"),
    CtrlS  = (19, "CtrlS"),
    CtrlT  = (20, "CtrlT"),
    CtrlU  = (21, "CtrlU"),
    CtrlV  = (22, "CtrlV"),
    CtrlW  = (23, "CtrlW"),
    CtrlX  = (24, "CtrlX"),
    CtrlY  = (25, "CtrlY"),
    CtrlZ  = (26, "CtrlZ"),
    Escape = (27, "Escape"),

    Backspace  = (127, "Backspace" ),

    # Special characters with virtual keycodes
    Stab     = (1000, "Stab"),
    Up       = (1001, "Up"),
    Down     = (1002, "Down"),
    Right    = (1003, "Right"),
    Left     = (1004, "Left"),
    Home     = (1005, "Home"),
    Insert   = (1006, "Insert"),
    Delete   = (1007, "Delete"),
    End      = (1008, "End"),
    PageUp   = (1009, "PageUp"),
    PageDown = (1010, "PageDown"),
  
    F1  = (1011, "F1"),
    F2  = (1012, "F2"),
    F3  = (1013, "F3"),
    F4  = (1014, "F4"),
    F5  = (1015, "F5"),
    F6  = (1016, "F6"),
    F7  = (1017, "F7"),
    F8  = (1018, "F8"),
    F9  = (1019, "F9"),
    F10 = (1020, "F10"),
    F11 = (1021, "F11"),
    F12 = (1022, "F12")
    F13 = (1023, "F13"),
    F14 = (1024, "F14"),
    F15 = (1025, "F15"),
    F16 = (1026, "F16"),
    F17 = (1027, "F17"),
    F18 = (1028, "F18"),
    F19 = (1029, "F19"),
    F20 = (1030, "F20"),
    F21 = (1031, "F21"),
    F22 = (1032, "F22"),
    F23 = (1033, "F23"),
    F24 = (1034, "F24"),

    altA  = (2001,"altA"),
    altB  = (2002,"altB"),
    altC  = (2003,"altC"),
    altD  = (2004,"altD"),
    altE  = (2005,"altD"),
    altF  = (2006,"altF"),
    altG  = (2007,"altG"),
    altH  = (2008,"altH"),
    altI  = (2009,"altI"),
    altJ  = (2010,"altJ"),
    altK  = (2011,"altK"),
    altL  = (2012,"altL"),
    altM  = (2013,"altM"),
    altN  = (2014,"altN"),
    altO  = (2015,"altO"),
    altP  = (2016,"altP"),
    altQ  = (2017,"altQ"),
    altR  = (2018,"altR"),
    altS  = (2019,"altS"),
    altT  = (2020,"altT"),
    altU  = (2021,"altU"),
    altV  = (2022,"altV"),
    altW  = (2023,"altW"),
    altX  = (2024,"altX"),
    altY  = (2025,"altY"),
    altZ  = (2026,"altZ"),

    Mouse = (5000, "Mouse"),


let
  keySequences = {
    ord(Key.Up):        @["\eOA", "\e[A"],
    ord(Key.Down):      @["\eOB", "\e[B"],
    ord(Key.Right):     @["\eOC", "\e[C"],
    ord(Key.Left):      @["\eOD", "\e[D"],

    ord(Key.Home):      @["\e[1~", "\e[7~", "\eOH", "\e[H"],
    ord(Key.Insert):    @["\e[2~"],
    ord(Key.Delete):    @["\e[3~"],
    ord(Key.End):       @["\e[4~", "\e[8~", "\eOF", "\e[F"],
    ord(Key.PageUp):    @["\e[5~"],
    ord(Key.PageDown):  @["\e[6~"],

    ord(Key.F1):        @["\e[11~", "\eOP"],
    ord(Key.F2):        @["\e[12~", "\eOQ"],
    ord(Key.F3):        @["\e[13~", "\eOR"],
    ord(Key.F4):        @["\e[14~", "\eOS"],
    ord(Key.F5):        @["\e[15~"],
    ord(Key.F6):        @["\e[17~"],
    ord(Key.F7):        @["\e[18~"],
    ord(Key.F8):        @["\e[19~"],
    ord(Key.F9):        @["\e[20~"],
    ord(Key.F10):       @["\e[21~"],
    ord(Key.F11):       @["\e[23~"],
    ord(Key.F12):       @["\e[24~"],
    ord(Key.F13):       @["\e[1;2P"],
    ord(Key.F14):       @["\e[1;2Q"],
    ord(Key.F15):       @["\e[1;2R"],
    ord(Key.F16):       @["\e[1;2S"],
    ord(Key.F17):       @["\e[15;2~"],
    ord(Key.F18):       @["\e[17;2~"],
    ord(Key.F19):       @["\e[18;2~"],
    ord(Key.F20):       @["\e[19;2~"],
    ord(Key.F21):       @["\e[20;2~"],
    ord(Key.F22):       @["\e[21;2~"],
    ord(Key.F23):       @["\e[23;2~"],
    ord(Key.F24):       @["\e[24;2~"],

    ord(Key.STab):      @["[279190"],

    ord(Key.altA):       @["2797"],
    ord(Key.altB):       @["2798"],
    ord(Key.altC):       @["2799"],
    ord(Key.altD):       @["27100"],
    ord(Key.altE):       @["27101"],
    ord(Key.altF):       @["27102"],
    ord(Key.altG):       @["27103"],
    ord(Key.altH):       @["27104"],
    ord(Key.altI):       @["27105"],
    ord(Key.altJ):       @["27106"],
    ord(Key.altK):       @["27107"],
    ord(Key.altL):       @["27108"],
    ord(Key.altM):       @["27109"],
    ord(Key.altN):       @["27110"],
    ord(Key.altO):       @["27111"],
    ord(Key.altP):       @["27112"],
    ord(Key.altQ):       @["27113"],
    ord(Key.altR):       @["27114"],
    ord(Key.altS):       @["27115"],
    ord(Key.altT):       @["27116"],
    ord(Key.altU):       @["27117"],
    ord(Key.altV):       @["27118"],
    ord(Key.altW):       @["27119"],
    ord(Key.altX):       @["27120"],
    ord(Key.altY):       @["27121"],
    ord(Key.altZ):       @["27122"]



  }.toTable

type
  Car* {.pure.} = enum      
    # Special ASCII characters
    # code decimal unicode  except Cool 

    Cent          = (162, "¢"),
    Currency      = (164, "¤"),
    Yen           = (165, "¥"),
    PipeBroken    = (166,"¦"),
    Copyright     = (169, "©"),
    Left2Quot     = (171, "«"),
    Registered    = (174, "®"),
    Degree        = (176, "°"),
    Plusminus     = (177, "±"),
    Expo2         = (178, "²"),
    Expo3         = (179, "³"),
    AcuteAccent   = (180, "´"),
    Micro         = (181, "µ"),
    Expo1         = (185, "¹"),
    Right2Quot    = (187, "»"),
    Fraction14    = (188, "¼"),
    Fraction12    = (189, "½"),
    Fraction34    = (190, "¾"),

    COmega        = (937, "Ω"),
    CAlpha        = (945, "α"),
    CDelta        = (948, "δ"),
    CEpsilon      = (949, "ε"),
    CLambda       = (955, "λ"),
    CPy           = (960, "π"),
    CPhi          = (966, "φ"),
    CPsy          = (968, "ψ"),
    
    CRho          = (1009, "ϱ"),



    Bullet        = (8226, "•"),
    Ellipsis      = (8230, "…"),
    Permille      = (8240, "‰"),
    Euro          = (8364, "€"),


    TradeMark     = (8482, "™"),

    Left          = (8592, "←"),
    Up            = (8593, "↑"),
    Right         = (8594 , "→"),
    Down          = (8595 , "↓"),
    LeftRight     = (8596, "↔"),
    UpDown        = (8597, "↕"),

    Round         = (8771, "≃"),
    PlusLE        = (8804, "≤"),
    PlusGE        = (8805, "≥"),

    Ombre0        = (9617, "░"),
    Ombre1        = (9618, "▒"),
    Ombre2        = (9619, "▓"),

    UpBlack       = (9650, "▲"),
    RightBlack    = (9658, "►"),
    DownBlack     = (9660, "▼"),
    LeftBlack     = (9668, "◄"),


    Xtrue         = (9673, "◉"),
    Xfalse        = (9678, "◎"),


    Bad           = (9785, "☹️"),
    Cool          = (9786, "😊"),  # no reference

    Femele        = (9792, "♀"),
    Male          = (9794, "♂"),

    
    Pique         = (9824, "♠"),
    Trefle        = (9827, "♣"),
    Coeur         = (9829, "♥"),
    Carreau       = (9830, "♦"),

    Audio         = (9835, "♫")





# surely a 30 char buffer is more than enough; the longest
# keycode sequence I've seen was 6 chars
const KeySequenceMaxLen = 30



#======================================================
# Thank you johnnovak for Mouse
# Event Mouse 
# https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates
#======================================================


const
  CSI = 0x1B.chr & 0x5B.chr
  EnableMouse = fmt"{CSI}?1000;1005;1006h"
  DisableMouse = fmt"{CSI}?1000;;1005;1006l"

type
  MouseButtonAction*{.pure.} = enum
    mbaNone, mbaPressed, mbaReleased
  MouseInfo* = object
    x*: int ## x mouse position
    y*: int ## y mouse position
    button*: MouseButton ## which button was pressed
    action*: MouseButtonAction ## if button was released or pressed
    ctrl*: bool ## was ctrl was down on event
    shift*: bool ## was shift was down on event
    scroll*: bool ## if this is a mouse scroll
    scrollDir*: ScrollDirection
    move*: bool ## if this a mouse move
  MouseButton* {.pure.} = enum
    mbNone, mbLeft, mbMiddle, mbRight
  ScrollDirection* {.pure.} = enum
    sdNone, sdUp, sdDown

var gMouseInfo = MouseInfo()


proc getPos(inp: seq[int]): int =
  var str = ""
  for ch in inp:
    str &= $(ch.chr)
  result = parseInt(str)

proc splitInputs(inp: openarray[int], max: Natural): seq[seq[int]] =
  ## splits the input buffer to extract mouse coordinates
  var parts: seq[seq[int]] = @[]
  var cur: seq[int] = @[]
  for ch in inp[CSI.len+1 .. max-1]:
    if ch == ord('M'):
      # Button press
      parts.add(cur)
      gMouseInfo.action = mbaPressed
      break
    elif ch == ord('m'):
      # Button release
      parts.add(cur)
      gMouseInfo.action = mbaReleased
      break
    elif ch != ord(';'):
      cur.add(ch)
    else:
      parts.add(cur)
      cur = @[]
  return parts

proc eventMouseInfo(keyBuf: array[KeySequenceMaxLen, int]) =
  let parts = splitInputs(keyBuf, keyBuf.len)
  gMouseInfo.y = parts[1].getPos()
  gMouseInfo.x = parts[2].getPos() 
  let bitset = parts[0].getPos()
  gMouseInfo.ctrl = bitset.testBit(4)
  gMouseInfo.shift = bitset.testBit(2)
  gMouseInfo.move = bitset.testBit(5)
  case ((bitset.uint8 shl 6) shr 6).int
  of 0: gMouseInfo.button = MouseButton.mbLeft
  of 1: gMouseInfo.button = MouseButton.mbMiddle
  of 2: gMouseInfo.button = MouseButton.mbRight
  else:
    gMouseInfo.action = MouseButtonAction.mbaNone
    gMouseInfo.button = MouseButton.mbNone # Move sends 3, but we ignore
  gMouseInfo.scroll = bitset.testBit(6)
  if gMouseInfo.scroll:
    # on scroll button=3 is reported, but we want no button pressed
    gMouseInfo.button = MouseButton.mbNone
    if bitset.testBit(0): gMouseInfo.scrollDir = ScrollDirection.sdDown
    else: gMouseInfo.scrollDir = ScrollDirection.sdUp
  else:
    gMouseInfo.scrollDir = ScrollDirection.sdNone








#======================================================
# open Terminal Linux noblook non ctrl-c ....
# Thank you base https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50
#======================================================

## Modification of the terminal for keyboard reading without stdou.write
let fd = getFileHandle(stdin)
var oldMode: Termios
var Screen :bool = false


# no crtl-c active
proc openRAW(fd: FileHandle, time: cint = TCSAFLUSH) =
  if Screen == true : return
  var mode: Termios
  discard fd.tcGetAttr(addr oldMode)
  discard fd.tcGetAttr(addr mode)
  mode.c_iflag = mode.c_iflag and not Cflag(BRKINT or ICRNL or INPCK or
    ISTRIP or IXON)
  mode.c_oflag = mode.c_oflag and not Cflag(OPOST)
  mode.c_cflag = (mode.c_cflag and not Cflag(CSIZE or PARENB)) or CS8
  mode.c_lflag = mode.c_lflag and not Cflag(ECHO or ICANON or IEXTEN or ISIG)
  mode.c_cc[VMIN] = 0.cuchar
  mode.c_cc[VTIME] = 0.cuchar
  discard fd.tcSetAttr(time, addr mode)







proc TitleScreen*( title :string)=
  if title != "" :
    const CSIstart = 0x1b.chr & "]" & "0" & ";"
    const CSIend   = 0x07.chr
    stdout.write(fmt"{CSIstart}{title}{CSIend}")


# if use resize  ok : vte application terminal ex TermVte or
# change
# sudo thunar /etc/X11/app-defaults/XTerm  
# *allowWindowOps: true
# *eightBitInput: false

proc ResizeScreen*(line ,cols : Natural;) =
    if line > int(0) and cols > int(0) :
      stdout.write(fmt"{CSI}8;{line};{cols};t")

proc InitScreen*(line ,cols : Natural; title : string ="") =
  if Screen == false :
    fd.openRAW()
    ResizeScreen(line,cols)
    TitleScreen(title)
    Screen = true

proc InitScreen*() =
  if Screen == false :
    fd.openRAW()
    Screen = true

## restor terminal 
proc CloseScren*() =
  discard fd.tcSetAttr(TCSADRAIN, addr oldMode)
  quit(0)







proc getCursor*(line : var Natural ;cols : var Natural ) =
  var cursBuf: array[13,char]
  var i = 0
  line = 0
  cols = 0

  var seq2 = ""
  var seqx = ""
  var seqn = ""

  stdin.flushFile
  stdout.write(fmt"{CSI}?6n")
  stdout.flushFile
  ## read cursor
  while true  :
    var ncar = read(0, cursBuf.addr, 13)
    if ncar == 0 and i > 0 : break
    if ncar > 0 : 
      i += 1


  seq2 &= char(cursBuf[2])
 
  if "?" == seq2 :
    i = 3
    while i < 14:
      seqx =""
      seqx &= char(cursBuf[i])

      if i == 13 : break
      if seqx != ";" :
        seqn &= char(cursBuf[i])
      elif seqx ==  ";" and  line  == 0 :
        line = parseInt(seqn)
        seqn =""
      elif seqx ==  ";" and line > 0 and cols == 0:
        cols = parseInt(seqn)
        break
      inc(i)





#======================================================
# Event Keyboard
#======================================================

# global keycode buffer
var keyBuf: array[KeySequenceMaxLen,int]

func toKey(c: int): Key =
  if c > int(31) and c < int(127) : 
    return Key.Char

  elif c > int(127) and c < int(256) : 
    return Key.Char

  result = Key(c)

#======================================================
 # Parse Keyboard ASCII 255 
# include Mouse
#======================================================
type 
  Ckey = object 
    Chr : string


proc parseKey(charsRead: int): (Key , Ckey.Chr) =
  var inputSeq = ""
  var key = Key.Char

  if charsRead == 1:
    let ch = keyBuf[0]
    case ch:
    of   9: key = Key.Tab
    of  10: key = Key.Enter
    of  27: key = Key.Escape
    of 127: key = Key.Backspace
    of 0, 29, 30, 31: discard   
    else:
      key = toKey(ch)
      if key == Key.Char : 
        inputSeq &= char(keyBuf[0])
    return (key,inputSeq)

  if keyBuf[0] == 27 and charsRead == 2 :
    inputSeq &= "27"
    inputSeq &= $keyBuf[1]
    for keyCode, sequences in keySequences.pairs:
      for s in sequences:
        if s == inputSeq:
          key = toKey(keyCode)
          inputSeq =""
          break
    if key == Char : key = Key.None
    return (key,"")

  elif charsRead > 3 and keyBuf[0] == 27 and keyBuf[1] == 91 and keyBuf[2] == 60: # TODO what are these :)
      eventMouseInfo(keyBuf)
      return (Key.Mouse,"")

  elif charsRead == 3 and keyBuf[0] == 27 and keyBuf[1] == 91 and keyBuf[2] == 90: # TODO what are these :)
      return (Key.Stab,"")
  
  for i in 0..<charsRead:
    inputSeq &= char(keyBuf[i])

  for keyCode, sequences in keySequences.pairs:
    for s in sequences:
      if s == inputSeq:
        key = toKey(keyCode)
        inputSeq =""
        break
  if key == Key.None : key = Key.Char
  return (key,inputSeq)



#======================================================
# Keyboard Linux 
#======================================================

## get the keyboard keys from the terminal
proc getKey*() : (Key , Ckey.Chr) =
  while true :
    stdin.flushFile
    ## clean buffer
    var i = 0
    for u in 0..<KeySequenceMaxLen:
      keyBuf[u] = 0

    ## Read a mutlicaractère character from the terminal, noblocking until it is entered.
    ## read keyboard or Mouse
    while true  :
      var ncar = read(0, keyBuf[i].addr, 1)
      if ncar == 0 and i > 0 : break
      if ncar > 0 : i += 1
    ## decrypt Data
    let (key, chr) = parseKey(i)
    if key != Key.None : return (key, chr)

## get the keyboard keys from the terminal
proc getFunc*() : (Key) =
  while true :
    stdin.flushFile
    ## clean buffer
    var i = 0
    for u in 0..<KeySequenceMaxLen:
      keyBuf[u] = 0

    ## Read a mutlicaractère character from the terminal, noblocking until it is entered.
    ## read keyboard or Mouse
    while true  :
      var ncar = read(0, keyBuf[i].addr, 1)
      if ncar == 0 and i > 0 : break
      if ncar > 0 : i += 1
    ## decrypt Data
    let (key, chr) = parseKey(i)
    if key != Key.None and key != Key.Char  : return (key)

proc gotoXY*(line: Natural ; cols : Natural) =
  stdout.write(fmt"{CSI}{line};{cols}H")
  stdout.flushFile

proc OnMouse*() =
  stdout.write(EnableMouse)
  stdout.flushFile


proc OffMouse*() =
  stdout.write(DisableMouse)
  stdout.flushFile


proc getMouse*(): MouseInfo =
  return gMouseInfo


proc onScroll*(line , linePage: Natural) : bool =

  if line == 0 or linePage == 0 : return false
  
  var page : Natural  =  line + linePage - 1
  stdout.write(fmt"{CSI}{line};{page}r")
  stdout.flushFile
  return true



proc offScroll*():bool =
  stdout.write(fmt"{CSI}r")
  stdout.flushFile
  return false

proc Upscrool*(line : Natural) =
  stdout.write(fmt"{CSI}{line}S")
  stdout.flushFile

proc Downscrool*(line : Natural) =
  stdout.write(fmt"{CSI}{line}T")
  stdout.flushFile
