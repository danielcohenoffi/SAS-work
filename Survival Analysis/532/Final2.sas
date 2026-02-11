libname f532 '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\final532';

data f532.final;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\final532';
run;

proc corr data = f532.final;
var divorce years;
run;


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
set f532.inter2;
agegroup = 0;
if age > 20 then agegroup = 1;
if age > 22 then agegroup = 2;
if age > 24 then agegroup = 3;
if age > 26 then agegroup = 4;
if age > 28 then agegroup = 5;
if age > 30 then agegroup = 6;
run;

data cirrf312;
	set cirr;
	if case le 312;	
	
	if case le 161 then trans=1;
	else trans=0;
	years=days/365;

run;
run;


proc princomp data = f532.inter2 out = f532.ortho_poly;
	var agescaled agescaled2 age3scaled;
	run;

	proc print data = f532.ortho_poly (obs = 10);
	run;
\
proc corr data = f532.inter3;
var age age^2 age^3;
run;


proc corr data = f532.final2;
var age_at_event age;
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
proc lifetest data = f532.FINAL2 plots = (h(bw = 5));
	time years *divorce(0);
	run;
ods graphics off

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


proc corr data = f532.ortho_poly;
var prin1 prin2 prin3;
run;
/* log-normal */
proc lifereg data = f532.inter3;
	model years*divorce(0) =  mixed2 hubeduc income income_elow agescaled agescaled2 agescaled3/dist = lognormal;
probplot;
run;

proc lifereg data = f532.inter3;
	class agegroup;
	model years*divorce(0) =  mixed2 hubeduc income income_elow agegroup/dist = lognormal;
	lsmeans agegroup/diff;
probplot;
run;

proc means data = f532.inter3;
var age agegroup;
run;



proc reg data = f532.inter3;
model years = age age2 age3;
run;

data f532.age_duration_predictions;
do age = 18 to 78 by 5;
age2 = age**2;
age3 = age**3;

prin1 = 0.575*age + .58 *age2 + .58*age3;
prin2 = 0.71*age - 0.004*age2 +0.7*age3;
prin3 = 0.40*age - 0.82*age2 + .41*age3;
log_duration = 3.32 + .11*prin1 -8.6*prin2 - 84.5 *prin3;

predicted_duration = exp(log_duration);
output;
end;
run;

proc means data = f532.decade;
run;

proc print data = f532.age_duration_predictions;
	var age prin1 prin2 prin3 log_duration;
	run;

proc means data = f532.inter2;
run;

proc corr data = f532.inter2;
var agescaled agescaled2 agescaled3 age age2 age3;
run;


ods graphics on;
proc lifereg data = f532.FINAL2 outest = out01;
	class hubeduc mixed2 ;
	model years*divorce(0) = age income mixed2 hubeduc 
/dist = gamma;
	output out = out02 xbeta = lp;
lsmeans hubeduc/diff;
	probplot;
	run;
ods graphics off;

data f532.lnorm_res;
set lnorm_res;
run;

proc contents data = lnorm_res;
run;

proc corr data =  f532.lnorm_res;
var reds years;
run;

proc corr data =  f532.gamma_reds;
var reds years;
run;

proc sgplot data = f532.lnorm_res;
scatter x = years y = reds / jitter;
loess x = years y = reds;
run;
proc sgplot data = f532.gamma_reds;
scatter x = years y = reds / jitter;
loess x = years y = reds;
run;



/* cox models 
*/

proc phreg data = f532.FINAL2;
class hubeduc (ref = '1');
model years*divorce(0) = age income mixed2 hubeduc;
output out = resids ressch = sch_age sch_income sch_mixed sch_educ;
run;

proc phreg data = f532.FINAL2;
class hubeduc (ref = '1');
model years*divorce(0) = age income mixed2 hubeduc;
output out = resids ressch = sch_age sch_income sch_mixed sch_educ;
run;

proc corr data = resids;
var sch_age sch_income sch_mixed sch_educ;
with years;
run;

proc phreg data = f532.FINAL2;
class hubeduc;
model years*divorce(0) = age income mixed2 hubeduc age_time income_time mixed_time;
age_time = age * years;
income_time = income* years;
mixed_time = mixed2 * years;
educ_time = hubeduc * years;
run;

proc phreg data = f532.FINAL2;
class hubeduc (ref = '1');
model years*divorce(0) = age income mixed2 hubeduc;
baseline out = base_hazard survival = s hazard = h /method = pl
run;




proc means data = f532.cox_infl;
run;
proc phreg data = f532.FINAL_interactions;
	model years*divorce(0) = age income mixed2 hubeduc hubblack  blackelow blackemid  mixedelow mixedemid  age_elow age_emid  income_elow income_emid black_mixed black_age black_income mixed_age mixed_income age_income age2 age3 income2 income3
/ selection = score include = 5;
	run;
ods graphics off;


/* no time dependent covariates for parametric models*/
proc phreg data = f532.FINAL_interactions;
	model years*divorce(0) = age income mixed2 hubeduc hubblack  blackelow blackemid  mixedelow mixedemid  age_elow age_emid  income_elow income_emid black_mixed black_age black_income mixed_age mixed_income age_income age2 age3 income2 income3
/ selection = forwards include = 5;
	
	run;
ods graphics off;




proc phreg data = f532.FINAL_interactions;
	model years*divorce(0) = age income mixed2 hubeduc hubblack  blackelow blackemid  mixedelow mixedemid  age_elow age_emid  income_elow income_emid black_mixed black_age black_income mixed_age mixed_income age_income age2 age3 income2 income3
age_t income_t mixed_t educ_t black_t / selection = score include = 5;
	age_t = age*years;
	income_t = income*years;
	mixed_t = mixed2*years;
	educ_t = hubeduc*years;
	black_t = hubblack *years;
	run;
ods graphics off;





/* old code jail

ods graphics on;
proc lifereg data = f532.FINAL2;
	class hubeduc mixed2 hubblack;
	model years*divorce(0) = age income mixed2 hubeduc 
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
	run;
ods graphics off;

ods graphics on;
proc lifereg data = f532.FINAL_interactions plots = (all);
	class hubeduc mixed2;
	model years*divorce(0) = age income mixed2 hubeduc income_elow
/dist = lognormal;
	run;
ods graphics off;


/*removed all interactions, kept age_polynomials*/
ods graphics on;
proc lifereg data = f532.FINAL_interactions;
	class hubeduc;
	model years*divorce(0) = age income mixed2 hubeduc age2 age3
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
	run;
ods graphics off;

/* with only interaction with being income_elow */

ods graphics on;
proc lifereg data = f532.Final_interactions;
	class hubeduc;
	model years*divorce(0) = age income mixed2 hubeduc income_emid income_ehigh age2 age3 
/dist = gamma;
lsmeans hubeduc/diff;
	probplot;
	run;
ods graphics off;


/* using all interactions and polynomial terms, ugly code jail*/
ods graphics on;
proc lifereg data = f532.FINAL_interactions;
	model years*divorce(0) = age income mixed2 hubblack hubeduc  blackelow blackemid  mixedelow mixedemid  age_elow age_emid  income_elow income_emid black_mixed black_age black_income mixed_age mixed_income age_income age2 age3 income2 income3
/dist = gamma selection = stepwise;
	
	run;
ods graphics off;



data f532.discrete;
set f532.every_year_data;
rage_start = round(age_start);
rage_now = round(agenow); 
run;




proc lifereg data = f532.decade;
	class hubeduc mixed2 decade;
	model years*divorce(0) = age income mixed2 hubeduc decade
/dist = lognormal;
lsmeans hubeduc/diff;
lsmeans decade/diff;
	probplot;
	run;
ods graphics off;

