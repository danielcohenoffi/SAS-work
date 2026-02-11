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
means AGENT/hovtest tukey lines;
quit;



        *****CONFIDENT INTERVAL WITH ERROR BARS****;



goptions reset=global gunit=pct border cback=white rotate=landscape
         colors=(black blue green red) ftext=swiss
         ftitle=swissb htitle=5 htext=3.5 device=win;


axis1 label=('AGENT' ) ;
  axis2 label=('DAYS' j=c
             'Error Bar Confidence Limits: 90%')
       minor=(number=1);
     pattern1 color=yellow;

proc gchart data=prob1;
hbar agent / type=MEAN sumvar=DAYS   discrete
              freqlabel='Number per Color'
              meanlabel='Mean Rating'
              errorbar=both
              clm=90                         maxis=axis1
noframe  raxis=axis2               ;
run; quit;





                ****WHAT ABOUT 90% CI for the Tukey Estimates****;



proc glm data=prob1 alpha=0.10;
class AGENT;
model DAYS = AGENT ;
means AGENT/t tukey clm;
   means agent/tukey lines;
       lsmeans agent/adjust=tukey cl alpha=0.10;
output out=o LCLM=lower UCLM = upper p=phat;

quit;

proc print data=o label;
quit;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=o gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=dot  i=none C=red ci=red height=2.5;
SYMBOL3 v=circle  i=none C=green ci=green height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'GROUP')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT phat*agent=2 lower*agent =1 upper*agent = 3/overlay
HAXIS=AXIS1 VAXIS=AXIS2  frame ;
                        ;
RUN;


*****All Paired Comparisons****;



proc glm data=prob1 alpha=0.10;
class AGENT;
model DAYS = AGENT /solution clparm ;
   means AGENT;
   means AGENT/t clm;
means AGENT/tukey ;
means AGENT/scheffe ;
means AGENT/bon ;

/*
means AGENT/SCHEFFE lines;

  means agent/ tukey alpha=.1 cldiff;
   means AGENT/bon lines;
      means AGENT/t clm;
means agent/tukey ;
*/

                lsmeans agent/pdiff adjust=tukey cl alpha=0.10;

                lsmeans agent/pdiff adjust=scheffe cl alpha=0.10;

                lsmeans agent/pdiff adjust=bon cl alpha=0.10;
quit;



proc glm data=prob1 alpha=0.10;
class AGENT;
model DAYS = AGENT /solution clparm ;

                lsmeans agent/pdiff adjust=tukey cl alpha=0.10;

                lsmeans agent/pdiff adjust=scheffe cl alpha=0.10;

                lsmeans agent/pdiff adjust=bon cl alpha=0.10;  ***This adjusts for all 10 PW Comp***;

                lsmeans agent/pdiff  cl alpha=0.010;  ***Me manually doing Bon for all 10 PW Comp***;
                lsmeans agent/pdiff  cl alpha=0.03333;  ***Me manually doing Bon controlling for 1-3, 1-5,
															3-5 contrasts in our adjustment for mult Comp
																**;




quit;


proc glm data=prob1 alpha=0.10;
class AGENT;
model DAYS = AGENT /solution clparm ;
lsmeans agent/pdiff adjust=tukey cl alpha=0.10;

estimate 'AG1' intercept 1 agent 1 0 0 0 0 ;
estimate 'AG2' intercept 1 agent 0 1 0 0 0 ;
estimate 'AG3' intercept 1 agent 0 0 1 0 0 ;
estimate 'AG4' intercept 1 agent 0 0 0 1 0 ;
estimate 'AG5' intercept 1 agent 0 0 0 0 1 ;


estimate 'AG1 vs AG2'  agent 1 -1 0 0 0 ;
contrast 'AG1 vs AG2'  agent 1 -1 0 0 0 ;
estimate 'AG1 vs AG 3' agent 1 0 -1 0 0  ;
estimate 'AG1 vs AG 5' agent 1 0 0 0 -1  ;
estimate 'AG3 vs AG 5' agent 0 0 1 0 -1  ;


quit;



      ****PART e***;

proc glm data=prob1 alpha=0.03333;
class AGENT;
model DAYS = AGENT /solution clparm ;
estimate 'AG1 vs AG 3' agent 1 0 -1 0 0  ;
estimate 'AG1 vs AG 5' agent 1 0 0 0 -1  ;
estimate 'AG3 vs AG 5' agent 0 0 1 0 -1  ;

quit;



data a2;
set a2;
one = 1;
run;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=a2 gout=hwone;
where agent in (1,3,5);
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
SYMBOL4 v=square  i=none C=orange ci=orange height=2.5;
SYMBOL5 v=triangle  i=none C=purple ci=pruple height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'GROUP')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT avgdays*one=agent/ HAXIS=AXIS1 VAXIS=AXIS2  frame ;
                        ;
RUN;
QUIT; TITLE; title2;




  *****TUKEY LOOKS AT THE MAXIMIZED SEPARATION***;



proc glm data=prob1 alpha=0.10;
class AGENT;
model DAYS = AGENT /solution clparm ;
lsmeans agent/pdiff adjust=tukey cl alpha=0.10;
quit;

