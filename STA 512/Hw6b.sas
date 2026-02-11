data Hw6b;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\ch05q15';
run;
/*
proc reg data = work.hw6b;
model ln_bldtl = ppm_tolu weight age ln_brntl /vif collinoint;

output out=newdata p=pred residual=ei stdr=s_ei rstudent=jackknife h = leverage cookd = cooks student=student;
run;

proc univariate  data = work.newdata normal normaltest plots;

var jackknife;
histogram;
run;
/*
data hw6b2;
set hw6b;
ln2_bldtl = log(ln_bldtl);
run;

proc reg data = work.hw6b2;
model ln2_bldtl = ppm_tolu weight age /vif collinoint;

output out=newdata p=pred residual=ei stdr=s_ei rstudent=jackknife h = leverage cookd = cooks student=student;
run;
*/
/*
proc plot data = work.newdata;
plot pred * jackknife = '*';
run;


proc sort data = newdata;
by descending cooks leverage;
run;

proc print data = newdata;
var jackknife cooks leverage;
run;

*/
data newmodel;
set hw6b;
if ppm_tolu = 100 then ppm100 = 1;
else ppm100 = 0;
if ppm_tolu = 500 then ppm500 = 1;
else ppm500 = 0;
if ppm_tolu = 1000 then ppm1000 = 1;
else ppm1000 = 0;
run;


proc reg data = work.newmodel;
model ln_bldtl =  weight age  ppm100 ppm500 ppm1000 /vif collinoint;

output out=newdata2 p=pred residual=ei stdr=s_ei rstudent=jackknife h = leverage cookd = cooks student=student;
run;

proc univariate  data = work.newdata2 normal normaltest plots;

var jackknife;
histogram;
run;


proc plot data = work.newdata;
plot pred * jackknife = '*';
run;




proc sort data = newdata;
by descending cooks leverage;
run;

proc print data = newdata;
var jackknife cooks leverage;
run;
