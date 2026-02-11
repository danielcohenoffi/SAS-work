*Pb 19.35, two-way anova

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




/****my code ****/


/* diagnostics. Holistic analysis, don't rely on any single significant p value 
Running this before splitting effects into main and interaction keeps from attaching 
meaning to test results when model assuptions violated, overall F test same
*/
proc glm data = program plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class A B;
model days = A*B; /*testing as one way anova first for hovtest*/
means A*B /hovtest;
lsmeans A*B /pdiff cl adjust = tukey lines; /* which are different? all pairwise so tukey lines. 
I love my big matrices, close inspection of lines tables tells you slicing*/
ods exclude lsmeansplots; /* tell you NOTHING, clutter up output*/
output out = diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;

proc sort data = diag1;
by studentresid;
run;

proc print data = diag1; /* look for obvious data entry errors in outliers*/
run;

proc univariate data = diag1 normal;
var studentresid; /*formal test of normalities, informal bonferroni adjustment used*/
run;


proc transreg data = program plots = none; /* run as diagnostic test, ho is lambda = 1, ha lambda not 1.*/
model boxcox(days) = class(A|B);
run;


proc glm data = program plots(only) = (intplot); /* already did diagnostics */
Class A B;
model days = A|B;
lsmeans A|B /slice = A; /* 2 way model only needed for slicing, not all pairwise */
lsmeans A|B /slice = B;
run;



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


goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;

symbol1 v=circle h=3 i=none;
proc gplot data=program;
   plot days*A_B/frame;
run;quit;


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

symbol1 v=square h=3 i=join c=red;
symbol2 v=diamond h=3 i=join c=green;
symbol3 v=circle h=3 i=join c=gold;
proc gplot data=a2;
   plot avgday*A=B/frame  haxis = 1 to 2 by 1;
run;quit;


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

data a2All;
set a2all;
B2 = B+3;
run;


proc format;
value xAfmt 1='Small' 2='SmandLarge' ;
value xBfmt 1='<5' 2='5-10' 3='11+';
value xBbfmt 4='<5' 5='5-10' 6='11+';

quit;

proc means data=A2all;
quit;



goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;
symbol1 v=square h=1 i=join c=red;
symbol2 v=diamond h=1 i=join c=green;
symbol3 v=circle h=1 i=join c=gold;
symbol4 v=square h=3 i=none c=red;
symbol5 v=diamond h=3 i=none c=green;
symbol6 v=circle h=3 i=none c=gold;

proc gplot data=a2all;
   plot avgday*A=B/frame haxis = 1 to 2 by 1
                 vaxis = 0 to 240 by 30;
plot2 days*A=B2/frame vaxis = 0 to 240 by 30;
format A xAfmt.;
format B xBfmt.;
format B2 xBbfmt.;
run;quit;


*************RUN 2-way model with interaction****;



proc glm data=program alpha=0.01;
   class A B;
   model days=A|B;
   means A*B/ hovtest = levene;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl pdiff;
    quit;

	proc anova data = program;
	class A B;
	model days = A|B;
	means A*B /hovtest;
	run;



****Were not intested in all pairwise comparions therefore Bon better than Tukey
Also, the number of  Comparison is equal to Factors so Bon is better than Scheffe***;
****p.@870***;



proc glm data=program alpha=0.0083;****Bonferonni adjustments (if alpha = .05 .05/6 = .0083***;

   class A B;
   model days=A|B/clparm;
   ****using all the estimates statements to create the 6 contrasts of interest****;
estimate 'u11' intercept 1 a 1 0 b 1 0 0 a*b 1 0 0 0 0 0 ;
estimate 'u21' intercept 1 a 0 1 b 1 0 0 a*b 0 0 0 1 0 0 ;
estimate 'D1'              a 1 -1       a*b 1 0 0 -1 0 0 ;
estimate 'u12' intercept 1 a 1 0 b 0 1 0 a*b 0 1 0 0 0  0;
estimate 'u22' intercept 1 a 0 1 b 0 1 0 a*b 0 0 0 0 1 0;
estimate 'D2'              a 1 -1        a*b 0 1 0 0 -1 0 ;
estimate 'u13' intercept 1 a 1 0 b 0 0 1 a*b 0 0 1 0 0 0;
estimate 'u23' intercept 1 a 0 1 b 0 0 1 a*b 0 0 0 0 0 1;
estimate 'D3' a 1 -1 a*b 0 0 1 0 0 -1;

estimate 'D1' a 1 -1 a*b 1 0 0 -1 0 0 ;
estimate 'D2' a 1 -1 a*b 0 1 0 0 -1 0 ;
estimate 'D3' a 1 -1 a*b 0 0 1 0 0 -1;

estimate 'D1' a 1 -1 a*b 1 0 0 -1 0 0 ;
estimate 'D2' a 1 -1 a*b 0 1 0 0 -1 0 ;
estimate 'L1'        a*b 1 -1 0 -1 1 0;

estimate 'D1' a 1 -1 a*b 1 0 0 -1 0 0 ;
estimate 'D3' a 1 -1 a*b 0 0 1 0 0 -1;
estimate 'L2' a*b 1 0 -1 -1 0 1;

estimate 'D2' a 1 -1 a*b 0 1 0 0 -1 0 ;
estimate 'D3' a 1 -1 a*b 0 0 1 0 0 -1;
estimate 'L3' a*b 0 1 -1 0 -1 1;

****six contrasts we want****;
estimate 'D1' a 1 -1 a*b 1 0 0 -1 0 0 ;
estimate 'D2' a 1 -1 a*b 0 1 0 0 -1 0 ;
estimate 'D3' a 1 -1 a*b 0 0 1 0 0 -1;
estimate 'L1'        a*b 1 -1 0 -1 1 0;
estimate 'L2' a*b 1 0 -1 -1 0 1;
estimate 'L3' a*b 0 1 -1 0 -1 1;

    quit;


                ****the two below give the same thing
                        adjusting the alpha by the number of
                        pairwise comparisons 0.05 / 6 choose 2
                        where 6 is the number of cells****;


proc glm data=program alpha=0.05;****Tukey adjustments***;

   class A B;
   model days=A|B/clparm;
lsmeans A*B/pdiff adjust = tukey lines cl;
    quit;


proc glm data=program alpha=0.0033333;****Bon adjustments***;

   class A B;
   model days=A|B/clparm;
lsmeans A*B/pdiff lines cl;
    quit;



proc glm data=program alpha=0.05;****Bon adjustments***;

   class A B;
   model days=A|B/clparm;
lsmeans A*B/pdiff adjust = bon lines cl;
    quit;




/*
For the pairwise comparisons of the cell means we can do it in the LSMEANS statement with the 
	respective adjust = tukey, adjust=scheffe, or adjust = bon

	We can do the adjust=BON manually by adjusting the alpha on the PROC LINE to the original alpha  divided
																					by the numbner of contrasts
																					of interest.

	For contrasts invovling combination of cell means, we need to 
	(1) for the BON we can adjust the alpha level in the PROC LINE
	(2) For the tukey and scheffe, we need to do it manually by outputing the 
	estimates of the contrast to a data set and programming the CI


	*/


proc glm data=program alpha=0.0083;****Bonferonni adjustments (if alpha = .05 .05/6 = .0083***;
   class A B;
   model days=A|B/clparm;
estimate 'D1' a 1 -1 a*b 1 0 0 -1 0 0 ;
estimate 'D2' a 1 -1 a*b 0 1 0 0 -1 0 ;
estimate 'D3' a 1 -1 a*b 0 0 1 0 0 -1;
estimate 'L1'        a*b 1 -1 0 -1 1 0;
estimate 'L2' a*b 1 0 -1 -1 0 1;
estimate 'L3' a*b 0 1 -1 0 -1 1;
ods output Estimates=est;
    quit;


	proc print data=est;
	quit;

	****Scheffe - 95% conf*****;

	

data estS;
set est;
fstar=FINV(0.95,5,18);
S_sq = (2*3-1)*FINV(0.95,5,18);  *****Equation 19.93c a=2  b=3, so ab-1 = 6 -1   = 5, Second is DDF***;
xs=sqrt(S_sq);

LowerScheffe = Estimate - sqrt(S_sq)*StdErr;
UpperScheffe = Estimate + sqrt(S_sq)*StdErr;
run;


proc print data=estS;
quit;

	*****Tukey - 95% CI*****;

data estT;
set estS;
q = probmc("RANGE", ., 0.95, 18, 6);  *****Degrees of freedom ordering is flipped as compared to Scheffe****;
										*****First is DDF =- Denominator degrees of freedom****;
										****Note, equation 19.89a*****;
										***Scheffe uses ab-1 where Tukey here is using ab****;

TSTAR = q/sqrt(2);

LBTukey = Estimate - TSTAR*Stderr;
UBTukey = Estimate + TSTAR*Stderr;

run;

proc print data=estT;
quit;


***************GOODNESS OF FIT*******;


data sqrt;
set program;
sqrtdays = sqrt(days);
run;

***HOV test***;
proc glm data=sqrt ;
   class A_B;
   model sqrtdays=A_B/clparm;
means A_B/hovtest;
quit;


***HOV test***;
proc glm data=program ;
   class A B;
   model days=A*B/clparm;
means A*B / hovtest;
quit;

proc mixed data = program;
class A B;
model days = A|B /ddfm = satterth;
repeated /group = A*B;
run;

***Normality of residuals****;
proc glm data=program plots = all ;
   class A B;
   model days=A|B/clparm;
output out=o r=resid rstudent=jackred;
quit;

proc univariate data=o normal;
var resid;
quit;

****Outliers****;
proc print data=o;
where abs(jackred) gt 2;
quit;


**************RECIP*********;
data program;
set program;
invdays = 1/days;
lgdays = log(days);
run;


goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;

symbol1 v=circle h=3 i=none;
proc gplot data=program;
   plot invdays*A_B/frame;
run;quit;



goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;

symbol1 v=circle h=3 i=none;
proc gplot data=program;
   plot lgdays*A_B/frame;
run;quit;

*****TWo-WAY PLOT***;

proc sort data=program;
by A B;
quit;


proc means data=program;
   var invdays;
   by A B;
   output out=a2 mean=avgday;
quit;

proc print data=a2;
quit;

symbol1 v=square h=3 i=join c=red;
symbol2 v=diamond h=3 i=join c=green;
symbol3 v=circle h=3 i=join c=gold;
proc gplot data=a2;
   plot avgday*A=B/frame  haxis = 1 to 2 by 1;
run;quit;






proc means data=program;
   var lgdays;
   by A B;
   output out=a2 mean=avgday;
quit;

proc print data=a2;
quit;

symbol1 v=square h=3 i=join c=red;
symbol2 v=diamond h=3 i=join c=green;
symbol3 v=circle h=3 i=join c=gold;
proc gplot data=a2;
   plot avgday*A=B/frame  haxis = 1 to 2 by 1;
run;quit;





*****WHY DO THIS?   NO DON't !!!!   The data fit the two-way ANOVA model
(1) No issue with HOV
(2) No issue with normality of the residuals.

Why remove the interaction?  

****;

proc glm data=program;

   class A B A_B;
   model invdays=A|B/ss3;
quit;




proc glm data=program;

   class  A_B;
   model invdays=A_B/ss3;
        means A_B/hovtest;
quit;
