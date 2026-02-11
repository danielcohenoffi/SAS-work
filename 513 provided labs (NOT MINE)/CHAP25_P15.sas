
/*Chapter 25: Pr 25.15.*/



options formdlim=' ' ls=90 ps=50;

data ratings;
  input rating driver car unit;
cards;
  25.3      1      1      1
   25.2      1      1      2
   28.9      1      2      1
   30.0      1      2      2
   24.8      1      3      1
   25.1      1      3      2
   28.4      1      4      1
   27.9      1      4      2
   27.1      1      5      1
   26.6      1      5      2
   33.6      2      1      1
   32.9      2      1      2
   36.7      2      2      1
   36.5      2      2      2
   31.7      2      3      1
   31.9      2      3      2
   35.6      2      4      1
   35.0      2      4      2
   33.7      2      5      1
   33.9      2      5      2
   27.7      3      1      1
   28.5      3      1      2
   30.7      3      2      1
   30.4      3      2      2
   26.9      3      3      1
   26.3      3      3      2
   29.7      3      4      1
   30.2      3      4      2
   29.2      3      5      1
   28.9      3      5      2
   29.2      4      1      1
   29.3      4      1      2
   32.4      4      2      1
   32.4      4      2      2
   27.7      4      3      1
   28.9      4      3      2
   31.8      4      4      1
   30.7      4      4      2
   30.3      4      5      1
   29.9      4      5      2
;
run;



proc print data=ratings;
quit;



proc sort data=ratings;
by car;
quit;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

title1 'Plot of the data';
symbol1 v=circle h=4 i=none c=black;;
proc gplot data=ratings;
   plot rating*driver=1/haxis=axis2 vaxis=axis1 frame;
by car;
AXIS1 LABEL = (C=BLACK a=90 F=SWISSL H=4 'Ratings') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Driver')  value=(h=3.5 f=swissb) minor=none   ;
run; quit;title1;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle h=4 i=none c=black;;
symbol2 v=circle h=4 i=none c=blue;;
symbol3 v=circle h=4 i=none c=red;;
symbol4 v=circle h=4 i=none c=orange;;
symbol5 v=circle h=4 i=none c=green;;
proc gplot data=ratings;
   plot rating*driver=car/haxis=axis2 vaxis=axis1 frame;
AXIS1 LABEL = (C=BLACK a=90 F=SWISSL H=4 'Ratings') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Driver')  value=(h=3.5 f=swissb) minor=none   ;
run; quit;title1;




					*****Method of Moments****;
proc mixed data=ratings method=type1 covtest cl alpha=0.01; ***CL for Variance Components****;
   class car driver;
   model rating=/solution cl alpha=0.01;       ****CL for Fixed Effects*****;
   random car driver car*driver;
quit;



proc mixed data=ratings method=reml covtest cl alpha=0.01; ***CL for Variance Components****;
   class car driver;
   model rating=/solution cl alpha=0.01;       ****CL for Fixed Effects*****;
   random car driver car*driver;  ***We were seeing if there was an interactive behavior
   									between our two random effects****;
quit;




proc mixed data=ratings method=reml covtest cl alpha=0.01; ***CL for Variance Components****;
   class car driver;
   model rating=/solution cl alpha=0.01;       ****CL for Fixed Effects*****;
   random car driver ;  ***interaction non-significant so we took it out*****;

quit;
			***DO we create a parsimonious model*****;

*****random effect to fixed?  But we say NO.  Remember, George Milliken said about random effects

Random effects are chosen prior to the data analysis and are treated as a source of 
variability (RANDOM EFFECT) regardless of Statistical significance*****;



***THIS IS OUR PARSIMONIOUS MODEL****;

proc mixed data=ratings method=reml covtest cl alpha=0.01; ***CL for Variance Components****;
   class car driver;
   model rating=/solution cl alpha=0.01;       ****CL for Fixed Effects*****;
   random car driver ;  ***interaction non-significant so we took it out*****;

quit;

