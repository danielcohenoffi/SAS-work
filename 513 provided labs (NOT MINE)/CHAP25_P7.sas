
/*Chapter 25: Pr 25.7.*/



options formdlim=' ' ls=90 ps=50;

data ratings;
  input rating brand unit;
cards;
   24.4      1      1
   22.6      1      2
   23.8      1      3
   22.0      1      4
   24.5      1      5
   22.3      1      6
   25.0      1      7
   24.5      1      8
   10.2      2      1
   12.1      2      2
   10.3      2      3
   10.2      2      4
    9.9      2      5
   11.2      2      6
   12.0      2      7
    9.5      2      8
   19.2      3      1
   19.4      3      2
   19.8      3      3
   19.0      3      4
   19.6      3      5
    18.3      3      6
   20.0      3      7
   19.4      3      8
   17.4      4      1
   18.1      4      2
   16.7      4      3
   18.3      4      4
   17.6      4      5
   17.5      4      6
   18.0      4      7
   16.4      4      8
   13.4      5      1
   15.0      5      2
   14.1      5      3
   13.1      5      4
   14.9      5      5
   15.0      5      6
   13.4      5      7
   14.8      5      8
   21.3      6      1
   20.2      6      2
   20.7      6      3
   20.8      6      4
   20.1      6      5
   18.8      6      6
   21.1      6      7
   20.3      6      8
;
run;



proc print data=ratings;
quit;




goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

title1 'Plot of the data';
symbol1 v=circle h=4 i=none c=black;
proc gplot data=ratings;
   plot rating*brand/haxis=axis2 vaxis=axis1 frame;
AXIS1 LABEL = (C=BLACK a=90 F=SWISSL H=4 'Ratings') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Brand')  value=(h=3.5 f=swissb) minor=none   ;
run; quit;title1;




proc sort data=ratings;
by brand;
quit;


proc means data=ratings;
   output out=a2 mean=avrate;
   var rating;
   by brand;
quit;





title1 'Plot of the means';
symbol1 v=circle h=4 i=none c=black;
proc gplot data=a2;
   plot avrate*brand/haxis=axis2 vaxis=axis1 frame;
AXIS1 LABEL = (C=BLACK a=90 F=SWISSL H=4 'Ratings') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Brands')  value=(h=3.5 f=swissb) minor=none   ;
run; quit;title1;



****************WHAT IF WE JUST TREATED IT AS A FIXED EFFECTS MODEL***;

proc glm data=ratings ;
class brand;
model rating =brand;
means brand/hovtest;
lsmeans brand/tdiff pdiff;
quit;




************************RANDOM EFFECTS MODEL********;

						****method = reml is the default, so doesn't need to be there****';

proc mixed data=ratings method=reml covtest cl alpha=0.01; ***CL for Variance Components****;
   class brand;
   model rating=/solution cl alpha=0.01;       ****CL for Fixed Effects*****;
   *random brand / v vcorr;

   random brand /solution;  ***Deviation of the BLUP estimates from the overall MEAN (intercept) ****;

*lsmeans brand;  ****Only for fixed effects can we use LSMEANS****;


estimate 'Overall' intercept 1  /cl alpha=0.01;

/* BLUP ESTIMATES BELOW */
estimate 'br1' intercept 1 | brand 1 0  0 0 0 0 /cl alpha=0.01;
estimate 'br2' intercept 1 | brand 0 1  0 0 0 0 /cl alpha=0.01;
estimate 'br3' intercept 1 | brand 0 0  1 0 0 0 /cl alpha=0.01;
estimate 'br4' intercept 1 | brand 0 0  0 1 0 0 /cl alpha=0.01; ;
estimate 'br5' intercept 1 | brand 0 0  0 0 1 0 /cl alpha=0.01;
estimate 'br6' intercept 1 | brand 0 0  0 0 0 1 /cl alpha=0.01 ;
quit;

proc means data=ratings maxdec=2;
class brand;
var rating;
quit;



						***took method  = reml out****;
	
proc mixed data=ratings  covtest cl alpha=0.01; ***CL for Variance Components****;
   class brand;
   model rating=/solution cl alpha=0.01;       ****CL for Fixed Effects*****;
  
   random brand ;
estimate 'br1' intercept 1 |brand 1 0  0 0 0 0 /cl alpha=0.01;
estimate 'br2' intercept 1 |brand 0 1  0 0 0 0 /cl alpha=0.01;
estimate 'br3' intercept 1 |brand 0 0  1 0 0 0 /cl alpha=0.01;
estimate 'br4' intercept 1 |brand 0 0  0 1 0 0 /cl alpha=0.01; ;
estimate 'br5' intercept 1 |brand 0 0  0 0 1 0 /cl alpha=0.01;
estimate 'br6' intercept 1 |brand 0 0  0 0 0 1 /cl alpha=0.01 ;

	*****What about differences between levels of BLUPS*****;

estimate 'br2' intercept 1 |brand 0 1  0 0 0 0 /cl alpha=0.01;
estimate 'br4' intercept 1 |brand 0 0  0 1 0 0 /cl alpha=0.01; ;
estimate 'delta_2_4' intercept 0 | brand 0 1 0 -1 0 0 /cl alpha=.01;
estimate 'delta_2_4v2' | brand 0 1 0 -1 0 0 /cl alpha=.01;


	****Any contrasts is between or amomng the selected levels and only those levels****;

contrast 'delta_2_4v2' | brand 0 1 0 -1 0 0 ;
contrast 'delta_2_4v2 & 3_4' | brand 0 1 0 -1 0 0,| brand 0 0 1 -1 0 0  ;



contrast 'All 6 Levels' | brand 1 -1 0 0 0 0,| brand 0  1 -1 0 0 0 , | brand 0 0 1 -1 0 0 , 
							| brand 0 0 0 1 -1 0, |brand 0 0 0 0 1 -1;
								***Pretty close to the overall ANOVA F from PROC GLM,
									but this contrasts focuses on the difference betweeen the 6
									and only considering among these 6 observed levels. Not
									accounting/accomodating that these 6 are a selected realization from
									a larger collection of brands****;

quit;
