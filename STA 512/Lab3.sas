data lab3;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\schools';
run;

/*proc reg data = lab3;
model sat_total = cost college enroll;
run; */

data fstat;
a = 1-probf(3,131, 33);
run;

proc print data = work.fstat;
run; 

