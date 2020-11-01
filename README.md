# nim_termkey
gestion terminal keyboard and mouse resize ...

doc : [TERMKEY](http://htmlpreview.github.io/?https://github.com/AS400JPLPC/nim_termkey/blob/master/htmldocs/termkey.html)

**A library to manage the keyboard on a terminal, the mouse, with a set of functions to initialize as we must do when we talk with the terminal example for applications of the curse type.**<br />
&rarr;&nbsp;It's in pure Nim and UTF8<br />
&rarr;&nbsp;some keys not coming from the keyboard are introduced such that ATTN PROC CALL allows in certain situations to simulate programs or functions.<br />
&rarr;&nbsp;all the characters remain consistent with the management of a terminal on Linux<br />
&rarr;&nbsp;mouse management is subject to Xterm Ncurses compliance<br />
&rarr;&nbsp;Your table of unusual characters conforms to the standard of the possibilities of an extended keyboard<br />
&rarr;&nbsp;I decided not to introduce management on Windows and prefer to have 2 separate libraries, there are too many differences.<br />


**Linux**

**nim pure**

gestion Mouse

gestion full keyboard

<u>Keyboard management and respect for the terminal philosophy</u><br />

&rarr;&nbsp; UTF8
the function keys being common to keyboards
the character keys are UTF8  

&rarr;&nbsp;use in conjunction with a libvte program, you can easily resize / change title as you see fit.  

&rarr;&nbsp;for Xterm  
sudo mousepad /etc/X11/app-defaults/XTerm  
* allowWindowOps: true
* eightBitInput: false


If you use the VteTERM project you will have even more possibilities than xterm



&rarr;&nbsp;***function***:  
&ndash;&nbsp; crtlA..Z  
&ndash;&nbsp; altA..Z
&ndash;&nbsp; F1..F24
&ndash;&nbsp; tab ... inser&nbsp;delete&nbsp;home&nbsp;end&nbsp;page&nbsp;up&nbsp;down&nbsp;left&nbsp;rigth&nbsp;esc  
&ndash;&nbsp; other&nbsp;full&nbsp;char  
&rarr;&nbsp;Special function
&ndash;&nbsp; scrolling area with page before or page after  
&ndash;&nbsp; in my experience, switching on the automation managed by escape mode does nothing good except the possibility of manually scrolling by program in a specific area the test will show you.    

&ndash;&nbsp; Keyboard simulation done by the program and not by the keyboard

&ndash;&nbsp; ATTN keyboard simulation&nbsp;&nbsp;&rarr;Passes program name to application server

&ndash;&nbsp; PROC keyboard simulation&nbsp;&nbsp;&rarr;Transmits the name of the procedure to be executed in Internal

&ndash;&nbsp; CALL keyboard simulation&nbsp;&nbsp;&rarr;Transmits the name of the procedure to be executed in External

&ndash;&nbsp;(key,chr ) = getKey()
&ndash;&nbsp;(key) = getFunc()

*I would like to thank*

* [https://github.com/johnnovak/illwill](https://github.com/johnnovak/illwill)
* [https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50](https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50)
* [https://en.wikipedia.org/wiki/Windows-1252](https://en.wikipedia.org/wiki/Windows-1252) and Other
* [https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates)
* [http://www.sweger.com/ansiplus/EscSeqScroll.html](http://www.sweger.com/ansiplus/EscSeqScroll.html)  
* [https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange](https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange)<BR />


USE DEMO termvte  your terminal   $HOME/..../termvte $HOME/..../keyboard  <BR />
  
for test import termcurs   non stable juste download <BR />




* Provision of special characters    


i did this to work with nim to understand some subtlety  


**Update**
&rarr;&nbsp; 2020-04-16   add  proc (key) = getFunc()  read touche  omit key.Char 

&rarr;&nbsp; 2020-04-18   correctif line 572   if key == Key.None : key = Key.Char

&rarr;&nbsp; 2020-04-20   correctif Key/Car change: enum  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * to respect enum:adding the table with a functional suite  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Car = Facilitates special character display  

&rarr;&nbsp; 2020-06-20   additif Key.ATTN&nbsp;Key.PROC&nbsp;Key.CALL&nbsp;&nbsp;&nbsp; Keyboard simulation done by the program and not by the keyboard

&rarr;&nbsp; 2020-06-02   proc (key) = getFunc(curs : bool = false)&nbsp;&nbsp;&nbsp;improves function

&rarr;&nbsp; 2020-06-24   correctif Mouse I solved the problem : scratching  

&rarr;&nbsp; 2020-06-26   Addition hide show cursor, only for harmonization and other module & mouse  

&rarr;&nbsp; 2020-08-26   correctif change: special character conformité and terminal and UTF8   

&rarr;&nbsp; 2020-11-01   correctif change: Key -> TKey getKey -> getTkey  ( nim posix use key)
)
&rarr;&nbsp; 2020-11-01   correctif change: fdTerm = fd +1  ( if using posix ex (mq_open) posix initializes fd 0) 

.  

.  

.  


***Proc***

proc titleScreen(title: string) {...}

proc resizeScreen(line, cols: Natural) {...}

proc initScreen(line, cols: Natural; title: string = "") {...}

proc initScreen() {...}

proc closeScren() {...}

proc offCursor() {...}

proc onCursor() {...}

proc getCursor(line: var Natural; cols: var Natural) {...}

proc getTKey(): (Key, Ckey.Chr) {...}

proc getFunc(curs: bool = false): (Key) {...}

proc gotoXY(line: Natural; cols: Natural) {...}

proc onMouse() {...}

proc offMouse() {...}

proc getMouse(): MouseInfo {...}

proc onScroll(line, linePage: Natural): bool {...}

proc offScroll(): bool {...}

proc upScrool(line: Natural) {...}

proc downScrool(line: Natural) {...}
