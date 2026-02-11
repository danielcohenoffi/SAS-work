



/*Inputting Sheffield Foods Co. data, table 25.12, p. 1071.*/
data Sheffield;
  input fat method lab rep ;
cards;
5.19  1  1  1
5.09  1  1  2
4.09  1  2  1
3.99  1  2  2
3.75  1  2  3
4.04  1  2  4
4.06  1  2  5
4.62  1  3  1
4.32  1  3  2
4.35  1  3  3
4.59  1  3  4
3.71  1  4  1
3.86  1  4  2
3.79  1  4  3
3.63  1  4  4
3.26  2  1  1
3.48  2  1  2
3.24  2  1  3
3.41  2  1  4
3.35  2  1  5
3.04  2  1  6
3.02  2  2  1
3.32  2  2  2
2.83  2  2  3
2.96  2  2  4
3.23  2  2  5
3.07  2  2  6
3.08  2  3  1
2.95  2  3  2
2.98  2  3  3
2.74  2  3  4
3.07  2  3  5
2.70  2  3  6
2.98  2  4  1
2.89  2  4  2
2.75  2  4  3
3.04  2  4  4
2.88  2  4  5
3.20  2  4  6
;
run;





goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle h=4 i=none c=black;
axis1 order=(0 to 5 by 1) label=( C=BLACK a=90 F=SWISSL H=4 a=90 'Laboratory') value=(h=3.5 f=swissb) ;
axis2 order=(2.5 to 5.5 by 1) label=( C=BLACK F=SWISSL H=4 'Fat') value=(h=3.5 f=swissb) ;
proc gplot data=sheffield;
  by method;
  plot lab*fat=1/ vaxis=axis1 haxis=axis2;
run;
quit;

proc sql;
  create table plot as
  select method, lab, mean(fat) as mfat
  from sheffield
  where method=1
  group by lab;
quit;


proc sql;
  create table plot1 as
  select method, lab, mean(fat) as mfat1
  from sheffield
  where method=2
  group by lab;
quit;


data combo;
  set plot plot1;
run;



symbol1 c=blue v=dot h=.8 i=join;
symbol2 c=red v=square h=.8 i=join;
axis1 order=(0 to 5 by 1) label=( C=BLACK  F=SWISSL H=4  'Laboratory') value=(h=3.5 f=swissb) ;
axis2 order=(2.5 to 5.5 by 1) label=( C=BLACK a=90 F=SWISSL H=4 'Fat') value=(h=3.5 f=swissb) ;
legend1 label=none value=(height=1 font=swiss 'Method 1' 'Method 2' )
        position=(bottom right inside) mode=share cborder=black;
proc gplot data=combo;
  plot (mfat mfat1)*lab / vaxis=axis2 haxis=axis1 overlay legend=legend1;
run;
quit;





proc mixed data=sheffield method = reml covtest;
class lab method;
model fat = method/cl solution;
random lab lab*method;
estimate 'mu' intercept 1 method 0.5 0.5 /cl;
lsmeans method/tdiff pdiff;
quit;


			*****we will retain lab as random since labs were randomly chosen****;

			*****we modeled the lab by method interaction, since its not significant we
						will take it out****;

proc means data=sheffield;
class method;
var fat;
quit;

proc mixed data=sheffield method = reml covtest;
class lab method;
model fat = method/cl solution;
random lab ;   ***although lab is not significant, which means
				the average fat contents does not show significant difference across the randomly
						selected labs, we retain it as a source of variability in our acquired data**;

estimate 'mu' intercept 1 method 0.5 0.5 /cl;  ***Estimates grand mean fat rating***;
lsmeans method/tdiff pdiff;  *** will display the mean fat rating for the two methods
									AND THE DIFFERENCE BETWEEN THE TWO LEVELS OF OUR FIXED
									EFFECT METHOD****;

quit;
