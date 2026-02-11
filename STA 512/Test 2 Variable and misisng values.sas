Proc import file = "\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\Test2data.csv"
out =work.test2
dbms = csv;
run;



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

agegapabs = sqrt(agegap**2);
run;
/*
proc univariate data = test2a;
var sharedf sharedm;
histogram;
run;
/*
proc univariate data = test2a;
var agegapabs;
histogram;
run;
*/

/*
proc univariate data = work.test2a;
var agem agef;
histogram;
run;
*/


proc univariate data = work.test2a;
var likem likef;
histogram;
run;






/*

proc corr data = work.test2a;
var likem likef;
run;

proc sort data = work.test2a;
by racef;
run;

proc freq data = work.test2a;
by racef;
tables racef;
run;
*/

proc means data = work.test2a;
run;
