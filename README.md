# nim_termkey
gestion terminal keyboard and mouse resize ...


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


*I would like to thank*

* [https://github.com/johnnovak/illwill](URL)
* [https://github.com/nim-lang/Nim/blob/version-1-0/lib/pure/terminal.nim#L50](URL)
* [https://en.wikipedia.org/wiki/Windows-1252](URL) and Other
* [https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates](URL)
* [http://www.sweger.com/ansiplus/EscSeqScroll.html](URL)  
* [https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange](URL)



* Provision of special characters    


i did this to work with nim to understand some subtlety  










