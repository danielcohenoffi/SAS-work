data lab5;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\bear';
run;



data lab5_1;
set lab5;
interaction = length * neck * age;
lengneck = length * neck;
lengage = length * age;
ageneck = age * neck;
run;
/*
proc reg data = work.lab5_1;
model weight = length neck age interaction;
run;



proc reg data = work.lab5_1 plots = none;
model weight = length neck age lengneck lengage ageneck;
test lengneck, lengage, ageneck;
run;


proc reg data = work.lab5_1;
model weight = length neck age lengneck;
run;
*/

data lab5_2;
set lab5;
L2 =length **2;
L3 =length **3;
n2 = neck **2;
n3 = neck **3;
a2 = age **2;
a3 = age **3;
leng_neck = length * neck;
log_weight = log(weight);
run;
/*
proc reg data = lab5_2 plots = none;
model weight = length neck age leng_neck L2 L3 n2 n3 a2 a3;
test L2, L3, n2, n3, a2, a3;
run;
*/
proc reg data = lab5_2 ;
model log_weight = length neck leng_neck n3;
test n3;
run;

* the best model!
