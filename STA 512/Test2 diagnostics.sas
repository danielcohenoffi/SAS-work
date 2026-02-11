Proc import file = "\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\Test2data.csv"
out =work.test2
dbms = csv;
run;

data work.test2a;
set test2;
agegap = agem - agef;
id = _N_;
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

ambm_abs = ambm - 6.7;
attrm_abs = attrm -6.8;
funm_abs = funm -6.8;
ambm2_abs = ambm_abs **2;

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

proc univariate data = work.test2a;
var likem;
histogram;
run;

proc sort data = work.test2a;
by racef;
run;

proc freq data = work.test2a;
tables racef;
run;


proc means data = work.test2;
run;



/*
proc reg data = work.test2a;
model likem =  attrm funm sincerem sharedm
/vif collinoint;
output out =residm p=pred 
rstudent=jackknife cookd=cooks h=leverage;
run;


proc sort data = residm;
by descending leverage;
run;

proc print data = residm;
var id jackknife cooks leverage;
run;

data big_jack_Lev;
set residm;
if jackknife >2 or jackknife <-2 or leverage > .4;
run;

proc print data = big_jack_lev;
run;





*/
