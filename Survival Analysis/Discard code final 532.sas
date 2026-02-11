* old code from final*;

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
proc reg data = f532.FINAL_interactions;
	model years) = age income mixed2 hubblack hubeduc  blackelow blackemid  mixedelow mixedemid  age_elow age_emid  income_elow income_emid black_mixed black_age black_income mixed_age mixed_income age_income age2 age3 income2 income3
/dist = gamma selection = stepwise;

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


proc phreg data = f532.inter3;
class hubeduc (ref = '1');
model years*divorce(0) = mixed2 hubeduc hubblack agesc_elow income income_elow income3 mixed_agesc agescaled agescaled2 agescaled3;
output out = f532.resids ressch = schmix scheduc schblack schagesclow schincome schincomeelow schincome3 schmixedagesc schagesc aschagescw schagesc3 ;
run;


proc princomp data = f532.inter2 out = f532.ortho_poly;
	var agescaled agescaled2 age3scaled;
	run;

	proc print data = f532.ortho_poly (obs = 10);
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
