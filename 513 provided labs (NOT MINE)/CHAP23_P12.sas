*Pb 23.12, two-way anova

options formdlim=' ' ls=90 ps=50;
data relief;
input hour A B id;
cards;
   2.4      1      1      1
    2.7      1      1      2
    2.3      1      1      3
    2.5      1      1      4
    4.6      1      2      1
    4.2      1      2      2
    4.9      1      2      3
    4.7      1      2      4
    4.8      1      3      1
    4.5      1      3      2
    4.4      1      3      3
    4.6      1      3      4
    5.8      2      1      1
    5.2      2      1      2
    5.5      2      1      3
    5.3      2      1      4
    8.9      2      2      1
    9.1      2      2      2
    8.7      2      2      3
    9.0      2      2      4
    9.1      2      3      1
    9.3      2      3      2
    8.7      2      3      3
    9.4      2      3      4
    6.1      3      1      1
    5.7      3      1      2
    5.9      3      1      3
    6.2      3      1      4
    9.9      3      2      1
   10.5      3      2      2
   10.6      3      2      3
   10.1      3      2      4
   13.5      3      3      1
   13.0      3      3      2
   13.3      3      3      3
   13.2      3      3      4
;
run;



proc print data=relief;
quit;


***************PLOT TO SEE WHAT^S UP*****;

****One-way Plot****;

data relief;
set relief;
   if A eq 1 and B eq 1 then A_B='A=Low_B=Low';
   if A eq 1 and B eq 2 then A_B='A=Low_B=Mid';
   if A eq 1 and B eq 3 then A_B='A=Low_B=xHi';
   if A eq 2 and B eq 1 then A_B='A=Mid_B=Low';
   if A eq 2 and B eq 2 then A_B='A=Mid_B=Mid';
   if A eq 2 and B eq 3 then A_B='A=Mid_B=xHi';
   if A eq 3 and B eq 1 then A_B='A=xHi_B=Low';
   if A eq 3 and B eq 2 then A_B='A=xHi_B=Mid';
   if A eq 3 and B eq 3 then A_B='A=xHi_B=xHi';
run;

proc glm data = relief plots = all;
class a_b;
model hour = a_b;
means a_b /hovtest;
lsmeans a_b /adjust = tukey lines;
output out = diag1 p = predicted r = resid student = studentresid;
run;

proc sort data = diag1;
by studentresid;
run;

proc print data = diag1;
run;

proc univariate data = diag1 normal;
var studentresid;
run;

 proc sgplot data=relief;
xaxis type=discrete Label = 'A-Dose and B-DOSE';
yaxis label ="Hours";;
scatter x=A_B y=hour;
quit;

run
;



*****TWo-WAY PLOT***;

proc sort data=relief;
by A B;
quit;


proc means data=relief;
   var hour;
   by A B;
   output out=a2 mean=avghr;
quit;

proc print data=a2;
quit;
proc sort data=a2;
by A B;
quit;

proc sort data=relief;
by A B;
quit;

DATA A2ALL;
MERGE relief a2;
by A B;
run;


proc print data=A2all;
quit;



       proc sgplot data=A2All ;
xaxis type=discrete Label = 'A-DOSE and B-DOSE';;
yaxis label ="Relief";;
series x=A y=avghr /group=B;
scatter x=A y=hour /group=B markerattrs=(size=10) ;
quit;



*************RUN 2-way model with interaction****;



proc glm data=relief PLOTS=all;  ****AUTO PLTS***;;
;

   class A B;
   model hour=A|B;
        lsmeans A*B/cl pdiff adjust = tukey lines;
		
    quit;



proc glm data=relief PLOTS=none;  ****AUTO PLTS***;;
;

   class A B;
   model hour=A|B;
        lsmeans A*B/slice = A cl pdiff;
		lsmeans A*B/slice = B cl pdiff;
		lsmeans A*B/slice = A*B cl pdiff adjust = tukey lines ;
		
    quit;


data  relief;
set relief;
if A = 2 and B=2 then delete;
run;



data  a2all;
set a2all;
if A = 2 and B=2 then delete;
run;






       proc sgplot data=A2All ;
xaxis type=discrete Label = 'A-DOSE and B-DOSE';;
yaxis label ="Relief";;
series x=A y=avghr /group=B;
scatter x=A y=hour /group=B markerattrs=(size=10) ;
quit;









proc glm data=relief;
   class A B;
   model hour=A|B;
   means A*B;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl pdiff;
    quit;



proc glm data=relief plots = none;
   class A B;
   model hour=A|B;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl pdiff adjust = tukey lines;
    quit;



proc glm data=relief plots = all;
   class A B;
   model hour=A|B;
    quit;





proc glm data=relief alpha = 0.02 plots = none;
   class A B;
   model hour=A|B /solution clparm;
   lsmeans A*B;

estimate 'mu11' intercept 1 a 1 0 0 b 1 0 0 a*b 1 0 0 0 0 0 0 0;
estimate 'mu12' intercept 1 a 1 0 0 b 0 1 0 a*b 0 1 0 0 0 0 0 0;
estimate 'mu13' intercept 1 a 1 0 0 b 0 0 1 a*b 0 0 1 0 0 0 0 0 ;
estimate 'mu21' intercept 1 a 0 1 0 b 1 0 0 a*b 0 0 0 1 0 0 0 0;
estimate 'mu23' intercept 1 a 0 1 0 b 0 0 1 a*b 0 0 0 0 1 0 0 0 ;
estimate 'mu31' intercept 1 a 0 0 1 b 1 0 0 a*b 0 0 0 0 0 1 0 0;
estimate 'mu32' intercept 1 a 0 0 1 b 0 1 0 a*b 0 0 0 0 0 0 1 0;
estimate 'mu33' intercept 1 a 0 0 1 b 0 0 1 a*b 0 0 0 0 0 0 0 1 ;



estimate 'mu13' intercept 1 a 1 0 0 b 0 0 1 a*b 0 0 1 0 0 0 0 0 ;
estimate 'mu11' intercept 1 a 1 0 0 b 1 0 0 a*b 1 0 0 0 0 0 0 0;

estimate 'D1' b -1 0 1 a*b -1 0 1 0 0 0 0 0;

estimate 'mu23' intercept 1 a 0 1 0 b 0 0 1 a*b 0 0 0 0 1 0 0 0 ;
estimate 'mu21' intercept 1 a 0 1 0 b 1 0 0 a*b 0 0 0 1 0 0 0 0;

estimate 'D2' b -1 0 1 a*b 0 0 0 -1 1 0 0 0;



estimate 'mu33' intercept 1 a 0 0 1 b 0 0 1 a*b 0 0 0 0 0 0 0 1 ;
estimate 'mu31' intercept 1 a 0 0 1 b 1 0 0 a*b 0 0 0 0 0 1 0 0;

estimate 'D3' b -1 0 1 a*b 0 0 0 0 0 -1 0 1;

estimate 'D1' b -1 0 1 a*b -1 0 1   0 0   0 0 0;
estimate 'D2' b -1 0 1 a*b 0 0 0   -1 1   0 0 0;
estimate 'L1' a*b -1 0 1 1 -1 0 0 0 ;

estimate 'D1' b -1 0 1 a*b -1 0 1  0 0   0 0 0;
estimate 'D3' b -1 0 1 a*b 0 0 0   0 0  -1 0 1;
estimate 'L2' a*b -1 0 1 0 0 1 0 -1;


estimate 'u12 = u13' b 0 1 -1 a*b 0 1 -1 0 0 0 0 0 ;
estimate 'u32 = u33' b 0 1 -1 a*b 0 0  0 0 0 0 1 -1;


format A B 2.;
run;




