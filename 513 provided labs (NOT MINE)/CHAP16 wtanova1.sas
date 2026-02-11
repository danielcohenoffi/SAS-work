
 ***CREATE A WORK FILE FOR THE DATA***;
data prob1;
input time group id;
cards;
  29.0      1      1
   42.0      1      2
   38.0      1      3
   40.0      1      4
   43.0      1      5
   40.0      1      6
   30.0      1      7
   42.0      1      8
   30.0      2      1
   35.0      2      2
   39.0      2      3
   28.0      2      4
   31.0      2      5
   31.0      2      6
   29.0      2      7
   35.0      2      8
   29.0      2      9
   33.0      2     10
   26.0      3      1
   32.0      3      2
   21.0      3      3
   20.0      3      4
   23.0      3      5
   22.0      3      6
;
run;



data prob1;
set prob1;                    *****Setting up the weighted dummy coding myself****;
x1=0;
x2=0;
x3=0;
if group = 1 then x1= 8/24;
if group = 2 then x2=10/24;
if group = 3 then x3=-18/24;
run;


proc glm data=prob1;
model time=x1 x2 x3/solution noint;
estimate 'Wt-ed derivation of x1'   x1 0.333;    ***we use the estimates statement and multiply the
                                                        solutions by their respective wts to get at
                                                        this weighted anova process.  Is there a
                                                        better way to do this in a standard
                                                        GLM?  YES.
                                                        With the Estimate and Contrast
                                                        Statements of Chapter 17***;

estimate 'Wt-ed derivation of x2'   x2 0.417;
estimate 'Wt-ed derivation of x3'   x3 -0.75;


quit;



data prob1x;
set prob1;                    *****Setting up the weighted dummy coding myself****;
x1=0;
x2=0;
x3=0;
if group = 1 then x1= 8/24;  ****SET WTS with X1 & X3 having + values****;
if group = 2 then x2=-14/24;
if group = 3 then x3=6/24;
run;


proc glm data=prob1x;
model time=x1 x2 x3/solution noint;
estimate 'Wt-ed derivation of x1'   x1 0.333;    ***we use the estimates statement and multiply the
                                                        solutions by their respective wts to get at
                                                        this weighted anova process.  Is there a
                                                        better way to do this in a standard
                                                        GLM?  YES.
                                                        With the Estimate and Contrast
                                                        Statements of Chapter 17***;

estimate 'Wt-ed derivation of x2'   x2 -0.583;
estimate 'Wt-ed derivation of x3'   x3 0.25;


quit;
