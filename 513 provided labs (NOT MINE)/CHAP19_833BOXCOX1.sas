*Section 19.4, two-way anova   ;


options formdlim=' ' ls=90 ps=50;
data Castle;
input sales height width store;
cards;
  47  1  1  1
  43  1  1  2
  46  1  2  1
  40  1  2  2
  62  2  1  1
  68  2  1  2
  67  2  2  1
  71  2  2  2
  41  3  1  1
  39  3  1  2
  42  3  2  1
  46  3  2  2
;
run;


title;
proc print data=Castle;
quit;
proc glm data=Castle;
   class height width;
   model sales=height width height*width;
   output out=a2 r=resid;
quit;




symbol1 v=square i=none c=blue;
symbol2 v=diamond i=none c=red;

proc gplot data=a2;
   plot resid*height=width/frame;
run;quit;


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

*******Box Cox Assessment for Transformation  *******;

proc freq data=a2;
tables height width;
quit;

	****I need dummy variables for TRANSREG*****;
data a2;
set a2;
h1 = (height = 1);
h2 = (height = 2);
w1 = (width = 1);
h1w1 = h1*w1;
h2w1 = h2*w1;
run;

proc transreg data=a2 PBO;
model boxcox(sales) = Identity(h1 h2 w1 h1w1 h2w1);
quit;


****Convenient lambda =1 (no transformation needed)  / Best lambda says square-root   *****;



proc glm data=Castle alpha=0.01;  ****Change alpha for CI in Means***;
   class height width;
   model sales=height width height*width/solution;
   means height width height*width /t clm; ***Get CI for MEANS***;
   lsmeans height width height*width /pdiff cl alpha=0.01;  **GET 99% CI FOR LSMEANS**;
format sales 6.2;
    quit;

proc glm data=Castle alpha=0.01;  ****Change alpha for CI in Means***;
   class height width;
   model sales=height width height*width/solution;
   means height width height*width /t clm; ***Get CI for MEANS***;
   lsmeans height width height*width /adjust=scheffe pdiff cl alpha=0.01;  **GET 99% CI FOR LSMEANS**;
format sales 6.2;
    quit;




proc glm data=Castle alpha=0.01;
   class height width;
   *class  width height;
   model sales=height width height*width/clparm solutions;***CI for Pcest & est***;
estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;
estimate 'mu32' intercept 1 height 0 0 1 width 0 1 height*width 0 0 0 0 0 1;
;
quit;

