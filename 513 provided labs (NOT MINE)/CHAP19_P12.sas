*Pb 19.12, two-way anova

options formdlim=' ' ls=90 ps=50;
data eye;
input rate contact gender id;
cards;
    11.0      1      1      1
    7.0      1      1      2
   12.0      1      1      3
    6.0      1      1      4
   10.0      1      1      5
   15.0      1      2      1
   12.0      1      2      2
   14.0      1      2      3
   11.0      1      2      4
   16.0      1      2      5
   12.0      2      1      1
   16.0      2      1      2
   10.0      2      1      3
   13.0      2      1      4
   14.0      2      1      5
   14.0      2      2      1
   17.0      2      2      2
   13.0      2      2      3
   20.0      2      2      4
   18.0      2      2      5
;
run;



proc print data=eye;
quit;


***************PLOT TO SEE WHAT^S UP*****;

****One-way Plot****;

data eye;
set eye;
   if contact eq 1 and gender eq 1 then C_G='Pres_M';
   if contact eq 1 and gender eq 2 then C_G='Pres_F';
   if contact eq 2 and gender eq 1 then C_G='Abs_M';
   if contact eq 2 and gender eq 2 then C_G='Abs_F';
run;


*****TWo-WAY PLOT***;


proc format;
value genfmt 1='Male' 2='Female';
value gengmt 3='Male' 4='Female';
value confmt 1='Present' 2='Absent';

quit;

*************RUN 2-way model with interaction****;



proc glm data=eye PLOTS=diagnostics intplot;  ****AUTO PLTS***;;
   class contact gender;
   model rate=contact gender contact*gender;
   means contact*gender;
   lsmeans contact*gender/ pdiff cl alpha=0.05 plots=(meanplot (join cl));
   lsmeans contact*gender/slice=contact;
   lsmeans contact*gender/slice=gender;
   ods exclude lsmeansplots;
format gender genfmt.;
format contact confmt.;
    quit;


	ODS TRACE OFF;


proc glm data=eye PLOTS(only) = diagnostics intplot fitplot order=internal;  ****AUTO PLTS***;;
   class contact gender;
   model rate=contact gender contact*gender;
   means contact*gender;
   lsmeans contact*gender/ pdiff cl alpha=0.05 plots=(meanplot (join cl));
   lsmeans contact*gender/slice=contact;
   lsmeans contact*gender/slice=gender;
format gender genfmt.;
format contact confmt.;
ods exclude lsmeansplots;
ODS OUTPUT IntPlot = INTPLOT2;
    quit;

PROC CONTENTS DATA=INTPLOT2 POSITION SHORT;
QUIT;

/* Dependent _YVAR _XCLAS_OBS _GROUP_OBS _INDEX_OBS _GROUP_FIT _XCLAS _Predicted_FIT _INDEX_FIT   */


proc print data=intplot2;
quit;

************INTERACTION NOT SIGNIFICANT - RUN MAIN EFFECTS MODEL****;

proc glm data=eye;
   class contact gender;
   model rate=contact gender ;
   means contact gender;
   lsmeans contact/pdiff;
   lsmeans gender/pdiff;
format gender genfmt.;
format contact confmt.;
    quit;


**************************GOODNESS OF FIT in the TWO-WAY MODEL****;


proc glm data=eye plots = none;
   class contact gender;
   model rate=contact gender contact*gender;
   output out=a2 r=resid;
quit;

proc univariate data=a2 normal ;
var resid;
quit;


                ************Use the OFATA model to assess HOV****;

proc glm data=eye;
   class c_G;
   model rate=C_G;
   means C_G/hovtest;
   quit;


***************UNEQUAL VARIANCE ?*****;


proc mixed data=eye covtest ;
   class id contact gender C_G;
   model rate=contact gender contact*gender;
repeated / group=C_G  ;
quit;


proc mixed data=eye covtest ;
   class id contact gender C_G;
   model rate=contact gender contact*gender;
quit;




******Normal Probability Plot*****;

proc rank data=a2
   out=a3 normal=blom;
  var resid;
  ranks zresid;
quit;

proc sort data=a3;
   by zresid;
symbol1 v=circle i=sm70;
proc gplot data=a3;
   plot resid*zresid/frame;
run;quit;


proc univariate data=a2 normal ;
var resid;
quit;


proc corr data=a3;
var resid zresid;
quit;




*****Trend Plot of the Residuals***;

data a2;
set a2;
obsnr = _n_;
run;

proc reg data=a2;
model resid = obsnr /dw dwprob;
quit;
