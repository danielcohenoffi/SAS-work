Proc import file = "\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\Test2data.csv"
out =work.test2
dbms = csv;
run;

proc means data = work.test2;
run;
/*
proc print data = work.test2(obs = 10);

run;
/* model vars: attractiveness, intelligence, sincerity
 fun, ambitiousness, 
shared interests*/

data work.test2a;
set test2;
agegap = agem - agef;
if agegap > 2 then close_age = 0;
else if agegap < -2 then close_age = 0;
else close_age = 1;
if racem = racef then same_race = 1;
else same_race = 0;
/*typo  preemption */
sharedm = sharedinterestsm;
sharedf = sharedinterestsf;
intm = intelligentm;
intf = intelligentf;
attrm = attractivem;
attrf = attractivef;
ambm = ambitiousm;
ambf = ambitiousf;

/*decolinearization*/

likem_cent = likem - 6.6825;
likef_cent = likef - 6.3658;
attrm_cent = attrm - 6.6868;
attrf_cent = attrf - 6.2737;
sincem_cent = sincerem - 7.856;
sincef_cent = sinceref - 7.7839;
intm_cent = intm - 7.62;
intf_cent = intf - 7.92;
funm_cent = funm - 6.87;
funf_cent = funf - 6.563;
ambm_cent = ambm - 6.768;
ambf_cent = ambf - 7.43;
sharedm_cent = sharedm - 5.9;
sharedf_cent = sharedf - 5.5;

ambm_2cent = ambm_cent**2;

/* interactions*/

attr_intm = attrm *intm;
attr_sincem = attrm * sincerem;
attr_funm = attrm *funm;
attr_ambm = attrm *ambm;
attr_sharedm = attrm *sharedm;
int_sincem = intm *sincerem;
int_funm = intm *funm;
int_ambm = intm *ambm;
int_sharedm = intm *sharedm;
since_funm = sincerem *funm;
since_ambm = sincerem * ambm;
since_sharedm = sincerem *sharedm;
fun_ambm = funm*ambm;
fun_sharedm = funm*sharedm;
amb_sharedm = ambm*sharedm;

attr_intf = attrf *intf;
attr_sincef = attrf * sinceref;
attr_funf = attrf *funf;
attr_ambf = attrf *ambf;
attr_sharedf = attrf *sharedf;
int_sincef = intf *sinceref;
int_funf = intf *funf;
int_ambf = intf *ambf;
int_sharedf = intf *sharedf;
since_funf = sinceref *funf;
since_ambf = sinceref * ambf;
since_sharedf = sinceref *sharedf;
fun_ambf = funf*ambf;
fun_sharedf = funf*sharedf;
amb_sharedf = ambf*sharedf;

/* squared and cubed*/
attr2m = attrm**2;
attr3m = attrm**3;
int2m = intm **2;
int3m = intm **3;
since2m = sincerem **2;
since3m = sincerem **3;
fun2m = funm **2;
fun3m = funm **3;
amb2m = ambm**2;
amb3m = ambm**3;
shared2m = sharedm**2;
shared3m = sharedm**3;

attr2f = attrf**2;
attr3f = attrf**3;
int2f = intf **2;
int3f = intf **3;
since2f = sinceref **2;
since3f = sinceref **3;
fun2f = funf **2;
fun3f = funf **3;
amb2f = ambf**2;
amb3f = ambf**3;
shared2f = sharedf**2;
shared3f = sharedf**3;


run;


data split;
set test2a;
ran_num = ranuni(2024);
run;


proc sort data = split;
by ran_num;
run;

data holdout training;
set split;
counter = _N_;
if counter le 80 then output holdout;
else output training;
run;

/* validation*/


/*

data holdout;
set holdout;
run;

proc corr data = holdout;
var likem yhat_m;

run;

proc corr data = holdout;
var likef yhat_f;
run;
/*

/* model building */
/* model M - mens attraction to women */
/*
proc reg data = training plots =none;
model likef = attrf intf funf sharedf/VIF collinoint;
run;

/* all possible models */

/*
proc reg data = training plots = none;
model likem = attrm_cent sincem_cent  funm_cent ambm_cent sharedm_cent intm_cent same_race close_age
attr_intm attr_sincem attr_funm attr_ambm attr_sharedm
int_sincem int_funm int_ambm int_sharedm
since_funm since_ambm since_sharedm
fun_ambm fun_sharedm amb_sharedm
attr2m attr3m int2m int3m since2m since3m
fun2m fun3m amb2m amb3m shared2m shared3m /
selection = rsquare cp mse
include = 8;
run;
&persevere; /*


/* forward selection */
/*
proc reg data = test2a plots = none;
model likem = attrm sincerem  funm ambm sharedm intm
attr_intm attr_sincem attr_funm attr_ambm attr_sharedm
int_sincem int_funm int_ambm int_sharedm
since_funm since_ambm since_sharedm
fun_ambm fun_sharedm amb_sharedm
attr2m attr3m int2m int3m since2m since3m
fun2m fun3m amb2m amb3m shared2m shared3m /
selection = forward 
include = 5;
run;
&persevere;


*/

/* backwards elimination */

/*
proc reg data = test2a plots = none;
model likem = attrm sincerem funm ambm sharedm intm
attr_intm attr_sincem attr_funm attr_ambm attr_sharedm
int_sincem int_funm int_ambm int_sharedm
since_funm since_ambm since_sharedm
fun_ambm fun_sharedm amb_sharedm
attr2m attr3m int2m int3m since2m since3m
fun2m fun3m amb2m amb3m shared2m shared3m /
selection = backwards 
include = 5;
run;
&persevere;

*/

/* stepwise forward selection */

proc reg data = training plots = none;
model likem = attrm_cent sincem_cent  funm_cent ambm_cent sharedm_cent same_race close_age intm_cent
attr_intm attr_sincem attr_funm attr_ambm attr_sharedm
int_sincem int_funm int_ambm int_sharedm
since_funm since_ambm since_sharedm
fun_ambm fun_sharedm amb_sharedm
attr2m attr3m int2m int3m since2m since3m
fun2m fun3m amb2m amb3m shared2m shared3m /
selection =  stepwise slstay = .10 VIF
include = 8;
run; 




proc reg data = holdout plots = none;
model likem = attrm sincerem funm sharedm;
run;
*/

/*
proc reg data = test2m;
model likem = attrm sincerem funm ambm sharedm
attr_funm attr_ambm amb2m;
run;
&persevere;*/


/* female model */
/* all possible models */
/*
proc reg data = training plots = none;
model likef = attrf_cent   funf_cent ambf_cent sharedf_cent intf_cent sincef_cent close_age same_race
attr_intf attr_sincef attr_funf attr_ambf attr_sharedf
int_sincef int_funf int_ambf int_sharedf
since_funf since_ambf since_sharedf
fun_ambf fun_sharedf amb_sharedf
attr2f attr3f int2f int3f since2f since3f
fun2f fun3f amb2f amb3f shared2f shared3f /
selection = rsquare cp mse
include = 8;
run; */

/* forward selection */
/*
proc reg data = training plots = none;
/*
model likef = attrf sinceref  funf ambf sharedf intf
attr_intf attr_sincef attr_funf attr_ambf attr_sharedf
int_sincef int_funf int_ambf int_sharedf
since_funf since_ambf since_sharedf
fun_ambf fun_sharedf amb_sharedf
attr2f attr3f int2f int3f since2f since3f
fun2f fun3f amb2f amb3f shared2f shared3f /
selection = forward slstay = .10
include = 6;
run;


*/

/* backwards elimination*/
/*
proc reg data = training plots = none;
model likef = attrf sinceref  funf ambf sharedf intf
attr_intf attr_sincef attr_funf attr_ambf attr_sharedf
int_sincef int_funf int_ambf int_sharedf
since_funf since_ambf since_sharedf
fun_ambf fun_sharedf amb_sharedf
attr2f attr3f int2f int3f since2f since3f
fun2f fun3f amb2f amb3f shared2f shared3f /
selection = backwards
include = 6;
run;
&persevere;
*/



proc reg data = training plots = none;
model likef = attrf funf ambf sharedf intf same_race sinceref close_age
attr_intf attr_sincef attr_funf attr_ambf attr_sharedf
int_sincef int_funf int_ambf int_sharedf
since_funf since_ambf since_sharedf
fun_ambf fun_sharedf amb_sharedf
attr2f attr3f int2f int3f since2f since3f
fun2f fun3f amb2f amb3f shared2f shared3f /
selection = stepwise slstay = .30
include = 6;
run;
&persevere;


proc reg data = holdout plots = none;
model likef = attrf funf  sharedf intf /VIF;
run;
