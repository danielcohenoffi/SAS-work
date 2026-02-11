data Hw6;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\homework6';
run;

proc reg data = work.hw6 plots = none;
model density = height weight wrist /vif collinoint;

output out=newdata p=pred residual=ei stdr=s_ei rstudent=jackknife h = leverage cookd = cooks student=student;
run;


proc corr data = work.hw6;
var height weight forearm wrist;
run;

proc plot data = work.newdata;
plot pred * jackknife = '*';
run;

proc univariate data = work.newdata normal normaltest plots;
var jackknife;
histogram;


run;


proc sort data = newdata;
by descending cooks leverage;
run;

proc print data = newdata;
var jackknife cooks leverage;
run;

