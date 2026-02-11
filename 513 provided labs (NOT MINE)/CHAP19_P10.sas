*Pb 19.10, two-way anova ;


options formdlim=' ' ls=90 ps=50;
data Cash;
input cash age gender id;
cards;
  21.0      1      1      1
   23.0      1      1      2
   19.0      1      1      3
   22.0      1      1      4
   22.0      1      1      5
   23.0      1      1      6
   21.0      1      2      1
   22.0      1      2      2
   20.0      1      2      3
   21.0      1      2      4
   19.0      1      2      5
   25.0      1      2      6
   30.0      2      1      1
   29.0      2      1      2
   26.0      2      1      3
   28.0      2      1      4
   27.0      2      1      5
   27.0      2      1      6
   26.0      2      2      1
   29.0      2      2      2
   27.0      2      2      3
   28.0      2      2      4
   27.0      2      2      5
   29.0      2      2      6
   25.0      3      1      1
   22.0      3      1      2
   23.0      3      1      3
   21.0      3      1      4
   22.0      3      1      5
   21.0      3      1      6
   23.0      3      2      1
   19.0      3      2      2
   20.0      3      2      3
   21.0      3      2      4
   20.0      3      2      5
   20.0      3      2      6
;
run;



proc print data=Cash;
quit;




***************PLOT TO SEE WHAT^S UP*****;

****One-way Plot****;

data Cash;
set Cash;
   if age eq 1 and gender eq 1 then A_G='Young_M';
   if age eq 1 and gender eq 2 then A_G='Young_F';
   if age eq 2 and gender eq 1 then A_G='Mid_M';
   if age eq 2 and gender eq 2 then A_G='Mid_F';
   if age eq 3 and gender eq 1 then A_G='Old_M';
   if age eq 3 and gender eq 2 then A_G='Old_F';
run;

proc freq data=cash;
tables age*gender*A_G/list;
quit;



goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;

symbol1 v=circle h=3 i=none;
proc gplot data=Cash;
   plot cash*A_G/frame;
run;quit;


*****TWo-WAY PLOT***;

proc sort data=cash;
by age gender;
quit;


proc means data=Cash;
   var cash;
   by age gender;
   output out=a2 mean=avgcash;
quit;

proc sort data=a2;
by age gender;
quit;

proc sort data=Cash;
by age gender;
quit;

DATA A2ALL;
MERGE cash a2;
by age gender;
run;


proc print data=A2all;
quit;

data a2All;
set a2all;
gender2 = gender+2;
run;


proc format;
value genfmt 1='Male' 2='Female';
value gengmt 3='Male' 4='Female';
value agefmt 1='Young' 2='Middle' 3='Old';

quit;

*************RUN 2-way model with interaction****;


ods graphics;


proc glm data=Cash PLOTS=all;  ****AUTO PLTS***;
   class age gender;
   model cash=age|gender;
 means age*gender;
 lsmeans age*gender/pdiff cl alpha=0.05;
   lsmeans age*gender/slice=age;
   lsmeans age*gender/slice=gender;
format gender genfmt.;
format age agefmt.;
    quit;





proc glm data=Cash order=internal;  ****Keeps the original data value ordering of the
                                                                        factors.  Not the formatted values***;
   class age gender;

   model cash=age gender age*gender;
   *model cash=age|gender;


 means age*gender;
   lsmeans age*gender/slice=age;
   lsmeans age*gender/slice=gender;
format gender genfmt.;
format age agefmt.;
    quit;



************INTERACTION NOT SIGNIFICANT - RUN MAIN EFFECTS MODEL****;

proc glm data=Cash;
   class age gender;
   model cash=age gender ;
   means age gender;
   lsmeans age/pdiff;
   lsmeans gender/pdiff;
format gender genfmt.;
format age agefmt.;
    quit;







**************************GOODNESS OF FIT in the TWO-WAY MODEL****;


proc glm data=Cash plots(only) = diagnostic;
   class age gender;
   model cash=age gender age*gender;
   output out=diag1 r=resid p=phat;
quit;

proc print data=diag1;
quit;


proc means daga=diag1 n mean stddev sum maxdec=3;
class A_G;
var resid;
quit;


proc univariate data=diag1 normal ;
var resid;
quit;

proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender;
   output out=diag1 r=resid p=phat;
quit;

		*******IF WE ARE USING KS FOR NORMALITY - WE NEED TO LOOK AT THE BOX-COX TO NORMALIZE THE RESIDUALS *****;
			****TRANSREG NEEDS DUMMY VARIABLES.  NO CLASS STATEMENT*****;

proc freq data=Cash;
tables age gender;
quit;

data Cash2;
set Cash;

age1 = 0; age2  = 0;
IF AGE =1 THEN AGE1 = 1;
IF AGE = 2 THEN AGE2 = 1;

MALE = (GENDER = 1);
RUN;

proc freq data = Cash2;
tables age*age1*age2/list;
tables gender*male / list;
quit;


proc transreg data=cash2 pbo;
model BoxCox(cash) = identity(age1 age2 male age1*male age2*male);
quit;





proc glm data=Cash;
   class Age gender;
   model cash=age gender age*gender;
means Age*gender/hovtest;
quit;



proc glm data=Cash;
   class A_G;
   model cash=A_G;
means A_G/hovtest;
quit;



***************UNEQUAL VARIANCE ?*****;


proc mixed data=Cash covtest ;
   class id age gender A_G;
   model cash=age gender age*gender;
repeated / group=A_G  ;
quit;
 

* Homogeneous variance model (for comparison);
proc mixed data=Cash;
   class age gender;
   model cash = age gender age*gender;
   * No repeated statement = equal variances;
run;


proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender;
quit;


proc mixed data=Cash covtest method=ml plots = none;***Estimation Algorithm Maximum Likelihood***;
   class id age gender A_G;
   model cash=age gender age*gender;
quit;

proc mixed data=Cash covtest method=reml plots = none;***Estimation Algorithm Restricted Maximum Likelihood (DEFAULT)****;
   class id age gender A_G;
   model cash=age gender age*gender;
quit;



******Normal Probability Plot*****;

proc rank data=a2
   out=a3 normal=blom;
  var resid;
  ranks zresid;
quit;

proc sort data=a3;
   by zresid;
symbol1 v=circle i=sm70;
proc gplot data=a3;
   plot resid*zresid/frame;
run;quit;


proc univariate data=a2 normal ;
var resid;
quit;


proc corr data=a3;
var resid zresid phat;
quit;




*****Trend Plot of the Residuals***;

data a2;
set a2;
obsnr = _n_;
run;



symbol1 v=square h=3  i=join c=blue;
proc gplot data=a2;
   plot resid*obsnr=1/frame;
run;quit;

proc reg data=a2;
model resid = obsnr /dw dwprob;
quit;



proc sort data=a2;
by age gender obsnr;
quit;

symbol1 v=square h=3  i=join c=blue;
proc gplot data=a2;
by age gender;
   plot resid*obsnr=1/frame;
run;quit;



proc means data=a2 n mean sum stddev maxdec=2;
class age gender;
var resid;
quit;

proc reg data=a2;
by age gender;
model resid = obsnr /dw dwprob;
quit;

proc reg data=a2;
by age gender;
model resid = id /dw dwprob;
quit;
