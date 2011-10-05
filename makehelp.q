/ create a helpfile from a directory of *.txt files
t:-1"kdb+makehelp 0.02 2006.08.17"
o:.Q.opt .z.x;if[2>count .Q.x;-2">q ",(string .z.f)," SRCDIR SAVEFILE";exit 1]
SRC:.z.x 0;SAVEFILE:hsym`$.z.x 1
F:key hsym`$SRC;F:asc F where(lower F)like "*.txt"
if[not count F; -1"? no *.txt files found in <",SRC,">"; exit 1]
t:@[hdel;SAVEFILE;{}]
\c 9999 9999
SAVEH:neg hopen SAVEFILE
t:SAVEH"/ help.q ",string .z.z;t:SAVEH"\\d .help";t:SAVEH"DIR:TXT:()!()"
t:SAVEH"display:{if[not 10h=abs type x;x:string x];$[1=count i:where(key DIR)like x,\"*\";-1 each TXT[(key DIR)[i]];show DIR];}"
t:SAVEH"fetch:{if[not 10h=abs type x;x:string x];$[1=count i:where(key DIR)like x,\"*\";1_raze\"\\n\",'TXT[(key DIR)[first i]];DIR]}"
helptext:{txt:read0 hsym`$SRC,"/",string x;
	SAVEH"TXT,:(enlist`",(name:lower string` sv -1_` vs x),")!enlist(";
	{SAVEH" ",(-3!x),";"}each 1_-1_ txt;
	{SAVEH" ",-3!x}last txt;SAVEH" )";
    SAVEH"DIR,:(enlist`",name,")!enlist`$",-3!first txt;
    }
t:helptext each F
t:SAVEH".q.help:.help.display"
t:-1"* helpfile <",(1_ string SAVEFILE),"> built from *.txt files in <",SRC,">"
\\
format of a help textfile is:
one line description of help
help texts (make sure no trailing empty lines)
filename (without .txt) is key for the help 	
