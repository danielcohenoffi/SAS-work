data Hw4;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\schools';
run;


proc glm data = hw4;
model sat = GMCASMth TwoYrPub TwoYrPri;
run;
