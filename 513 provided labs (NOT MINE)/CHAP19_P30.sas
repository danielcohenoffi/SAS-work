
proc glm data=Cash order=internal ;
   class age gender;
   model cash=age gender age*gender;
   lsmeans age*gender/cl ;
format gender genfmt.;
format age agefmt.;
    quit;
*Pb 19.30, two-way anova;


options formdlim=' ' ls=90 ps=50;
data Cash;
input cash age gender id;
cards;
  21.0      1      1      1
   23.0      1      1      2
   19.0      1      1      3
   22.0      1      1      4
   22.0      1      1      5
   23.0      1      1      6
   21.0      1      2      1
   22.0      1      2      2
   20.0      1      2      3
   21.0      1      2      4
   19.0      1      2      5
   25.0      1      2      6
   30.0      2      1      1
   29.0      2      1      2
   26.0      2      1      3
   28.0      2      1      4
   27.0      2      1      5
   27.0      2      1      6
   26.0      2      2      1
   29.0      2      2      2
   27.0      2      2      3
   28.0      2      2      4
   27.0      2      2      5
   29.0      2      2      6
   25.0      3      1      1
   22.0      3      1      2
   23.0      3      1      3
   21.0      3      1      4
   22.0      3      1      5
   21.0      3      1      6
   23.0      3      2      1
   19.0      3      2      2
   20.0      3      2      3
   21.0      3      2      4
   20.0      3      2      5
   20.0      3      2      6
;
run;



proc print data=Cash;
quit;


*************RUN 2-way model with interaction****;



proc glm data=Cash PLOTS=all;  ****AUTO PLTS***;;
   class age gender;
   model cash=age gender age*gender;
   means age*gender;
   lsmeans age*gender/slice=age;
   lsmeans age*gender/slice=gender;
   lsmeans age*gender/pdiff cl adjust = tukey lines alpha=0.05 plots=(meanplot (join cl));
    quit;




************INTERACTION NOT SIGNIFICANT - RUN MAIN EFFECTS MODEL****;

proc glm data=Cash;
   class age gender;
   model cash=age gender ;
   means age gender;
   lsmeans age/pdiff;
   lsmeans gender/pdiff;
*format gender genfmt.;
*format age agefmt.;
    quit;



*******************CONFIDENCE INTERVALS - Mu 11*****;

****DEFAULT IS 95%****;

proc glm data=Cash order=internal ;
   class age gender;
   model cash=age gender age*gender;
   lsmeans age*gender/cl ;
format gender genfmt.;
format age agefmt.;
    quit;


proc glm data=Cash order=internal alpha=.01;****99% CI****;
   class age gender;
   model cash=age gender age*gender;
   lsmeans age*gender/cl ;
format gender genfmt.;
format age agefmt.;
    quit;


proc glm data=Cash order=internal ;
   class age gender;
   model cash=age gender age*gender;
   lsmeans age*gender/cl alpha=.01;  ****99% CI****;
format gender genfmt.;
format age agefmt.;
    quit;





**********************Gender Contrast*****;

proc glm data=Cash plots = none;  *****WOOOO - WATCH OUT TO WHAT THE FORMATS ARE DOING TO THE ORDERING OF THE CELLS***;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans gender/cl pdiff;


estimate 'Female Middle' intercept 1 age 1 0 0 gender 1 0 age*gender 1 0 0 0 0 0 ;
estimate 'Female old' intercept 1 age 0 1 0 gender 1 0 age*gender 0 0 1 0 0 0 ;
estimate 'female young' intercept 1 age 0 0 1 gender 1 0 age*gender 0 0 0 0 1 0 ;
estimate 'FEMALE' intercept 3 age 1 1 1 gender 3 0 age*gender 1 0 1 0 1 0 /divisor = 3;
estimate 'FEMALE' intercept 1  gender 1 0 ;


estimate 'male Middle' intercept 1 age 1 0 0 gender 0 1 age*gender 0 1  0 0 0 0 ;
estimate 'male old' intercept 1 age 0 1 0 gender 0 1  age*gender 0 0 0 1  0 0 ;
estimate 'male young' intercept 1 age 0 0 1 gender  0 1 age*gender 0 0 0 0 0 1 ;
estimate 'MALE' intercept 3 age 1 1 1 gender 0 3 age*gender 0 1 0 1 0 1  /divisor = 3;
estimate 'MALE' intercept 1  gender 0 1 ;

estimate 'feMALE' intercept 3 age 1 1 1 gender 3 0 age*gender 1 0 1 0 1 0 /divisor = 3;
estimate 'MALE' intercept 3 age 1 1 1 gender 0 3 age*gender 0 1 0 1 0 1 /divisor = 3;
estimate 'diff' gender 3 -3 age*gender 1 -1 1 -1 1 -1/divisor = 3;
estimate 'diff' gender 3 -3/divisor = 3;
    quit;

proc glm data=Cash ORDER=INTERNAL;  ***mAINTAINS THE NUMBERING ORDERING PER THE FORMATS OF THE CELLS***;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;  ***ANSWER PART A***;
lsmeans gender/cl pdiff;   ***wILL aNSWER PART C FOR US****;
format gender genfmt.;
format age agefmt.;

estimate 'Mal Young' intercept 1 age 1 0 0 gender 1 0 age*gender 1 0 0 0 0 0 ;***ANSWER PART A***;
estimate 'Mal Mid' intercept 1 age 0 1 0 gender 1 0 age*gender 0 0 1 0 0 0 ;


estimate 'Mal Young' intercept 1 age 1 0 0 gender 1 0 age*gender 1 0 0 0 0 0 ;***ANSWER PART A***;
estimate 'Mal Mid' intercept 1 age 0 1 0 gender 1 0 age*gender 0 0 1 0 0 0 ;
estimate 'Mal Old' intercept 1 age 0 0 1 gender 1 0 age*gender 0 0 0 0 1 0 ;

estimate 'MALE-(1)' intercept 3 age 1 1 1 gender 3 0 age*gender 1 0 1 0 1 0 /divisor = 3;
estimate 'MALE-(2)' intercept 1  gender 1 0 ;



estimate 'feMalE Young' intercept 1 age 1 0 0 gender 0 1 age*gender 0 1 0 0 0 0  ;
estimate 'fEMalE Mid' intercept 1 age 0 1 0 gender 0 1 age*gender  0 0 0 1 0 0  ;
estimate 'fEMalE Old' intercept 1 age 0 0 1 gender 0 1 age*gender  0 0 0 0 0 1  ;
estimate 'FEMALE-(1)' intercept 3 age 1 1 1 gender 0 3 age*gender 0 1 0 1 0 1 /divisor = 3;
estimate 'fEMALE-(2)' intercept 1  gender 0 1 ;

estimate 'MALE' intercept 3 age 1 1 1 gender 3 0 age*gender 1 0 1 0 1 0 /divisor = 3;
estimate 'FEMALE' intercept 3 age 1 1 1 gender 0 3 age*gender 0 1 0 1 0 1 /divisor = 3;
estimate 'diff-(1)' gender 3 -3 age*gender 1 -1 1 -1 1 -1/divisor = 3; ***THESE WILL ANSWER PART C FOR US**;
estimate 'diff-(2)' gender 3 -3/divisor = 3;
estimate 'diff-(2A)' gender 1 -1;
    quit;






proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans age/cl pdiff adjust=tukey alpha=0.10;



lsmeans age*gender/cl pdiff adjust=tukey alpah=0.10;



lsmeans age/cl pdiff adjust=scheffe alpah=0.10;


lsmeans age*gender/cl pdiff adjust=scheffe alpah=0.10;

lsmeans age/cl pdiff adjust=bon alpah=0.10;


lsmeans age*gender/cl pdiff adjust=bon alpah=0.10;

format gender genfmt.;
format age agefmt.;
    quit;



proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans age/cl pdiff adjust=sheffe alpah=0.10;
format gender genfmt.;
format age agefmt.;
    quit;


proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans age/cl pdiff adjust=bon alpah=0.10;
format gender genfmt.;
format age agefmt.;
    quit;


proc glm data=Cash;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans age/cl pdiff adjust=tukey alpah=0.10;
lsmeans age/cl pdiff adjust=SCHEFFE alpah=0.10;
lsmeans age/cl pdiff adjust=BON alpah=0.10;
format gender genfmt.;
format age agefmt.;
    quit;



proc glm data=Cash order=internal;
   class   AGE GENDER;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans age/cl pdiff adjust=bon alpah=0.10;
format gender genfmt.
;
format age agefmt.;
estimate 'ageL1' age 0.5 -1 0.5;

estimate 'ageL1-(1)' age 0.5 -1 0.5 AGE*GENDER 0.25 0.25 -0.5 -0.5 0.25 0.25;



estimate 'ageL1' age 0.5 -1 0.5;
estimate 'ageL1-(1)' age 0.5 -1 0.5 AGE*GENDER 0.25 0.25 -0.5 -0.5 0.25 0.25;
    quit;

                        ****NOTE BELOW USING FORMATTED VALUES FOR FACTORS
                                ORDERING IS ALPHABETICAL BY THE FORMATS***;

                        *****TO MAINTAIN THE ORIGINAL ORDERING USE
                                ORDER=INTERNAL IN THE PROC STATEMENT***;


proc glm data=Cash  ;  ****nOW REMEMBER WERE USING THE FORMATED ORDERING NOT THE DATA ORDERING***;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   lsmeans age*gender/cl;
lsmeans gender/cl pdiff;
format gender genfmt.;
format age agefmt.;
estimate 'FEMALE' intercept 100 age 60 10 30 gender 100 0 age*gender 60 0 10 0 30 0
                /divisor = 100;
estimate 'MALE' intercept 100 age 60 10 30 gender 0 100 age*gender 0 60 0 10 0 30
                /divisor = 100;

    quit;




*************************REMEMBER GOODNESS OF FIT in the TWO-WAY MODEL****;


        *****hov test*****;

                ******uSE THE OFATA VARIABLE TO ASSESS hov***;

proc glm data=Cash order=internal ;
   class age gender a_g;
   model cash=a_G;
MEANS a_G/HOVTEST;
QUIT;


PROC SORT DATA=CASH;
BY AGE GENDER;
QUIT;

PROC UNIVARIATE DATA=CASH NORMAL;
BY AGE GENDER;
VAR CASH;
QUIT;



proc glm data=Cash  ;  ****nOW REMEMBER WERE USING THE FORMATED ORDERING NOT THE DATA ORDERING***;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   OUTPUT OUT=O R=RESID P=PHAT;
   QUIT;


   PROC PRINT DATA=O;
   QUIT;

   PROC UNIVARIATE DATA=O NORMAL;
   VAR RESID;
   QUIT;


   ****what if our damp - SAID TO USE KOLMOGORIV -SMIRNOFF****;

   ****EVIDENCE IN DEVIATION IN NORMALITY****;


   ****BOX-COX ASSESSMENTS****;

   PROC MEANS DATA=CASH;
   VAR CASH;
   QUIT;

   /*  REMEMBER WITH THE BOX COX WE NEED THE OUTCOME TO BE POSITIVE  

   IF Y IS THE OUTCOME & MIN OF Y IS 0 THen WE USE A SHIFT ON Y:  Y2 = Y + shift;

   */



   /**** proc transreg requires dummy coding for the variables****/

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



   proc transreg data=cash pbo;  ****PBO WILL PRINT OUT THE TABLE SO YOU DON^T
                                                                                        NEED TO CHANGE THE OPTIONS TO PRINT OUT THE LISTING***;
   model BoxCox(cash) = Identity(male young middle male*young male*middle);
   quit;

   ****NEED TO CHANGE THE TOOLS -OPTIONS- PREFERENCES - RESULTS (ONLY CREATE lISTING CLICKED)*****;
   *****CONVENIENT LAMDA IS 1 - NO TRANSFORMATION*****;


   ****IF WE CHOSE THE BEST LAMBDA = 1.25, WE'D NEED THE FOLLOWING****;
   DATA CASH;
   SET CASH;
   CASH2 = (CASH)**1.25;
   RUN;

proc glm data=Cash  ;  ****nOW REMEMBER WERE USING THE FORMATED ORDERING NOT THE DATA ORDERING***;
   class age gender;
   model cash2=age gender age*gender/solution clparm;
   OUTPUT OUT=OO R=RESID P=PHAT;
   QUIT;




   PROC UNIVARIATE DATA=OO NORMAL;
   VAR RESID;
   QUIT;






proc glm data=Cash  ;  ****nOW REMEMBER WERE USING THE FORMATED ORDERING NOT THE DATA ORDERING***;
   class age gender;
   model cash=age gender age*gender/solution clparm;
   LSMEANS AGE*GENDER;
   QUIT;



   ****how big would i need to have 80% power for a significant interaction****;


   data meanvals;
   input age gender mncash;
   cards;
1 1 21.6666667
1 2 21.3333333
2 1 27.8333333
2 2 27.6666667
3 1 22.3333333
3 2 20.5000000
;
run;

/* ROOT MSE is 1.545603   */



  Proc glmpower data=meanvals;
Class age gender;
Model mncash = age gender age*gender ;
POWER STDDEV=1.545603 alpha=0.05 Ntotal=.  Power=0.80;
Run;
