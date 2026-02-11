******3-way ANOVA p. 1005****;

options formdlim=' ' ls=90 ps=50;

data STRESS;
  input extol gender fat smoke unit;
cards;
  24.1  1  1  1  1
  29.2  1  1  1  2
  24.6  1  1  1  3
  20.0  2  1  1  1
  21.9  2  1  1  2
  17.6  2  1  1  3
  14.6  1  2  1  1
  15.3  1  2  1  2
  12.3  1  2  1  3
  16.1  2  2  1  1
   9.3  2  2  1  2
  10.8  2  2  1  3
  17.6  1  1  2  1
  18.8  1  1  2  2
  23.2  1  1  2  3
  14.8  2  1  2  1
  10.3  2  1  2  2
  11.3  2  1  2  3
  14.9  1  2  2  1
  20.4  1  2  2  2
  12.8  1  2  2  3
  10.1  2  2  2  1
  14.4  2  2  2  2
   6.1  2  2  2  3
;
run;

proc glm data = stress plots = (diagnostics residuals);
class gender fat smoke;
model extol = gender*fat*smoke;
means gender*fat*smoke  /hovtest;
lsmeans gender*fat*smoke /pdiff cl adjust = tukey lines;

output out = diag1 cookd = cooksd p = predicted r = resid student = studres;
ods exclude lsmeansplot;
run;

proc sort data = diag1;
by resid;
run;

proc print data = diag1;
run;

proc univariate data = diag1 normal;
var studres;
run;

proc glm data = stress plots(only) = (diagnostics residuals intplot contourfit);
class gender fat smoke;
model extol = gender|fat|smoke;
lsmeans gender|fat|smoke /adjust = tukey lines;
ods exclude LSMeansplot;
run;


proc print data=stress;
quit;

proc freq data=stress;
tables smoke*gender*fat;
quit;


proc sort data=stress;
by gender smoke fat;
quit;



proc means data=stress;
by gender smoke fat;
var extol;
output out=a2 mean=mnextol;
quit;


proc print data=a2;
quit;


data red1;
set a2;
if gender = 1;
mnextol1 = mnextol;
drop gender mnextol;
run;


data red2;
set a2;
if gender = 2;
mnextol2 = mnextol;
drop gender mnextol;
run;


proc sort data=red1;
by smoke fat;
quit;

proc sort data=red2;
by smoke fat;
quit;


data dgender;
merge red1 red2;
deltaex = mnextol1 - mnextol2;
run;



proc means data=dgender;
class fat smoke;
var deltaex;
quit;



       proc sgplot data=dgender ;
xaxis type=discrete Label = 'Smoke and FAT';;
yaxis label ="Difference";;
series x=smoke y=deltaex /group=fat;
quit;




proc sort data=a2;
by gender;

quit;


       proc sgplot data=a2 ;
by gender;
xaxis type=discrete Label = 'Smoke and FAT';;
yaxis label ="MEAN";;
series x=smoke y=mnextol /group=fat;
quit;

proc sgpanel data=a2;
   panelby gender / columns=2;

series x=smoke y=mnextol /group=fat;
run;





 proc glm data=stress plots(only) = (diagnostics residuals intplot contourfit);
  class gender smoke fat;
 *model extol = gender|smoke|fat;
model extol = gender smoke fat gender*smoke gender*fat smoke*fat gender*smoke*fat;
output out=info r=resid p=phat student=stdres rstudent=jackres;
lsmeans gender*smoke*fat;
lsmeans gender*smoke*fat/slice=gender;
lsmeans gender*smoke*fat/slice=gender*smoke;
lsmeans gender*smoke*fat/slice=gender*fat;
lsmeans gender*smoke*fat/slice=smoke*fat;
quit;
 quit;

proc glm data=stress plots=all;
class gender fat smoke;
model extol = gender|fat|smoke;
run;

*************************COME ON BOOK !!!!!*****************;


data stress2;
set stress;
if gender = 2 then fat=3-fat;  ****here I^m flipping the blue and red
                                line within women****;
run;


proc sort data=stress2;
by gender smoke fat;
quit;

proc means data=stress2;
by gender smoke fat;
var extol;
output out=a2 mean=mnextol;
quit;


proc print data=a2;
quit;


data red1;
set a2;
if gender = 1;
mnextol1 = mnextol;
drop gender mnextol;
run;


data red2;
set a2;
if gender = 2;
mnextol2 = mnextol;
drop gender mnextol;
run;


proc sort data=red1;
by smoke fat;
quit;

proc sort data=red2;
by smoke fat;
quit;


data dgender;
merge red1 red2;
deltaex = mnextol1 - mnextol2;
run;



proc means data=dgender;
class fat smoke;
var deltaex;
quit;





       proc sgplot data=dgender ;
xaxis type=discrete Label = 'Smoke and FAT';;
yaxis label ="Difference";;
series x=smoke y=deltaex /group=fat;
quit;




proc sort data=a2;
by gender;

quit;


       proc sgplot data=a2 ;
by gender;
xaxis type=discrete Label = 'Smoke and FAT';;
yaxis label ="MEAN";;
series x=smoke y=mnextol /group=fat;
quit;

proc sgpanel data=a2;
   panelby gender / columns=2;

series x=smoke y=mnextol /group=fat;
run;





 proc glm data=stress2 plots = none;
  class gender smoke fat;
 model extol = gender|smoke|fat;
output out=info r=resid p=phat student=stdres rstudent=jackres;
lsmeans gender*smoke*fat / bylevel adjust= tukey linesm slice = (gender smoke fat);
ods exclude lsmeansplot;
quit;
quit;
 quit;

lsmean gender*smoke*fat/slice=gender;
lsmean gender*smoke*fat/slice=gender*smoke;
lsmean gender*smoke*fat/slice=gender*fat;
lsmean gender*smoke*fat/slice=smoke*fat;

 proc glm data=stress plots = none;
  class gender smoke fat;
 model extol = gender|smoke smoke|fat gender|fat;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;
 quit;



 proc glm data=stress;
  class gender smoke fat;
 model extol = fat gender smoke smoke|fat ;
lsmeans smoke*fat;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;
 quit;




                *******QUICK CHECK OF HOV****;

data stress;
set stress;
ofata = 100*gender + 10*smoke+fat;
run;

proc freq data=stress;
tables gender*smoke*fat*ofata/list;
quit;

proc glm data=stress;
class ofata;
model extol=ofata;
means ofata/hovtest;
quit;




        *****NOMRAL PROBABILITY PLOT****;


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



      data stress1;
set stress;
sqrtextol=sqrt(extol);
run;


 proc glm data=stress1;
  class gender smoke fat;
 model sqrtextol = fat gender smoke smoke|fat ;
lsmeans smoke*fat /adjust = tukey lines;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;
 quit;




        *****NOMRAL PROBABILITY PLOT****;


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





 proc glm data=stress;
  class gender smoke fat;
 model extol = gender|smoke smoke|fat gender*fat;
quit;




            data a1;
set STRESS;
   if (fat eq 1)*(smoke eq 1)
     then fs='1_fs';
   if (fat eq 1)*(smoke eq 2)
     then fs='2_fS';
   if (fat eq 2)*(smoke eq 1)
     then fs='3_Fs';
   if (fat eq 2)*(smoke eq 2)
     then fs='4_FS';
run;





    proc glm data=a1;
   class gender fs;
   model extol=gender fs;
   means gender fs/tukey;
quit;;





proc sort data=stress;
by gender;
quit;

 proc glm data=stress;
by gender;


  class gender smoke fat;
 model extol =smoke|fat;
quit;



 proc glm data=stress;
  class gender smoke fat;
 model extol = gender|smoke|fat /solution clparm;
lsmeans gender*smoke*fat/slice=gender cl pdiff adjust=tukey;
                *****use estimate statement to  mean for men with low smokeing and high
                                fat diet****;



estimate 'Men,LowSm,HiFat'      intercept 1
                                gender 1 0
                                smoke 1 0
                                fat 0 1
                                gender*smoke 1 0 0 0
                                gender*fat 0 1 0 0
                                smoke*fat  0 1 0 0
                                gender*smoke*fat  0 1 0 0 0 0  0 0;




estimate 'Men,LowSm,LowFat'      intercept 1
                                gender 1 0
                                smoke 1 0
                                fat 1 0
                                gender*smoke 1 0 0 0
                                gender*fat 1 0 0 0
                                smoke*fat  1 0 0 0
                                gender*smoke*fat  1 0 0 0 0 0  0 0;


estimate 'Delta for Men - Lowsmoke'  fat -1 1 gender*fat -1 1 0 0
                                        smoke*fat -1 1 0 0
                                        gender*smoke*fat -1 1 0 0 0 0 0 0 ;



quit;





ods rtf file='C:\Users\SMSTAT\Documents\WCULaptop\STA513\threeway.rtf';

proc sgpanel data=a2;
   panelby gender / columns=2;

series x=smoke y=mnextol /group=fat;
run;


 proc glm data=stress2;
  class gender smoke fat;
 model extol = gender|smoke|fat;
output out=info r=resid p=phat student=stdres rstudent=jackres;
lsmeans gender*smoke*fat;
lsmean gender*smoke*fat/tdiff pdiff;
quit;
quit;
 quit;

 ods rtf close;


ods rtf file='C:\Users\SMSTAT\Documents\WCULaptop\STA513\threewaya.rtf';

proc sgpanel data=a2;
   panelby fat / columns=2;

series x=smoke y=mnextol /group=gender;
run;



 ods rtf close;
