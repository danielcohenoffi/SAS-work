libname f532 '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\final532';

data f532.final;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\final532';
run;

proc corr data = f532.final;
variables divorce years;
run;


%macro lifehaz(outest=,out=,obsno=0,xbeta=lp);
/********************************************************************
Version 2.0 (9-14-01)

This version of LIFEHAZ works for SAS Release 6.12 through 
Release 8.2.  

Macro LIFEHAZ plots the hazard function for a model fitted by
LIFEREG. In the LIFEREG procedure you must specify OUTEST=name1
in the PROC statement.  You must also use the OUTPUT statement with
OUT=name2 and XBETA=name3. By default, the hazard is plotted for the
mean value of XBETA (the linear predictor).  If you want a plot for a
specific observation, you must specify the observation number
(OBSNO) when you invoke the macro.  The macro is invoked as follows:

   %lifehaz(outest=name1,out=name2,xbeta=name3,obsno=1);
   
Author: Paul D. Allison, U. of Pennsylvania, allison@ssc.upenn.edu.   

********************************************************************/
data;
  set &outest;
  call symput('time',_NAME_);
run;
proc means data=&out noprint;
  var &time &xbeta;
  output out=_c_ min(&time)=min max(&time)=max mean(&xbeta)=mean;
run;
data;
  set &outest;
  call symput('model',_dist_);
  s=_scale_;
  d=_shape1_;
  _y_=&obsno;
  set _c_ (keep=min max mean);
  if _y_=0 then m=mean;
  else do;
    set &out (keep=&xbeta) point=_y_;
    m=&xbeta;
  end;
  inc=(max-min)/300;
  g=1/s;
  alph=exp(-m*g);
  _dist_=upcase(_dist_);
if _dist_='LOGNORMAL' or _dist_='LNORMAL'  then do;
  do t=min to max by inc;
  z=(log(t)-m)/s;
  f=exp(-z*z/2)/(t*s*sqrt(2*3.14159));
  Surv=1-probnorm(z);
  h=f/Surv;
  output;
  end;
end;
else if _dist_='GAMMA' then do;
  k=1/(d*d);
  do t=min to max by inc;
  u=(t*exp(-m))**(1/s);
  f=abs(d)*(k*u**d)**k*exp(-k*u**d)/(s*gamma(k)*t);
  Surv=1-probgam(k*u**d,k);
  if d lt 0 then Surv=1-Surv;
  h=f/Surv;
  output;
  end;
end;
else if _dist_='WEIBULL' or _dist_='EXPONENTIAL' or _dist_='EXPONENT'  then do;
  do t=min to max by inc;
  h=g*alph*t**(g-1);
  output;
  end;
end;
else if _dist_='LLOGISTIC' or _dist_='LLOGISTC' then do;
  do t=min to max by inc;
  h=g*alph*t**(g-1)/(1+alph*t**g);
  output;
  end;
end;
else put 'ERROR:DISTRIBUTION NOT FITTED BY LIFEREG';
run;
proc gplot;
  plot h*t / haxis=axis2 vaxis=axis1 vzero;
  symbol1 i=join v=none c=black;
  axis1 label=(f=titalic angle=90 'Hazard');
  axis2 label=(f=titalic justify=c 'time' f=titalic justify=c "&model");
run; quit;
%mend lifehaz;


data f532.FINAL2;
set f532.final;
if heduc = '12-15 years' then hubeduc = 1;
if heduc = '< 12 years' then hubeduc = 0;
if heduc = '16+ years' then hubeduc = 2;
if hubeduc = 0 then educlow = 1;
else educlow = 0;
if hubeduc = 1 then educmid = 1;
else educmid = 0;
if heblack = 'No' then hubblack = 0;
if heblack = 'Yes' then hubblack = 1;
if mixed = 'No' then mixed2 = 0;
if mixed = 'Yes' then mixed2 = 1;
age_at_event = age+ years;
run;


data f532.inter3;
set f532.inter3;
if hubeduc = 0 then elow = 1;
else elow = 0;
run;

proc corr data = f532.inter3;
var age age^2 age^3;
run;

proc sort data = f532.inter3;
by agegroup divorce;
run;

proc freq data = f532.inter3;
tables agegroup*divorce;
run;

proc means data = f532.inter3 median;
var years;
by agegroup;
where divorce = 1;
run;

proc sort data = f532.FINAL2;
by age hubeduc hubblack mixed2;
run;

proc freq data = f532.FINAL2;
tables hubeduc hubblack mixed2;
run;

proc freq data = work.final;
tables heduc heblack mixed;
run;
run;

proc means data = f532.FINAL2;
run;

/*kaplan meier and epachnikov smoothed curves*/
ods graphics on;
proc lifetest data = f532.inter3 plots = (h(bw = 5));
strata agegroup;
	time years*divorce(0);
	run;
ods graphics off;

/* life table*/
proc lifetest data = f532.FINAL2 method = life plots = (s,h) intervals = 0 to 60 by 5;
	time  years*divorce(0);
	run;

/* univariate testing */

proc lifetest data = f532.FINAL2;
	strata hubeduc;
	time years *divorce(0);
	test age income mixed2 hubblack;
	
	run;

	proc lifetest data = f532.inter3;
	strata agegroup;
	time years*divorce(0);
	test agegroup;
	run;



	/*parametric models*/


/* forward selected model*/:


ods graphics on;
proc lifereg data = f532.FINAL_interactions  outest = out01;
	class hubeduc;
	model years*divorce(0) = income age mixed2 hubeduc hubblack  income_elow age2 
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
	run;
ods graphics off;


/* backwards selected model*/

	/* original*/
proc lifereg data = f532.FINAL_interactions  outest = out01;
	class hubeduc mixed2 ;
	model years*divorce(0) = income age mixed2 hubeduc hubblack age_elow age_emid income_elow mixed_age age2 income3
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
	run;

/* adjusted */

/* remove age_low, age_emid, hubblack, income3, */
proc lifereg data = f532.FINAL_interactions  outest = out01;
	class hubeduc;
	model years*divorce(0) = income age mixed2 hubeduc income_elow mixed_age age2 
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
run;
/* removed mixed_age */
ods graphics on;
proc lifereg data = f532.FINAL_interactions  outest = out01;
	class hubeduc;
	model years*divorce(0) = income age mixed2 hubeduc income_elow age2 
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
run;
ods graphics off;



/* log-normalf final */
proc lifereg data = f532.inter3 outest = out1;
	class agegroup hubeduc;
	model years*divorce(0) =  mixed2 hubeduc income income_elow  agegroup/dist = lognormal;
output out = out2 xbeta = lp;

run;

%lifehaz(outest = out1, out = out2,  obsno = 0, xbeta = lp);


proc lifereg data = f532.inter3;
	class agegroup hubeduc;
	model years*divorce(0) =  mixed2 hubeduc income_ehigh income_emid income_elow  agegroup/dist = lognormal;
lsmeans agegroup hubeduc/diff;
output out = f532.LNdiag  p = pred xbeta = xbeta;
run;

proc means data = f532.lndiag;
var years;
run;

proc sort data = f532.lndiag;
by descending pred xbeta;
run;

proc print data = f532.lndiag (obs = 21);
var mixed2 hubeduc income age pred xbeta;
run;










/* cox models 
*/


/* ph assumption testing */
proc phreg data = f532.FINAL2;
class hubeduc (ref = '1');
model years*divorce(0) = age income mixed2 hubeduc hubblack;
output out = resids ressch = sch_age sch_income sch_mixed sch_educ sch_black;
run;

proc phreg data = f532.FINAL2;
class hubeduc (ref = '1');
model years*divorce(0) = age income mixed2 hubeduc hubblack;
assess ph/resample;
run;

proc corr data = resids;
var sch_age sch_income sch_mixed sch_educ sch_black;
with years;
run;

proc phreg data = f532.FINAL2;
class hubeduc;
model years*divorce(0) = age income mixed2 hubeduc hubblack age_time income_time mixed_time black_time educ_time;
age_time = age * years;
income_time = income* years;
mixed_time = mixed2 * years;
educ_time = hubeduc * years;
black_time = hubblack*years;
run;








proc phreg data = f532.inter3;
	model years*divorce(0) = agescaled income mixed2 hubeduc hubblack black_t blackelow blackemid  mixedelow mixedemid  agesc_elow agesc_emid  income_elow income_emid black_mixed black_age black_income mixed_agesc mixed_income agesc_income agescaled2 agescaled3 income2 income3   
/ selection = backwards include = 6;
	black_t = hubblack *years;
	run;
ods graphis off;

data f532.inter3;
set f532.inter3;
loginc = log(income);
run;


ods graphics on;
proc phreg data = f532.inter3 plots(overlay = row)=s;
class hubeduc(ref = '1');
model years*divorce(0) =  mixed2 hubeduc hubblack  income income3 income_elow mixed_agesc agesc_elow agescaled agescaled2 agescaled3;
output out= f532.cox_infl ld = lddiv dfbeta = dmix deduc dblack dinc dinc3 dinclow dmixage dagelow dscaled1 dscaled2 dscaled3;
run;
ods graphics off;

proc means data = f532.cox_infl;
run;

proc sort data = f532.cox_infl;
by DESCENDING lddiv;
run;

proc print data = f532.cox_infl (obs = 10);
run;


proc phreg data = f532.inter3;
class hubeduc (ref = '1');
model years*divorce(0) = mixed2 hubeduc hubblack black_t agesc_elow income income_elow income3 mixed_agesc agescaled agescaled2 agescaled3;
black_t = hubblack*years;
run;

proc phreg data = f532.inter3;
class hubeduc (ref = '1') agegroup;
model years*divorce(0) = mixed2 hubeduc hubblack agesc_elow income income_elow income3 mixed_agesc agegroup;
assess ph / resample;
run;
