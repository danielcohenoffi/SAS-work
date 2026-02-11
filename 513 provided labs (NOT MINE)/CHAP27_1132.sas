/*Chapter 27: Repeated Measures
Inputting the Wine Judging Data, table 27.2, p. 1132.*/




options formdlim=' ' ls=90 ps=50;

data wine;
  input rating judge wine;
cards;
  20  1  1
  24  1  2
  28  1  3
  28  1  4
  15  2  1
  18  2  2
  23  2  3
  24  2  4
  18  3  1
  19  3  2
  24  3  3
  23  3  4
  26  4  1
  26  4  2
  30  4  3
  30  4  4
  22  5  1
  24  5  2
  28  5  3
  26  5  4
  19  6  1
  21  6  2
  27  6  3
  25  6  4
;
run;




/*ANOVA table of the wine data, table 27.3, p. 1133,  including a test
of the main effect of wine, p. 1132.
From the means statement we obtain the factor means and the grand
mean is part of the standard output of proc glm, table 27.2, p. 1132.*/


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=join c=blue height=2.5;;
symbol2 v=circle i=join c=red height=2.5;;
symbol3 v=circle i=join c=green height=2.5;;
symbol4 v=circle i=join c=black height=2.5;;
symbol5 v=circle i=join c=orange height=2.5;;
symbol6 v=circle i=join c=pink height=2.5;;
proc gplot data=wine;
LEGEND1 VALUE=(f=swissb h=3.0) label = (f=swissb h=3.0);
AXIS1 LABEL = (C=BLACK  H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none    ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Wine')  value=(h=3.5 f=swissb) minor=none   ;
PLOT rating*wine=judge/frame HAXIS=AXIS2 VAXIS=AXIS1  legend=legend1;
                       ;
RUN;quit;





proc glm data=wine;
  class wine judge;
  model rating = wine judge;
  means judge wine;
 quit;


proc mixed data=wine;
  class wine judge;
  model rating = wine ;
repeated wine/type=un subject=judge;

quit;

proc mixed data=wine;
  class wine judge;
  model rating = wine ;
repeated wine/type=cs subject=judge;

quit;

proc mixed data=wine;
  class wine judge;
  model rating = wine ;
random judge;

quit;







/*Diagnostic residual plots .*/
proc glm data=wine noprint;
  class wine judge;
  model rating = wine judge;
  output out=resid r=resid;
run;
quit;
symbol1 c=blue v=dot h=.8;
proc capability data=resid noprint;
  qqplot resid;
run;
data resid;
  set resid;
  if judge=1 then resid1=resid;
  if judge=2 then resid2=resid;
  if judge=3 then resid3=resid;
  if judge=4 then resid4=resid;
  if judge=5 then resid5=resid;
  if judge=6 then resid6=resid;
run;
axis1 order=(-2 to 2 by 1);
axis2 order=(3 2 1 4);
axis3 order=(1 3 2 4);
axis4 order=(3 2 4 1);
axis5 order=(2 3 1 4);
proc gplot data=resid;
  plot resid1*wine / vref=0 vaxis=axis1 haxis=axis2;
  plot resid2*wine / vref=0 vaxis=axis1 haxis=axis3;
  plot resid3*wine / vref=0 vaxis=axis1 haxis=axis4;
  plot resid4*wine / vref=0 vaxis=axis1 haxis=axis5;
  plot resid5*wine / vref=0 vaxis=axis1 haxis=axis4;
  plot resid6*wine / vref=0 vaxis=axis1 haxis=axis3;
run;
quit;
/*It is the lsmeans statement with a pdiff option that provides us
with all possible pair-wise comparisons of the mean rating of the
wines.*/
proc glm data=wine ;
  class wine judge;
  model rating = wine judge ;
  lsmeans wine / pdiff adjust=tukey cl;
run;
quit;






