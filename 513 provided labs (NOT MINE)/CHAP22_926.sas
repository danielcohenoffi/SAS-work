**** one-way analysis of covariance using data from Table 22.1  page 926;


data Cracker;
   input cases last treat store;
cards;
  38  21  1  1
  39  26  1  2
  36  22  1  3
  45  28  1  4
  33  19  1  5
  43  34  2  1
  38  26  2  2
  38  29  2  3
  27  18  2  4
  34  25  2  5
  24  23  3  1
  32  29  3  2
  31  30  3  3
  21  16  3  4
  28  29  3  5
;
run;

proc glm data=Cracker plots = all;
   class treat;
   model cases=treat;
   means treat /hovtest;
quit;




proc glm data=Cracker plots = all;
   class treat;
   model cases=last treat;
quit;


proc glm data=Cracker;
   class treat;
   model cases=last treat/solution;
quit;


options formdlim=' ' ls=90 ps=50;

proc glm data=Cracker;
   class treat;
   model cases= treat;
   lsmeans treat/pdiff cl;
quit;
proc glm data=Cracker;
   class treat;
   model cases= treat;
   lsmeans treat/stderr tdiff pdiff cl;
quit;



proc means data=cracker maxdec=2;
class treat;
var last cases;
quit;

proc means data=cracker maxdec=2;
var last cases;
quit;

proc glm data=Cracker;
   class treat;
   model cases=last treat ;
   lsmeans treat/stderr tdiff pdiff cl;
quit;



proc means data=cracker;
var last;
quit;


title1 'Plot of the data with the model';
proc glm data=Cracker;
   class treat;
   model cases=last treat;
   output out=a2 p=pred;
quit;
data a3; set a2;
   drop cases pred;
   if treat eq 1 then do
     cases1=cases;
     pred1=pred;
     output; end;
   if treat eq 2 then do
     cases2=cases;
     pred2=pred;
     output; end;
  if treat eq 3 then do
     cases3=cases;
     pred3=pred;
     output; end;
proc print data=a3;
run;
symbol1 v='1' i=none c=black;
symbol2 v='2' i=none c=black;
symbol3 v='3' i=none c=black;
symbol4 v=none i=rl c=black;
symbol5 v=none i=rl c=black;
symbol6 v=none i=rl c=black;
proc gplot data=a3;
   plot (cases1 cases2  cases3 pred1 pred2 pred3)*last/frame overlay;
run;
title1 'Check for equal slopes';
proc glm data=Cracker;
   class treat;
   model cases=last treat last*treat;  ******THE BIG THING HERE IS THE INTERACTION TERM
                                                                                        IS GIVEN US THE TEST OF SIGNIFICANCE FOR
                                                                                                THE CONSTANCY OF SLOPE  ****;

quit;



quit;
proc glm data=Cracker;
   class treat;
   model cases=last treat/solution clparm ;
quit;



data Cracker;
set Cracker;
delta = cases - last;
run;

*****Raw Change Model****;



proc glm data=Cracker;
   class treat;
   model delta=treat;
   means treat / hovtest;
   lsmeans treat/stderr tdiff pdiff cl;
quit;


*****ANCOVA - Residualized Change Model*****;

proc glm data=Cracker;
   class treat;
   model delta=last treat /solution ;
   lsmeans treat/stderr tdiff pdiff cl;
quit;



*****Original ANCOVA******;

proc glm data=Cracker;
   class treat;
   model cases=last treat/solution ;
   lsmeans treat/stderr tdiff pdiff cl;
quit;



data cracker;
set cracker;
tx1= (Treat=1);
tx2=(Treat =2);
run;


******Focusing on the derived equations on the board where we converted the change scores
to Y2ij - Y1ij and isolated Y2ij, we want Y2ij as the outcome in testing whether
the coefficient of the covariate is different than 1 or not*****;


proc reg data=cracker;
model cases =last tx1 tx2;
b_eq1: test last=1;  ***** STATISTICAL TEST OF WHETHER THE COEFFICIENT OF LAST IS EQUAL TO 1
                                                        THIS MAY HELP PEOPLE DECIDE THATS ITS OK TO USE A RAW CHANGE
                                                        MODEL RATHER THAN AN ANCOVA MODEL (RESIDUALIZED MODEL)******;

quit;



DATA cracker;
set cracker;
centlast = last - 25;
zlast = (last - 25)/5.0709255;
run;



proc glm data=Cracker;
   class treat;
   model cases=last treat/solution;
   lsmeans treat;
quit;
proc glm data=Cracker;
   class treat;
   model cases=centlast treat/solution;
   lsmeans treat;
quit;
proc glm data=Cracker;
   class treat;
   model cases=zlast treat/solution;
   lsmeans treat;
quit;



proc glm data=Cracker;
   class treat;
   model cases=zlast treat/solution;
   lsmeans treat;
   means treat;  ***PRODUCES UNADJUSTED MEAN VALUES.  WE DONT WANT THIS EVER !!!!!! ****;

quit;
