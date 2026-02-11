

Proc glmpower  DATA=lsinfo;
Class A B ;
weight wt;
Model LSMEAN = A|B;   ****OK WITH THE FACTORIAL CODE****;
POWER STDDEV=0.245327 alpha=0.05 Ntotal=.  Power=0.90;
Run;
;





options formdlim=' ' ls=90 ps=50;
data relief;
input hour A B id;
cards;
   2.4      1      1      1
    2.7      1      1      2
    2.3      1      1      3
    2.5      1      1      4
    4.6      1      2      1
    4.2      1      2      2
    4.9      1      2      3
    4.7      1      2      4
    4.8      1      3      1
    4.5      1      3      2
    4.4      1      3      3
    4.6      1      3      4
    5.8      2      1      1
    5.2      2      1      2
    5.5      2      1      3
    5.3      2      1      4
    8.9      2      2      1
    9.1      2      2      2
    8.7      2      2      3
    9.0      2      2      4
    9.1      2      3      1
    9.3      2      3      2
    8.7      2      3      3
    9.4      2      3      4
    6.1      3      1      1
    5.7      3      1      2
    5.9      3      1      3
    6.2      3      1      4
    9.9      3      2      1
   10.5      3      2      2
   10.6      3      2      3
   10.1      3      2      4
   13.5      3      3      1
   13.0      3      3      2
   13.3      3      3      3
   13.2      3      3      4
;
run;



proc print data=relief;
quit;


***************PLOT TO SEE WHAT^S UP*****;

****One-way Plot****;

data relief;
set relief;
   if A eq 1 and B eq 1 then A_B='A=Low_B=Low';
   if A eq 1 and B eq 2 then A_B='A=Low_B=Mid';
   if A eq 1 and B eq 3 then A_B='A=Low_B=xHi';
   if A eq 2 and B eq 1 then A_B='A=Mid_B=Low';
   if A eq 2 and B eq 2 then A_B='A=Mid_B=Mid';
   if A eq 2 and B eq 3 then A_B='A=Mid_B=xHi';
   if A eq 3 and B eq 1 then A_B='A=xHi_B=Low';
   if A eq 3 and B eq 2 then A_B='A=xHi_B=Mid';
   if A eq 3 and B eq 3 then A_B='A=xHi_B=xHi';
run;



*****TWo-WAY PLOT***;

proc format;
value Afmt 1='Low' 2='Mid' 3='Hi';
value Bfmt 1='Low' 2='Mid' 3='Hi';

quit;
    


*************RUN 2-way model with interaction****;



proc glm data=relief  PLOTS=all;  ****AUTO PLTS***;;   
;
   class A B;
   model hour=A|B;
  
        lsmeans A*B/cl pdiff adjust=tukey;
    
*format A B afmt.;
    quit;


		*****************WHAT IF WE WANTED TO POWER A STUDY to have 90% power with the 
					same design (9 cells with the same observed means and Pooled SD)
					HOW BIG DOE S EACH CELL NEED TO BE*****;




ods trace off;

proc glm data=relief  ;   
;
   class A B;
   model hour=A|B;
   lsmeans A*B;
   ods output LSMeans=lsinfo;  ****GET A DATA SET WITH THE CELL MEANS****;
   quit;


   proc print data=lsinfo;
   quit;

Proc glmpower  DATA=lsinfo;
Class A B ;
Model LSMEAN = A B A*B;
POWER STDDEV=0.245327 alpha=0.05 Ntotal=.  Power=0.90;  ***STDEV IS OUR POOLED SD ESTIMATED by
															ROOT MSE****;
Run;

Proc glmpower  DATA=lsinfo;
Class A B ;
Model LSMEAN = A|B;   ****OK WITH THE FACTORIAL CODE****;
POWER STDDEV=0.245327 alpha=0.05 Ntotal=.  Power=0.90;
Run;

		*****What about Weights / unequal cell size into mix*****;

			****RULE the HIGHS are always 2 as much as the rest
				With the HIGH HIGH being 4 times as much****;


   proc print data=lsinfo;
   quit;


   data lsinfo;
   set lsinfo;
   wt = 1;
   if _n_ in (3,6,7,8) then wt = 2;
   if _n_ = 9 then wt = 4;
   run;

   proc print data=lsinfo;
   quit;


Proc glmpower  DATA=lsinfo;
Class A B ;
weight wt;
Model LSMEAN = A|B;   ****OK WITH THE FACTORIAL CODE****;
POWER STDDEV=0.245327 alpha=0.05 Ntotal=.  Power=0.90;
Run;

************IF THE INTERACTION NOT SIGNIFICANT - RUN MAIN EFFECTS MODEL****;

***HOW TO RUN THE MAIN EFFECTS MODEL****;

***HOW TO RUN THE MAIN EFFECTS MODEL****;
proc glm data=relief  PLOTS=all;  ****AUTO PLTS***;;   
  class A B;
   model hour=A B;
   quit;


   ****BACK TO THE INTERACTION MODEL****;
proc glm data=relief  PLOTS=all;  ****AUTO PLTS***;;   
;
   class A B;
   model hour=A|B /solution;


   means A*B;
   /*
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl pdiff;



*/
****LETS BUILD THE CELL MEANS WITH ESTIMATE STATEMENTS*****;

   ESTIMATE '11' INTERCEPT 1 A 1 0 0 B 1 0 0 A*B 1 0 0 0 0 0 0 0 0 ;

   ESTIMATE '12' INTERCEPT 1 A 1 0 0 B 0 1 0 A*B 0 1 0 0 0 0 0 0 0 ;
   ESTIMATE '13' INTERCEPT 1 A 1 0 0 B 0 0 1 A*B 0 0 1 0 0 0 0 0 0 ;
   ESTIMATE 'AVG12_13' INTERCEPT 1 A 1 0 0 B 0 0.5 0.5 A*B 0 0.5 0.5 0 0 0 0 0 0 ;
   ESTIMATE '11'       INTERCEPT 1 A 1 0 0 B 1   0  0  A*B 1 0   0   0 0 0 0 0 0 ;
   ESTIMATE 'L1' B -1 0.5 0.5 A*B -1 0.5 0.5 0 0 0 0 0 0 ;
   



   ESTIMATE '21' INTERCEPT 1 A 0 1 0 B 1 0 0 A*B 0 0 0  1 0 0 0 0 0  ;
   ESTIMATE '22' INTERCEPT 1 A 0 1 0 B 0 1 0 A*B 0 0 0 0 1 0 0 0 0   ;
   ESTIMATE '23' INTERCEPT 1 A 0 1 0 B 0 0 1 A*B 0 0 0 0 0 1 0 0 0  ;
   ESTIMATE 'AVG22_23' INTERCEPT 1 A 0 1 0 B 0 0.5 0.5 a*b 0 0 0 0 0.5 0.5 0 0 0 ;
   ESTIMATE '21'       INTERCEPT 1 A 0 1 0 B 1 0 0     A*B 0 0 0  1 0 0 0 0 0  ;
   ESTIMATE 'L2' B -1 0.5 0.5 a*b 0 0 0 -1 0.5 0.5 0 0 0 ;


   
   ESTIMATE '31' INTERCEPT 1 A 0 0 1 B 1 0 0 A*B 0 0 0 0 0 0  1 0 0   ;
   ESTIMATE '32' INTERCEPT 1 A 0 0 1 B 0 1 0 A*B 0 0 0 0 0 0 0 1 0    ;
   ESTIMATE '33' INTERCEPT 1 A 0 0 1 B 0 0 1 A*B 0 0 0 0 0 0 0 0 1   ;
   ESTIMATE 'AVG32_33' INTERCEPT 1 A 0 0 1 B 0 0.5 0.5 A*B 0 0 0 0 0 0 0 0.5 0.5;
   ESTIMATE '31' INTERCEPT 1 A 0 0 1 B 1 0 0 A*B 0 0 0 0 0 0  1 0 0   ;
   ESTIMATE 'L3' B -1 0.5 0.5 A*B 0 0 0 0 0 0 -1 0.5 0.5;

   ESTIMATE 'L2' B -1 0.5 0.5 a*b 0 0 0 -1 0.5 0.5 0 0 0 ;
   ESTIMATE 'L1' B -1 0.5 0.5 A*B -1 0.5 0.5 0 0 0 0 0 0 ;
   ESTIMATE 'L4' A*B 1 -0.5 -0.5 -1 0.5 0.5 0 0 0 ;

   
   ESTIMATE 'L3' B -1 0.5 0.5 A*B 0 0 0 0 0 0 -1 0.5 0.5;
   ESTIMATE 'L1' B -1 0.5 0.5 A*B -1 0.5 0.5 0 0 0 0 0 0 ;
   ESTIMATE 'L5' A*B 1 -0.5 -0.5 0 0 0 -1 0.5 0.5;


   ESTIMATE 'L3' B -1 0.5 0.5 A*B 0 0 0 0 0 0 -1 0.5 0.5;
   ESTIMATE 'L2' B -1 0.5 0.5 a*b 0 0 0 -1 0.5 0.5 0 0 0 ;
   ESTIMATE 'L6' A*B 0 0 0 1 -0.5 -0.5 -1 0.5 0.5;

   CONTRAST 'L6' A*B 0 0 0 1 -0.5 -0.5 -1 0.5 0.5;
esTimate 'L1' B -1 0.5 0.5 A*B -1 0.5 0.5 0 0 0 0 0 0 ;

esTimate 'L2' B -1 0.5 0.5 A*B 0 0 0 -1 0.5 0.5  0 0 0 ;
esTimate 'L3' B -1 0.5 0.5 A*B 0 0 0 0 0 0 -1 0.5 0.5 ;
estimate 'L4=L2-L1' A*B 1 -0.5 -0.5 -1 0.5 0.5 0 0 0;
estimate 'L5=L3-L1' A*B 1 -0.5 -0.5 0 0 0 -1 0.5 0.5 ;
estimate 'L6=L3-L2' A*B 0 0 0 1 -0.5 -0.5 -1 0.5 0.5 ;
ods output Estimates=est;

format A B 3.;
    quit;



proc print data=est;
quit;


proc contents data=est;
quit;



data est;
set est;
fstar=FINV(0.90,8,27);
S_sq = (3*3-1)*FINV(0.90,8,27);  *****Equation 19.93c a= 3 b=3, so ab-1 = 3*3 -1   = 8***;
xs=sqrt(S_sq);

Lower = Estimate - sqrt(S_sq)*StdErr;
Upper = Estimate + sqrt(S_sq)*StdErr;
run;




proc print data=est;
quit;




proc glm data=relief;
   class A*B;
   model hour=A|B;
        means A*B/ lines;
		LSMEANS A*B/PDIFF cl ADJUST=TUKEY alpha=.10;  
format A B 3.;
    quit;

proc glm data=relief;
   class A*B;
   model hour=A*B;
        means A*B / lines tukey;
        means A*B / HOVTEST;
    quit;



	******if we had a violation of hov*****;
		*****fit heterogeneous two-way anova model****;

	data relief;
	set relief;
	obsnr = _n_;  ****we need this for autocorrelation of the observations with the residuals****;

	run;



	proc mixed data=relief ;
	class A B;
	model hour = A B A*B /s ;
	lsmeans A*B/pdiff cl adjust=scheffe;
	lsmeans A*B / slice=A;
esTimate 'L2' B -1 0.5 0.5 A*B 0 0 0 -1 0.5 0.5  0 0 0 ;
	repeated /group=A*B ;
	quit;


	

	*************What about normality?******;

	proc sort data=relief;
	by A B;
	quit;

	proc univariate data=relief normal;
	by A B;
	var hour;
	quit;


proc glm data=relief;
   class A B;
   model hour=A|B;
   output out=o r=resid;
   quit;

proc univariate data=o normal;
var resid;
quit;

*****************If it fails normality*********;

data relief;
set relief;
A1 = (A=1);  ****THIS IS A CONDITIONAL COMMAND WHERE A1 IS 1 WHEN THE CONDITION IS TRUE.
					A1 IS 0 WHEN THE CONDITION IS FALSE***;
A2 = (A=2);
B1 = (B=1);
B2= (B=2);
run;

                                                                                                                          
                                                                                                                                        
proc transreg data=relief pbo;                                                                                                              
model BoxCOX(hour) = identity(A1 A2 B1 B2 A1*B1 A1*b2 A2*b1 A2*b2) ;                                                                     
quit;                                                                                                                                   
                



data relief2;
input hour A B id;
cards;
   2.4      1      1      1
    2.7      1      1      2
    2.3      1      1      3
    2.5      1      1      4
    4.6      1      2      1
    4.2      1      2      2
    4.9      1      2      3
    4.7      1      2      4
    4.8      1      3      1
    4.5      1      3      2
    4.4      1      3      3
    4.6      1      3      4
    5.8      2      1      1
    5.2      2      1      2
    5.5      2      1      3
    5.3      2      1      4
    8.9      2      2      1
    9.1      2      2      2
    8.7      2      2      3
    9.0      2      2      4
    9.1      2      3      1
    9.3      2      3      2
    8.7      2      3      3
    9.4      2      3      4
    6.1      3      1      1
    5.7      3      1      2
    5.9      3      1      3
    6.2      3      1      4
    9.9      3      2      1
   10.5      3      2      2
   10.6      3      2      3
   10.1      3      2      4
   13.5      3      3      1
   13.0      3      3      2
   13.3      3      3      3
   13.2      3      3      4
   0         3      3      4
;
run;

data relief2;
set relief2;
A1 = (A=1);
A2 = (A=2);
B1 = (B=1);
B2= (B=2);
run;

                                                                                                                          
                                                                                                                                        
proc transreg data=relief2 pbo;                                                                                                              
model BoxCOX(hour) = identity(A1 A2 B1 B2 A1*B1 A1*b2 A2*b1 A2*b2) ;                                                                     
quit;      

DATA relief3;
set relief2;
hour_shift = hour + 0.1;****Shifting so the smallest value is positive***;
run;

                                                                                              
                                                                                                                                        
proc transreg data=relief3 pbo;                                                                                                              
model BoxCOX(hour_shift) = identity(A1 A2 B1 B2 A1*B1 A1*b2 A2*b1 A2*b2) ;                                                                     
quit;      

		****SENSITIVITY ANALYSIS IS HOW ROBUST YOUR MODEL RESULTS ARE
				TO VARIOUS SHIFTS*****;

 
                

data relief;
set relief;
invhour = 1/hour;
sqrhour=sqrt(hour);
run;




proc means data=relief;
   var invhour;
   by A B;
   output out=a3 mean=avghr;
quit;

proc print data=a3;
quit;

symbol1 v=square h=3 i=join c=red;
symbol2 v=diamond h=3 i=join c=green;
symbol3 v=circle h=3 i=join c=gold;
proc gplot data=a3;
   plot avghr*A=B/frame  haxis = 1 to 3 by 1;
run;quit;






proc means data=relief;
   var sqrhour;
   by A B;
   output out=a3 mean=avghr;
quit;

proc print data=a3;
quit;

symbol1 v=square h=3 i=join c=red;
symbol2 v=diamond h=3 i=join c=green;
symbol3 v=circle h=3 i=join c=gold;
proc gplot data=a3;
   plot avghr*A=B/frame  haxis = 1 to 3 by 1;
run;quit;




proc glm data=relief;
   class A B;
   model invhour=A|B;
        means A*B/ lines;
		LSMEANS A*B/PDIFF ADJUST=TUKEY;
format A B 3.;
    quit;

	
proc glm data=relief;
   class A B;
   model sqrhour=A|B;
        means A*B/ lines;
		LSMEANS A*B/PDIFF ADJUST=TUKEY;
format A B 3.;
    quit;



	
	**************Loose Orthogonality****;

	
proc glm data=relief2;
   class A B;
   model hour=A|B;
        means A*B/ lines;
		LSMEANS A*B/PDIFF ADJUST=TUKEY;
format A B 3.;
    quit;
