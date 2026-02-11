


libname wcu v6 'C:\Users\SMSTAT\Documents\WCULaptop\STA513\Materials513\Data';

data mialong;
set wcu.mialong;
run;

libname wcu v6 '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets';

data mialong;
set wcu.mialong;
run;

proc contents data = mialong;
run;

proc print data=mialong (obs=125);
quit;

proc freq data=wcu.mialong;
tables couple rater targetsp;
quit;

proc freq data=wcu.mialong;
tables couple*rater couple*targetsp rater*targetsp;
tables couple*rater*targetsp/list;

quit;


proc glm data = mialong;
class targetsp rater;
model it17 = targetsp|rater sess;
lsmeans targetsp|rater/pdiff cl adjust = tukey lines;
ods exclude lsmeansplots;
run;




proc mixed data=wcu.mialong covtest;
class  couple targetsp rater sess;
model IT17 = targetsp;
random  couple  couple*targetsp  rater ;
quit;
