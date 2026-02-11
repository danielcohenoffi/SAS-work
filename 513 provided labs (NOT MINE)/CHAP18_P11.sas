********************************************************************************************
* Basic ANOVA Modeling                                  Statistician:   Robert J. Gallop   *
*                                                                                          *
* Investigator: STAT 513                                                                   *
* PRB 18                                                                                   *
********************************************************************************************
;

options ls=90 ps=50 formdlim=' ';

***********************************************************************************;
***********************************************************************************;
;

 ***CREATE A WORK FILE FOR THE DATA***;
data prob1;
input improve group id;
cards;
 7.6      1      1
    8.2      1      2
    6.8      1      3
    5.8      1      4
    6.9      1      5
    6.6      1      6
    6.3      1      7
    7.7      1      8
    6.0      1      9
    6.7      2      1
    8.1      2      2
    9.4      2      3
    8.6      2      4
    7.8      2      5
    7.7      2      6
    8.9      2      7
    7.9      2      8
    8.3      2      9
    8.7      2     10
    7.1      2     11
    8.4      2     12
    8.5      3      1
    9.7      3      2
   10.1      3      3
    7.8      3      4
    9.6      3      5
    9.5      3      6
;
run;


        ***LOOK AT WHAT IS INSIDE***;
proc contents data=prob1 position;

quit;

proc print data=prob1;
quit;                         *****NOTE WE DO NOT HAVE BALANCED DATA*****;


    *****Graphically Look at the Relationship****;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=prob1 gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
legend1  frame value=(height=2.5             )

                across=3
                label=none
                ;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'ID')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT improve*id=group/ HAXIS=AXIS1 VAXIS=AXIS2  frame legend=legend1;
                        ;
RUN;
QUIT; TITLE; title2;
                              *****NOTE: Patients are not crossed but nested****;


proc means data=prob1;
class group;
quit;

proc sort data=prob1;
by group;
quit;


proc means data=prob1;
   output out=a2 mean=avgimprove;   by group;
quit;


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=a2 gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'GROUP')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT avgimprove*group=1/ HAXIS=AXIS1 VAXIS=AXIS2  frame ;
                        ;
RUN;
QUIT; TITLE; title2;




proc sql;
create tables K3 as
select a.*, b.*
from prob1 a left join a2 b
on a.group = b.group;
quit;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

proc gplot data=K3;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=join C=blue ci=blue w=3 height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'GROUP')
value=(h=4 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=4 f=swissb) minor=none ;
plot improve*group=1 avgimprove*group=2/ HAXIS=AXIS1 VAXIS=AXIS2 overlay frame;
run;quit; TITLE; title2;




        ***ANOVA - GROUP PREDICTING IMPROVEMENT with DUMMY VARIABLES***;


*****NOW equation 16.75 presents the dummy coding as sum to zero not set to 0****;

****The Benefit of this is the intercept represents the overall mean****;

data prob1;
set prob1;

        ****SUM TO ZERO***;
if group =1 then do; g1 = 1; g2=0; end;
if group =2 then do; g1 = 0; g2=1; end;
if group =3 then do; g1 = -1; g2=-1; end;

        ****SET TO ZERO***;
x1=0; x2=0;
if group =1 then do; x1 = 1; x2=0; end;
if group =2 then do; x1 = 0; x2=1; end;
run;

proc print data=prob1;
id group id;
var improve g1 g2;
quit;



proc print data=prob1;
id group id;
var improve x1 x2;
quit;



              ***SUM TO ZERO***;
proc glm data=prob1;
class group;
model improve = g1 g2/solution ;
estimate 'gp1' intercept 1 g1 1 g2 0;
estimate 'gp2' intercept 1 g1 0 g2 1;
estimate 'gp3' intercept 1 g1 -1 g2 -1;
contrast 'anova' g1 1 g2-1, g1 2 g2 1;

quit;


             ****SET TO ZERO***;
proc glm data=prob1;
class group;
model improve = x1 x2/solution ;
estimate 'gp1' intercept 1 x1 1 x2 0;
estimate 'gp2' intercept 1 x1 0 x2 1;
estimate 'gp3' intercept 1 x1 0 x2 0;
contrast 'anova' x1 1 x2-1, x1 1 x2 0;
quit;



ods graphics on;



              ***Let GLM do it***;
proc glm data=prob1 PLOTS=all;
class group;
model improve = group/solution ;
means group;
lsmeans group /plots=(meanplot (join cl));

quit;




proc glm data=prob1;
class group;
model improve = group/solution ;
means group;
means group/hovtest=bf;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;






        *****Residual versus Factor***;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=info;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Group') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
PLOT resid*group/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;





                  *****BAR GRAPH with Error Bars*****;

goptions reset=global gunit=pct border cback=white rotate=landscape
         colors=(black blue green red) ftext=swiss
         ftitle=swissb htitle=5 htext=3.5 device=win;


axis1 label=('GROUP' ) ;
  axis2 label=('Residual
' )
       minor=(number=1);


proc gchart data=info;
vbar GROUP / type=MEAN sumvar=Resid   discrete
              errorbar=both
              clm=95                         maxis=axis1
noframe  raxis=axis2               ;
run; quit;









        *****HOMOGENEITY OF VARIANCE LOOK****;

data info;
set info;
absresid = abs(resid);
run;

proc corr data=info;
var absresid phat;
quit;
