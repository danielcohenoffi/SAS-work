*Section 23.2, two-way anova Unequal cell size;


options formdlim=' ' ls=90 ps=50;
data growth;
input delta gender develop pid;
cards;
  1.4  1  1  1
  2.4  1  1  2
  2.2  1  1  3
  2.1  1  2  1
  1.7  1  2  2
  0.7  1  3  1
  1.1  1  3  2
  2.4  2  1  1
  2.5  2  2  1
  1.8  2  2  2
  2.0  2  2  3
  0.5  2  3  1
  0.9  2  3  2
  1.3  2  3  3
;
run;



proc print data=growth;
quit;


proc freq data=growth;
tables gender*develop;
quit;


proc glm data=Growth plots = none;
   class gender develop / param = "effect" ;
   model delta=gender|develop /solution;
   lsmeans gender develop gender*develop /cl adjust = bon lines out = lsmeans_data;
estimate "grand mean" intercept 1;
    quit;




proc means data = lsmeans_data mean;
var lsmean;
run;


proc glm data=Growth;
   class gender develop;
   model delta=gender|develop /solution;
   means gender develop gender*develop ;
   lsmeans gender develop gender*develop /cl adjust = tukey lines;
****Compare  mu22 vs mu11 *****;

 estimate 'mu11' intercept 1 gender 1 0 develop 1 0 0 gender*develop 1 0 0 0 0 0 ;
 estimate 'mu22' intercept 1 gender 0 1 develop 0 1 0 gender*develop 0 0 0 0 1 0 ;
 estimate 'mu11 vs mu22' gender 1 -1 develop 1 -1 0 gender*develop 1 0 0 0 -1 0 ;
   lsmeans gender*develop /cl tdiff pdiff;


   ****Compare avg for severe and moderate for women to sever for boys****;
 estimate 'mu21' intercept 1 gender 0 1 develop 1 0 0 gender*develop 0 0 0 1 0 0  ;
 estimate 'mu22' intercept 1 gender 0 1 develop 0 1 0 gender*develop 0 0 0 0 1 0 ;
 estimate 'avgmu21mu22' intercept 1 gender 0 1 develop 0.5 0.5 0 gender*develop 0 0 0 0.5 0.5 0;

 estimate 'avgmu21mu22' intercept 1 gender 0 1 develop 0.5 0.5 0 gender*develop 0 0 0 0.5 0.5 0;
 estimate 'L2' gender 1 -1 develop 0.5 -0.5 0 gender*develop 1 0 0 -0.5 -0.5 0;



quit;


        *****CREATE A 0 CELL BY DELETING THE GIRL WITH SEVERE DEPRESS FROM THE ORG DATA***;

data growth2;
input delta gender develop pid;
cards;
  1.4  1  1  1
  2.4  1  1  2
  2.2  1  1  3
  2.1  1  2  1
  1.7  1  2  2
  0.7  1  3  1
  1.1  1  3  2
  2.5  2  2  1
  1.8  2  2  2
  2.0  2  2  3
  0.5  2  3  1
  0.9  2  3  2
  1.3  2  3  3
;
run;

proc freq data=growth2;
tables gender*develop;
quit;


proc glm data=Growth2 plots(only) = (diagnostics residuals fitplot intplot);
   class gender develop;
   model delta=gender|develop /solution;
   lsmeans gender develop gender*develop /cl adjust = tukey lines;
   ods exclude lsmeansplot;
   quit;


   ****WITH THIS ZERO CELL - WHAT DOES THE INTERACTION REALLY MEAN?****;
                ****lets do this as a one-way layout with the OFATA variable***;


data growth2; set growth2;
   if (gender eq 1)*(develop eq 1)
      then gb='1_Msev ';
   if (gender eq 1)*(develop eq 2)
      then gb='2_Mmod ';
   if (gender eq 1)*(develop eq 3)
      then gb='3_Mmild';
   if (gender eq 2)*(develop eq 1)
      then gb='4_Fsev ';
   if (gender eq 2)*(develop eq 2)
      then gb='5_Fmod ';
   if (gender eq 2)*(develop eq 3)
      then gb='6_Fmild';
run;


proc glm data=Growth2 plots(only) = (diagnostics residuals fitplot intplot)   ;
   class gender develop GB;
   model delta=GB /solution;
   means GB /hovtest;
   lsmeans GB /adjust = tukey cl tdiff pdiff;
   ods exclude lsmeansplot;
   quit;





proc glm data=Growth2
  plots(only) = (diagnostics residuals fitplot intplot)
;
   class gender develop;
   model delta=gender develop;
   lsmeans gender develop/adjust = tukey lines pdiff ;
   ods exclude lsmeansplot
    quit;

proc glm data=Growth2
  plots = all
;
   class gender develop;
   model delta=gender develop;
   lsmeans gender develop/adjust = tukey lines pdiff ;
   ods exclude lsmeansplot
    quit;




proc glm data=Growth 
 plots(only) = (diagnostics residuals fitplot intplo);
   class gender develop;
   model delta= develop;
   means  develop /hovtest ;
   lsmeans develop/pdiff adjust = tukey lines ;
   ods exclude lsmeansplot;
    quit;



****BOOK USES DUMMY CODING*****;


data growth; set growth;

if gender = 1 then X1=-1;
if gender = 2 then X1=1;

x2=0;
if develop = 1 then x2 = 1;
if develop = 3 then x2 = -1;
x3=0;
if develop = 2 then x3 = 1;
if develop = 3 then x3 = -1;


run;


proc glm data=Growth;
   class gender develop;
   model delta=gender|develop /solution;
   means gender develop gender*develop ;
   lsmeans gender develop gender*develop;
   lsmeans gender*develop/pdiff;
    quit;




proc glm data=Growth;
   class gender develop;
   model delta= x1 x2 x3 x1*x2 x1*x3;
contrast 'inter' x1*x2 1, x1*x3 1;
contrast 'develop' x2 1, x3 1;
    quit;




proc glm data=Growth;
   class gender develop;
   model delta= x1 x2 x3;
    quit;




proc glm data=Growth;
   class gender develop;
   model delta= x2 x3 x1*x2 x1*x3;
    quit;




proc glm data=Growth;
   class gender develop;
   model delta= x1 x1*x2 x1*x3;
    quit;




ods rtf file='c:\example.rtf';


proc glm data=Growth;
   class gender develop;
   model delta=gender|develop;
    quit;

ods rtf close;



****BUILD ALL POSSIBLE CONTRASTS****;


proc glm data=Growth;
   class gender develop;
   model delta=gender|develop /solution clparm;
lsmeans gender*develop;



estimate 'mu11' intercept 1 gender 1 0 develop 1 0 0 gender*develop 1 0 0 0 0 0 ;
estimate 'mu21' intercept 1 gender 0 1 develop 1 0 0 gender*develop 0 0 0 1 0 0 ;
estimate 'mu.1' intercept 1 gender 0.5 0.5 develop 1 0 0 gender*develop 0.5 0 0 0.5 0 0 ;
    quit;








proc freq data=growth;
tables gender*develop;
quit;



proc glm data=Growth;
   class gender develop;
   model delta=gender|develop /solution;
estimate 'mu21' intercept 1 gender 0 1 develop 1 0 0 gender*develop  0 0 0 1 0 0 ;
quit;



  *******************EMPTY CELLS***********;


options formdlim=' ' ls=90 ps=50;
data growth;
input delta gender develop pid;
cards;
  1.4  1  1  1
  2.4  1  1  2
  2.2  1  1  3
  2.1  1  2  1
  1.7  1  2  2
  0.7  1  3  1
  1.1  1  3  2
  2.5  2  2  1
  1.8  2  2  2
  2.0  2  2  3
  0.5  2  3  1
  0.9  2  3  2
  1.3  2  3  3
;
run;



proc print data=growth;
quit;


proc freq data=growth;
tables gender*develop;
quit;




symbol1 v=circle c=green i=sm60;
symbol2 v=star c=purple i=sm60;
proc gplot data=growth;
   plot delta*develop=gender/frame;
run;quit;


data growth; set growth;
   if (gender eq 1)*(develop eq 1)
      then gb='1_Msev ';
   if (gender eq 1)*(develop eq 2)
      then gb='2_Mmod ';
   if (gender eq 1)*(develop eq 3)
      then gb='3_Mmild';
   if (gender eq 2)*(develop eq 1)
      then gb='4_Fsev ';
   if (gender eq 2)*(develop eq 2)
      then gb='5_Fmod ';
   if (gender eq 2)*(develop eq 3)
      then gb='6_Fmild';
run;

title1 'Plot of the data';
symbol1 v=circle i=none c=black;
proc gplot data=growth;
   plot delta*gb/frame;
run; quit;


proc sort data=growth;
by gender develop;
quit;

proc means data=growth;
by gender develop;
var delta;
output out=a2 mean=avgdelta;
quit;

proc print data=a2;
quit;


symbol1 v=circle c=green i=join;
symbol2 v=star c=purple i=join;
proc gplot data=a2;
plot avgdelta*develop=
            gender/frame;
run; quit;




******POSSIBLE CONTRASTS****;


proc glm data=Growth;
   class gender develop gb;
model delta=gb;
means gb/hovtest tukey scheffe lines;
quit;

proc glm data=Growth;
   class gender develop gb;
model delta=gender|develop;

quit;


***********Unequal Importance of Cell Means*****;


options formdlim=' ' ls=90 ps=50;
data growth;
input delta gender develop pid;
cards;
  1.4  1  1  1
  2.4  1  1  2
  2.2  1  1  3
  2.1  1  2  1
  1.7  1  2  2
  0.7  1  3  1
  1.1  1  3  2
  2.4  2  1  1
  2.5  2  2  1
  1.8  2  2  2
  2.0  2  2  3
  0.5  2  3  1
  0.9  2  3  2
  1.3  2  3  3
;
run;

data growth; set growth;
gb1=0; gb2=0; gb3=0; gb4=0; gb5=0; gb6=0;
   if (gender eq 1)*(develop eq 1)

      then gb1=1;
   if (gender eq 1)*(develop eq 2)
      then gb2=1;
   if (gender eq 1)*(develop eq 3)
      then gb3=1;;
   if (gender eq 2)*(develop eq 1)
      then gb4=1;;
   if (gender eq 2)*(develop eq 2)
      then gb5=1;;
   if (gender eq 2)*(develop eq 3)
      then gb6=1;
run;



proc print data=Growth;

var gender develop gb1-gb6;
quit;


***we set u21=2u12+u22-2u11;
***we also set u23=2u12-2u13=u22;


****We^re interest to see if the chnage in the growth rate for the 3 development groups is ot
the same:  F=(SSE(R)-SSE(F)/(dfr-dfF))/(SSE(F)/dff)  ~ F(dfr-dff, dff)***;


data Growth;
set Growth;

z1 = gb1-2*gb4;
z2=gb2+2*gb4+2*gb6;
z3=gb3-2*gb6;

z4=gb4+gb5+gb6;
run;



proc print data=Growth;

var gender develop gb1-gb6 z1-z4;
quit;



proc glm data=Growth;
   class gender develop ;
model delta=gb1 gb2 gb3 gb4 gb5 gb6/noint ;
quit;



proc glm data=Growth;
   class gender develop ;
model delta=z1 z2 z3 z4/noint;
quit;


   *****Weighted Contrast by Sample Size****;

proc freq data=Growth;
tables gender*develop/nopercent norow nocol;
quit;




proc glm data=Growth;
   class gender develop ;
model delta=gender|develop/solution ;
estimate 'Male wt avg' intercept 7 gender 7 0 develop 3 2 2
gender*develop 3 2 2 0 0 0 /divisor = 7;
estimate 'FeMale wt avg' intercept 7 gender 0 7 develop 1 3 3
gender*develop 0 0 0 1 3 3  /divisor = 7;
contrast 'Delta Gender' gender 7 -7 develop 2 -1 -1 gender*develop 3 2 2 -1 -3 -3;
lsmeans gender/cl;

quit;
