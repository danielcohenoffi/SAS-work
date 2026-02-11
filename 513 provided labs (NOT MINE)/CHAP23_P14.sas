*Pb 23.14, two-way anova

options formdlim=' ' ls=90 ps=50;
data program;
input days A B id;
cards;
  240.0      1      1      1
  206.0      1      1      2
  217.0      1      1      3
  225.0      1      1      4
  110.0      1      2      1
  118.0      1      2      2
  103.0      1      2      3
   95.0      1      2      4
   56.0      1      3      1
   60.0      1      3      2
   68.0      1      3      3
   58.0      1      3      4
   71.0      2      1      1
   53.0      2      1      2
   68.0      2      1      3
   57.0      2      1      4
   47.0      2      2      1
   52.0      2      2      2
   31.0      2      2      3
   49.0      2      2      4
   37.0      2      3      1
   33.0      2      3      2
   40.0      2      3      3
   45.0      2      3      4
;
run;



proc print data=program;
quit;


***************PLOT TO SEE WHAT^S UP*****;

****One-way Plot****;

data program;
set program;
   if A eq 1 and B eq 1 then A_B='A= S_B=  5';
   if A eq 1 and B eq 2 then A_B='A= S_B=510';
   if A eq 1 and B eq 3 then A_B='A= S_B=10+';
   if A eq 2 and B eq 1 then A_B='A=SL_B=  5';
   if A eq 2 and B eq 2 then A_B='A=SL_B=510';
   if A eq 2 and B eq 3 then A_B='A=SL_B=10+';
run;


proc freq data=program;
tables A*B*A_B/list missing;
quit;

proc glm data = program plots = all;
class a_b;
model days = a_b;
means a_b /hovtest;
lsmeans A_b/cl pdiff adjust = tukey lines;
output out = diag1 p = predicted cookd = cooksd r = resid student = studentresid;
run;

proc sort data = diag1;
by studentresid;
run;

proc print data = diag1;
run;

proc univariate data = diag1 normal;
var studentresid;
run;





 proc sgplot data=program;
xaxis type=discrete Label = 'A & B';
yaxis label ="DAYS";;
scatter x=A_B y=DAYS;
quit;

run
;



*****TWo-WAY PLOT***;

proc sort data=program;
by A B;
quit;


proc means data=program;
   var days;
   by A B;
   output out=a2 mean=avgday;
quit;

proc print data=a2;
quit;


proc sort data=a2;
by A B;
quit;

proc sort data=program;
by A B;
quit;

DATA A2ALL;
MERGE PROGRAM a2;
by A B;
run;


proc print data=A2all;
quit;




       proc sgplot data=A2All ;
xaxis type=discrete Label = 'A and B';;
yaxis label ="DAYS";;
series x=A y=avgday /group=B;
scatter x=A y=days /group=B markerattrs=(size=10) ;
quit;



*************RUN 2-way model with interaction****;



proc glm data=program alpha=0.01  PLOTS=all;  ****AUTO PLTS***;;
;

   class A B;
   model days=A|B;
        lsmeans A*B/cl pdiff adjust = tukey;
    quit;




proc glm data=program alpha=0.01 plots = none;
   class A B;
   model days=A|B;
   means A*B;
format A  2.;
format B  2.;
    quit;





data program;
set program;
if A = 2 and B = 1 then delete;
run;



data a2all;
set a2all;
if A = 2 and B = 1 then delete;
run;







       proc sgplot data=A2All ;
xaxis type=discrete Label = 'A and B';;
yaxis label ="DAYS";;
series x=A y=avgday /group=B;
scatter x=A y=days /group=B markerattrs=(size=10) ;
quit;







proc glm data=program alpha=0.0167;
   class A B;
   model days=A|B/clparm solution;
   means A*B;
format A  2.;
format B  2.;
estimate 'mu11' intercept 1 A 1 0 B 1 0 0 A*B 1 0 0 0 0 ;
estimate 'mu12' intercept 1 a 1 0 b 0 1 0 A*b 0 1 0 0 0 ;
estimate 'mu13' intercept 1 a 1 0 b 0 0 1 a*b 0 0 1 0  0;
estimate 'mu22' intercept 1 a 0 1 b 0 1 0 a*b 0 0 0 1 0 ;
estimate 'mu23' intercept 1 a 0 1 b 0 0 1 a*b 0 0 0 0 1;


estimate 'mu12' intercept 1 a 1 0 b 0 1 0 A*b 0 1 0 0 0 ;
estimate 'mu13' intercept 1 a 1 0 b 0 0 1 a*b 0 0 1 0  0;
estimate 'D1' b 0 1 -1 a*b 0 1 -1 0 0 ;

estimate 'mu22' intercept 1 a 0 1 b 0 1 0 a*b 0 0 0 1 0 ;
estimate 'mu23' intercept 1 a 0 1 b 0 0 1 a*b 0 0 0 0 1;
estimate 'D2' b 0 1 -1 a*b 0 0 0 1 -1;


estimate 'D1' b 0 1 -1 a*b 0 1 -1 0 0 ;
estimate 'D2' b 0 1 -1 a*b 0 0 0 1 -1;
estimate 'L1' a*b 0 1 -1 -1 1;

estimate 'D1' b 0 1 -1 a*b 0 1 -1 0 0 ;
estimate 'D2' b 0 1 -1 a*b 0 0 0 1 -1;
estimate 'L1' a*b 0 1 -1 -1 1;



*****Part b****;


estimate 'mu22' intercept 1 a 0 1 b 0 1 0 a*b 0 0 0 1 0 ;
estimate 'mu23' intercept 1 a 0 1 b 0 0 1 a*b 0 0 0 0 1;

estimate 'H0: u22<u23, Ha: u22>=u23' b 0 1 -1 a*b 0 0 0 1 -1;

quit;




****Part b with a 95% one-sided CI****;
proc glm data=program alpha=0.10;
   class A B;
   model days=A|B/clparm solution;
estimate 'mu22' intercept 1 a 0 1 b 0 1 0 a*b 0 0 0 1 0 ;
estimate 'mu23' intercept 1 a 0 1 b 0 0 1 a*b 0 0 0 0 1;

estimate 'H0: u22<u23, Ha: u22>=u23' b 0 1 -1 a*b 0 0 0 1 -1;

quit;

    quit;

