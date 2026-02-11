data hw1a;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\ch05q06';
run;

/*Proc sgplot data = hw1a;
reg x = age y = atst /clm cli;
run; */

/*proc reg data = hw1a;
model atst = age / clb clm cli;
run; */

data hw1b;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\schools';
run;

/*proc univariate data = work.hw1b;
var salary;
run; */


/*proc sgplot data = hw1b;
reg x = sat_total y =salary /clm cli;
run; */
/*
proc sort data = hw1b;
by salary;
run;

proc reg data = hw1b;
id sat_total;
model salary = sat_total / cli;
run; 
/*

proc corr data = hw1b;
var sat_total salary;
run; 
*/
/*proc means data = hw1b min;
var sat_total;
run;*/



data additional;
input salary;
cards;
45106
80000
;
run;

data combined;
set additional hw1b;
run;

proc reg data = work.combined;
model sat_total = salary /clb clm cli;
run;

