**** two-way analysis of covariance using data from Table 22.6  page 935;


options formdlim=' ' ls=90 ps=50;

data Flower;
   input number size variety moisture unit;
cards;
  98  15  1  1  1
  60   4  1  1  2
  77   7  1  1  3
  80   9  1  1  4
  95  14  1  1  5
  64   5  1  1  6
  55   4  2  1  1
  60   5  2  1  2
  75   8  2  1  3
  65   7  2  1  4
  87  13  2  1  5
  78  11  2  1  6
  71  10  1  2  1
  80  12  1  2  2
  86  14  1  2  3
  82  13  1  2  4
  46   2  1  2  5
  55   3  1  2  6
  76  11  2  2  1
  68  10  2  2  2
  43   2  2  2  3
  47   3  2  2  4
  62   7  2  2  5
  70   9  2  2  6
;
run;

data flower;
set flower;
if moisture=1 and variety=1 then group = 1;
if moisture=1 and variety=2 then group = 2;
if moisture=2 and variety=1 then group = 3;
if moisture=2 and variety=2 then group = 4;
run;


proc glm data = flower;
class group;
model number = group;
means group /hovtest;
output out = diag1 p = yhat r = resid student = stresid;
run;

proc sort data = diag1;
by stresid;
run;

proc print data = diag1;
run;

proc univariate data = diag1 normal;
var stresid;
histogram;
run;

proc univariate data = diag1 normal;
var resid;
run;





proc glm data=FLOWER;
   class moisture variety;
   model number=moisture|variety; ***Moisture variety moisture*variety***;
*model number =Moisture variety moisture*variety;
lsmeans moisture*variety;

quit;

proc glm data=FLOWER;
   class moisture variety;
   model number= moisture|variety size/solution;
lsmeans moisture*variety /pdiff cl adjust = tukey lines;
quit;

proc means data = flower;
var number;
run;

proc means data=flower;
var size;
quit;

proc means data=flower;
   class moisture variety;
var size;
quit;


proc glm data=FLOWER plots = none;
   class moisture variety;
   model number=size moisture|variety /solution;
lsmeans moisture*variety/slice=variety adjust = tukey;
lsmeans moisture*variety/slice=moisture adjust = tukey;
lsmeans moisture*variety /pdiff = all adjust = tukey lines;
quit;


***********constancy of slope assessment*****;

proc glm data=FLOWER;
   class moisture variety;
   model number=size|moisture|variety /solution;
lsmeans moisture*variety*size/slice=variety;
lsmeans moisture*variety*size/slice=moisture;
lsmeans  moisture*variety*size;
quit;


        ******CENTERING OURSELVES****;

proc means data=flower;
var size;
output out=o mean=avgsize;
quit;


proc sql;
create table flower as
select a.*, b.*
from flower a left join o b
on a.unit;
quit;


proc print data=flower;
quit;


data flower;
set flower;
centsize = size - avgsize;
run;

ods trace on;

ods listing close;


proc glm data=FLOWER;
   class moisture variety;
   model number=size moisture|variety /solution;
lsmeans  moisture*variety;
estimate '11'  intercept 1 moisture 1 0 size 0  variety 1 0  moisture*variety 1 0 0 0;
estimate '12'  intercept 1 moisture 1 0 variety 0 1 moisture*variety 0 1 0 0 ;
estimate '21'  intercept 1 moisture 0 1  variety 1 0 moisture*variety 0 0 1 0 ;
estimate '22'  intercept 1 moisture 0 1  variety 0 1 moisture*variety 0 0 0 1 ;
ods output Estimates=est1;
ods output LSMeans=lsm1;
quit;



proc glm data=FLOWER;
   class moisture variety;
   model number=centsize moisture|variety /solution;
lsmeans  moisture*variety;
estimate '11'  intercept 1 moisture 1 0 centsize 0 variety 1 0  moisture*variety 1 0 0 0;
estimate '12'  intercept 1 moisture 1 0 variety 0 1 moisture*variety 0 1 0 0 ;
estimate '21'  intercept 1 moisture 0 1  variety 1 0 moisture*variety 0 0 1 0 ;
estimate '22'  intercept 1 moisture 0 1  variety 0 1 moisture*variety 0 0 0 1 ;
estimate '11 vs 12' variety 1 -1 moisture *variety 1
ods output Estimates=est2;
ods output LSMeans=lsm2;

quit;

ods listing;
ods trace off;


proc print data=est1; quit;
proc print data=est2; quit;


proc print data=lsm1; quit;
proc print data=lsm2; quit;






proc glm data=FLOWER;
   class moisture variety;
   model size=moisture|variety /solution;
means  moisture*variety;
quit;
