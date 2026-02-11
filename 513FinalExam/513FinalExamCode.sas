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
run;

data final.data4;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\513FinalExam\fin_p4_25';
run;

proc contents data = final.data1;
run;

proc print data = final.data1;
run;

ods trace on;
proc glm data = final.data1 plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class tx;
model rawdiff = tx; /*testing as one way anova first for hovtest*/
means tx / welch hovtest;
lsmeans tx /pdiff cl adjust = tukey lines; /* which are different? all pairwise so tukey lines. 
I love my big matrices, close inspection of lines tables tells you slicing*/
estimate "grand mean" intercept 1; /* get grand adjusted mean*/
ods exclude lsmeansplots; /*  declutter output,*/
output out = diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
ods trace off;

proc univariate data = diag1 normal;
var studentresid; /*formal test of normalities, want agreement if p above 0.0125, below 0.05, informal bonferronni*/
run;

ods trace on;
proc glm data = final.data1 plots(only) = (diagnostics residuals intplot fitplot); /*diagnostic plots*/
class tx;
model adjustdiff = tx; /*testing as one way anova first for hovtest*/
means tx / welch hovtest;
lsmeans tx /pdiff cl adjust = tukey lines; /* which are different? all pairwise so tukey lines. 
I love my big matrices, close inspection of lines tables tells you slicing*/
estimate "grand mean" intercept 1; /* get grand adjusted mean*/
ods exclude lsmeansplots; /*  declutter output,*/
output out = diag1 r = resid p = predicted cookd = cooksd student = studentresid; /* 2 way residuals */
run;
ods trace off;

proc univariate data = diag1 normal;
var studentresid; /*formal test of normalities, want agreement if p above 0.0125, below 0.05, informal bonferronni*/
run;




proc print data = final.data2;
run;




ods output lsmeans = cellmeansmixed estimates = effectsmixed;
proc mixed data = final.data2 covtest plots = all maxiter = 1000;
class driver auto additive var_group;
Model ETBE_X = additive /ddfm = satterthwaite s outpm = phatmixed;
lsmeans additive /pdiff cl adjust = tukey ;
ods exclude lsmeansplots;
random driver auto;
run;

proc glm data = final.data2;
class additive;
model etbe_x = additive;
means additive/hovtest;
run;

proc mixed data = final.data2 covtest plots = all maxiter = 1000;
class driver auto additive var_group;
Model ETBE_X = additive /ddfm = satterthwaite s outpm = phatmixed;
lsmeans additive /pdiff cl adjust = tukey ;
ods exclude lsmeansplots;
random driver auto;
repeated / group = var_group;
run;

proc mixed data = final.data2 covtest plots = all maxiter = 1000;
class driver auto additive variance;
Model ETBE_X = additive /ddfm = satterthwaite s outpm = phatmixed;
lsmeans additive /pdiff cl adjust = tukey ;
ods exclude lsmeansplots;
random driver auto;
repeated /group = variance;
run;
