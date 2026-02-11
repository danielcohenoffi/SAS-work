*Pb 19.34, two-way anova ;


options formdlim=' ' ls=90 ps=50;
data kidney;
input days A B id;
cards;
   0.0      1      1      1
    2.0      1      1      2
    1.0      1      1      3
    3.0      1      1      4
    0.0      1      1      5
    2.0      1      1      6
    0.0      1      1      7
    5.0      1      1      8
    6.0      1      1      9
    8.0      1      1     10
    2.0      1      2      1
    4.0      1      2      2
    7.0      1      2      3
   12.0      1      2      4
   15.0      1      2      5
    4.0      1      2      6
    3.0      1      2      7
    1.0      1      2      8
    5.0      1      2      9
   20.0      1      2     10
   15.0      1      3      1
   10.0      1      3      2
    8.0      1      3      3
    5.0      1      3      4
   25.0      1      3      5
   16.0      1      3      6
    7.0      1      3      7
   30.0      1      3      8
    3.0      1      3      9
   27.0      1      3     10
    0.0      2      1      1
    1.0      2      1      2
    1.0      2      1      3
    0.0      2      1      4
    4.0      2      1      5
    2.0      2      1      6
    7.0      2      1      7
    4.0      2      1      8
    0.0      2      1      9
    3.0      2      1     10
    5.0      2      2      1
    3.0      2      2      2
    2.0      2      2      3
    0.0      2      2      4
    1.0      2      2      5
    1.0      2      2      6
    3.0      2      2      7
    6.0      2      2      8
    7.0      2      2      9
    9.0      2      2     10
   10.0      2      3      1
    8.0      2      3      2
   12.0      2      3      3
    3.0      2      3      4
    7.0      2      3      5
   15.0      2      3      6
    4.0      2      3      7
    9.0      2      3      8
    6.0      2      3      9
    1.0      2      3     10
;
run;



proc print data=kidney;
quit;


data kidney;
set kidney;
   if A eq 1 and B eq 1 then A_B='A=Short_B=Mild';
   if A eq 1 and B eq 2 then A_B='A=Short_B=Mod';
   if A eq 1 and B eq 3 then A_B='A=Short_B=Subs';
   if A eq 2 and B eq 1 then A_B='A=Long_B=Mild';
   if A eq 2 and B eq 2 then A_B='A=Long_B=Mod';
   if A eq 2 and B eq 3 then A_B='A=Long_B=Subs';

   /*  Could create a numeric version for the OFATA  */
   			A_B2 = 10*A+B;
   

run;

proc freq data=kidney;
tables A*B*A_B*A_B2/list;
quit;



proc sort data=kidney;
by A B;
quit;


proc means data=kidney;
   var days;
   by A B;
   output out=a2 mean=avgday;
quit;

proc print data=a2;
quit;

        
proc sort data=a2;
by A B;
quit;

proc sort data=kidney;
by A B;
quit;

DATA A2ALL;
MERGE kidney a2;
by A B;
run;


proc print data=A2all;
quit;
                                                                                                                                                                     
    
goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;
                                                                                                                                                                                      
                                                                                                                                                                                          
                                                                                                                                                                                          
       proc sgplot data=A2all noautolegend;                                                                                                                                               
xaxis type=discrete Label = 'Duration by Wt Gain OFATA';                                                                                                                                           
yaxis label ="Days";;                                                                                                                                                                     
scatter x=A_B y=avgday / markerattrs=(size=12 symbol=star color=black) ;  ;                                                                                                              
scatter x=A_B y=days / markerattrs=(size=10) ;                                                                                                                                            
quit;                                                                                                                                                                                     
                                                                                                                                                                                          
run                                                                                                                                                                                       
;                                                                                                                                                                                         
                    



proc glm data=kidney;
class A_B;
model days=A_B;
means A_B/hovtest;
quit;


*****TWo-WAY PLOT***;


proc format;
value Afmt 1='Short' 2='Long' ;
value Bfmt 1='Mild' 2='Mod' 3='Subs';

quit;

                                                                                                                                                                           
                                                                                                                                                                                          
                                                                                                                                                                                          
       proc sgplot data=A2All ;                                                                                                                                                           
xaxis type=discrete Label = 'Duration by Wt Gain';;                                                                                                                                             
yaxis label ="DAYS";;                                                                                                                                                                     
series x=a y=avgday /group=B;                                                                                                                                                     
scatter x=a y=days /group=B markerattrs=(size=10) ;                                                                                                                                
quit;                                                                                                                                                                                     
                                   
                                                                                                                                                                    
                                                                                                                                                                                          
       proc sgplot data=A2All ;                                                                                                                                                           
xaxis type=discrete Label = 'Wt Gain by Duration';;                                                                                                                                             
yaxis label ="DAYS";;                                                                                                                                                                     
series x=b y=avgday /group=a;                                                                                                                                                     
scatter x=b y=days /group=A markerattrs=(size=10) ;                                                                                                                                
quit;                                                                                                                                                                                     
                         

*************RUN 2-way model with interaction****;


proc glm data=kidney;
   class A_B;
   model days=A_B;
means A_B/hovtest;
quit;




                        ********What about Normality of the
                                        Outcome*****;
proc sort data=kidney;
by A_B;
quit;
proc univariate data=kidney normal noprint;
by A_B;
var days;
output out=z normal=normal probN=pvalue;
quit;
proc print data=z label;
quit;


proc mixed data=kidney;  *****HETEROGENEOUS MODEL******;
class A B A_B;
model days = A|B /outpm = resid ddfm = satterth;
repeated / group=A_B ;

quit;

proc univariate data=resid normal;
var resid;
quit;

proc sort data=resid;
  by A_B;
run;

proc univariate data=resid normal;
  var resid;
  by A_B;
  ods select TestsForNormality;  * Clean output - just normality tests;
run;





proc means data=kidney;
var days;
quit;

                  ******REASON TO DO THIS: BEFORE WE GO TO TRANSREG WE NEED THE
                                SUPPORT SET OF THE OUTCOME TO NOT CONTAIN 0****;

data kidney;
set kidney;
days_P1 = days+1;
run;

data kidney;
set kidney;
if A=1 and B=1 then c11 = 1; else c11 = 0;
if A=1 and B=2 then c12 = 1; else c12 = 0;
if A=1 and B=3 then c13 = 1; else c13 = 0;
if A=2 and B=1 then c21 = 1; else c21 = 0;
if A=2 and B=2 then c22 = 1; else c22 = 0;
if A=2 and B=3 then c23 = 1; else c23 = 0;
if A=3 and B=1 then c31 = 1; else c31 = 0;
if A=3 and B=2 then c32 = 1; else c32 = 0;
if A=3 and B=3 then c33 = 1; else c33 = 0;
run;


****Using all the cell indicators: OK but overparameterized  ****;

proc transreg data=kidney PBO;
model BoxCOX(days_P1) = identity(c11 c12 c13 c21 c22 c23 c31 c32) ;
quit;



data kidney;
set kidney;
A1 = (A = 1);
A2 = (A = 2);
B1 = (B = 1);
B2 = (B = 2);
run;

****Using all the dummy indicators: OK but overparameterized  ****;
proc transreg data=kidney PBO;
model BoxCOX(days_P1) = identity(A1 A2 B1 B2 A1*B1 A1*B2 A2*B1 A2*B2) ;
quit;


****Using correct amount of the cell indicators: number of dummies needed is 1 less than the 
										number of levels per factor.
										interaction is composed of the product of the dummies
										per factor****;
proc transreg data=kidney PBO;
model BoxCOX(days_P1) = identity(A1 B1 B2 A1*B1 A1*B2) ;
quit;

data kidney;
set kidney;
y = log10(days+1);  ****Base 10****;

/**  Back transformations when needed
10^y = days+1
10^y - 1 = days  */

run;


                        ********What about Normality of the
                                        Outcome*****;
proc sort data=kidney;
by A_B;
quit;
proc univariate data=kidney normal noprint;
by A_B;
var y;
output out=z normal=normal probN=pvalue;
quit;
proc print data=z label;
quit;


proc means data=kidney;
var days;
quit;



proc glm data=kidney;
   class A_B;
   model Y=A_B;
means A_B/hovtest;
quit;



proc glm data=kidney  PLOTS=all;  ****AUTO PLTS***;;   
;
   class A B;
   model y=A|B;  ****Remember A|B SAS sees as A B A*B ****;
   means A*B;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl tdiff pdiff;
format A  afmt.;
format B  bfmt.;
    quit;



****************GO TO THE LOG SCALE***;

data kidney;
set kidney;
Y = log(days + 1);   *****Base e****;

run;


data kidney;
set kidney;
Y = log10(days + 1);   *****Stick with Base 10****;

run;


proc sort data=kidney;
by A B;
quit;


proc means data=kidney;
   var Y;
   by A B;
   output out=a2 mean=avgY;
quit;

proc print data=a2;
quit;

symbol1 v=square h=3 i=join c=red;
symbol2 v=diamond h=3 i=join c=green;
symbol3 v=circle h=3 i=join c=gold;
proc gplot data=a2;
   plot avgY*A=B/frame  haxis = 1 to 2 by 1;
run;quit;


proc sort data=a2;
by A B;
quit;

proc sort data=kidney;
by A B;
quit;

DATA A2ALL;
MERGE kidney a2;
by A B;
run;


proc print data=A2all;
quit;

data a2All;
set a2all;
B2 = B+3;
run;


proc format;
value Afmt 1='Short' 2='Long' ;
value Bfmt 1='Mild' 2='Mod' 3='Subs';
value Bbfmt 4='Mild' 5='Mod' 6='Subs';

quit;

proc means data=A2all;
quit;



goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;
symbol1 v=square h=1 i=join c=red;
symbol2 v=diamond h=1 i=join c=green;
symbol3 v=circle h=1 i=join c=gold;
symbol4 v=square h=3 i=none c=red;
symbol5 v=diamond h=3 i=none c=green;
symbol6 v=circle h=3 i=none c=gold;

proc gplot data=a2all;
   plot avgY*A=B/frame haxis = 1 to 2 by 1
                 vaxis = 0 to 4 by 1;
plot2 avgY*A=B2/frame vaxis = 0 to 4 by 1;
format A Afmt.;
format B Bfmt.;
format B2 Bbfmt.;
run;quit;




data kidney;
set kidney;
y2 = log10(days + 1);
run;


proc glm data=kidney;
   class A B;
   model Y2=A|B;
   means A*B;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl pdiff;
quit;



proc glm data=kidney;
   class A B;
   model Y=A|B;
   means A*B;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl pdiff;
quit;



proc univariate data=kidney normal;
var days;
quit;



***********INTERACTION MODEL***;


proc glm data=kidney;
   class A B;
   model Y=A|B;
   means A*B;
   lsmeans A*B/slice=A;
   lsmeans A*B/slice=B;
        lsmeans A*B/cl;
        lsmeans A*B/cl pdiff;
format A  afmt.;
format B  bfmt.;
    quit;



*****MAIN EFFECTS MODEL FOR A***;


proc glm data=kidney;
   class A B;
   model Y=A;
   means A/hovtest;
   lsmeans A;
format A  afmt.;
    quit;



proc glm data=kidney alpha = 0.10;
   class A B;
   model Y=A;
   means A;
   lsmeans A/pdiff adjust=scheffe cl;
   lsmeans A/pdiff adjust=tukey cl;
   lsmeans A/pdiff adjust=bonferroni cl;
format A  afmt.;
    quit;

   *****MAIN EEFFECTS MODEL FOR B***;


proc glm data=kidney;
   class A B;
   model Y=B;
   means B/hovtest;
   lsmeans B;
format B  bfmt.;
    quit;


proc glm data=kidney alpha = 0.10;
   class A B;
   model Y=B;
   means B;
   lsmeans B/pdiff adjust=scheffe cl;
   lsmeans B/pdiff adjust=tukey cl;
   lsmeans B/pdiff adjust=bonferroni cl;
format B  bfmt.;
    quit;



        **********Main effects model****;

proc glm data=kidney alpha = 0.10;
   class A B;
   model Y=A B;

   means A;
   lsmeans A/pdiff adjust=scheffe cl;
   lsmeans A/pdiff adjust=tukey cl;
   lsmeans A/pdiff adjust=bonferroni cl;
format A  afmt.;
   means B;
   lsmeans B/pdiff adjust=scheffe cl;
   lsmeans B/pdiff adjust=tukey cl;
   lsmeans B/pdiff adjust=bonferroni cl;
format B  bfmt.;
    quit;


********************Boferonni Plot****;

ods trace on;


proc glm data=kidney alpha=0.10;
class A;
model Y = A ;
lsmeans A/pdiff adjust=bon cl alpha=0.10;
ods output  LSMeanDiffCL=o;
quit;

ods trace off;

proc print data=o label;
quit;


data o;
set o;
pair = 10*i+j;
run;

proc print data=o label;
quit;

proc contents data=o position;
quit;

proc print data=o ;
quit;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=o gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=dot  i=none C=red ci=red height=2.5;
SYMBOL3 v=circle  i=none C=green ci=green height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Difference')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT  Difference*pair=2 lowerCl*pair =1 upperCL*pair = 3/overlay
HAXIS=AXIS1 VAXIS=AXIS2  frame vref=0;
format Difference LowerCl upperCl 6.2;
                        ;
RUN;
quit;




ods trace on;


proc glm data=kidney alpha=0.10;
class B;
model Y = B ;
lsmeans B/pdiff adjust=bon cl alpha=0.10;
ods output   LSMeanDiffCL=o;
quit;

ods trace off;

proc print data=o label;
quit;


data o;
set o;
pair = 10*i+j;
run;

proc print data=o label;
quit;

proc contents data=o position;
quit;

proc print data=o ;
quit;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=o gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=dot  i=none C=red ci=red height=2.5;
SYMBOL3 v=circle  i=none C=green ci=green height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'Difference')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')

value=(h=3 f=swissb) minor=none ;
PLOT  Difference*pair=2 lowerCl*pair =1 upperCL*pair = 3/overlay
HAXIS=AXIS1 VAXIS=AXIS2  frame vref=0;
format Difference LowerCl upperCl 6.2;
                        ;
RUN;
quit;



proc glm data=kidney alpha=0.05;
class A B;
model Y = A|B /clparm ;
estimate 'Overall Avg' intercept 1 A 0.5 0.5 B 0.3 0.4 0.3 A*B 0.15 0.20 0.15 0.15 0.20 0.15;
estimate 'OvAvg2' intercept 1 b 0.3 0.4 0.3;
ods output Estimates=est;

quit;




proc print data=est;
quit;

proc contents data=est position short;
quit;



/**  Back transformations when needed
y = log10(days + 1);
10^y = days+1
10^y - 1 = days  */


data est;
set est;
array info(*)  Estimate LowerCL UpperCL;
array tinfo(*) T_Estimate T_LowerCL T_UpperCL;
do i = 1 to dim(info);
tinfo(i) = 10**(info(i)) - 1;
end;
drop i;
run;



proc print data=est;
quit;
