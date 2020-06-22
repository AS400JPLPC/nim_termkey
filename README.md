# nim_termkey
gestion terminal keyboard and mouse resize ...

doc : [TERMKEY](http://htmlpreview.github.io/?https://github.com/AS400JPLPC/nim_termkey/blob/master/termkey.html)

**Linux**

**nim pure**

gestion Mouse

gestion full keyboard

<u>Keyboard management and respect for the terminal philosophy</u>

&rarr;&nbsp; UTF8
the function keys being common to keyboards
the character keys are UTF8  

&rarr;&nbsp;use in conjunction with a tvte program, you can easily resize / change title as you see fit.  

&rarr;&nbsp;for Xterm  
sudo mousepad /etc/X11/app-defaults/XTerm  
* allowWindowOps: true
* eightBitInput: false

&rarr;&nbsp;function:  
* crtlA..Z  
* altA..Z
* F1..F24
* tab ... inser&nbsp;delete&nbsp;home&nbsp;end&nbsp;page&nbsp;up&nbsp;down&nbsp;left&nbsp;rigth&nbsp;esc  
* other&nbsp;full&nbsp;char  
* Special function
scrolling area with page before or page after  
in my experience, switching on the automation managed by escape mode does nothing good except the possibility of manually scrolling by program in a specific area the test will show you.    
* ATTN PROC CALL  
Keyboard simulation done by the program and not by the keyboard

&rarr;&nbsp; ATTN keyboard simulation&nbsp;&nbsp;&rarr;Passes program name to application server

&rarr;&nbsp; PROC keyboard simulation&nbsp;&nbsp;&rarr;Transmits the name of the procedure to be executed in Internal

&rarr;&nbsp; CALL keyboard simulation&nbsp;&nbsp;&rarr;Transmits the name of the procedure to be executed in External


&rarr;&nbsp;(key,chr ) = getKey()
&rarr;&nbsp;(key) = getFunc()

*I would like to thank*

* [https://github.com/johnnovak/illwill](https://github.com/johnnovak/illwill)
* [https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50](https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50)
* [https://en.wikipedia.org/wiki/Windows-1252](https://en.wikipedia.org/wiki/Windows-1252) and Other
* [https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates)
* [http://www.sweger.com/ansiplus/EscSeqScroll.html](http://www.sweger.com/ansiplus/EscSeqScroll.html)  
* [https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange](https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange)



* Provision of special characters    


i did this to work with nim to understand some subtlety  


**Update**
&rarr;&nbsp; 2020-04-16   add  proc (key) = getFunc()  read touche  omit key.Char 

&rarr;&nbsp; 2020-04-18   correctif line 572   if key == Key.None : key = Key.Char

&rarr;&nbsp; 2020-04-20   correctif Key/Car change: enum  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * to respect enum:adding the table with a functional suite  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Car = Facilitates special character display  

&rarr;&nbsp; 2020-04-24   correctif Key.F2 =F2 (error script) 

&rarr;&nbsp; 2020-06-20   additif Key.ATTN&nbsp;Key.PROC&nbsp;Key.CALL&nbsp;&nbsp;&nbsp; Keyboard simulation done by the program and not by the keyboard

&rarr;&nbsp; 2020-06-02   proc (key) = getFunc(curs : bool = false)&nbsp;&nbsp;&nbsp;improves function

&rarr;&nbsp; 2020-06-24   correctif Mouse I solved the problem : scratching  

&rarr;&nbsp; 2020-06-26   Addition hide show cursor, only for harmonization and other module & mouse  

.  

.  

.  


Procs

proc titleScreen(title: string) {...}

proc resizeScreen(line, cols: Natural) {...}

proc initScreen(line, cols: Natural; title: string = "") {...}

proc initScreen() {...}

proc closeScren() {...}

proc offCursor() {...}

proc onCursor() {...}

proc getCursor(line: var Natural; cols: var Natural) {...}

proc getKey(): (Key, Ckey.Chr) {...}

proc getFunc(curs: bool = false): (Key) {...}

proc gotoXY(line: Natural; cols: Natural) {...}

proc onMouse() {...}

proc offMouse() {...}

proc getMouse(): MouseInfo {...}

proc onScroll(line, linePage: Natural): bool {...}

proc offScroll(): bool {...}

proc upScrool(line: Natural) {...}

proc downScrool(line: Natural) {...}