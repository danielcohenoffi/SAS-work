

/* formatting example code*/
proc format;
value genfmt 1='Male' 2='Female';
value gengmt 3='Male' 4='Female';
value agefmt 1='Young' 2='Middle' 3='Old';

quit;

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

proc glm data=program;
  class A B;
  model days = A*B;
  means A*B / hovtest;    /* SPACE before slash! */
run;





/****my code ****/


/* diagnostics. Holistic analysis, don't rely on any single significant p value 
Running this before splitting effects into main and interaction keeps from seeing partial F test 
results when model assumptions violated
*/
ods trace on;
proc glm data = program plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class A B;
model days = A*B; /*testing as one way anova first for hovtest*/
means A*B / welch hovtest;
lsmeans A*B /pdiff cl adjust = tukey lines; /* which are different? all pairwise so tukey lines. 
I love my big matrices, close inspection of lines tables tells you slicing*/
estimate "grand mean" intercept 1; /* get grand adjusted mean*/
ods exclude lsmeansplots; /*  declutter output,*/
output out = diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
ods trace off;

proc sort data = diag1;
by studentresid;
run;

proc print data = diag1; /* look for obvious data entry errors in outliers*/
run;

proc univariate data = diag1 normal;
var studentresid; /*formal test of normalities, want agreement if p above 0.0125, below 0.05, informal bonferronni*/
run;


proc transreg data = program plots = none; /* run as diagnostic test, ho is lambda = 1, ha lambda not 1.
If lands on a convenient transformation even when 1 is in interval, and otherwise don't have a fix for data problems
use anyway
if values are negative just use proc mixed
*/
model boxcox(days) = class(A|B);
run;


proc glm data = program plots(only) = (intplot); /* already did diagnostics */
Class A B;
model days = A|B/solution;
ods output Estimates=effects_estimates;
lsmeans A|B /slice = A slice = B out = lsmeans_estimates;
lsmeans A|B/ adjust = tukey lines;
estimate "grand mean" intercept 1;
/* I used deepseek (an LLM) to generate these automatically to save time cleaning up typos
I couldn't get the proc glm to generate effect coding (with correct standard error)
any other way. There's datastep methods but you'd have to recalculate standard errors and t statistics
There's redundancy in these statements but I like the completeness
*/
ESTIMATE 'A Effect 1 (alpha1)' A 1 -1 / DIVISOR=2;
ESTIMATE 'A Effect 2 (alpha2)' A -1 1 / DIVISOR=2; 
ESTIMATE 'B Effect 1 (beta1)'  B 2 -1 -1 / DIVISOR=3;
ESTIMATE 'B Effect 2 (beta2)'  B -1 2 -1 / DIVISOR=3;
ESTIMATE 'B Effect 3 (beta3)'  B -1 -1 2 / DIVISOR=3;
/* Row A1 */
ESTIMATE 'A1B1 Interaction (aB11)' A*B 2 -1 -1 -2 1 1 / DIVISOR=3; /* pretend aB = alphabeta*/
ESTIMATE 'A1B2 Interaction (aB12)' A*B -1 2 -1 1 -2 1 / DIVISOR=3;
ESTIMATE 'A1B3 Interaction (aB13)' A*B -1 -1 2 1 1 -2 / DIVISOR=3;
/* Row A2 */
ESTIMATE 'A2B1 Interaction (aB21)' A*B -2 1 1 2 -1 -1 / DIVISOR=3;
ESTIMATE 'A2B2 Interaction (aB22)' A*B 1 -2 1 -1 2 -1 / DIVISOR=3;
ESTIMATE 'A2B3 Interaction (aB23)' A*B 1 1 -2 -1 -1 2 / DIVISOR=3;

ods exclude lsmeansplot; 
output out = est p = estimate;
run;

/* effect coding dataset*/
proc print data = effect_estimates;
run;

/*means dataset*/
proc print data = lsmeans_estimates;
run;

/* Consolidated adjustment calculations;
MAKE SURE USE BOTH FACTORS ONLY WHEN CONTRAST CUTS ACROSS BOTH FACTORS
IF ONLY TESTING ON ONE FACTOR, USE (A-1) OR (B-1)
*/
data est_adjusted;
  set cell_means;
  
  /* no magic numbers*/
  num_means = 4;        /* ab unless empty cells */
  numDF_effect = 3;     /* ab-1 unless empty cells */
  denDF = 15;           /* Denominator DF from mixed model, 
  all the black box adjustments contained in hereand in stderr*/
  
  /* Scheffe */
  fstar = finv(0.95, numDF_effect, denDF);
  S_sq = numDF_effect * fstar;
  LowerScheffe = Estimate - sqrt(S_sq)*StdErr;
  UpperScheffe = Estimate + sqrt(S_sq)*StdErr;
  
  /* Tukey */
  q = probmc("RANGE", ., 0.95, denDF, num_means); 
  TSTAR = q/sqrt(2);
  LowerTukey = Estimate - TSTAR*StdErr;
  UpperTukey = Estimate + TSTAR*StdErr;
  
  /* Bonferroni option */
  num_comparisons = 6;  /* Total comparisons in family */
  t_bonf = tinv(1-0.05/num_comparisons, denDF);
  LowerBonf = Estimate - t_bonf*StdErr;
  UpperBonf = Estimate + t_bonf*StdErr;
run;




/* prox mixed */


ods output lsmeans = cellmeansmixed estimates = effectsmixed;
proc mixed data = program covtest plots = all;
class A B;
Model days = A|B /s outpm = phatmixed;
lsmeans A|B /pdiff cl adjust = tukey ;
estimate "grand mean" intercept 1;
/* main effects */
ESTIMATE 'A Effect 1 (alpha1)' A 1 -1 / DIVISOR=2;
ESTIMATE 'A Effect 2 (alpha2)' A -1 1 / DIVISOR=2; 
ESTIMATE 'B Effect 1 (beta1)'  B 2 -1 -1 / DIVISOR=3;
ESTIMATE 'B Effect 2 (beta2)'  B -1 2 -1 / DIVISOR=3;
ESTIMATE 'B Effect 3 (beta3)'  B -1 -1 2 / DIVISOR=3;
/* Row A1 */
ESTIMATE 'A1B1 Interaction (aB11)' A*B 2 -1 -1 -2 1 1 / DIVISOR=3; /* pretend aB = alphabeta*/
ESTIMATE 'A1B2 Interaction (aB12)' A*B -1 2 -1 1 -2 1 / DIVISOR=3;
ESTIMATE 'A1B3 Interaction (aB13)' A*B -1 -1 2 1 1 -2 / DIVISOR=3;
/* Row A2 */
ESTIMATE 'A2B1 Interaction (aB21)' A*B -2 1 1 2 -1 -1 / DIVISOR=3;
ESTIMATE 'A2B2 Interaction (aB22)' A*B 1 -2 1 -1 2 -1 / DIVISOR=3;
ESTIMATE 'A2B3 Interaction (aB23)' A*B 1 1 -2 -1 -1 2 / DIVISOR=3;

ods exclude lsmeansplots;
repeated / group = A*B; /* does LRT to compare constant to nonconstant variance*/
run;

proc print data = cellmeansmixed;
run;


proc print data = effectsmixed;
run;


proc sort data = phatmixed;
by A B;
run;

ods select TestsForNormality;
proc univariate data = phatmixed normal;
var resid;
by A B;
run;




/* Weightled least squares 1 way anova hack */

data interaction_only;
set cellmeansmixed;
where Effect = 'A*B';
inv_var = 1/(stderr**2);
scaled_weight = round(inv_var * 1000);
run;


proc sort data = interaction_only;
by A B;
run;
proc print data = interaction_only;
run;

proc glmpower data = interaction_only;
class A B;
model estimate =A B A*B;
weight scaled_weight;
Power
Stddev = 9.3
alpha = 0.05
ntotal = .
power = 0.80;
run;































/*standardized residuals nonsense*/

proc means data = phatmixed;
by A B;
var resid;
output out = group_sd std = group_std;
run;

data phatmixed;
merge phatmixed group_sd;
by A B;
standardresid = resid/group_std;
run;

proc print data = phatmixed;
run;

ods select TestsForNormality;
proc univariate data = phatmixed normal;
var standardresid;
by A B;
run;

proc sgpanel data = phatmixed;
panelby A B;
histogram standardresid;
density standardresid / type = normal;
colaxis label = "Standardized Residuals";
run;












/* scrap code*/


/* tukey and Scheffe adjustment code shamelessly taken from chap19_p35*/

	****Scheffe - 95% conf*****;

	




data estS;
set est;
fstar=FINV(1-alpha,num df, denom df);
S_sq = (r -1)*FINV(1- alpha,r- 1, error df);  *****Equation 19.93c a=2  b=3, so ab-1 = 6 -1   = 5, Second is DDF***;
xs=sqrt(S_sq);

LowerScheffe = Estimate - sqrt(S_sq)*StdErr;
UpperScheffe = Estimate + sqrt(S_sq)*StdErr;
run;


*****Tukey - 95% CI*****;

data estT;
set estS;
q = probmc("RANGE", ., 0.95, denom df, num df);  *****Degrees of freedom ordering is flipped as compared to Scheffe****;
										*****First is DDF =- Denominator degrees of freedom****;
										****Note, equation 19.89a*****;
										***Scheffe uses ab-1 where Tukey here is using ab****;

TSTAR = q/sqrt(2);

LBTukey = Estimate - TSTAR*Stderr;
UBTukey = Estimate + TSTAR*Stderr;

run;



proc print data = est;
run;

quit;

/* attach cell means to treatment labels*/
proc sql;
create table cell_means as
select A,B,Mean(estimate) as estimate
from est
group by A,B;
quit;

proc print data = cell_means;
run;







