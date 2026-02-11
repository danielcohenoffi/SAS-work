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

proc glm data = cocaine.month0;
class tx_cond;
model med_sub = tx_cond;
means tx_cond;
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

proc glmselect data = cocaine.month6;
class tx_cond crack site gender;
where med_sub_nonzero = 1;
model med_sub = tx_cond crack site gender EMP_SUB|daysused|m0cpi|complete / selection = backward include = 4;
run;

proc glm data = cocaine.month6;
class tx_cond crack site gender;
*where med_sub_nonzero = 1;
model med_sub = tx_cond;
means tx_cond /hovtest;
run;

proc glm data = cocaine.month6;
class tx_cond crack site gender;
*where med_sub_nonzero = 1;
model med_sub = site;
means site /hovtest;
run;

proc glm data = cocaine.month6;
class tx_cond crack site gender;
where med_sub_nonzero = 1;
model med_sub = gender;
means gender /hovtest;
run;


ods trace on;
proc mixed data = cocaine.month6 plots = none;
where med_sub_nonzero = 1;
class tx_cond crack site gender;
model med_sub = tx_cond site crack gender EMP_SUB daysused m0cpi complete/ddfm = satterthwaite;
lsmeans tx_cond/ cl pdiff;
repeated/ group = site;
run;
ods trace off;

proc mixed data = cocaine.month6 plots = none;
class tx_cond crack site gender;
model med_sub = tx_cond site crack gender EMP_SUB daysused m0cpi complete/ddfm = satterthwaite;
lsmeans tx_cond/cl pdiff;
repeated / group = site;
run;



proc mixed data = cocaine.month6 plots = none;
where med_sub_nonzero = 1;
class tx_cond(reference = "4") crack site gender;
model med_sub = tx_cond site tx_cond*site crack gender/ noint ddfm = satterthwaite ;
repeated / group = site;
lsmeans site*tx_cond/slice = tx_cond slice = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
lsmeans site*tx_cond /cl pdiff  adjust = tukey;
ods output diffs = cocaine.twowaydiffs6;
run;

proc contents data = cocaine.twowaydiffs6;
run;

/* Tukey adjustment is overkill with two way comparisons, because it includes 
comparisons that differ wrt both factors. A more careful bonferroni approach can be considered. 
the table has a total of 206 observations, with 10 between site only comparisons and 6 between treatment.
There are 4 treatments and 5 sites. 
Within each site there are 4 choose 2 = 6 within site comparisons, for 30 total within site treatment comparisons
Within each treatment there are 5 choose 2 = 10 within treatment comparisons, for 50 total within site treatment comparisons
Considering the sum of 80 comparisons of interest, bonferroni of 80 seems reasonable*/


proc print data = cocaine.twowaydiffs6;
where site = _site and probt < 0.00167;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.twowaydiffs6;
where tx_cond = _tx_cond and probt <0.00125;
title "Within Treatment Site differences";
run;

proc mixed data = cocaine.month6 plots = all;
where med_sub_nonzero = 1;
class tx_cond crack site gender;
model med_sub = tx_cond|site crack gender  /ddfm = satterthwaite;
repeated / group = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
lsmeans site*tx_cond /cl pdiff adjust = tukey;
ods output diffs = cocaine.twowaydiffsw06;
run;

proc print data = cocaine.twowaydiffs6;
where site = _site and probt < 0.00167;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.twowaydiffs6;
where tx_cond = _tx_cond and probt <0.00125;
title "Within Treatment Site differences";
run;



proc mixed data = cocaine.month6 plots = none;
where med_sub_nonzero = 1;
class tx_cond crack site gender;
model med_sub = tx_cond|site|gender crack daysused
 
/  ddfm = satterthwaite;
lsmeans tx_cond/cl pdiff adjust = tukey;
lsmeans site/cl pdiff adjust = tukey;
repeated /group = site;
lsmeans site*tx_cond /cl pdiff adjust = tukey;
ods output diffs = cocaine.threewaydiffs6;
run;

proc print data = cocaine.threewaydiffs6;
where site = _site and probt < 0.05 and probt > 0;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.threewaydiffs6;
where tx_cond = _tx_cond and probt <0.05 and probt > 0;
title "Within Treatment Site differences";
run;



proc freq data = cocaine.month6;
tables gender*site*tx_cond;
run;


proc mixed data = cocaine.month6 plots = none;
class tx_cond crack site gender;
model med_sub = tx_cond|site|gender EMP_SUB m0cpi/ ddfm = satterthwaite;
repeated / group = site;
lsmeans tx_cond/cl pdiff adjust = tukey;
*lsmeans site/cl pdiff adjust = tukey;
*lsmeans site*tx_cond /cl pdiff adjust = tukey;
*lsmeans site*tx_cond*gender /cl pdiff adjust = tukey;
*ods output diffs = cocaine.threewaydiff6sw0;
*ods output lsmeans = cocaine.full_lsmeans3;
run;


proc sgplot data = cocaine.full_lsmeans3;


proc sgpanel data = cocaine.full_lsmeans3;
panelby tx_cond /columns = 4;
vline site /response = estimate group = gender markers;
title "Three way interaction";
run;

proc sgpanel data = cocaine.full_lsmeans3;
panelby tx_cond /columns = 4;
vline site /response = estimate markers;
title "Two way int within 3 way"
run;


proc print data = cocaine.threewaydiff6sw0;
where site = _site and probt < 0.05 and probt > 0 and gender = _gender;
title "Within Site and gender Treatment differences";
run;

proc print data = cocaine.threewaydiff6sw0;
where tx_cond = _tx_cond and probt <0.05 and probt > 0;
title "Within Treatment Site differences";
run;

proc genmod data = cocaine.month6;
class tx_cond site crack gender;
model med_sub = tx_cond|site gender crack daysused/ dist = beta type3 maxiter =10000;
ods exclude MeanPlot;
lsmeans tx_cond /cl pdiff adjust = tukey;
lsmeans site /cl pdiff adjust = tukey;
lsmeans tx_cond*site/cl pdiff adjust = tukey;
*ods output lsmeans = cocaine.full_lsmeans2tweedie6;
*ods output diffs = cocaine.twowaydiffstweedie6;
run;



proc print data = cocaine.twowaydiffstweedie6;
where site = _site and probz < 0.00167;
title "Within Site Treatment Differences";
run;

proc print data = cocaine.twowaydiffstweedie6;
where tx_cond = _tx_cond and probz <0.00125;
title "Within Treatment Site differences";
run;
