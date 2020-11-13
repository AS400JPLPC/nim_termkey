# nim_termkey<br />

**terminal keyboard and mouse resize ...**<br />


doc : [TERMKEY](http://htmlpreview.github.io/?https://github.com/AS400JPLPC/nim_termkey/blob/master/htmldocs/termkey.html)<br />


**A library to manage the keyboard on a terminal, the mouse, with a set of functions to initialize as we must do when we talk with the terminal example for applications of the curse type.**<br /><br />
<br />

&rarr;&nbsp;It's in pure Nim and UTF8<br />
&rarr;&nbsp;some keys not coming from the keyboard are introduced such that ATTN PROC CALL allows in certain situations to simulate programs or functions.<br />
&rarr;&nbsp;all the characters remain consistent with the management of a terminal on Linux<br />
&rarr;&nbsp;mouse management is subject to Xterm Ncurses compliance<br />
&rarr;&nbsp;Your table of unusual characters conforms to the standard of the possibilities of an extended keyboard<br />
&rarr;&nbsp;I decided not to introduce management on Windows and prefer to have 2 separate libraries, there are too many differences.<br />
&rarr;&nbsp;Attribute management and display.<br />

**Linux**

**Affranhissement nim->Terminal

management Mouse

management full keyboard   read buffer / output screen

<u>Keyboard management and respect for the terminal philosophy</u><br />

&rarr;&nbsp; UTF8
the function keys being common to keyboards
the character keys are UTF8  

&rarr;&nbsp;for Xterm   **UBUNTU** <BR />
sudo mousepad /etc/X11/app-defaults/XTerm <BR />
* allowWindowOps: true <BR />
* eightBitInput: false <BR /><BR />

&rarr;&nbsp;Manjaro xfce4 not problème is terminal<BR /> 
&rarr;&nbsp;If you use the VteTERM/ nim_Termvte  project you will have even more possibilities than xterm<BR />



&rarr;&nbsp;***function***:<BR />
&ndash;&nbsp; crtlA..Z<BR />
&ndash;&nbsp; altA..Z<BR />
&ndash;&nbsp; F1..F24<BR />
&ndash;&nbsp; tab ... inser&nbsp;delete&nbsp;home&nbsp;end&nbsp;page&nbsp;up&nbsp;down&nbsp;left&nbsp;rigth&nbsp;esc<BR />
&ndash;&nbsp; other&nbsp;full&nbsp;char<BR />
&rarr;&nbsp;***Special function***<BR />
&ndash;&nbsp; scrolling area with page before or page after<BR />
&ndash;&nbsp; in my experience, switching on the automation managed by escape mode does nothing good except the possibility of manually scrolling by program in a specific area the test will show you.<BR />

&ndash;&nbsp; Keyboard simulation done by the program and not by the keyboard<BR />

&ndash;&nbsp; ATTN keyboard simulation&nbsp;&nbsp;&rarr;Passes program name to application server<BR />

&ndash;&nbsp; PROC keyboard simulation&nbsp;&nbsp;&rarr;Transmits the name of the procedure to be executed in Internal<BR />

&ndash;&nbsp; CALL keyboard simulation&nbsp;&nbsp;&rarr;Transmits the name of the procedure to be executed in External<BR />

&ndash;&nbsp;(key,chr ) = getKey()<BR />

&ndash;&nbsp;(key) = getFunc()<BR />

*I would like to thank*<BR />

* [https://github.com/johnnovak/illwill](https://github.com/johnnovak/illwill)<BR />
* [https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50](https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50)<BR />
* [https://en.wikipedia.org/wiki/Windows-1252](https://en.wikipedia.org/wiki/Windows-1252) and Other<BR />
* [https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates)<BR />
* [http://www.sweger.com/ansiplus/EscSeqScroll.html](http://www.sweger.com/ansiplus/EscSeqScroll.html)<BR />
* [https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange](https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange)<BR />


USE DEMO termvte  your terminal   $HOME/..../termvte $HOME/..../keyboard  <BR />
<BR />
USE DEMO ex: your terminal xfce4-terminal   $ ./keyboard <BR />




* Provision of special characters<BR />


i did this to work with nim to understand some subtlety<BR />


**Update**<BR />
&rarr;&nbsp; 2020-04-16   add  proc (key) = getFunc()  read touche  omit key.Char<BR />

&rarr;&nbsp; 2020-04-18   correctif line 572   if key == Key.None : key = Key.Char<BR />

&rarr;&nbsp; 2020-04-20   correctif Key/Car change: enum<BR />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * to respect enum:adding the table with a functional suite<BR />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Car = Facilitates special character display<BR />

&rarr;&nbsp; 2020-06-20   additif Key.ATTN&nbsp;Key.PROC&nbsp;Key.CALL&nbsp;&nbsp;&nbsp; Keyboard simulation done by the program and not by the keyboard<BR />

&rarr;&nbsp; 2020-06-02   proc (key) = getFunc(curs : bool = false)&nbsp;&nbsp;&nbsp;improves function<BR />

&rarr;&nbsp; 2020-06-24   correctif Mouse I solved the problem : scratching<BR />

&rarr;&nbsp; 2020-06-26   Addition hide show cursor, only for harmonization and other module & mouse<BR />

&rarr;&nbsp; 2020-08-26   correctif change: special character conformité and terminal and UTF8<BR />

&rarr;&nbsp; 2020-11-01   correctif change: Key -> TKey getKey -> getTkey  ( nim posix use key)<BR />

&rarr;&nbsp; 2020-11-01   correctif change: fdTerm = fd +1  ( if using posix  initializes fd 0)<BR />  

&rarr;&nbsp; 2020-11-05   correctif add : clsTerm clear Terminal <BR />  

&rarr;&nbsp; 2020-11-05   correctif change: initScreen (add clear terminal) <BR />  

&rarr;&nbsp; 2020-11-10   enfranchisement Nim:Terminal code cleanup operational with libvte or ex xfce-terminal<BR />  

&rarr;&nbsp; 2020-12-10   duplicate fd is use Posix default FD = 0->(STDIN)  the dup function gives the first free<BR />  
  


.<BR />

.<BR />

.<BR />

***Proc***.<BR />


proc defCursor(e_curs: typCursor = cnoBlink) {...}

    define type Cursor form terminal 

proc getCursor(line: var Natural; cols: var Natural) {...}

    get Cursor form terminal 

proc getTKey(): (TKey, Ckey.Chr) {...}

    get the keyboard keys from the terminal 

proc getFunc(curs: bool = false): (TKey) {...}

    get the keyboard keys from the terminal 

proc titleTerm(title: string) {...}

proc resizeTerm(line, cols: Natural) {...}

proc initTerm(line, cols: Natural; title: string = "") {...}

proc iniTerm() {...}

proc closeTerm() {...}

proc offCursor() {...}

proc onCursor() {...}

proc gotoXY(line: Natural; cols: Natural) {...}

proc gotoXPos(cols: int) {...}

    Sets the terminal's cursor to the x position. The y position is not changed. 

proc cursorUp(count = 1) {...}

    Moves the cursor up by count rows. 

proc cursorDown(count = 1) {...}

    Moves the cursor down by count rows. 

proc cursorForward(count = 1) {...}

    Moves the cursor forward by count columns. 

proc cursorBackward(count = 1) {...}

    Moves the cursor backward by count columns. 

proc onMouse() {...}

proc offMouse() {...}

proc getMouse(): MouseInfo {...}

proc onScroll(line, linePage: Natural): bool {...}

    on scrolling 

proc offScroll(): bool {...}

    off scrolling 

proc upScrool(line: Natural) {...}

    scrolling up 

proc downScrool(line: Natural) {...}

    scrolling down 

proc clsTerm() {...}

    Erases the entire terminal attribut and word 

proc resetAttributes() {...}

    Resets all attributes. 

proc eraseLineEnd() {...}

    Erases from the current cursor position to the end of the current line. 

proc eraseLineStart() {...}

    Erases from the current cursor position to the start of the current line. 

proc eraseDown() {...}

    Erases the screen from the current line down to the bottom of the screen. 

proc eraseUp() {...}

    Erases the screen from the current line up to the top of the screen. 

proc eraseLine() {...}

    Erases the entire current line. 

proc eraseTerm() {...}

    Erases the entire word. 

proc setStyle(style: set[Style]) {...}

    Sets the terminal style. 

proc writeStyled(txt: string; style: set[Style] = {styleBright}) {...}

    Writes the text txt in a given style to stdout. 

proc setForegroundColor(fg: ForegroundColor; bright = false) {...}

    Sets the terminal's foreground color. 

proc setBackgroundColor(bg: BackgroundColor; bright = false) {...}

    Sets the terminal's background color. 

proc terminalWidth(): int {...}

    Returns terminal width from first fd the ioctl. 

proc terminalHeight(): int {...}

    Returns terminal height from first fd the ioctl. 

<BR />
<BR />

**Made with Nim. Generated: 2020-11-11 12:58:03 UTC**
