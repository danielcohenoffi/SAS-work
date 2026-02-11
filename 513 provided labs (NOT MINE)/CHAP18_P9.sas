********************************************************************************************
* Basic ANOVA Modeling                                  Statistician:   Robert J. Gallop   *
*                                                                                          *
* Investigator: STAT 513                                                                   *
********************************************************************************************
;

options ls=90 ps=50 formdlim=' ';

***********************************************************************************;
***********************************************************************************;
;

 ***CREATE A WORK FILE FOR THE DATA***;
data prob1;
input days agent id;
cards;
   24.0      1      1
   24.0      1      2
   29.0      1      3
   20.0      1      4
   21.0      1      5
   25.0      1      6
   28.0      1      7
   27.0      1      8
   23.0      1      9
   21.0      1     10
   24.0      1     11
   26.0      1     12
   23.0      1     13
   24.0      1     14
   28.0      1     15
   23.0      1     16
   23.0      1     17
   27.0      1     18
   26.0      1     19
   25.0      1     20
   18.0      2      1
   20.0      2      2
   20.0      2      3
   24.0      2      4
   22.0      2      5
   29.0      2      6
   23.0      2      7
   24.0      2      8
   28.0      2      9
   19.0      2     10
   24.0      2     11
   25.0      2     12
   21.0      2     13
   20.0      2     14
   24.0      2     15
   22.0      2     16
   19.0      2     17
   26.0      2     18
   22.0      2     19
   21.0      2     20
   10.0      3      1
   11.0      3      2
    8.0      3      3
   12.0      3      4
   12.0      3      5
   10.0      3      6
   14.0      3      7
    9.0      3      8
    8.0      3      9
   11.0      3     10
   16.0      3     11
   12.0      3     12
   18.0      3     13
   14.0      3     14
   13.0      3     15
   11.0      3     16
   14.0      3     17
    9.0      3     18
   11.0      3     19
   12.0      3     20
   15.0      4      1
   13.0      4      2
   18.0      4      3
   16.0      4      4
   12.0      4      5
   19.0      4      6
   10.0      4      7
   18.0      4      8
   11.0      4      9
   17.0      4     10
   15.0      4     11
   12.0      4     12
   13.0      4     13
   13.0      4     14
   14.0      4     15
   17.0      4     16
   16.0      4     17
   17.0      4     18
   14.0      4     19
   16.0      4     20
   33.0      5      1
   22.0      5      2
   28.0      5      3
   35.0      5      4
   29.0      5      5
   28.0      5      6
   30.0      5      7
   31.0      5      8
   29.0      5      9
   28.0      5     10
   33.0      5     11
   30.0      5     12
   32.0      5     13
   33.0      5     14
   29.0      5     15
   35.0      5     16
   32.0      5     17
   26.0      5     18
   30.0      5     19
   29.0      5     20
;
run;


        ***LOOK AT WHAT IS INSIDE***;
proc contents data=prob1 position;

quit;

proc print data=prob1;
quit;


    *****Graphically Look at the Relationship****;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=prob1 gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
SYMBOL4 v=square  i=none C=orange ci=orange height=2.5;
SYMBOL5 v=triangle  i=none C=purple ci=pruple height=2.5;
legend1  frame value=(height=2.5             )

                across=5
                label=none
                ;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'ID')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT days*id=agent/ HAXIS=AXIS1 VAXIS=AXIS2  frame legend=legend1;
                        ;
RUN;
QUIT; TITLE; title2;




    *****Graphically Look at the Relationship****;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=prob1 gout=hwone;
SYMBOL1 v=circle  i=sm60 C=green ci=green height=2.5;
SYMBOL2 v=star  i=sm60 C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=sm60 C=red ci=red height=2.5;
SYMBOL4 v=square  i=sm60 C=orange ci=orange height=2.5;
SYMBOL5 v=triangle  i=sm60 C=purple ci=pruple height=2.5;
legend1  frame value=(height=2.5             )

                across=5
                label=none
                ;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'ID')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT days*id=agent/ HAXIS=AXIS1 VAXIS=AXIS2  frame legend=legend1;
                        ;
RUN;
QUIT; TITLE; title2;






proc means data=prob1;
class agent;
quit;

proc sort data=prob1;
by agent;
quit;


proc means data=prob1;
   output out=a2 mean=avgdays;
   by agent;
quit;


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=a2 gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
SYMBOL4 v=square  i=none C=orange ci=orange height=2.5;
SYMBOL5 v=triangle  i=none C=purple ci=pruple height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'GROUP')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT avgdays*agent=agent/ HAXIS=AXIS1 VAXIS=AXIS2  frame ;
                        ;
RUN;
QUIT; TITLE; title2;




        ***SLR - X PREDICTING y***;

proc glm data=prob1;
class AGENT;
model DAYS = AGENT ;
means AGENT/hovtest tukey lines; ;

quit;








ods graphics on;


proc glm data=prob1 PLOTS=all;
class agent;
model days=agent;
means agent/hovtest;
lsmeans agent /plots=(meanplot (join cl));
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;






        *****Residual versus Factor***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=info;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Agent') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*agent/frame HAXIS=AXIS1 VAXIS=AXIS2
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

proc corr data=a3 pearson spearman;
var resid zresid;
quit;


proc univariate data=a3 normal;
var resid;
quit;


proc sort data=a3; by agent; quit;

proc univariate data=a3 normal;
by agent;
var days;
quit;




        ****BAR GRAPH OF RESIDUALS VERSUS LEVELS****;





                  *****BAR GRAPH with Error Bars*****;

goptions reset=global gunit=pct border cback=white rotate=landscape
         colors=(black blue green red) ftext=swiss
         ftitle=swissb htitle=5 htext=3.5 device=win;


axis1 label=('AGENT' ) ;
  axis2 label=('Residual
' )
       minor=(number=1);


proc gchart data=info;
vbar AGENT / type=MEAN sumvar=Resid   discrete
              errorbar=both
              clm=95                         maxis=axis1
noframe  raxis=axis2               ;
run; quit;






 proc sort data=info;
by AGENT;
quit;



        *****Residual versus UNITS***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=join height=2.5;;
proc gplot data=info;
by AGENT;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'UNIT') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*ID=1/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;


proc reg data=info;
by agent;
model resid = id /dw dwprob;
quit;




        *****HOMOGENEITY OF VARIANCE LOOK****;

data info;
set info;
absresid = abs(resid);
run;

proc corr data=info;
var absresid phat;
quit;




proc glm data=prob1;
class agent;
model days=agent;
means agent/hovtest;
quit;


        *****Residual versus PREDICTED***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=info;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'P-HAT') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*phat/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;


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


data info;
set info;
                                ********Bonferroni Threshold  P. 780  t(1-alpha/2,Nt - r-1)****;

BonfCrit = tinv(0.975,100-5-1);   ****ALPHA=0.05*****;

BonfCrit2 = tinv(0.9875,100-5-1);     ****ALPHA=0.025****;
run;



proc print data=info;
where abs(jackres) gt BonfCrit;
quit;



proc print data=info;
where abs(jackres) gt BonfCrit2;
quit;


