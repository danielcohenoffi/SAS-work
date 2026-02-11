options formdlim=' ' ls=90 ps=50;


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





data prob1;
set prob1;
        ****SUM TO ZERO***;     **TAU***;
if group =1 then do; g1 = 1; g2=0; end;
if group =2 then do; g1 = 0; g2=1; end;
if group =3 then do; g1 = -1; g2=-1; end;
        ****SET TO ZERO***;   ***GLM is working***;
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
var improve g1 g2;
quit;
proc print data=prob1;
id group id;
var improve x1 x2;
quit;
              ***SUM TO ZERO***;

   ***SUM TO ZERO***;
proc means data=prob1;
var improve;
quit;
proc means data=prob1;
class group;
var improve;
quit;

proc glm data=prob1;
class group;
model improve = g1 g2/solution ;
quit;

proc glm data=prob1;
class group;
model improve = g1 g2/solution ;
estimate 'gp1' intercept 1 g1 1 g2 0;
estimate 'gp2' intercept 1 g1 0 g2 1;
estimate 'gp3' intercept 1 g1 -1 g2 -1;


estimate 'gp1 dev' g1 1 g2 0 ;
estimate 'gp2 dev' g1 0 g2 1;
estimate 'gp3 dev' g1 -1 g2 -1;

estimate 'gp1 dev' g1 1 g2 0 ;
estimate 'gp2 dev' g1 0 g2 1;
estimate 'T1 vs T2' g1 1  g2 -1;


estimate 'gp1 dev' g1 1 g2 0 ;
estimate 'gp3 dev' g1 -1 g2 -1;
estimate 'T1 vs T3' g1 2 g2 1;


estimate 'gp2 dev' g1 0 g2 1;
estimate 'gp3 dev' g1 -1 g2 -1;
estimate 'T2 vs T3' g1 1 g2 2;
                **T1vsT2 &    T1vsT3 &  T2vsT3**;
contrast 'ANOVA' g1 1 g2 -1 , g1 2 g2 1, g1 1 g2 2;

contrast 'anova' g1 1 g2-1, g1 2 g2 1;

quit;
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

estimate 'gp1' intercept 1 x1 1 x2 0;
estimate 'gp2' intercept 1 x1 0 x2 1;
estimate 'gp1 vs gp2' intercept 0 x1 1 x2 -1;

estimate 'gp1' intercept 1 x1 1 x2 0;
estimate 'gp3' intercept 1 x1 0 x2 0;
estimate 'gp1 vs gp3' intercept 0 x1 1 x2 0;


estimate 'gp2' intercept 1 x1 0 x2 1;
estimate 'gp3' intercept 1 x1 0 x2 0;
estimate 'gp2 vs gp3' intercept 0 x1 0 x2 1;


estimate 'gp1 vs gp2' intercept 0 x1 1 x2 -1;
estimate 'gp1 vs gp2 b' x1 1 x2 -1;


contrast 'anova' x1 1 x2-1, x1 1 x2 0;
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
              ***SUM TO ZERO***;
proc glm data=prob1;
class group;
model improve = g1 g2/solution ;
estimate 'gp1' intercept 1 g1 1 g2 0;
estimate 'gp2' intercept 1 g1 0 g2 1;
estimate 'gp3' intercept 1 g1 -1 g2 -1;
contrast 'anova' g1 1 g2-1, g1 2 g2 1;
quit;
              ***Let GLM do it***;
proc glm data=prob1;
class group;
model improve = group/solution ;
means group;
quit;
              ***Let GLM do it***;
proc glm data=prob1;
class group;
model improve = group/solution ;
means group;
output out=o p=phat;
quit;

proc print data=o;
var improve phat x1 x2;
quit;

proc print data=o;
var y phat x1 x2;
quit;
proc print data=o;
var improve phat x1 x2;
quit;
proc print data=o;
var improve phat x1 x2;
quit;
proc means data=prob1;
var improve;
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
options ls=90 ps=50 formdlim=' ';
***********************************************************************************;
***********************************************************************************;
;
