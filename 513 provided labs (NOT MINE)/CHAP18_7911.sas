


                *********BOX COX***;


   data fail;
input time location unit;
cards;
   4.41  1  1
  100.65  1  2
   14.45  1  3
   47.13  1  4
   85.21  1  5
    8.24  2  1
   81.16  2  2
    7.35  2  3
   12.29  2  4
    1.61  2  5
  106.19  3  1
   33.83  3  2
   78.88  3  3
  342.81  3  4
   44.33  3  5
      ;
run;




proc glm data=fail;
class location;
model time=location;
means location/hovtest;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;






        *****Residual versus Factor***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=info;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Location') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*location/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;


************Chapter 18 - Page 791*****;
data fail;
input time location unit;
cards;
4.41  1  1
  100.65  1  2
   14.45  1  3
   47.13  1  4
   85.21  1  5
    8.24  2  1
   81.16  2  2
    7.35  2  3
   12.29  2  4
    1.61  2  5
  106.19  3  1
   33.83  3  2
   78.88  3  3
  342.81  3  4
   44.33  3  5
      ;
run;






proc means data=fail maxdec=2 n mean std var clm;
class location;
var time;
   output out=Kinfo mean=avgtime std=sdtime var=vartime;
quit;


proc glm data=fail;
class location;
model time=location;
means location/hovtest;
output out=info1 r=resid p=phat student=stdres rstudent=jackres;
quit;

proc univariate data=info1 normal;
var resid;
quit;


proc sort data=info1;
by location;
quit;


proc univariate data=info1 normal;
by location;
var time resid;
quit;



                        ************log trasnform***;
data fail;
set fail;
ltime = log(time);
**** ltime = log(time+1);  ***Shifted Log if you have 0 outcome values*****;
*****ltime = log(time + shift) ;  ***Shifted Log if you have 0 outcome values*****;
                                                        ***Set shift to 0.01, 0.05, 0.1****;
run;


proc glm data=fail;
class location;
model ltime=location;
means location/hovtest;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;



proc univariate data=info normal;
var resid jackres;
title 'Looking at the Distribution of the Residuals: Shapiro-Wilk';
quit; title;


proc sort data=info;
by location;
quit;


proc univariate data=info normal;
by location;
var ltime;
title 'Looking at the Distribution of the Outcome within Level of the Factor: Shapiro-Wilk';
quit; title;









     ******LINE PLOT****;

proc means data=fail; var time; by location;
   output out=K2 mean=avgtime;
quit;

proc print data=K2;quit;

data K2;
set ;
intcpt = 1;
run;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none c=blue height=2.5;;
symbol2 v=circle i=none c=red height=2.5;;
symbol3 v=circle i=none c=green height=2.5;;
symbol4 v=circle i=none c=black height=2.5;;
proc gplot data=K2;
LEGEND1 VALUE=(f=swissb h=3.0) label = (f=swissb h=3.0);
AXIS1 LABEL = none value=none minor=none   ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none   ;
PLOT intcpt*avgtime=location/frame HAXIS=AXIS2 VAXIS=AXIS1 vref=1 legend=legend1;
                       ;
RUN;quit;




        ******SCATTER PLOT****;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=fail;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Location') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Time')  value=(h=3.5 f=swissb) minor=none   ;
PLOT time*location/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;


           *****BAR GRAPH with Error Bars*****;

goptions reset=global gunit=pct border cback=white rotate=landscape
         colors=(black blue green red) ftext=swiss
         ftitle=swissb htitle=5 htext=3.5 device=win;


axis1 label=('LOcation' ) ;
  axis2 label=('Rate' j=c
             'Error Bar Confidence Limits: 95%')
       minor=(number=1);
     pattern1 color=yellow;

proc gchart data=FAIL;
hbar LOCATION / type=MEAN sumvar=time   discrete
              freqlabel='Number per Location'
              meanlabel='Mean Time'
              errorbar=both
              clm=95                         maxis=axis1
noframe  raxis=axis2               ;
run; quit;





proc glm data=fail;
class location;
model time=location;
means location/hovtest;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;






        *****Residual versus Factor***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=info;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Location') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*location/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;


        *****NOMRAL PROBABILITY PLOT****;


proc rank data=info out=a3
     normal=blom;
   var resid;
   ranks zresid;
quit;

proc sort data=a3;
   by zresid;
quit;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;


symbol1 v=circle  height=2.5 i=sm70;
proc gplot data=a3;
   plot resid*zresid=1/frame HAXIS=AXIS1 VAXIS=AXIS2  ;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Normal Ranking') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
run;
quit;



        ****BAR GRAPH OF RESIDUALS VERSUS LEVELS****;





                  *****BAR GRAPH with Error Bars*****;

goptions reset=global gunit=pct border cback=white rotate=landscape
         colors=(black blue green red) ftext=swiss
         ftitle=swissb htitle=5 htext=3.5 device=win;


axis1 label=('Location' ) ;
  axis2 label=('Residual
' )
       minor=(number=1);


proc gchart data=info;
vbar LOCATION / type=MEAN sumvar=Resid   discrete
              errorbar=both
              clm=95                         maxis=axis1
noframe  raxis=axis2               ;
run; quit;






 proc sort data=info;
by location;
quit;



        *****Residual versus UNITS***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=join height=2.5;;
proc gplot data=info;
by location;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'UNIT') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*UNIT=1/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;

                ******Let formally assess the Autocorrelation with DW test*****;


proc sort data=info;
by location;
quit;


proc reg data=info;
by location;
model time=unit / dw dwprob;
quit;




        ****OUTLIERRS*****;



proc univariate data=info normal;
var resid jackres;
title 'Looking at the Distribution of the Residuals: Shapiro-Wilk';
quit; title;


proc gchart data=info;
title h=6 f=swissb c=black 'Histogram of Residuals';
axis3 label = (C=Black H=3.5 f=Swissb 'Residuals') value= (h=2.5 f=swissb
                                c=black);
axis4 label = (C=black A=90 h=3.5 f=swissb 'PERCENT') value= (h=2.5 f=swissb
                                c=black);
vbar jackres/ type=percent levels=11 maxis=axis3 raxis=axis4;
run;quit; title;



proc print data=info;
where abs(jackres) gt 2;
quit;



proc sort data=info;
by location;
quit;

proc univariate data=info noprint;
by location;
var time;
output out=Kinfo mean=avgtime var=vartime std=sdtime;
quit;






data KInfo;
set Kinfo;
varbymean = vartime/avgtime;
sdbymean = sdtime/avgtime;
sdbymeansq = sdtime/(avgtime**2);
run;


ods rtf file='c:\example.rtf';
proc print data=Kinfo;
id location;
var varbymean sdbymean sdbymeansq;
quit;

ods rtf close;

                                *****As we see below PROC TRANSREG TRUMPS THIS EYEBALLING THE RATIOS ABOVE****;




   data fail;
input time location unit;
cards;
4.41  1  1
  100.65  1  2
   14.45  1  3
   47.13  1  4
   85.21  1  5
    8.24  2  1
   81.16  2  2
    7.35  2  3
   12.29  2  4
    1.61  2  5
  106.19  3  1
   33.83  3  2
   78.88  3  3
  342.81  3  4
   44.33  3  5
      ;
run;


data fail;
set fail;
local1 = (location = 1);
local2 = (location = 2);
run;

proc freq data=fail;
tables location*local1*local2/list;
quit;



proc transreg data=fail;
      model BoxCox(time) = identity(local1 local2);
   run;





   data fail2;
input time location unit;
cards;
4.41  1  1
  100.65  1  2
   14.45  1  3
   47.13  1  4
   85.21  1  5
    8.24  2  1
   81.16  2  2
    7.35  2  3
   12.29  2  4
    1.61  2  5
  106.19  3  1
   33.83  3  2
   78.88  3  3
  342.81  3  4
   44.33  3  5
        0  3  6
      ;
run;


data fail2;
set fail2;
local1 = (location = 1);
local2 = (location = 2);
run;


proc transreg data=fail2;
      model BoxCox(time) = identity(local1 local2);
   run;
data fail2;
set fail2;
time2 = time+1;
run;



proc transreg data=fail2;
      model BoxCox(time2) = identity(local1 local2);
   quit;
		******BEST LAMDA 0.25 Power
   				CONVENIENT LAMDA 0 POWER OR LOG-TRANSFORMATION****;


proc transreg data=fail2 pbo;  ****PBO = Tells SAS to print out the BLOCKED OUTPUT FOR VARIOUS LAMBDA****;
      model BoxCox(time2) = identity(local1 local2);
   quit;

		******BEST LAMDA 0.25 Power
   				CONVENIENT LAMDA 0 POWER OR LOG-TRANSFORMATION****;

   

******SAS OUTPUT SAYS LAMBDA = 0 MEANS LOG TRANSFORMATION****;



                   ************log trasnform***;
data fail;
set fail;
ltime = log(time);
**** ltime = log(time+1);  ***Shifted Log if you have 0 outcome values*****;
*****ltime = log(time + shift) ;  ***Shifted Log if you have 0 outcome values*****;
                                                        ***Set shift to 0.01, 0.05, 0.1****;
run;


proc glm data=fail;
class location;
model ltime=location;
means location/hovtest;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;





********WHAT IF WE TRIED THE SQUARE-ROOT TRANSFORMATION*****;



                   ************SQRT trasnform***;
data fail;
set fail;
sqrttime = sqrt(time);
run;


proc glm data=fail;
class location;
model sqrttime=location;
means location/hovtest;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;



proc univariate data=info normal;
var resid jackres;
title 'Looking at the Distribution of the Residuals: Shapiro-Wilk';
quit; title;



*************************************;

ods trace off;


data fail;
set fail;
ltime = log(time);
run;


proc glm data=fail;
class location;
model ltime=location;
means location/hovtest;
lsmeans location/tdiff pdiff cl;

output out=info r=resid p=phat student=stdres rstudent=jackres;
ods output Lsmeans=lsminfo;
ods output LSMeanCL = cl;


quit;


proc print data=lsminfo;
quit;

proc print data=cl;
quit;


******BACK TRANSFORM THE MEANS*****;


data lsminfo;
set lsminfo;
BT_MEAN = exp(LSMEAN);
run;



proc print data=lsminfo;
quit;

data cl;
set cl;
BT_MEAN = exp(LSMEAN);
BT_LB = exp(LowerCL);
BT_UB = exp(upperCL);

run;

proc print data=cl;
quit;
