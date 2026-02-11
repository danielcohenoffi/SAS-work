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
                                But let^s look at SAS LAB to see if it can identify
                                        a transformation to yield more "normal" residuasl***;


  *****SAS LAB TELLS US THE ORIGINAL SCALE IS FINE.
                DESPITE THE SHAPIRO WILK PVALUE, THE BOX-COX TRANSFORMATION
            TO YIELD "NEAR nORMAL" RESIDUALS IS THE 0.9 POWER, BUT THAT
                        DOES NOT PROVIDE ANY SUBSTANTIAL GAIN IN FIT COMPARED
                        TO THE ORIGINAL SCALE*****;



        ******Cell Means*****;




****************************************************************************;
*********************CONTRASTS OF INTERESTS*******;

******BEGIN WITH THE Just the 12 cells estimated******;



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



estimate 'fee1 scope2 super1' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 1 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super2' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;



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




quit;


*****WORK ON THE D-PORTIONS OF THE CONTRASTS****;



 proc glm data=quality;   ******BONFERRONI FOR THOSE 6 CONTRASTS  ALPHA = .10/6=0.0167  ****;
  class fee scope supervision;
 model quality = fee|scope|supervision/sOLUTION;  **CLPARM NEEDS TO BE ADDED IN FOR THE CI OF CONTRASTS****;

        *****Fee 1****;

estimate 'fee1 scope1 super1' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 1 0 0 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope1 super2' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 1 0 0
                           fee*scope*supervision 0 1 0 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super1' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 0 0 1 0
                           fee*scope*supervision 0 0 1 0 0 0 0 0 0 0 0 0;



estimate 'fee1 scope2 super2' intercept 1 fee 1 0 0 scope 0 1 fee*scope 0 1 0 0 0 0
                                supervision 0 1 fee*supervision 0 1 0 0 0 0
                                scope*supervision 0 0 0 1
                           fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;






estimate 'bLUNT FORCE LAYOUT TO SUBSTRact later - fee1 scope2 super2' 
intercept 1 
fee 1 0 0 
scope 0 1 
fee*scope 0 1 0 0 0 0
supervision 0 1 
fee*supervision 0 1 0 0 0 0
scope*supervision 0 0 0 1
fee*scope*supervision 0 0 0 1 0 0 0 0 0 0 0 0;


ESTIMATE 'MU1..' INTERCEPT 1 FEE 1 0 0 SCOPE 0.5 0.5 FEE*SCOPE 0.5 0.5 0 0 0 0 
						SUPERVISION 0.5 0.5 FEE*SUPERVISION 0.5 0.5 0 0 0 0
						SCOPE*SUPERVISION 0.25 0.25 0.25 0.25
						FEE*SCOPE*SUPERVISION 0.25 0.25 0.25 0.25 0 0 0 0 0 0 0 0;

						
ESTIMATE 'MU2..' INTERCEPT 1 FEE 0 1 0 SCOPE 0.5 0.5 FEE*SCOPE 0 0 0.5 0.5 0 0 
						SUPERVISION 0.5 0.5 FEE*SUPERVISION 0 0 0.5 0.5 0 0
						SCOPE*SUPERVISION 0.25 0.25 0.25 0.25
						FEE*SCOPE*SUPERVISION 0 0 0 0 0.25 0.25 0.25 0.25 0 0 0 0 ;



	
ESTIMATE 'MU3..' INTERCEPT 1 FEE 0 0 1  SCOPE 0.5 0.5 FEE*SCOPE 0 0 0 0 0.5 0.5  
						SUPERVISION 0.5 0.5 FEE*SUPERVISION 0 0 0 0 0.5 0.5 
						SCOPE*SUPERVISION 0.25 0.25 0.25 0.25
						FEE*SCOPE*SUPERVISION 0 0 0 0 0 0 0 0 0.25 0.25 0.25 0.25  ;

						
ESTIMATE 'sIMPLE MU1..' INTERCEPT 1 FEE 1 0 0   ;


ESTIMATE 'sIMPLE MU2..' INTERCEPT 1 FEE 0 1 0   ;
ESTIMATE 'sIMPLE MU3..' INTERCEPT 1 FEE 0 0 1   ;



ESTIMATE 'd1' FEE 1 -1 0 ;

estimate 'ComplexD1'  fee 1 -1 0 fee*scope 0.5 0.5 -0.5 -0.5 0 0 
				fee*supervision 0.5 0.5 -0.5 -0.5 0 0 
				fee*scope*supervision 0.25 0.25 0.25 0.25 -0.25 -0.25 -0.25 -0.25 0 0 0 0 ;


ESTIMATE 'D2' FEE 0 1 -1;


estimate 'ComplexD2'  fee 0 1 -1  fee*scope 0 0  0.5 0.5 -0.5 -0.5  
				fee*supervision 0 0  0.5 0.5 -0.5 -0.5  
				fee*scope*supervision 0 0 0 0  0.25 0.25 0.25 0.25 -0.25 -0.25 -0.25 -0.25  ;

ESTIMATE 'D3' FEE 1 0 -1;


estimate 'ComplexD3'  fee 1 0 -1  fee*scope 0.5 0.5 0 0  -0.5 -0.5 
				fee*supervision 0.5 0.5 0 0 -0.5 -0.5 
				fee*scope*supervision 0.25 0.25 0.25 0.25 0 0 0 0 -0.25 -0.25 -0.25 -0.25 ;





estimate 'fee1 scope1 super1' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 1 0 0 0 0 0 0 0 0 0 0 0;


estimate 'fee2 scope1 super1' intercept 1 fee 0 1 0 scope 1 0 fee*scope 0 0 1 0 0 0
                                supervision 1 0 fee*supervision 0 0 1 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 1 0 0 0 0 0 0 0;

estimate 'fee3 scope1 super1' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 1 0 fee*supervision 0 0 0 0 1 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 1 0 0 0;

ESTIMATE 'MU.11' INTERCEPT 3 FEE 1 1 1 SCOPE 3 0 FEE*SCOPe  1 0 1 0 1 0 
					SUPERVISION 3 0 FEE*SUPERVISION 1 0 1 0 1 0 
					SCOPE*SUPERVISION 3 0 0 0 
					FEE*SCOPE*SUPERVISION 1 0 0 0 1 0 0 0 1 0 0 0 /DIVISOR = 3;



ESTIMATE 'sIMPLE MU.11' INTERCEPT 3 SCOPE 3 0  
					SUPERVISION 3 0  
					SCOPE*SUPERVISION 3 0 0 0 
					 /DIVISOR = 3;

					 

ESTIMATE 'sIMPLE MU.12' INTERCEPT 3 SCOPE 3 0  
					SUPERVISION 0 3  
					SCOPE*SUPERVISION 0 3 0 0 
					 /DIVISOR = 3;

ESTIMATE 'D4' SUPERVISION 3 -3 SCOPE*SUPERVISION 3 -3 0 0/DIVISOR = 3;					 
					 
ESTIMATE 'sIMPLE MU.21' INTERCEPT 3 SCOPE 0 3  
					SUPERVISION 3 0  
					SCOPE*SUPERVISION 0 0 3 0 
					 /DIVISOR = 3;

					 

ESTIMATE 'sIMPLE MU.22' INTERCEPT 3 SCOPE 0 3  
					SUPERVISION 0 3  
					SCOPE*SUPERVISION 0 0 0 3 
					 /DIVISOR = 3;


ESTIMATE 'D5' SUPERVISION 3 -3 SCOPE*SUPERVISION 0 0 3 -3 /DIVISOR = 3;

ESTIMATE 'L' SCOPE*SUPERVISION 3 -3 -3 3 /DIVISOR = 3;

QUIT;



****part b****;

 proc glm data=quality;
  class fee scope supervision;
 model quality = fee|scope|supervision/sOLUTION;
LSMEANS FEE*SCOPE*SUPERVISION/PDIFF TDIFF CL;
QUIT;


******mORE CONTRAST CODES BELOW*****;



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


estimate 'Delta fee1 scope2'    supervision 1 -1 fee*supervision 1 -1 0 0 0 0
                                scope*supervision 0 0  1 -1
                                        fee*scope*supervision 0 0  1 -1  0 0 0 0 0 0 0;



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


estimate 'D1: Delta fee1 fee2 DD'  fee*scope*supervision 1 -1 -1 1 -1 1 1 -1 0 0 0 0;
estimate 'D:3 Delta fee1 fee3 DD'  fee*scope*supervision 1 -1 -1 1 0 0 0 0  -1 1 1 -1 ;
estimate 'D:2 Delta fee2 fee3 DD'  fee*scope*supervision 0 0 0 0 1 -1 -1 1  -1 1 1 -1 ;

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



******Below gives us the 3 estimated means when scope = 1 and super = 1******;



estimate 'fee1 scope1 super1' intercept 1 fee 1 0 0 scope 1 0 fee*scope 1 0 0 0 0 0
                                supervision 1 0 fee*supervision 1 0 0 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 1 0 0 0 0 0 0 0 0 0 0 0;
estimate 'fee2 scope1 super1' intercept 1 fee 0 1 0 scope 1 0 fee*scope 0 0 1 0 0 0
                                supervision 1 0 fee*supervision 0 0 1 0 0 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 1 0 0 0 0 0 0 0;

estimate 'fee3 scope1 super1' intercept 1 fee 0 0 1 scope 1 0 fee*scope 0 0 0 0 1 0
                                supervision 1 0 fee*supervision 0 0 0 0 1 0
                                scope*supervision 1 0 0 0
                           fee*scope*supervision 0 0 0 0 0 0 0 0 1 0 0 0;

***********************Lets estimate the average of these 3 cells*****;


estimate 'Fee * scope1 super1' intercept 3 fee 1 1 1 scope 3 0 fee*scope 1 0 1 0 1 0 
						supervision 3 0 fee*supervision 1 0 1 0 1 0 
						scope*supervision 3 0 0 0 
						fee*scope*supervision 1 0 0 0 1 0 0 0  1 0 0 0  /divisor = 3;







quit;

