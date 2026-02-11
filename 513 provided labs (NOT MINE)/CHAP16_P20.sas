********************************************************************************************
* Basic ANOVA Modeling                                  Statistician:   Robert J. Gallop   *
*                                                                                          *
* Investigator: STAT 513                                                                   *
* PRB 20                                                                                   *
********************************************************************************************
;

options ls=90 ps=50 formdlim=' ';

***********************************************************************************;
***********************************************************************************;
;

 ***CREATE A WORK FILE FOR THE DATA***;
data prob1;
input time group id;
cards;
  29.0      1      1
   42.0      1      2
   38.0      1      3
   40.0      1      4
   43.0      1      5
   40.0      1      6
   30.0      1      7
   42.0      1      8
   30.0      2      1
   35.0      2      2
   39.0      2      3
   28.0      2      4
   31.0      2      5
   31.0      2      6
   29.0      2      7
   35.0      2      8
   29.0      2      9
   33.0      2     10
   26.0      3      1
   32.0      3      2
   21.0      3      3
   20.0      3      4
   23.0      3      5
   22.0      3      6
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
PLOT time*id=group/ HAXIS=AXIS1 VAXIS=AXIS2  frame legend=legend1;
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
   output out=a2 mean=avgtime;   by group;
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
PLOT avgtime*group=1/ HAXIS=AXIS1 VAXIS=AXIS2  frame ;
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
plot time*group=1 avgtime*group=2/ HAXIS=AXIS1 VAXIS=AXIS2 overlay frame;
run;quit; TITLE; title2;




        ***ANOVA - GROUP PREDICTING RECOVERY TIME***;

proc glm data=prob1;
class group;
model time = group/solution ;
means group/hovtest  ;
lsmeans group/pdiff;
output out=info r=resid p=phat  rstudent=stdresid DFFITS=dffits ;
quit;



     ***ANOVA - GROUP PREDICTING TIME with WEIGHTED DUMMY VARIABLES***;


*****NOW equation 16.81 presents the weighted dummy coding as wted sum to zero not set to 0****;

data prob1;
set prob1;

        ****SUM TO ZERO***;
if group =1 then do; g1 = 1; g2=0; end;
if group =2 then do; g1 = 0; g2=1; end;
if group =3 then do; g1 = -8/6; g2=-10/6; end;
run;



proc print data=prob1;
id group id;
var time g1 g2;
quit;


proc means data=prob1;
var time;
quit;

proc glm data=prob1;
class group;
model time = g1 g2/solution ;
quit;


data one;

Fvalue = finv(0.95,2,21);
run;

proc print data=one; quit;


data one;

Fvalue = finv(0.99,2,21);
run;

proc print data=one; quit;
