*Pb 19.10, two-way anova

options formdlim=' ' ls=90 ps=50;
data Cash;
input cash age gender id volume;
cards;
  21.0      1      1      1    3.0
   23.0      1      1      2    5.1
   19.0      1      1      3    1.0
   22.0      1      1      4    4.4
   22.0      1      1      5    2.7
   23.0      1      1      6    4.9
   21.0      1      2      1    3.5
   22.0      1      2      2    4.2
   20.0      1      2      3    2.2
   21.0      1      2      4    3.1
   19.0      1      2      5    1.3
   25.0      1      2      6    6.6
   30.0      2      1      1    6.5
   29.0      2      1      2    4.1
   26.0      2      1      3    2.2
   28.0      2      1      4    3.7
   27.0      2      1      5    3.4
   27.0      2      1      6    3.0
   26.0      2      2      1    2.2
   29.0      2      2      2    5.4
   27.0      2      2      3    3.1
   28.0      2      2      4    4.5
   27.0      2      2      5    3.6
   29.0      2      2      6    5.0
   25.0      3      1      1    5.0
   22.0      3      1      2    3.1
   23.0      3      1      3    3.2
   21.0      3      1      4    3.2
   22.0      3      1      5    3.0
   21.0      3      1      6    2.9
   23.0      3      2      1    4.0
   19.0      3      2      2    0.8
   20.0      3      2      3    1.9
   21.0      3      2      4    2.8
   20.0      3      2      5    2.2
   20.0      3      2      6    1.9
;
run;



proc print data=Cash;
quit;


***************PLOT TO SEE WHAT^S UP*****;

****One-way Plot****;

data Cash;
set Cash;
	if age eq 1 then agename = "y";
	if age eq 2 then agename = "m";
	if age eq 3 then agename = "o";
	if gender eq 1 then gendername = "M";
	if gender eq 2 then gendername = "F";
   if age eq 1 and gender eq 1 then A_G='Young_M';
   if age eq 1 and gender eq 2 then A_G='Young_F';
   if age eq 2 and gender eq 1 then A_G='Mid_M';
   if age eq 2 and gender eq 2 then A_G='Mid_F';
   if age eq 3 and gender eq 1 then A_G='Old_M';
   if age eq 3 and gender eq 2 then A_G='Old_F';
run;


proc glm data = cash plots = all;
class a_g;
model cash = a_g;
means a_g /hovtest;
output out = diag1 cookd = cooksd p = yhat r = resid student = studentresid;
run;

proc univariate data = diag1 normal;
var studentresid;
run;

proc sort data = diag1;
by studentresid;
run;

proc print data = diag1;
run;

proc univariate data = diag1 normal;
var resid;
run;

goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;

symbol1 v=circle h=3 i=none;
proc gplot data=Cash;
   plot cash*A_G/frame;
run;quit;





 proc sgplot data=CASH;
xaxis type=discrete Label = 'Age and Gender';
yaxis label ="Sales";;
scatter x=A_G y=cash;
quit;

run
;


*****TWo-WAY PLOT***;

proc sort data=cash;
by age gender;
quit;


proc means data=Cash;
   var cash;
   by age gender;
   output out=a2 mean=avgcash;
quit;

proc print data=a2;
quit;
proc sort data=a2;
by age gender;
quit;

proc sort data=Cash;
by age gender;
quit;

DATA A2ALL;
MERGE cash a2;
by age gender;
run;


proc print data=A2all;
quit;



       proc sgplot data=A2All ;
xaxis type=discrete Label = 'Age and Gender';;
yaxis label ="Sales";;
series x=age y=avgcash /group=gender;
scatter x=age y=cash /group=gender markerattrs=(size=10) ;
quit;



*************RUN 2-way model with interaction****;


proc contents data=Cash position ;
quit;



proc means data=Cash;
var volume;
output out=x mean=mnvol;
quit;

proc print data=x;
quit;

proc print data=Cash;
quit;




proc sql;
create table Cash as
select a.*, b.*
from Cash a left join x b
on a.id;
quit;   ****SQL code just tags the "overall age volume  AVERAGE into our original data set"****;

proc print data=Cash;
quit;


data Cash;
set Cash;
centvol= volume - mnvol;   ******Here we're creating the centered  volume of cash sales****;
run;


proc glm data=Cash  PLOTS=all;  ****AUTO PLTS***;;   ;   **** OUR ORIGINAL TWO WAY ANOVA PROBLEM FOR 19.10****;

   class age gender;
   model cash=age gender age*gender;
   lsmeans age*gender/slice=age;
   lsmeans age*gender/slice=gender;
    quit;


proc glm data=Cash  PLOTS=all;  ****AUTO PLTS***;;   ;
   class age gender;
   model cash=centvol  age gender age*gender;
   lsmeans age*gender/slice=age;
   lsmeans age*gender/slice=gender;
run;



proc glm data=Cash  PLOTS=all;  ****AUTO PLTS***;;   ;
   class age gender;
   model cash=volume age gender age*gender /solution;
   lsmeans age*gender/slice=age;
   lsmeans age*gender/slice=gender;
    quit;



                ***************************what about gof issues********;
proc glm data=Cash;
   class age gender;
   *model cash=volume age gender age*gender ;
   model cash=volume|age|gender ;
    quit;
proc glm data=Cash;
   class age gender;
   *model cash=volume age gender age*gender ;
   model cash=volume|age VOLUME|gender AGE|GENDER ;
    quit;

******IS THE COVARIATE PARALLEL  - iS THE PARALLELISM ASSUMPTION MET****;



                ****we^LL DO THE GOF ON THE TWO-WAY ANCOVA STRUCTURE EVEN THOUGH ITS NOT THE
                                        PARSIMONIOUS MODEL******;




        *****NOMRAL PROBABILITY PLOT to asses normality of the residuals****;


proc glm data=Cash plots = all;
   class age gender;
   model cash=centvol centvolsq  age gender age*gender /solution;
output out=info r=resid p=phat student=stdres rstudent=jackres;
QUIT;


data cash;
set cash;
centvolsq = centvol**2;
run;

proc rank data=info out=a3
     normal=blom;
   var resid;
   ranks zresid;
quit;

proc sort data=a3;
   by zresid;
quit;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;


symbol1 v=circle  height=2.5 i=sm70;
proc gplot data=a3;
   plot resid*zresid=1/frame HAXIS=AXIS1 VAXIS=AXIS2  ;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Normal Ranking') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Residual')  value=(h=3.5 f=swissb) minor=none   ;
run;
quit;


proc univariate data=a3 normal;
var resid;
quit;


*******What about the BOX-COX if we needed to do it*****;

data a3;
set a3;
age1 = (age = 1);
age2 = (age = 2);
run;

proc freq data=a3;
tables age*age1*age2*gender/list;
quit;


proc means data=a3;
quit;



***PBO WILL PRINT OUT THE TABLE SO YOU DON^T NEED TO CHANGE PREFERENCES****;

****RELOAD THE DATA  HERE***;


data Cash;
input cash age gender id volume;
cards;
  21.0      1      1      1    3.0
   23.0      1      1      2    5.1
   19.0      1      1      3    1.0
   22.0      1      1      4    4.4
   22.0      1      1      5    2.7
   23.0      1      1      6    4.9
   21.0      1      2      1    3.5
   22.0      1      2      2    4.2
   20.0      1      2      3    2.2
   21.0      1      2      4    3.1
   19.0      1      2      5    1.3
   25.0      1      2      6    6.6
   30.0      2      1      1    6.5
   29.0      2      1      2    4.1
   26.0      2      1      3    2.2
   28.0      2      1      4    3.7
   27.0      2      1      5    3.4
   27.0      2      1      6    3.0
   26.0      2      2      1    2.2
   29.0      2      2      2    5.4
   27.0      2      2      3    3.1
   28.0      2      2      4    4.5
   27.0      2      2      5    3.6
   29.0      2      2      6    5.0
   25.0      3      1      1    5.0
   22.0      3      1      2    3.1
   23.0      3      1      3    3.2
   21.0      3      1      4    3.2
   22.0      3      1      5    3.0
   21.0      3      1      6    2.9
   23.0      3      2      1    4.0
   19.0      3      2      2    0.8
   20.0      3      2      3    1.9
   21.0      3      2      4    2.8
   20.0      3      2      5    2.2
   20.0      3      2      6    1.9
;
run;



   /**** proc transreg requires dummy coding for the variables****/
options formdlim=' ' ls=90 ps=50;




   data cash;
   set cash;
   male = (gender = 1);
   young = (age = 1);
   middle = (age = 2);
   run;

   proc freq data=cash;
   tables gender*male/list;
   tables age*young*middle/list;
   quit;


                     ****BOX-COX on our 2way ANOVA****;

   proc transreg data=cash pbo;
   model BoxCox(cash) = Identity(male young middle male*young male*middle);
   quit;



                     ****BOX-COX on our 2way ANCOVA****;

   proc transreg data=cash pbo;
   model BoxCox(cash) = Identity(volume male young middle male*young male*middle);
   quit;

   proc means data=cash;
   var volume;
   quit;


   data cash;
   set cash;

centvol= volume -3.4083333;   ******Here we're creating the centered  volume of cash sales****;
run;


******WHAT ABOUT HOV*********;
 *****WAY 1: Treat is as you did in Regression: Visually inspect for violations of
                                homoscedacity*****;


proc glm data=Cash PLOTS=ALL;
   class age gender;
   model cash=centvol  age gender age*gender /solution;
output out=info r=resid p=phat student=stdres rstudent=jackres;
QUIT;


*****We quantified it through a correlation coefficient*****;


data info;
set info;
absres = abs(resid);
run;

proc corr data=info;
var absres;
with phat;
quit;


****WAY 2:  WHAT ABOUT AN HOV ASSESSMENT*****;


data CASH;
set CASH;
OFATA = 10*age+gender;
run;

proc freq data=cash;
tables ofata*age*gender/list;
quit;




proc glm data=Cash;
   class age gender;
   model cash=centvol   /solution;   ****PARTIALLING OUT THE EFFECT OF ALL THE COVARIATES****;
output out=PartialVolume r=Presid ;
QUIT;



proc glm data=partialvolume;
class ofata;
model Presid = ofata;
means ofata/hovtest;
quit;




proc glm data=Cash;
   class age gender;
   model cash=volUME   /solution;   ****PARTIALLING OUT THE EFFECT OF ALL THE COVARIATES****;
output out=PartialVolume2 r=Presid ;
QUIT;



proc glm data=partialvolume2;
class ofata;
model Presid = ofata;
means ofata/hovtest;
quit;


                ******what if a violation of hov***;



proc mixed data=Cash;
   class age gender ofata;
   model cash=centvol  age gender age*gender /solution;
   repeated / group=ofata subject=id(age*gender);
   quit;




****Interaction Model****;

proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender centvol/solution;
    quit;


****Main Effects Model***;


proc glm data=Cash;
   class age gender;
   model cash=age gender  centvol/solution;
means age;
lsmeans age;
means gender;
lsmeans gender;
    quit;



proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender centvol/solution;
lsmeans age*gender/pdiff cl adjust=bon alpha=0.10;
    quit;




proc glm data=Cash;
   class age gender;
   model cash=age gender centvol/solution;
lsmeans age /pdiff cl adjust=bon alpha=0.10;
lsmeans  gender/pdiff cl adjust=bon alpha=0.10;
    quit;

proc glm data=Cash;
   class age gender;
   model cash=age gender centvol/solution;
lsmeans age gender /pdiff cl adjust=bon alpha=0.10;
    quit;




                        ****Look at 4 total
                        pairwise differences for both, alpha/4***;

proc glm data=Cash;
   class age gender;
   model cash=age gender centvol/solution;
lsmeans age /pdiff cl alpha=0.025;
lsmeans  gender/pdiff cl alpha=0.025;
    quit;
