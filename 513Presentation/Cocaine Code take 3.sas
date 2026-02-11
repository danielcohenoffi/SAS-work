libname cocaine '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513Presentation';


data cocaine.data1;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513Presentation\finalcoke';
if med_sub > 0 then med_sub_nonzero_value = med_sub;
if med_sub > 0 then med_sub_nonzero = 1;
else med_sub_nonzero = 0;
run;


proc contents data = cocaine.data1;
run;

proc means data = cocaine.data1;
run;

proc sort data = cocaine.month0;
by patno;
run;

proc sort data = cocaine.month6;
by patno;
run;

data cocaine.change_score;
merge cocaine.month6 (in = a rename = (med_sub = score6));
merge cocaine.month0 (in = b rename = (med_sub = score0));
by patno;
if a and b;
change_med = score6 - score0;
score6count = score6*90;
score0count = score0*90;
change_med_count = change_med*90;
keep change_med_count patno txname tx_cond site gender sex crack score0 score6 change_med gths daysused score6count score0count;
run;


proc contents data = cocaine.change_score;
run;

proc means data = cocaine.change_score;
run;

proc freq data = cocaine.change_score;
tables change_med;
run;

proc univariate data = cocaine.change_score normal;
var change_med;
histogram /normal;
run;

proc glm data = cocaine.change_score;
class site txname;
model change_med = site*txname;
means site*txname /hovtest;
run;

proc mixed data = cocaine.change_score plots = all;
class txname site;
model change_med = txname site daysused crack gender gths /ddfm = satterthwaite;
lsmeans txname /adjust = tukey;
run;



proc mixed data = cocaine.change_score plots = all;
where change_med_count not = 0;
class txname site;
model change_med_count = txname|site daysused crack gender gths score0count /ddfm = satterthwaite solution;
lsmeans txname /adjust = tukey;
*repeated / group = site;
run;

proc genmod data = cocaine.change_score plots = none;
where change_med_count NOT = 0 ;
class txname site;
model score6count = txname site daysused crack gender gths score0count /dist = tweedie type3 type1 ;
*zeromodel txname|site daysused crack gender gths score0count;
lsmeans txname /adjust = tukey;
*slice txname*site;
run;


proc genmod data = cocaine.change_score plots = none;
class txname site;
model change_score_count = txname|site daysused crack gender gths score0count /dist = tweedie type3 type1;
lsmeans txname /adjust = tukey;
run;


proc reg data = cocaine.change_score;
model score6count = score0count;
run;


data cocaine.data1;
set cocaine.data1;
change = 

ods select histogram;
proc univariate data = cocaine.month3;
var med_sub_nonzero tx_cond emp_sub alc_sub dru_sub leg_sub fam_sub psy_sub daysused bdi gsi bai sighd17 suipu suipr ars beh_ars
bel_ars basa ham27 iip domi vind cold soav noas expl ovnu intr M0ASIDR M0ASIPS PS_HAM17 M0ALU30 M0COC30 M0ASIAL M0ASILE M0ASIEM M0ASIFA M0ASIMD 
PSBDI PSGSI PS_DOMI PS_VIND PS_SOAV PS_NOAS PS_EXPL PS_OVNU PS_INTR PS_ARS PS_BEH_ARS PS_SUIPU PS_SUIPR 
PVDAYS DCENSOR ZM0 GENDER M0CPI RACE MAR_STAT JOB CRACK EDUCATE COMPLETE GTHS;
histogram;
run;


data cocaine.month0;
set cocaine.data1;
if month = 0 then output;
run;


data cocaine.month6;
set cocaine.month6;
med_sub_count = med_sub*90;
run;

proc freq data = cocaine.month6;
tables med_sub_count;
run;

proc genmod data = cocaine.month6;
class txname site;
model med_sub_count = txname|site daysused /dist = zinb type3;
zeromodel txname site daysused;
lsmeans txname / adjust = tukey;
run;

proc genmod data = cocaine.month6;
class txname site;
model med_sub_count = txname|site crack gender gths txname*daysused txname*gender txname*crack txname*gths /dist = zip scale = pearson type3;
zeromodel txname site gender gths crack ;
lsmeans txname / adjust = tukey;
run;



proc means data = cocaine.month3;
*where med_sub_nonzero = 1;
var med_sub;
run;

proc mixed data = cocaine.month0;
class site;
model med_sub = site /ddfm = satterthwaite;
repeated /group = site;
lsmeans site /cl pdiff adjust = tukey;
ods output lsmeans = cocaine.lsmeanssite1;
run;

proc mixed data = cocaine.month0;
class tx_cond gender site;
model med_sub = tx_cond|site gender crack daysused /ddfm = satterthwaite;
repeated /group = site;
lsmeans site /cl pdiff adjust = tukey;
ods output lsmeans = cocaine.lsmeanssite2;
run;


proc mixed data = cocaine.month0;
class tx_cond gender site;
model med_sub = tx_cond|site|gender crack daysused /ddfm = satterthwaite;
repeated /group = site;
lsmeans site /cl pdiff adjust = tukey;
ods output lsmeans = cocaine.lsmeanssite3;
run;



proc sgpanel data=cocaine.lsmeanssite1;
   scatter x=SITE y=estimate /
           yerrorlower=Lower yerrorupper=Upper
           markerattrs=(symbol=circlefilled size=8);
   colaxis label="Site";
   rowaxis label="Predicted MED_SUB";
   title "Site LSMEANS Across Different Model Specifications, Month3";
run;

proc glm data = cocaine.month3;
class site;
model med_sub = site;
lsmeans site /cl pdiff adjust = tukey;
run;

proc glm data = cocaine.month6;
class site;
model med_sub = site;
lsmeans site /cl pdiff adjust = tukey lines;
run;

proc sort data = cocaine.month0;
by site tx_cond;
run;

proc means data = cocaine.month0;
var med_sub;
by site tx_cond;
run;

proc freq data = cocaine.month0;
tables site*tx_cond;
run;

proc univariate data = cocaine.month3 normal;
var med_sub;
histogram;
run;

proc freq data = cocaine.month3;
tables med_sub;
run;

proc contents data = cocaine.data1;
run;

proc transreg data = cocaine.MONTH3 maxiter = 1000 ;
where med_sub_nonzero = 1;
model boxcox(med_sub) = class(tx_cond|site);
run;



data cocaine.altered;
set cocaine.month3;
if med_sub = 0 then med_sub_altered = 0.001;
else if med_sub > 0 then med_sub_altered = med_sub;
med_sub_boxcox = med_sub_altered ** -.25;
run;

proc univariate data = cocaine.altered normal;
var med_sub_boxcox;
histogram;
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

run;

proc means data = cocaine.month3;
where med_sub_nonzero = 1;
run;

proc glmselect data = cocaine.month3;
class tx_cond crack site gender gths;
where med_sub_nonzero = 1;
model med_sub  = tx_cond crack site gender
emp_sub alc_sub dru_sub leg_sub fam_sub psy_sub daysused
M0ASIDR 
M0ASIPS 
PS_HAM17 
M0ALU30 
M0COC30 
M0ASIAL 
M0ASILE 
M0ASIEM 
M0ASIFA 
M0ASIMD 
PSBDI 
PSGSI 
ps_SUIPR 
PVDAYS 
CENSOR 
DEDAYS 
DCENSOR 
ZM0 
GENDER 
AGE 
M0CPI 
RACE 
MAR_STAT 
JOB 
CRACK 
EDUCATE 
COMPLETE 
SITES 
GTHS /selection = backward include = 4;
run; 

proc glmselect data = cocaine.month3;
class tx_cond crack site gender;
where med_sub_nonzero = 1;
model med_sub = tx_cond crack site gender EMP_SUB|daysused|m0cpi|complete / selection = backward include = 4;


proc glm data = cocaine.month3;
class tx_cond crack site gender;
where med_sub_nonzero = 1;
model med_sub = tx_cond;
means tx_cond /hovtest;
run;

proc glm data = cocaine.month3;
class tx_cond crack site gender;
model med_sub = site;
means site /hovtest;
run;

proc glm data = cocaine.month3;
class tx_cond crack site gender;
where med_sub_nonzero = 1;
model med_sub = gender;
means gender /hovtest;
run;


ods trace on;
proc mixed data = cocaine.month3 plots = none;
where med_sub_nonzero = 1;
class tx_cond crack site gender;
model med_sub = tx_cond site crack gender EMP_SUB daysused m0cpi complete/ddfm = satterthwaite;
lsmeans tx_cond/ cl pdiff;
repeated/ group = site;
run;
ods trace off;

proc mixed data = cocaine.month3 plots = none;
class tx_cond crack site gender;
model med_sub = tx_cond site crack gender EMP_SUB daysused m0cpi complete/ddfm = satterthwaite;
lsmeans tx_cond/cl pdiff;
repeated / group = site;
run;



proc mixed data = cocaine.month3 plots = none;
where med_sub_nonzero = 1;
class tx_cond crack site gender;
model med_sub = tx_cond|site crack gender EMP_SUB daysused m0cpi complete/ddfm = satterthwaite ;
repeated / group = site;
*lsmeans site*tx_cond/slice = tx_cond slice = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
*lsmeans site*tx_cond /cl pdiff  adjust = tukey;
ods output diffs = cocaine.twowaydiffs;
run;

proc contents data = cocaine.twowaydiffs;
run;

/* Tukey adjustment is overkill with two way comparisons, because it includes 
comparisons that differ wrt both factors. A more careful bonferroni approach can be considered. 
the table has a total of 206 observations, with 10 between site only comparisons and 6 between treatment.
There are 4 treatments and 5 sites. 
Within each site there are 4 choose 2 = 6 within site comparisons, for 30 total within site treatment comparisons
Within each treatment there are 5 choose 2 = 10 within treatment comparisons, for 50 total within site treatment comparisons
Considering the sum of 80 comparisons of interest, bonferroni of 80 seems reasonable*/


proc print data = cocaine.twowaydiffs;
where site = _site and probt < 0.00167;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.twowaydiffs;
where tx_cond = _tx_cond and probt <0.00125;
title "Within Treatment Site differences";
run;

proc mixed data = cocaine.month3 plots = none;
class tx_cond crack site gender;
model med_sub = tx_cond|site crack gender EMP_SUB daysused m0cpi complete /ddfm = satterthwaite;
repeated / group = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
lsmeans site*tx_cond /cl pdiff adjust = tukey;
ods output diffs = cocaine.twowaydiffsw0;
run;

proc print data = cocaine.twowaydiffs;
where site = _site and probt < 0.00167;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.twowaydiffs;
where tx_cond = _tx_cond and probt <0.00125;
title "Within Treatment Site differences";
run;



proc mixed data = cocaine.month3 plots = none;
*where med_sub_nonzero = 1;
class tx_cond crack site gender;
model med_sub = tx_cond|site|gender;* crack EMP_SUB daysused m0cpi complete/ddfm = satterthwaite;
*repeated / group = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
lsmeans site*tx_cond /cl pdiff adjust = tukey;
ods output diffs = cocaine.threewaydiffs;
run;

proc print data = cocaine.threewaydiffs;
where site = _site and probt < 0.05;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.threewaydiffs;
where tx_cond = _tx_cond and probt <0.05;
title "Within Treatment Site differences";
run;




proc mixed data = cocaine.month3 plots = none;
class tx_cond crack site gender;
model med_sub = tx_cond|site|gender crack EMP_SUB daysused m0cpi complete/ddfm = satterthwaite;
repeated / group = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
lsmeans site*tx_cond /cl pdiff adjust = tukey;
lsmeans site*tx_cond*gender /cl pdiff adjust = tukey;
ods output diffs = cocaine.threewaydiffsw0;
run;




proc print data = cocaine.threewaydiffsw0;
where site = _site and probt < 0.05;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.threewaydiffsw0;
where tx_cond = _tx_cond and probt <0.05;
title "Within Treatment Site differences";
run;

proc genmod data = cocaine.month6;
class tx_cond site crack;
model med_sub = tx_cond|site crack  gender daysused/ dist = zinb type3 maxiter = 2000 scale = pearson;
zeromodel tx_cond|site crack  gender daysused;
ods exclude MeanPlot;
lsmeans tx_cond /cl pdiff adjust = tukey;
*lsmeans site /cl pdiff adjust = tukey;
*lsmeans tx_cond*site/cl pdiff adjust = tukey;
run;





proc sort data = cocaine.month3;
by site txname;
run;

proc means data = cocaine.month3;
var med_sub;
by site;
run;
