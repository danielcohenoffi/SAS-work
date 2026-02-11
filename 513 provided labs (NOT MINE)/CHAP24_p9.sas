******3-way ANOVA p. 1005****;

options formdlim=' ' ls=90 ps=50;


data quality;

  input quality fee scope supervision unit;

cards;

  124.3      1      1      1      1

  120.6      1      1      1      2

  120.7      1      1      1      3

  122.6      1      1      1      4

  112.7      1      1      2      1

  110.2      1      1      2      2

  113.5      1      1      2      3

  108.6      1      1      2      4

  115.1      1      2      1      1

  119.9      1      2      1      2

  115.4      1      2      1      3

  117.3      1      2      1      4

   88.2      1      2      2      1

   96.0      1      2      2      2

   96.4      1      2      2      3

   90.1      1      2      2      4

  119.3      2      1      1      1

  118.9      2      1      1      2

  125.3      2      1      1      3

  121.4      2      1      1      4

  113.6      2      1      2      1

  109.1      2      1      2      2

  108.9      2      1      2      3

  112.3      2      1      2      4

  117.2      2      2      1      1

  114.4      2      2      1      2

  113.4      2      2      1      3

  120.0      2      2      1      4

   92.7      2      2      2      1

   91.1      2      2      2      2

   90.7      2      2      2      3

   87.9      2      2      2      4

   90.9      3      1      1      1

   95.3      3      1      1      2

   88.8      3      1      1      3

   92.0      3      1      1      4

   78.6      3      1      2      1

   80.6      3      1      2      2

   83.5      3      1      2      3

   77.1      3      1      2      4

   89.9      3      2      1      1

   83.0      3      2      1      2

   86.5      3      2      1      3

   82.7      3      2      1      4

   58.6      3      2      2      1

   63.5      3      2      2      2

   59.8      3      2      2      3

   62.3      3      2      2      4

;

run;

 quality fee scope supervision unit;

 proc glm data = quality plots(only) = (diagnostics residuals);
 class fee scope supervision;
 model quality = fee*scope*supervision;
 means fee*scope*supervision /hovtest;
 lsmeans fee*scope*supervision /cl pdiff adjust = tukey lines;
 ods exclude lsmeansplots;
 output out = diag1 student = stresid;
 run;

 proc univariate data = diag1 normal;
 var stresid;
 run;

proc print data=quality;
quit;


proc sort data=quality;
by fee scope supervision;
quit;



proc means data=quality;
by fee scope supervision;
var quality;
output out=a2 mean=mnquality;
quit;


proc print data=a2;
quit;




proc sort data=a2;
by fee;

quit;
goptions reset=aglobal gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=join c=blue height=2.5;;
symbol2 v=circle i=join c=red height=2.5;;
proc gplot data=a2;
by fee;
LEGEND1 VALUE=(f=swissb h=3.0) label = (f=swissb h=3.0);
AXIS1 LABEL =(C=BLACK  H=4 F=SWISSL 'Mn Quality')  value=(h=3.5 f=swissb) minor=none    ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Scope')  value=(h=3.5 f=swissb) minor=none   ;
PLOT mnquality*scope=supervision/frame HAXIS=AXIS2 VAXIS=AXIS1 legend=legend1;
                       ;
RUN;quit;




 proc glm data=quality;
  class fee scope supervision;
 model quality = fee|scope|supervision;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;


data quality2;
set quality;

if fee=1 then do; supervision=3-supervision; end;
run;


proc sort data=quality2;
by fee scope supervision;
quit;



proc means data=quality2;
by fee scope supervision;
var quality;
output out=a22 mean=mnquality;
quit;


proc print data=a22;
quit;




proc sort data=a22;
by fee;

quit;
goptions reset=aglobal gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=join c=blue height=2.5;;
symbol2 v=circle i=join c=red height=2.5;;
proc gplot data=a22;
by fee;
LEGEND1 VALUE=(f=swissb h=3.0) label = (f=swissb h=3.0);
AXIS1 LABEL =(C=BLACK  H=4 F=SWISSL 'Mn Quality')  value=(h=3.5 f=swissb) minor=none    ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Scope')  value=(h=3.5 f=swissb) minor=none   ;
PLOT mnquality*scope=supervision/frame HAXIS=AXIS2 VAXIS=AXIS1 legend=legend1;
                       ;
RUN;quit;






 proc glm data=quality;
  class fee scope supervision;
 model quality = fee|scope|supervision;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;





 proc glm data=quality2;
  class fee scope supervision;
 model quality = fee|scope|supervision;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;

proc univariate data = info normal;
var jackres;
run;








 proc glm data=quality;
  class fee scope supervision;
 model quality = fee|scope|supervision;
output out=info r=resid p=phat student=stdres rstudent=jackres;
quit;


proc rank data=info out=a3
     normal=blom;
   var resid;
   ranks zresid;
quit;

proc sort data=a3;
   by zresid;
quit;


proc corr data= a3;
var resid zresid;
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

                ****SW is 0.94 that^s not bad considering the small sample size of 48.
                        The pvalue was < 0.05 but we know this is sensitive to sample size/
                                But let^s look at BOX-COX with PROC TRANSREG to see if it can identify
                                        a transformation to yield more "normal" residuasl***;



****LET^S aDD IN THE PROC TRANSREG;


PROC FREQ DATA=QUALITY;
TABLES fee*scope*supervision/LIST;
QUIT;

data quality;
set quality;

fee1 = (fee = 1);
fee2 = (fee = 2);
scope1 = (scope = 1);
super1 = (supervision = 1);
run;

proc means data=quality;
var quality;
quit;


proc transreg data=quality pbo;
model BoxCox(quality) = Identity(fee1 fee2 scope1 super1 fee1*scope1 fee2*scope1
							fee1*super1 fee2*super1 super1*scope1
							fee1*super1*scope1 fee2*super1*scope1);
							quit;

proc transreg data = quality;
model boxcox(quality) = class(fee|scope|supervision);
run;


  *****BOX-COX TELLS US THE ORIGINAL SCALE IS FINE.
                DESPITE THE SHAPIRO WILK PVALUE, THE BOX-COX TRANSFORMATION
            TO YIELD "NEAR nORMAL" RESIDUALS IS THE 1.25 POWER, (raise the outcome to 1.25 power), BUT THAT
                        DOES NOT PROVIDE ANY SUBSTANTIAL GAIN IN FIT COMPARED
                        TO THE ORIGINAL SCALE*****;

							
data quality;
set quality;
quality_Rev = (quality)**1.25;
run;

proc corr data=quality;
var quality quality_rev;
quit;

 proc glm data=quality;
  class fee scope supervision;
 model quality_REV = fee|scope|supervision;
output out=info2 r=resid p=phat student=stdres rstudent=jackres;
quit;

proc univariate data=info2 normal;
var resid;
quit;
proc univariate data=info2 normal ;
var resid;
histogram resid;
quit;

/*   12 cells with 4 observations per cell, we're justing running into a problem normalizing residuals   */
/*  WE'RE DEALING WITH HAVING ENOUGH DATA TO EFFECT ANY SKEW IN OUR DATA.  WITHOUT ENOUGH N PER CELL
WE CAN'T OVERCOME ANY OF THE SKEW WE SEE IN THE RESIDUALS   */




/* OR IS IT A POOR MODEL - OVERSPECIFIED  */


 proc glm data=quality;
  class fee scope supervision;
 model quality_REV = fee scope supervision fee*scope fee*supervision scope*supervision;
output out=info2 r=resid p=phat student=stdres rstudent=jackres;
quit;


 proc glm data=quality;
  class fee scope supervision;
 model quality_REV = fee scope supervision  fee*supervision scope*supervision;
output out=info2 r=resid p=phat student=stdres rstudent=jackres;
quit;


 proc glm data=quality;
  class fee scope supervision;
 model quality_REV = fee scope supervision   scope*supervision;
output out=info2 r=resid p=phat student=stdres rstudent=jackres;
quit;


proc univariate data=info2 normal;
var resid;
quit;

proc univariate data=info2 normal ;
var resid;
histogram resid;  /*  We simplified the model but we still have an issue with normality of the residuals */
quit; /*  any interpreration from the fitted model should be interprted with caution do to the violation of
			the normality assumption  */



        ******Cell Means*****;




 proc glm data=quality;
  class fee scope supervision;
 model quality = fee|scope|supervision/sOLUTION;

        *****Fee 1****;

estimate 'fee1 scope1 super1' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 1 0 0 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope1 super2' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 1 0 0 0 0 0 0 0 0 0 0;


estimate 'Delta fee1 scope1' supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 1 -1 0 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super1' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 1 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super2' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;





						   
****Contrast between levels of supervision for fee1, score2****;

estimate 'fee1 scope2 super1' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 1 0 0 0 0 0 0 0 0 0;

estimate 'fee1 scope2 super2' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;



estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;

								
*****End of Contrast between levels of supervisiosn for fee1, score2******;


estimate 'Delta fee1 scope1' supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 1 -1 0 0 0 0 0 0 0 0 0 0;

estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;



              *****Fee 2****;

estimate 'fee2 scope1 super1' intercept 1 fee 0 1 0 scope 1 0 fee*scope 0 0 1 0 0 0
                                supervision 1 0 fee*supervision 0 0 1 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 1 0 0 0 0 0 0 0;



estimate 'fee2 scope1 super2' intercept 1 fee 0 1 0 scope 1 0 fee*scope 0 0 1 0 0 0
                                supervision 0 1 fee*supervision 0 0 0 1 0 0
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 0 0 0 0 1 0 0 0 0 0 0;


estimate 'fee2 scope2 super1' intercept 1 fee 0 1 0 scope 0 1 fee*scope 0 0 0 1 0 0
                                supervision 1 0 fee*supervision 0 0 1 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 0 0 0 0 1 0 0 0 0 0;



estimate 'fee2 scope2 super2' intercept 1 fee 0 1 0 scope 0 1 fee*scope 0 0 0 1 0 0
                                supervision 0 1 fee*supervision 0 0 0 1 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 0 0 0 0 1 0 0 0 0;




estimate 'Delta fee2 scope1' supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 1 -1 0 0 0 0 0 0;

estimate 'Delta fee2 scope2'    supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0  1 -1  0 0 0 0;




              *****Fee 3****;

estimate 'fee3 scope1 super1' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 1 0 fee*supervision 0 0 0 0 1 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 1 0 0 0;



estimate 'fee3 scope1 super2' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 0 1 fee*supervision 0 0 0 0 0 1
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 1 0 0;


estimate 'fee3 scope2 super1' intercept 1 fee 0 0 1 scope 0 1 fee*scope 0 0 0 0 0 1
                                supervision 1 0 fee*supervision 0 0 0 0 1 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 0 1 0;



estimate 'fee3 scope2 super2' intercept 1 fee 0 0 1 scope 0 1 fee*scope 0 0 0 0 0 1
                                supervision 0 1 fee*supervision 0 0 0 0 0 1
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 0 0 1;



estimate 'Delta fee3 scope1' supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 0 0 ;

estimate 'Delta fee3 scope2'    supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 0 0  1 -1  ;




                        ************Interaction****;



estimate 'Delta fee1 scope1' supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 1 -1 0 0 0 0 0 0 0 0 0 0;

estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;


estimate 'Fee1 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 1 -1 -1 1 0 0 0 0 0 0 0 0;


estimate 'Delta fee2 scope1' supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 1 -1 0 0 0 0 0 0;

estimate 'Delta fee2 scope2'    supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0  1 -1  0 0 0 0;


estimate 'Fee2 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 0 0 0 0 1 -1 -1 1  0 0 0 0;


estimate 'Delta fee3 scope1' supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 0 0 ;

estimate 'Delta fee3 scope2'    supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 0 0  1 -1  ;
estimate 'Fee3 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 -1 1 ;



                ***** 3 way interaction***;
estimate 'Fee1 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 1 -1 -1 1 0 0 0 0 0 0 0 0;


estimate 'Fee2 Delta of Delta'  scope*supervision 1 -1 -1 1
                          fee*scope*supervision 0 0 0 0 1 -1 -1 1  0 0 0 0;
estimate 'Delta fee1 fee2 DD'  fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0;


estimate 'Fee3 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 -1 1 ;
estimate 'Delta fee1 fee3 DD'  fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ;
estimate 'Delta fee2 fee3 DD'  fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;


estimate 'Delta fee1 fee2 DD'  fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0;
estimate 'Delta fee1 fee3 DD'  fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ;
estimate 'Delta fee2 fee3 DD'  fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;

contrast '3-way interaction' fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0,
                        fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ,
                                     fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;




estimate 'fee1'    intercept 1 fee 1 0 0 scope 0.5 0.5 fee*scope 0.5 0.5 0 0 0 0
                        supervision 0.5 0.5 fee*supervision 0.5 0.5 0 0 0 0
                                scope*supervision 0.25 0.25 0.25 0.25
                        fee*scope*supervision 0.25 0.25 0.25 0.25 0 0 0 0 0 0 0 0;

estimate 'fee1-SHORT'    intercept 1 fee 1 0 0 ;;

estimate 'fee3-SHORT'    intercept 1 fee 0 0 1 ;
estimate 'Delta fee3-fee1' fee -1 0 1;



estimate 'fee3 scope1 super2' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 0 1 fee*supervision 0 0 0 0 0 1
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 1 0 0;





quit;






 proc glm data=quality;
  class fee scope supervision;
 model quality = fee|scope|supervision/sOLUTION;

        *****Fee 1****;

estimate 'fee1 scope1 super1' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 1 0 0 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope1 super2' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 1 0 0 0 0 0 0 0 0 0 0;


estimate 'Delta fee1 scope1' supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 1 -1 0 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super1' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 1 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super2' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;





						   
****Contrast between levels of supervision for fee1, score2****;

estimate 'fee1 scope2 super1' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 1 0 0 0 0 0 0 0 0 0;

estimate 'fee1 scope2 super2' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;



estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;

								
*****End of Contrast between levels of supervisiosn for fee1, score2******;


estimate 'Delta fee1 scope1' supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 1 -1 0 0 0 0 0 0 0 0 0 0;

estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;



              *****Fee 2****;

estimate 'fee2 scope1 super1' intercept 1 fee 0 1 0 scope 1 0 fee*scope 0 0 1 0 0 0
                                supervision 1 0 fee*supervision 0 0 1 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 1 0 0 0 0 0 0 0;



estimate 'fee2 scope1 super2' intercept 1 fee 0 1 0 scope 1 0 fee*scope 0 0 1 0 0 0
                                supervision 0 1 fee*supervision 0 0 0 1 0 0
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 0 0 0 0 1 0 0 0 0 0 0;


estimate 'fee2 scope2 super1' intercept 1 fee 0 1 0 scope 0 1 fee*scope 0 0 0 1 0 0
                                supervision 1 0 fee*supervision 0 0 1 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 0 0 0 0 1 0 0 0 0 0;



estimate 'fee2 scope2 super2' intercept 1 fee 0 1 0 scope 0 1 fee*scope 0 0 0 1 0 0
                                supervision 0 1 fee*supervision 0 0 0 1 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 0 0 0 0 1 0 0 0 0;




estimate 'Delta fee2 scope1' supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 1 -1 0 0 0 0 0 0;

estimate 'Delta fee2 scope2'    supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0  1 -1  0 0 0 0;




              *****Fee 3****;

estimate 'fee3 scope1 super1' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 1 0 fee*supervision 0 0 0 0 1 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 1 0 0 0;



estimate 'fee3 scope1 super2' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 0 1 fee*supervision 0 0 0 0 0 1
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 1 0 0;


estimate 'fee3 scope2 super1' intercept 1 fee 0 0 1 scope 0 1 fee*scope 0 0 0 0 0 1
                                supervision 1 0 fee*supervision 0 0 0 0 1 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 0 1 0;



estimate 'fee3 scope2 super2' intercept 1 fee 0 0 1 scope 0 1 fee*scope 0 0 0 0 0 1
                                supervision 0 1 fee*supervision 0 0 0 0 0 1
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 0 0 1;



estimate 'Delta fee3 scope1' supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 0 0 ;

estimate 'Delta fee3 scope2'    supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 0 0  1 -1  ;




                        ************Interaction****;



estimate 'Delta fee1 scope1' supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 1 -1 0 0 0 0 0 0 0 0 0 0;

estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;


estimate 'Fee1 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 1 -1 -1 1 0 0 0 0 0 0 0 0;


estimate 'Delta fee2 scope1' supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 1 -1 0 0 0 0 0 0;

estimate 'Delta fee2 scope2'    supervision 1 -1 fee*supervision 0 0 1 -1 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0  1 -1  0 0 0 0;


estimate 'Fee2 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 0 0 0 0 1 -1 -1 1  0 0 0 0;


estimate 'Delta fee3 scope1' supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 1 -1 0 0
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 0 0 ;

estimate 'Delta fee3 scope2'    supervision 1 -1 fee*supervision 0 0 0 0 1 -1
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0 0 0 0 0 0 0 0 0  1 -1  ;
estimate 'Fee3 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 -1 1 ;



                ***** 3 way interaction***;
estimate 'Fee1 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 1 -1 -1 1 0 0 0 0 0 0 0 0;


estimate 'Fee2 Delta of Delta'  scope*supervision 1 -1 -1 1
                          fee*scope*supervision 0 0 0 0 1 -1 -1 1  0 0 0 0;
estimate 'Delta fee1 fee2 DD'  fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0;


estimate 'Fee3 Delta of Delta'  scope*supervision 1 -1 -1 1
                                  fee*scope*supervision 0 0 0 0 0 0 0 0 1 -1 -1 1 ;
estimate 'Delta fee1 fee3 DD'  fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ;
estimate 'Delta fee2 fee3 DD'  fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;


estimate 'Delta fee1 fee2 DD'  fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0;
estimate 'Delta fee1 fee3 DD'  fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ;
estimate 'Delta fee2 fee3 DD'  fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;

contrast '3-way interaction' fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0,
                        fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ,
                                     fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;




estimate 'fee1'    intercept 1 fee 1 0 0 scope 0.5 0.5 fee*scope 0.5 0.5 0 0 0 0
                        supervision 0.5 0.5 fee*supervision 0.5 0.5 0 0 0 0
                                scope*supervision 0.25 0.25 0.25 0.25
                        fee*scope*supervision 0.25 0.25 0.25 0.25 0 0 0 0 0 0 0 0;

estimate 'fee1-SHORT'    intercept 1 fee 1 0 0 ;;

estimate 'fee3-SHORT'    intercept 1 fee 0 0 1 ;
estimate 'Delta fee3-fee1' fee -1 0 1;



estimate 'fee3 scope1 super2' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 0 1 fee*supervision 0 0 0 0 0 1
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 0 1 0 0;





quit;
/* This gives you EVERYTHING with 5 lines */
proc glm data=quality;
  class fee scope supervision;
  model quality = fee|scope|supervision;
  lsmeans fee*scope*supervision / cl adjust=tukey slice=(fee scope supervision);
  contrast '3-way' fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0,
                   fee*scope*supervision 1 -1 -1 1 0 0 0 0 -1 1 1 -1;
run;
