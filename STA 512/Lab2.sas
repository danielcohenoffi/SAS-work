data lab2;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\ch05q02';
run;

/*proc sgplot data = lab2;
reg x=quet y = sbp /clm cli;
*pbspline x =quet y = sbp / clm cli;
run; */

proc reg data = lab2 plot = none;
model sbp=quet /clb;
run;

data additional;
input quet;
cards;
3.4
;
run;
data combined;
set lab2 additional;
run;

proc reg data = combined;
model sbp = quet /cli clm;
run;
