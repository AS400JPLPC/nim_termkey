#======================================================
#	work get-keyboard and Mouse 
#		Linux
#
# Inspiration johnnovak/illwill and JPLAS400PC C++
# retrieve keyboard UTF8
#======================================================


import  posix, termios , termios , bitops
import  tables, terminal
import  strformat, strutils

type
  TKey* {.pure.} = enum
      None   = "None", Char ="Char",
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

      F1  = "F1", F2   = "F2", F3  = "F3",   F4 = "F4",  F5  = "F5",
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

      ATTN = "ATTN",
      CALL = "CALL",
      PROC = "PROC"

# attn appel serveur externe d'application 
# call appel application extern
# proc appel fonction proc interne

const intListKey: array[TKey, int] = [-1,0,
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
    127,
    1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,
    1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,
    2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,
    5000,7001,7002,7003]

let
  keySequences = {
    intListKey[TKey.Up]:        @["\eOA", "\e[A"],
    intListKey[TKey.Down]:      @["\eOB", "\e[B"],
    intListKey[TKey.Right]:     @["\eOC", "\e[C"],
    intListKey[TKey.Left]:      @["\eOD", "\e[D"],

    intListKey[TKey.Home]:      @["\e[1~", "\e[7~", "\eOH", "\e[H"],
    intListKey[TKey.Insert]:    @["\e[2~"],
    intListKey[TKey.Delete]:    @["\e[3~"],
    intListKey[TKey.End]:       @["\e[4~", "\e[8~", "\eOF", "\e[F"],
    intListKey[TKey.PageUp]:    @["\e[5~"],
    intListKey[TKey.PageDown]:  @["\e[6~"],

    intListKey[TKey.F1]:        @["\e[11~", "\eOP"],
    intListKey[TKey.F2]:        @["\e[12~", "\eOQ"],
    intListKey[TKey.F3]:        @["\e[13~", "\eOR"],
    intListKey[TKey.F4]:        @["\e[14~", "\eOS"],
    intListKey[TKey.F5]:        @["\e[15~"],
    intListKey[TKey.F6]:        @["\e[17~"],
    intListKey[TKey.F7]:        @["\e[18~"],
    intListKey[TKey.F8]:        @["\e[19~"],
    intListKey[TKey.F9]:        @["\e[20~"],
    intListKey[TKey.F10]:       @["\e[21~"],
    intListKey[TKey.F11]:       @["\e[23~"],
    intListKey[TKey.F12]:       @["\e[24~"],
    intListKey[TKey.F13]:       @["\e[1;2P"],
    intListKey[TKey.F14]:       @["\e[1;2Q"],
    intListKey[TKey.F15]:       @["\e[1;2R"],
    intListKey[TKey.F16]:       @["\e[1;2S"],
    intListKey[TKey.F17]:       @["\e[15;2~"],
    intListKey[TKey.F18]:       @["\e[17;2~"],
    intListKey[TKey.F19]:       @["\e[18;2~"],
    intListKey[TKey.F20]:       @["\e[19;2~"],
    intListKey[TKey.F21]:       @["\e[20;2~"],
    intListKey[TKey.F22]:       @["\e[21;2~"],
    intListKey[TKey.F23]:       @["\e[23;2~"],
    intListKey[TKey.F24]:       @["\e[24;2~"],

    intListKey[TKey.STab]:      @["[279190"],

    intListKey[TKey.altA]:       @["2797"],
    intListKey[TKey.altB]:       @["2798"],
    intListKey[TKey.altC]:       @["2799"],
    intListKey[TKey.altD]:       @["27100"],
    intListKey[TKey.altE]:       @["27101"],
    intListKey[TKey.altF]:       @["27102"],
    intListKey[TKey.altG]:       @["27103"],
    intListKey[TKey.altH]:       @["27104"],
    intListKey[TKey.altI]:       @["27105"],
    intListKey[TKey.altJ]:       @["27106"],
    intListKey[TKey.altK]:       @["27107"],
    intListKey[TKey.altL]:       @["27108"],
    intListKey[TKey.altM]:       @["27109"],
    intListKey[TKey.altN]:       @["27110"],
    intListKey[TKey.altO]:       @["27111"],
    intListKey[TKey.altP]:       @["27112"],
    intListKey[TKey.altQ]:       @["27113"],
    intListKey[TKey.altR]:       @["27114"],
    intListKey[TKey.altS]:       @["27115"],
    intListKey[TKey.altT]:       @["27116"],
    intListKey[TKey.altU]:       @["27117"],
    intListKey[TKey.altV]:       @["27118"],
    intListKey[TKey.altW]:       @["27119"],
    intListKey[TKey.altX]:       @["27120"],
    intListKey[TKey.altY]:       @["27121"],
    intListKey[TKey.altZ]:       @["27122"]



  }.toTable


type
  Car* {.pure.} = enum      
    # Special ASCII characters
    # code decimal unicode  except Cool 

    Cent          = "¢", # 162
    Currency      = "¤", # 164
    Yen           = "¥", # 165
    PipeBroken    = "¦", # 166
    Copyright     = "©", # 169
    Left2Quot     = "«", # 171
    Registered    = "®", # 174
    Degree        = "°", # 176
    Plusminus     = "±", # 177
    Expo2         = "²", # 178
    Expo3         = "³", # 179
    AcuteAccent   = "´", # 180
    Micro         = "µ", # 181
    Expo1         = "¹", # 182
    Right2Quot    = "»", # 183
    Fraction14    = "¼", # 184
    Fraction12    = "½", # 185
    Fraction34    = "¾", # 190

    COmega        = "Ω", # 937
    CAlpha        = "α", # 945
    CDelta        = "δ", # 948
    CEpsilon      = "ε", # 949
    CLambda       = "λ", # 955
    CPy           = "π", # 960
    CPhi          = "φ", # 966
    CPsy          = "ψ", # 968
    
    CRho          = "ϱ", # 1009

    Bullet        = "•", # 8226
    Ellipsis      = "…", # 8230
    Permille      = "‰", # 8240
    Euro          = "€", # 8264

    TradeMark     = "™", # 8482
    Left          = "←", # 8492
    Up            = "↑", # 8493
    Right         = "→", # 8494
    Down          = "↓", # 8495
    LeftRight     = "↔", # 8496
    UpDown        = "↕", # 8497

    Round         = "≃", # 8771
    PlusLE        = "≤", # 8804
    PlusGE        = "≥", # 8805

    Ombre0        = "░", # 9617
    Ombre1        = "▒", # 9618
    Ombre2        = "▓", # 9619

    UpBlack       = "▲", # 9650
    RightBlack    = "►", # 9658
    DownBlack     = "▼", # 9660
    LeftBlack     = "◄", # 9668

    Xtrue         = "◉", # 9673
    Xfalse        = "◎", # 9678

    Femele        = "♀", # 9792
    Male          = "♂", # 9794

    
    Pique         = "♠", # 9824
    Trefle        = "♣", # 9827
    Coeur         = "♥", # 9829
    Carreau       = "♦", # 9830

    Audio         = "♫"  # 9835



# surely a 30 char buffer is more than enough; the longest
# keycode sequence I've seen was 6 chars
# very problème buffer expand occurs tihs value 800 is correct 99%
const KeySequenceMaxLen = 800



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

## Modification of the terminal for keyboard reading without stdout.write
## duplicate fd is use Posix default fd = 0


var fd :cint  = getFileHandle(stdin)
var oldMode: Termios
var Screen :bool = false
var fdTerm :cint = fd + 1

proc openRAW(fd: FileHandle, time: cint = TCSAFLUSH) =
  if Screen == true : return
  var mode: Termios
  discard fd.tcGetAttr(addr oldMode)

  discard dup2(fd,fdTerm)

  discard fdTerm.tcGetAttr(addr mode)
  mode.c_iflag = mode.c_iflag and not Cflag(BRKINT or ICRNL or INPCK or  ISTRIP or IXON)
  mode.c_oflag = mode.c_oflag and not Cflag(OPOST)
  mode.c_cflag = (mode.c_cflag and not Cflag(CSIZE or PARENB)) or CS8
  mode.c_lflag = mode.c_lflag and not Cflag(ECHO or ICANON or IEXTEN or ISIG)
  mode.c_cc[VMIN] = 0.cuchar
  mode.c_cc[VTIME] = 0.cuchar
  discard fd.tcSetAttr(time, addr mode)
  discard fdTerm.tcSetAttr(time, addr mode)





proc titleScreen*( title :string)=
  if title != "" :
    const CSIstart = 0x1b.chr & "]" & "0" & ";"
    const CSIend   = 0x07.chr
    stdout.write(fmt"{CSIstart}{title}{CSIend}")


# if use resize  ok : vte application terminal ex TermVte or
# change
# sudo thunar /etc/X11/app-defaults/XTerm  
# *allowWindowOps: true
# *eightBitInput: false

proc resizeScreen*(line ,cols : Natural;) =
    if line > int(0) and cols > int(0) :
      stdout.write(fmt"{CSI}8;{line};{cols};t")

proc initScreen*(line ,cols : Natural; title : string ="") =
  if Screen == false :
    fd.openRAW()
    resizeScreen(line,cols)
    titleScreen(title)
    Screen = true


proc initScreen*() =
  if Screen == false :
    fd.openRAW()
    Screen = true

# restor terminal 
proc closeScren*() =
  discard fd.tcSetAttr(TCSADRAIN, addr oldMode)
  quit(0)



proc offCursor*() = hideCursor()

proc onCursor*() = showCursor()


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
  #read cursor
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

proc toKey(c: int): TKey =
  if c > int(31) and c < int(127) : 
    return TKey.Char

  elif c > int(127) and c < int(256) : 
    return TKey.Char
  
  for i in low(intListkey)..high(intListkey):
    if c == intListKey[i] : 
      return TKey(i)

  result= TKey.None


  
#======================================================
 # Parse Keyboard ASCII 255 
# include Mouse
#======================================================
type 
  Ckey = object 
    Chr : string


proc parseKey(charsRead: int): (TKey , Ckey.Chr) =
  var inputSeq = ""
  var codekey = TKey.Char

  if charsRead == 1:
    let ch = keyBuf[0]
    case ch:
    of   9: codekey = TKey.Tab
    of  10: codekey = TKey.Enter
    of  27: codekey = TKey.Escape
    of 127: codekey = TKey.Backspace
    of 0, 29, 30, 31: discard   
    else:
      codekey = toKey(ch)
      if codekey == TKey.Char : 
        inputSeq &= char(keyBuf[0])
    return (codekey,inputSeq)

  if keyBuf[0] == 27 and charsRead == 2 :
    inputSeq &= "27"
    inputSeq &= $keyBuf[1]
    for keyCode, sequences in keySequences.pairs:
      for s in sequences:
        if s == inputSeq:
          codekey = toKey(keyCode)
          inputSeq =""
          break
    if codekey == Char : codekey = TKey.None
    return (codekey,"")

  elif charsRead > 3 and keyBuf[0] == 27 and keyBuf[1] == 91 and keyBuf[2] == 60: # TODO what are these :)
      eventMouseInfo(keyBuf)
      return (TKey.Mouse,"")

  elif charsRead == 3 and keyBuf[0] == 27 and keyBuf[1] == 91 and keyBuf[2] == 90: # TODO what are these :)
      return (TKey.Stab,"")
  
  for i in 0..<charsRead:
    inputSeq &= char(keyBuf[i])

  for keyCode, sequences in keySequences.pairs:
    for s in sequences:
      if s == inputSeq:
        codekey = toKey(keyCode)
        inputSeq =""
        break
  if codekey == TKey.None : codekey = TKey.Char
  return (codekey,inputSeq)

proc gotoXY*(line: Natural ; cols : Natural)

#======================================================
# Keyboard Linux 
#======================================================

## get the keyboard keys from the terminal
proc getTKey*() : (TKey , Ckey.Chr) =
  var codekey = TKey.None
  var chr : string
  
  while true :
    ## clean buffer
    var i = 0
    for u in 0..<KeySequenceMaxLen:
      keyBuf[u] = 0

    ## Read a mutlicaractère character from the terminal, noblocking until it is entered.
    ## read keyboard or Mouse
    stdin.flushFile
    while true  :
      var ncar = read(fdTerm, keyBuf[i].addr, 1)
      if ncar == 0 and i > 0 : break
      if ncar > 0 : i += 1
    ## decrypt Data
    (codekey, chr) = parseKey(i)
    if codekey != TKey.None : return (codekey, chr)

## get the keyboard keys from the terminal
proc getFunc*(curs : bool = false) : (TKey) =
  var codekey = TKey.None
  var chr : string
  while true :
    stdin.flushFile
    ## clean buffer
    var i = 0
    for u in 0..<KeySequenceMaxLen:
      keyBuf[u] = 0

    ## Read a mutlicaractère character from the terminal, noblocking until it is entered.
    ## read keyboard or Mouse
    while true  :
      if curs == false : hideCursor()
      var ncar = read(fdTerm, keyBuf[i].addr, 1)
      if ncar == 0 and i > 0 : break
      if ncar > 0 : i += 1
    ## decrypt Data
    (codekey, chr) = parseKey(i)
    if codekey != TKey.None and codekey != TKey.Char  : return (codekey)


proc gotoXY*(line: Natural ; cols : Natural) =
  stdout.write(fmt"{CSI}{line};{cols}H")
  stdout.flushFile

proc onMouse*() =
  stdout.write(EnableMouse)
  stdout.flushFile


proc offMouse*() =
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

proc upScrool*(line : Natural) =
  stdout.write(fmt"{CSI}{line}S")
  stdout.flushFile

proc downScrool*(line : Natural) =
  stdout.write(fmt"{CSI}{line}T")
  stdout.flushFile
