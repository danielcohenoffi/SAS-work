libname cocaine '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513Presentation';

data cocaine.data1;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513Presentation\finalcoke';
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
model med_sub_nonzero =   site tx_cond crack gender emp_sub alc_sub dru_sub leg_sub fam_sub psy_sub daysused  M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI
PVDAYS DCENSOR ZM0 M0CPI RACE MAR_STAT JOB  EDUCATE COMPLETE GTHS /scale = none aggregate selection = backwards include = 4 alpha = 0.20;
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

proc logistic data = cocaine.month3;
class site tx_cond /param = ref order = data;
model med_sub_nonzero = site tx_cond crack gender fam_sub|psy_sub|M0ASIPS /scale = none aggregate selection = backwards include = 4;
run;

proc logistic data = cocaine.month3;
class site tx_cond /param = ref order = data;
model med_sub_nonzero =  fam_sub psy_sub M0ASIPs site|tx_cond|crack|gender /scale = none aggregate selection = backward include = 3;
run;



proc logistic data = cocaine.month3;
class site tx_cond /param = ref order = data;
model med_sub_nonzero = site|tx_cond crack gender fam_sub psy_sub M0ASIPS /scale = none aggregate selection = backwards include = 4;
run;

/* final model*/
proc logistic data = cocaine.month3;
class site tx_cond /param = effect;
model med_sub_nonzero = site tx_cond crack gender fam_sub psy_sub M0ASIPS /lackfit scale = none aggregate;
run;

proc logistic data = cocaine.month3;
class tx_cond site;
model med_sub_nonzero = tx_cond|site;
run;

/*p = 0.06 for levene's test of non equal variance with no covars, so break out proc mixed*/
proc glm data = cocaine.month3(where = (med_sub_nonzero = 1));
class site tx_cond crack;
model med_sub_nonzero_value = site*tx_cond*crack gender fam_sub psy_sub M0ASIPS ;
means site*tx_cond*crack/hovtest;
run;


/*p = 0.08755 for levene's test of non equal variance with no covars, txcond only, so break out proc mixed*/
proc glm data = cocaine.month3(where = (med_sub_nonzero = 1));
class tx_cond;
model med_sub_nonzero_value = tx_cond ;
means tx_cond/hovtest;
run;

proc glm data = cocaine.month3transformed;
class crack;
model transformed = crack;
means crack/hovtest;
run;


proc glm data = cocaine.month3transformed;
class tx_cond;
model transformed = tx_cond;
means tx_cond/hovtest;
run;

ods output lsmeans = cellmeansmixed estimates = effectsmixed;
proc mixed data = cocaine.month3 covtest plots = all;
class site tx_cond crack gender;
Model MEd_sub_nonzero_value = site|tx_cond|crack gender fam_sub psy_sub m0asips /s outpm = phatmixed;
repeated/group = tx_cond;
run;





ods output lsmeans = cellmeansmixed estimates = effectsmixed;
proc mixed data = cocaine.month3transformed covtest plots = all;
class site tx_cond crack gender;
Model transformed = site|tx_cond|crack gender fam_sub psy_sub m0asips /s outpm = phatmixed;
repeated/group = tx_cond;
run;

proc print data = phatmixed;
run;

ods select TestsForNormality;
proc univariate data = phatmixed normal;
by tx_cond crack;
run;

proc npar1way data= cocaine.month3 wilcoxon;
class tx_cond;
var med_sub;
run;

proc univariate data = cocaine.month3(where = (med_sub_nonzero = 1)) normal;
var med_sub;
histogram;
run;

proc transreg data = cocaine.month3 maxiter = 1000;
model boxcox(med_sub_nonzero_value) = Class(site|tx_cond) / converge = -1;
run;

data cocaine.month3transformed;
set cocaine.month3;
if med_sub_nonzero = 1 then
transformed = med_sub_nonzero_value **.75;
run;

proc univariate data = cocaine.month3;


proc glm data = cocaine.month3(where = (transformed > 0)) plots(only) = (diagnostics intplot fitplot);
class tx_cond site crack;
model transformed = tx_cond|site|crack gender fam_sub psy_sub m0asips;
run;


proc contents data = cocaine.month3;
run;

data cocaine.beta;
set cocaine.month3;
med_sub_altered = med_sub + 0.000001;
run;

proc glimmix data = cocaine.beta;
class tx_cond site crack;
model med_sub_altered = tx_cond|site crack  gender m0asips / dist = beta ;
ods exclude MeanPlot;
lsmeans tx_cond /cl pdiff adjust = tukey;
lsmeans site /cl pdiff adjust = tukey;
*lsmeans tx_cond*site/cl pdiff adjust = tukey;
run;


/*

proc genmod data = cocaine.month3;
class tx_cond site crack;
model med_sub = tx_cond site crack gender m0asips / dist = tweedie type3 maxiter = 2000;
run;


proc genmod data = cocaine.month3;
class tx_cond site crack;
model med_sub = tx_cond|site crack gender  m0asips / dist = tweedie type3 maxiter = 2000;
run;

proc genmod data = cocaine.month3;
class tx_cond site crack;
model med_sub = tx_cond|crack site gender m0asips / dist = tweedie type3 maxiter = 2000;
run;

proc genmod data = cocaine.month3;
class tx_cond site crack;
model med_sub = tx_cond crack|site gender m0asips / dist = tweedie type3 maxiter = 2000;
run;


proc genmod data = cocaine.month3;
class tx_cond site crack;
model med_sub = tx_cond|site|crack gender  m0asips / dist = tweedie type3 maxiter = 2000;
lsmeans tx_cond / bylevel diff cl adjust = tukey;
lsmeans tx_cond*site /bylevel diff cl adjust = tukey;
lsmeans site /bylevel diff cl adjust = tukey;
output out = cocaine.diagtweedie predicted = predicted pzero = probzero resdev = resdev STDRESCHI = STDRESCHI
STDRESDEV = STDRESDEV;
ods exclude MeanPlot;
run;




lsmeans tx_cond /cl adjust = tukey lines;
lsmeans site /cl adjust = tukey lines;
lsmeans tx_cond*site/ cl adjust = tukey lines;

