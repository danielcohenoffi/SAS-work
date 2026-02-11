data use;
input days tx id;
cards;
4.5 1 1
3.8 1 2
6.4 1 3
7.1 1 4
8.9 1 5
28.4 2 1
24.2 2 2
29.5 2 2
25.2 2 4
28.1 2 5
19.1 3 1
19.3 3 1
22.3 3 3
20.2 3 4
21.8 3 5
;
run;

proc sort data=use;
by tx;
quit;


proc univariate data=use normal;
by tx;
var days;
quit;



proc glm data=use;
class tx;
model days=tx;
means tx/hovtest;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=use;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'TX') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Days')  value=(h=3.5 f=swissb) minor=none   ;
PLOT days*tx/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;




        *****Residual versus Factor***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=info;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'TX') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*tx/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;


proc glm data=use;
class tx;
model days=tx;
means tx/hovtest;
lsmeans tx/tdiff pdiff  cl;

output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;


proc npar1way data= use;
class tx;
var days;
quit;
