libname final '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513FinalExam';


data final.data1;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513FinalExam\fin_p1_25';
raw1 = RCDS2_r1;
raw2 = RCDS2_r2;
rawdiff = raw2-raw1;
adjust1 = RCDS2_a1;
adjust2 = RCDS2_a2;
adjustdiff = adjust2 - adjust1;
run;

data final.data2;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513FinalExam\fin_p2_25';
if additive = "D" then var_group =1;
else var_group = 2;

if additive = "A" then variance = "AC";
if additive = "B" then variance = "B";
if additive = "C" then variance = "AC";
if additive = "D" then variance = "D";
run;

proc sort data = final.data2;
by additive;
run;

proc means data = final.data2;
var etbe_x var_group;
by additive;
run;


data final.data3;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513FinalExam\fin_p3_25';
if race = 1 then racename = "Minority";
if race = 2 then racename = "Non-Minority";
if gender = 1 then sex = "Male";
if gender = 2 then sex = "Female";
if tx = 1 then txname = "Cognitive";
if tx = 2 then txname = "Behavioral";
if tx = 3 then txname = "Paxil";
run;

data final.data4;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513FinalExam\fin_p4_25';
QOL = QOLI_FAMSUPP;
assess = assmnt;
QOL3 = QOLI_FAMSUPP**3;
QOL5 = QOL**5;
if tx = 1 then txname = "Group";
if tx = 2 then txname = "Individual";
run;

proc contents data = final.data1;
run;

proc print data = final.data1;
run;

proc univariate data = final.data1 normal;
var adjustdiff;
histogram;
run;

proc transreg data = final.data1;
model boxcox(adjust2) = class(tx);
run;


proc means data = final.data1;
run;

*ods trace on;
proc glm data = final.data1 plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class tx;
model raw2 = tx;
means tx/hovtest;
lsmeans/cl pdiff;
output out = diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
*ods trace off;
proc means data = final.data1;
by tx;
run;
/*
proc reg data = final.data1;
model rawdiff = raw1;
run;

proc reg data = final.data1;
model raw2 = raw1;
run;
*/



proc freq data = final.data1;
tables tx;
run;

proc glm data = final.data1 plots = none; /*diagnostic plots*/
class tx;
model adjust2 = tx/solution;
lsmeans/cl pdiff;
run;

proc sort data = diag1;
by studentresid;
run;

proc print data = diag1;
run;
proc univariate data = diag1 normal;
var studentresid;
run;

ods trace on;
proc glm data = final.data1; * plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class tx;
model adjust2 = tx /solution;
means tx/hovtest;
lsmeans/cl pdiff;
output out = diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
ods trace off;

/*
proc reg data = final.data1;
model adjustdiff = adjust1;
run;

proc reg data = final.data1;
model adjust2 = adjust1;
run;*/


proc univariate data = diag1 normal;
var studentresid;
histogram;
run;







proc print data = final.data2;
run;


proc glm data = final.data2;
class additive auto driver;
model etbe_x = additive auto driver;
output out = final.simpdiag2 student = student;
estimate "A" intercept 1 additive 1 0 0 0;
estimate "B" intercept 1 additive 0 1 0 0;
estimate "A vs B" additive 1 -1 0 0;
estimate "C" intercept 1 additive 0 0 1 0;
estimate "D" intercept 1 additive 0 0 0 1;
estimate "A vs B VV C vs D" additive 1 -1 1 -1;  
run;

proc univariate data = final.simpdiag2 normal;
histogram;
run;

proc glm data = final.data2;
class additive auto;
model etbe_x = additive|auto;
means additive*auto /hovtest;
output out = final.simpdiag2 student = student;
run;



/*just use the constant variance model man*/
proc mixed data = final.data2 covtest plots = all method = reml cl;
class driver auto additive var_group;
Model ETBE_X = additive /ddfm = satterthwaite s outpm = phatmixed;
lsmeans additive /pdiff cl adjust = tukey ;
ods exclude lsmeansplots;
random driver auto;
estimate "A" intercept 1 additive 1 0 0 0;
estimate "B" intercept 1 additive 0 1 0 0;
estimate "A vs B" additive 1 -1 0 0;
estimate "C" intercept 1 additive 0 0 1 0;
estimate "D" intercept 1 additive 0 0 0 1;
estimate "A vs B VV C vs D" additive 1 -1 1 -1/ cl;  
run;

proc print data = phatmixed;
run;

proc univariate data = phatmixed normal;
var resid;
histogram;
run;


proc mixed data = final.data2 covtest plots = all cl ;
class driver auto additive var_group;
Model ETBE_X = additive /ddfm = satterthwaite s outpm = phatmixed;
lsmeans additive /pdiff cl adjust = tukey ;
ods exclude lsmeansplots;
random driver auto;
repeated / group = var_group;
estimate "A" intercept 1 additive 1 0 0 0;
estimate "B" intercept 1 additive 0 1 0 0;
estimate "A vs B" additive 1 -1 0 0;
estimate "C" intercept 1 additive 0 0 1 0;
estimate "D" intercept 1 additive 0 0 0 1;
estimate "AB vs CD" additive 1 1 -1 -1/ cl;  
parms (17.84) (14.1822) (0.00003) (14.93) /noiter;
run;


proc univariate data = final.fixeddiag2 normal;
var studentresid;
run;

proc sgplot data = final.fixeddiag2;
scatter x = predicted y = residual;
run;


proc contents data = final.data3;
run;


proc means data = final.data3;
run;

/*hov and normality tests*/
ods trace on;
proc glm data = final.data3 plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class tx;
model aae = tx; /*testing as one way anova first for hovtest*/
means tx / welch hovtest;
lsmeans tx /pdiff cl adjust = tukey lines;
estimate "grand mean" intercept 1; /* get grand adjusted mean*/
ods exclude lsmeansplots; /*  declutter output,*/
output out = final.diag3_1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
ods trace off;

proc univariate data = final.diag3_1 normal;
var studentresid;
run;


ods trace on;
proc glm data = final.data3 plots = all;*plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class txname racename sex;
model aae = txname*racename*sex; /*testing as one way anova first for hovtest*/
lsmeans txname*racename*sex /pdiff cl adjust = tukey lines;
means txname*racename*sex / hovtest;
ods exclude lsmeansplots; /*  declutter output,*/
output out = final.diag3_2 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
ods trace off;

proc univariate data = final.diag3_2 normal;
var studentresid;
run;


/*get boxplots*/
proc glm data = final.data3 plots = all; /*diagnostic plots*/
class tx race gender;
model aae = tx*race*gender; /*testing as one way anova first for hovtest*/
means tx*race*gender / hovtest;
ods exclude lsmeansplots; /*  declutter output,*/
output out = final.diag3_2 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;





/*satterthwaite*/
proc mixed data = final.data3 plots = none cl maxiter = 1000;
class txname racename sex;
model aae = txname|racename|sex/ddfm = satterthwaite s outpm = final.phatfull3;
repeated / group = racename*sex*txname;
lsmeans txname /cl pdiff;
lsmeans txname*racename*sex/cl pdiff ;*slice = txname*racename slice = txname*sex ;*slice = txname*sex slice = tx*racename slice = racename*sex;
ods output fitstatistics = final.full_fit3;
ods output lsmeans = final.full_lsmeans3;
ods output diffs = final.satt_diffs_lsmeans;
run;

proc print data = final.satt_diffs_lsmeans;
where txname = _txname and probt < 0.05;
run;



ods trace on;
proc transreg data = final.data3 maxiter = 1000;
model boxcox(aae) = class(tx|race|gender);
run;
ods trace off;

proc sort data = final.phatfull3;
by tx race gender;
run;

ods select histogram;
proc univariate data = final.phatfull3 normal;
var resid;
by tx race gender;
histogram / midpoints = -25 to 25 by 5;
run;

proc sgpanel data = final.full_lsmeans3;
panelby txname /columns = 3;
vline sex /response = estimate group = racename markers;
run;





proc sort data = final.full_lsmeans3;
by txname;
run;

proc sgplot data=final.full_lsmeans3;
  by txname;
  series x=sex y=estimate / group=racename markers;
  highlow x=sex low=lower high=upper / group=racename lowcap=serif highcap=serif;
  yaxis label="Predicted Mean Score";
run;

proc mixed data = final.data3 plots = none cl maxiter = 1000;
class txname racename sex;
model aae = txname racename sex txname*racename txname*sex racename*sex/ddfm = satterthwaite s outpm = final.phatpartial3;
repeated / group = racename*sex*txname;
ods output fitstatistics = final.partial_fit3;
*ods exclude lsmeansplots;
*ods output diffs = final.satt_diffs_lsmeans;
run;



proc print data = final.full_fit3;
title "full";
run;

proc print data = final.partial_fit3;
title "partial";
run;

proc print data = final.satt_diffs_lsmeans;
where tx = _tx and probt < 0.0045;
run;

data final.full_clean;
set final.phatfull3;
rename pred = full_pred resid = full_resid;
run;

data final.reduced_clean;
set final.phatpartial3;
rename pred = reduced_pred resid = reduced_resid;
run;

proc sort data = final.full_clean;
by patid;
run;

proc sort data = final.reduced_clean;
by patid;
run;

data final.interaction_effects;
merge final.full_clean final.reduced_clean;
by patid;
interaction_effect = full_pred - reduced_pred;
variance_explained = full_resid**2 - reduced_resid**2;
inteffect_over_stderr = interaction_effect/stderrpred;
run;


proc means data = final.interaction_effects mean std min max n;
class txname racename sex;
var aae interaction_effect inteffect_over_stderr;
title "Interaction Effects";
run;


proc print data = final.interaction_effects;
run;


/*containment method*/
proc mixed data = final.data3 plots = none cl maxiter = 1000;
class tx race gender;
model aae = tx|race|gender/ s outpm = phatmixed;
repeated / group = race*gender*tx;
lsmeans tx*race*gender/pdiff adjust = tukey;
lsmeans tx / pdiff adjust = tukey;
lsmeans race /pdiff adjust = tukey;
lsmeans gender /pdiff adjust = tukey;
lsmeans tx*race*gender /slice = tx;
lsmeans tx*race*gender /slice = race;
lsmeans tx*race*gender /slice = gender;
lsmeans tx*race*gender /slice = tx*race;
lsmeans tx*race*gender /slice = tx*gender;
lsmeans tx*race*gender /slice = race*gender; 
run;
ods trace off;


proc print data = final.containment_diff_lsmeans3;
where tx =_tx and probt < 0.0045;
run;


/*constant variance*/
ods trace on;
proc mixed data = final.data3 plots = none;
class tx race gender;
model aae = tx|race|gender;
lsmeans tx*race*gender/pdiff cl adjust = tukey;
ods exclude lsmeansplots;
ods output diffs = final.homvar_diff_lsmeans3;
run;
ods trace off;

proc print data = final.homvar_diff_lsmeans3;
where tx = _tx and probt < 0.0045;
run;




/* question 4*/


proc contents data = final.data4;
run;

proc print data = final.data4;
run;

proc contents data = final.phatmixed4untrans;
run;

proc glm data = final.data4;
class txname;
model qol = txname;
means txname/hovtest;
run;

proc glm data = final.data4;
class assess;
model qol = assess;
means assess/hovtest;
run;





proc mixed data = final.data4 covtest plots = all;
class patno txname assess;
model qol = txname|assess / ddfm = satterthwaite outpm = final.phatmixed4untrans residual;
random patno;
repeated assess / subject=patno type = vc group = tx r rcorr; 
*lsmeans tx /cl pdiff;
*lsmeans assess /cl pdiff;
*lsmeans tx*assess / cl pdiff slice = tx slice = assess adjust = tukey;
run;

proc print data = final.phatmixed4untrans;
run;

proc univariate data = final.phatmixed4untrans normal;
var studentresid;
run;

proc glm data = final.data4;
class txname assess;
model qol = txname*assess;
means txname*assess/hovtest;
run;

proc mixed data = final.data4 covtest plots = none;
class patno tx assess;
model qol = tx|assess / ddfm = satterthwaite outpm = final.phatmixed4cubed residual;
*repeated assess / subject=patno group = tx r rcorr;
repeated / group = tx;
random patno; 
lsmeans tx /cl pdiff;
lsmeans assess /cl pdiff;
*lsmeans tx*assess / cl pdiff slice = tx slice = assess adjust = tukey;
run;

proc sort data = final.phatmixed4cubed;
by tx;
run;

proc univariate data = final.phatmixed4cubed normal;
var studentresid;
histogram;
run;

proc mixed data = final.phacked4cubed covtest plots = all;
where outlier_flag = 0;
class patno tx assess;
model qol3 = tx|assess / ddfm = satterthwaite; 
random patno;
repeated assess / subject=patno group= tx r rcorr; 
lsmeans tx /cl pdiff;
lsmeans assess /cl pdiff;
*lsmeans tx*assess / cl pdiff slice = tx slice = assess adjust = tukey;
run;

proc transreg data = final.phacked4cubed;
where outlier_flag = 0;
model boxcox(qol3) = class(tx|assess patno);
run;


proc sort data = final.phatmixed4untrans;
by studentresid;
run;

data final.phacked4cubed;
set final.phatmixed4cubed;
outlier_flag = abs(studentresid) > 2.1;
run;


proc print data = final.phackedresid;
run;

proc sort data = final.phackedresid;
by tx;
run;

proc univariate data = final.phackedresid normal;
by tx;
var studentresid;
histogram /normal midpoints = -9 to 8 by 0.25;
qqplot studentresid / normal(mu=est sigma=est);
run;

proc print data = final.phatmixed4untrans;
run;

ods trace on;
proc univariate data = final.phatmixed4cubed normal;
var resid;
histogram /normal midpoints = -9 to 8 by 0.25;
qqplot resid / normal(mu=est sigma=est);
run;
ods trace off;

proc contents data = final.phatmixed4;
run;

proc print data = final.phatmixed4;
run;

proc transreg data = final.data4;
model boxcox(qol) = class(tx|assess patno);
run;

quit;
proc freq data=final.data4;
  tables patno*assess*qol / cmh2 scores=rank;
run;

proc mixed data=final.data4;
  class patno;
  model qol = /outpm = resids;
  random patno;;
run;

* ai generated, kind of useless;

proc contents data = final.phatmixed4untrans;
run;


proc rank data = final.data4 out = final.ranked4;
var qol;
ranks rank;
run;

proc means data = final.ranked4;
var rank;
run;

proc mixed data=final.ranked4;
  class tx assess patno;
  model rank = tx|assess /outpm = final.rankedresid residual;
  random patno;
  repeated assess /subject = patno group = tx;
run;

proc glimmix data = final.ranked4;
 class tx assess patno;
  model rank = tx|assess;
  random patno;
run;


proc glimmix data = final.data4;
 class tx assess patno;
  model qol = tx|assess /dist = gamma ddfm = satterthwaite;
  random patno;
run;

proc genmod data = final.data4;
class tx assess patno;
model qol = tx|assess;
repeated subject = patno;
run;

proc univariate data = final.rankedresid normal;
var studentresid;
histogram;
run;

proc surveyselect data=final.data4 out=bootsample
  method=urs samprate=1 outhits rep=1000;
run;


proc mixed data=bootsample;
  class tx assess patno;
  model qol = tx|assess /outpm = bootresids;
  random patno;
  repeated assess /subject = patno group = tx;
run;

proc contents data = bootresids;
run;

proc univariate data = bootresids normal;
var resid;
histogram /normal midpoints = -9 to 8 by 0.25;
qqplot resid / normal(mu=est sigma=est);
run;

proc glimmix data = final.data4;
class patno tx assess;
model qol = tx|assess / dist =igaussian ddfm = satterthwaite;

random intercept / subject = patno;
random assess / subject = patno type = vc;
run;

proc genmod data = final.data4;
class patno tx assess;
model qol = tx|assess /dist = normal;
repeated subject = patno /type = exch;
run;
