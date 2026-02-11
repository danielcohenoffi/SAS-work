data Hw4;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\bear';
run;


data hw41;
set hw4;
if sex = 1 then female = 0;
if sex = 2 then female = 1;
fem_len_int = female * length;
run;

Proc reg data = hw41 plots = none;
model weight = length female fem_len_int;
run;
