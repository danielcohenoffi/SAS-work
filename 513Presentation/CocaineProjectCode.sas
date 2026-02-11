libname cocaine '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513Final';

data cocaine.data1;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513Final\finalcoke';
if med_sub > 0 then med_sub_nonzero_value = med_sub;
if med_sub > 0 then med_sub_nonzero = 1;
else med_sub_nonzero = 0;
run;

ods select histogram;
proc univariate data = cocaine.month3;
var med_sub_nonzero tx_cond emp_sub alc_sub dru_sub leg_sub fam_sub psy_sub daysused bdi gsi bai sighd17 suipu suipr ars beh_ars
bel_ars basa ham27 iip domi vind cold soav noas expl ovnu intr M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI PSGSI PS_DOMI PS_VIND PS_SOAV PS_NOAS PS_EXPL PS_OVNU PS_INTR PS_ARS PS_BEH_ARS PS_SUIPU PS_SUIPR 
PVDAYS DCENSOR ZM0 GENDER M0CPI RACE MAR_STAT JOB CRACK EDUCATE COMPLETE GTHS;
histogram;
run;




proc contents data = cocaine.data1;
run;


proc means data = cocaine.data1;
run;

proc freq data = cocaine.data1;
tables month;
run;

data cocaine.month3;
set cocaine.data1;
where month = 3;
output;
run;

data cocaine.month6;
set cocaine.data1;
where month = 6;
output;
run;

proc means data = cocaine.data1;
var med_sub_altered;
run;

proc means data = cocaine.month3;
var med_sub_nonzero;
run;
ods trace on;
proc univariate data = cocaine.month3 normal;
var med_sub_nonzero;
histogram;
run;
ods trace off;

proc freq data = cocaine.month3;
tables month med_sub_altered;
run;

proc freq data = cocaine.month6;
tables month;
run;


/* potential covariates and interactive terms, choose best from each cluster
Just toss in here rather than attempt to study a correlation matrix*/
proc varclus data = cocaine.month3;
var M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI PSGSI PS_IIP PS_DOMI PS_VIND PS_SOAV PS_NOAS PS_EXPL PS_OVNU PS_INTR PS_ARS PS_BEH_ARS PS_SUIPU PS_SUIPR 
PVDAYS CENSOR DCENSOR ZM0 GENDER M0CPI RACE MAR_STAT JOB CRACK EDUCATE COMPLETE SITES GTHS;
run;

proc reg data = cocaine.month3;
model med_sub =  M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI PSGSI PS_IIP PS_DOMI PS_VIND PS_SOAV PS_NOAS PS_EXPL PS_OVNU PS_INTR PS_ARS PS_BEH_ARS PS_SUIPU PS_SUIPR 
PVDAYS CENSOR DCENSOR ZM0 GENDER M0CPI RACE MAR_STAT JOB CRACK EDUCATE COMPLETE SITES GTHS /vif;
run;

/*remove ps_iip and censor, model significant at 10% level, only gender signficant. 
Interpreting nothing due to type 1 error potential */
proc reg data = cocaine.month3;
model med_sub =  M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI PSGSI PS_DOMI PS_VIND PS_SOAV PS_NOAS PS_EXPL PS_OVNU PS_INTR PS_ARS PS_BEH_ARS PS_SUIPU PS_SUIPR 
PVDAYS DCENSOR ZM0 GENDER M0CPI RACE MAR_STAT JOB CRACK EDUCATE COMPLETE SITES GTHS /vif;
run;



/* model not significant but no vif*/
proc logistic data = cocaine.month3;
model MED_SUB = ps_iip dcensor zm0 m0alu30 crack m0coc30 ps_ars ps_domi m0asiem /vif;
run;

proc univariate data = cocaine.month3 normal; 
var med_sub;
run;

proc glm data = cocaine.month3 plots(only) = (diagnostics residuals intplot fitplot) ;
class tx_cond;
model med_sub = tx_cond;
means tx_cond/ hovtest;
lsmeans tx_cond/ cl adjust = tukey lines;
estimate intercept 1;
ods exclude "grand mean" lsmeansplots;
output out = cocaine.diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;



proc transreg data = cocaine.month3 plots = none;
model boxcox(med_sub_altered) = class(tx_cond);
run;

proc univariate data = cocaine.month3 normal;
var med_sub_altered_negsqrt;
histogram;
run;

/*It's a really really good thing I went over generalized estimating equations yesterday*/

proc logistic data = cocaine.month3;
class tx_cond site;
model med_sub_nonzero = site tx_cond ps_iip dcensor zm0 m0alu30 crack m0coc30 ps_ars ps_domi m0asiem /scale = none aggregate selection = backwards;
run;

proc logistic data = cocaine.month3;
class tx_cond;
model med_sub_nonzero = tx_cond zm0 tx_cond*zm0;
run;

 */emp_sub alc_sub dru_sub leg_sub fam_sub psy_sub daysused bdi gsi bai sighd17 suipu suipr ars beh_ars
bel_ars basa ham27 iip domi vind cold soav noas expl ovnu intr ;


proc logistic data = cocaine.month3;
class site tx_cond /param = ref order = data;
model med_sub_nonzero =   site tx_cond crack  gender emp_sub alc_sub dru_sub leg_sub fam_sub psy_sub daysused  M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI
PVDAYS DCENSOR ZM0 M0CPI RACE MAR_STAT JOB  EDUCATE COMPLETE GTHS /scale = none aggregate selection = backwards include = 4;
run;


proc logistic data = cocaine.month3;
class site tx_cond /param = ref order = data;
model med_sub_nonzero = site|tx_cond|crack|gender|fam_sub|psy_sub|M0ASIPS /scale = none aggregate selection = backwards include = 4;
run;

/* final model*/
proc logistic data = cocaine.month3;
class site tx_cond /param = effect;
model med_sub_nonzero = site tx_cond crack gender fam_sub psy_sub M0ASIPS /scale = none aggregate;
run;


proc logistic data = cocaine.month3;
class site tx_conc 

proc means data = cocaine.month3;
run;


proc reg data = cocaine.month3;
model m0asips = fam_sub psy_sub /vif;
run;

proc transreg data = cocaine.month3;
model boxcox(m0asips) = (sighd17|soav|ps_suipr);
run;

proc corr data = cocaine.month3;
var m0asips fam_sub psy_sub;
run;
