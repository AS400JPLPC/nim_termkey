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
      None = "None", Char ="Char",
      CtrlA  = "CtrlA",
      CtrlB  = "CtrlB",
      CtrlC  = "CtrlC",
      CtrlD  = "CtrlD",
      CtrlE  = "CtrlE",
      CtrlF  = "CtrlF",
      CtrlG  = "CtrlG",
      CtrlH  = "CtrlH",
      Tab    = "Tab",     # Ctrl-I
      CtrlJ  = "CtrlJ",
      CtrlK  = "CtrlK",
      CtrlL  = "CtrlL",
      Enter  = "Enter",  # Ctrl-M
      CtrlN  = "CtrlN",
      CtrlO  = "CtrlO",
      CtrlP  = "CtrlP",
      CtrlQ  = "CtrlQ",
      CtrlR  = "CtrlR",
      CtrlS  = "CtrlS",
      CtrlT  = "CtrlT",
      CtrlU  = "CtrlU",
      CtrlV  = "CtrlV",
      CtrlW  = "CtrlW",
      CtrlX  = "CtrlX",
      CtrlY  = "CtrlY",
      CtrlZ  = "CtrlZ",
      Escape = "Escape",

      Backspace  = "Backspace",

      # Special characters with virtual keycodes
      Stab     = "Stab",
      Up       = "Up",
      Down     = "Down",
      Right    = "Right",
      Left     = "Left",
      Home     = "Home",
      Insert   = "Insert",
      Delete   = "Delete",
      End      = "End",
      PageUp   = "PageUp",
      PageDown = "PageDown",

      F1  = "F1", F2   = "F21", F3  = "F3",   F4 = "F4",  F5  = "F5",
      F6  = "F6", F7   = "F7",  F8  = "F8",   F9 = "F9",  F10 = "F10",
      F11 = "F11", F12 = "F12", F13 = "F13", F14 = "F14", F15 = "F15",
      F16 = "F16", F17 = "F17", F18 = "F18", F19 = "F19", F20 = "F20",
      F21 = "F21", F22 = "F22", F23 = "F23", F24 = "F24",

      altA  = "altA",
      altB  = "altB",
      altC  = "altC",
      altD  = "altD",
      altE  = "altD",
      altF  = "altF",
      altG  = "altG",
      altH  = "altH",
      altI  = "altI",
      altJ  = "altJ",
      altK  = "altK",
      altL  = "altL",
      altM  = "altM",
      altN  = "altN",
      altO  = "altO",
      altP  = "altP",
      altQ  = "altQ",
      altR  = "altR",
      altS  = "altS",
      altT  = "altT",
      altU  = "altU",
      altV  = "altV",
      altW  = "altW",
      altX  = "altX",
      altY  = "altY",
      altZ  = "altZ",

      Mouse = "Mouse"

const intListKey: array[Key, int] = [-1,0,
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
    127,
    1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,
    1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,
    2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,
    5000]

let
  keySequences = {
    intListKey[Key.Up]:        @["\eOA", "\e[A"],
    intListKey[Key.Down]:      @["\eOB", "\e[B"],
    intListKey[Key.Right]:     @["\eOC", "\e[C"],
    intListKey[Key.Left]:      @["\eOD", "\e[D"],

    intListKey[Key.Home]:      @["\e[1~", "\e[7~", "\eOH", "\e[H"],
    intListKey[Key.Insert]:    @["\e[2~"],
    intListKey[Key.Delete]:    @["\e[3~"],
    intListKey[Key.End]:       @["\e[4~", "\e[8~", "\eOF", "\e[F"],
    intListKey[Key.PageUp]:    @["\e[5~"],
    intListKey[Key.PageDown]:  @["\e[6~"],

    intListKey[Key.F1]:        @["\e[11~", "\eOP"],
    intListKey[Key.F2]:        @["\e[12~", "\eOQ"],
    intListKey[Key.F3]:        @["\e[13~", "\eOR"],
    intListKey[Key.F4]:        @["\e[14~", "\eOS"],
    intListKey[Key.F5]:        @["\e[15~"],
    intListKey[Key.F6]:        @["\e[17~"],
    intListKey[Key.F7]:        @["\e[18~"],
    intListKey[Key.F8]:        @["\e[19~"],
    intListKey[Key.F9]:        @["\e[20~"],
    intListKey[Key.F10]:       @["\e[21~"],
    intListKey[Key.F11]:       @["\e[23~"],
    intListKey[Key.F12]:       @["\e[24~"],
    intListKey[Key.F13]:       @["\e[1;2P"],
    intListKey[Key.F14]:       @["\e[1;2Q"],
    intListKey[Key.F15]:       @["\e[1;2R"],
    intListKey[Key.F16]:       @["\e[1;2S"],
    intListKey[Key.F17]:       @["\e[15;2~"],
    intListKey[Key.F18]:       @["\e[17;2~"],
    intListKey[Key.F19]:       @["\e[18;2~"],
    intListKey[Key.F20]:       @["\e[19;2~"],
    intListKey[Key.F21]:       @["\e[20;2~"],
    intListKey[Key.F22]:       @["\e[21;2~"],
    intListKey[Key.F23]:       @["\e[23;2~"],
    intListKey[Key.F24]:       @["\e[24;2~"],

    intListKey[Key.STab]:      @["[279190"],

    intListKey[Key.altA]:       @["2797"],
    intListKey[Key.altB]:       @["2798"],
    intListKey[Key.altC]:       @["2799"],
    intListKey[Key.altD]:       @["27100"],
    intListKey[Key.altE]:       @["27101"],
    intListKey[Key.altF]:       @["27102"],
    intListKey[Key.altG]:       @["27103"],
    intListKey[Key.altH]:       @["27104"],
    intListKey[Key.altI]:       @["27105"],
    intListKey[Key.altJ]:       @["27106"],
    intListKey[Key.altK]:       @["27107"],
    intListKey[Key.altL]:       @["27108"],
    intListKey[Key.altM]:       @["27109"],
    intListKey[Key.altN]:       @["27110"],
    intListKey[Key.altO]:       @["27111"],
    intListKey[Key.altP]:       @["27112"],
    intListKey[Key.altQ]:       @["27113"],
    intListKey[Key.altR]:       @["27114"],
    intListKey[Key.altS]:       @["27115"],
    intListKey[Key.altT]:       @["27116"],
    intListKey[Key.altU]:       @["27117"],
    intListKey[Key.altV]:       @["27118"],
    intListKey[Key.altW]:       @["27119"],
    intListKey[Key.altX]:       @["27120"],
    intListKey[Key.altY]:       @["27121"],
    intListKey[Key.altZ]:       @["27122"]



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

proc toKey(c: int): Key =
  if c > int(31) and c < int(127) : 
    return Key.Char

  elif c > int(127) and c < int(256) : 
    return Key.Char
  
  for i in low(intListkey)..high(intListkey):
    if c == intListKey[i] : 
      return Key(i)

  result= Key.None


  
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
