data lab4;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\bear';
run;


proc reg data = lab4 plots = none;
model weight = neck chest age;
output out = output p = preds;
run;

proc print data = output;
run;

proc corr data = output;
var preds weight;
run;

proc corr data = lab4;
var weight chest;
partial neck;
run;
