*one way anova using data in Table 17.2;


/*Chapter 17: Single-Factor ANOVA Model and Tests
Inputting the RUST INHIBITOR  data, table 17.2, p. 735.*/

options formdlim=' ' ls=90 ps=50;
data RUST;
  input delta mach UNIT;
cards;
  -0.14      1      1
   0.20      1      2
   0.07      1      3
   0.18      1      4
   0.38      1      5
   0.10      1      6
  -0.04      1      7
  -0.27      1      8
   0.27      1      9
  -0.21      1     10
   0.39      1     11
  -0.07      1     12
  -0.02      1     13
   0.28      1     14
   0.09      1     15
   0.13      1     16
   0.26      1     17
   0.07      1     18
  -0.01      1     19
  -0.19      1     20
   0.46      2      1
   0.11      2      2
   0.12      2      3
   0.47      2      4
   0.24      2      5
   0.06      2      6
  -0.12      2      7
   0.33      2      8
   0.06      2      9
  -0.03      2     10
   0.05      2     11
   0.53      2     12
   0.42      2     13
   0.29      2     14
   0.36      2     15
   0.04      2     16
   0.17      2     17
   0.02      2     18
   0.11      2     19
   0.12      2     20
   0.21      3      1
   0.78      3      2
   0.32      3      3
   0.45      3      4
   0.22      3      5
   0.35      3      6
   0.54      3      7
   0.24      3      8
   0.47      3      9
   0.62      3     10
   0.47      3     11
   0.55      3     12
   0.59      3     13
   0.71      3     14
   0.45      3     15
   0.48      3     16
   0.44      3     17
   0.50      3     18
   0.20      3     19
   0.61      3     20
   0.49      4      1
   0.58      4      2
   0.52      4      3
   0.29      4      4
   0.27      4      5
   0.55      4      6
   0.40      4      7
   0.14      4      8
   0.48      4      9
   0.34      4     10
   0.01      4     11
   0.33      4     12
   0.18      4     13
   0.13      4     14
   0.48      4     15
   0.54      4     16
   0.51      4     17
   0.42      4     18
   0.45      4     19
   0.20      4     20
  -0.19      5      1
   0.27      5      2
   0.06      5      3
   0.11      5      4
   0.23      5      5
   0.15      5      6
   0.01      5      7
   0.22      5      8
   0.29      5      9
   0.14      5     10
   0.20      5     11
   0.30      5     12
  -0.11      5     13
   0.27      5     14
  -0.20      5     15
   0.24      5     16
   0.20      5     17
   0.14      5     18
   0.35      5     19
  -0.18      5     20
   0.05      6      1
  -0.05      6      2
   0.28      6      3
   0.47      6      4
   0.12      6      5
   0.27      6      6
   0.08      6      7
   0.17      6      8
   0.43      6      9
  -0.07      6     10
   0.20      6     11
   0.01      6     12
   0.10      6     13
   0.16      6     14
  -0.06      6     15
   0.13      6     16
   0.43      6     17
   0.35      6     18
  -0.09      6     19
   0.05      6     20
 ;
run;

proc print data=RUST;
quit;

ods rtf file='c:\example.rtf';

proc means data=rust n mean stdev clm maxdec=2;
class mach;
var delta;
quit;
ods rtf close;






ods rtf file='c:\example.rtf';

proc glm data=RUST;
class mach;
model delta=mach/ss3;
quit;
ods rtf close;


proc means data=RUST; var delta; by mach;
   output out=K2 mean=avgrate;
quit;

proc print data=K2;quit;


        ******LINE PLOT****;

data K2;
set K2;
intcpt = 1;
run;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v='1' i=none c=blue height=2.5;;
symbol2 v='2' i=none c=red height=2.5;;
symbol3 v='3' i=none c=green height=2.5;;
symbol4 v='4' i=none c=black height=2.5;;
symbol5 v='5' i=none c=purple height=2.5;;
symbol6 v='6' i=none c=orange height=2.5;;
proc gplot data=K2;
LEGEND1 VALUE=(f=swissb h=3.0) label = (f=swissb h=3.0);
AXIS1 LABEL = none value=none minor=none   ;
AXIS2 LABEL = (C=BLACK  H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none   ;
PLOT intcpt*avgrate=mach/frame HAXIS=AXIS2 VAXIS=AXIS1 vref=1 legend=legend1;
                       ;
RUN;quit;




        ******SCATTER PLOT****;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

symbol1 v=circle i=none height=2.5;;
proc gplot data=RUST; plot delta*mach/frame;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'BRAND') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none   ;
PLOT delta*mach/frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;
proc print data=K2;quit;


proc sql;
create table rust as
select a.*, b.avgrate
from rust a left join K2 b 
on a.mach = b.mach;
quit;

proc print data=rust (obs=25);
quit;


symbol1 v=circle c=blue i=none height=2.5;;
symbol2 v=star c=red i = join height=2.5;
proc gplot data=RUST; 
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'BRAND') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none   ;
PLOT delta*mach=1 avgrate*mach=2/overlay frame HAXIS=AXIS1 VAXIS=AXIS2
                       ;
RUN;
QUIT;
proc print data=K2;quit;


        ****COLORED SCATTER PLOT****;

symbol1 v=circle c=red i=none height=2.5;;
symbol2 v=circle c=blue i=none height=2.5;;
symbol3 v=circle c=green i=none height=2.5;;
symbol4 v=circle c=purple i=none height=2.5;;
symbol5 v='5' i=none c=purple height=2.5;;
symbol6 v='6' i=none c=orange height=2.5;;
proc gplot data=RUST;
LEGEND1 VALUE=(f=swissb h=3.0) label = (f=swissb h=3.0);
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'BRAND') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none   ;
PLOT delta*mach=mach/frame HAXIS=AXIS1 VAXIS=AXIS2 legend=legend1;
                       ;
RUN;
QUIT;





                  *****BAR GRAPH*****;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;

axis1 minor=none label=("Delta" h=5.5 f=swissb
                                c=black)  value= (h=3.5 f=swissb
                                c=black)
;
axis2 minor=none
label=("(Average)" h=3.5 f=swissb
                                c=black)  value= (h=3.5 f=swissb
                                c=black)
 ;
proc gchart data=RUST;
vbar3d mach / type=MEAN sumvar=delta maxis=axis1 discrete
noframe shape=CYLINDER outside=MEAN raxis=axis2;
run; quit;




        **************MAIN EFFECTS PLOT****;


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
symbol1 v=circle c=red i=join height=2.5;;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'BRAND') value=(h=3.5 f=swissb) minor=none   ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Rating')  value=(h=3.5 f=swissb) minor=none ;
proc gplot data=K2;
plot avgrate*mach/frame HAXIS=AXIS1 VAXIS=AXIS2 vref=75;
run;quit;








                  *****BAR GRAPH with Error Bars*****;

goptions reset=global gunit=pct border cback=white rotate=landscape
         colors=(black blue green red) ftext=swiss
         ftitle=swissb htitle=5 htext=3.5 device=win;


axis1 label=('Mach' ) ;
  axis2 label=('Rate' j=c
             'Error Bar Confidence Limits: 95%')
       minor=(number=1);
     pattern1 color=yellow;

proc gchart data=RUST;
hbar mach / type=MEAN sumvar=delta   discrete
              freqlabel='Number per Mach'
              meanlabel='Mean delta'
              errorbar=both
              clm=95                         maxis=axis1
noframe  raxis=axis2               ;
run; quit;


ods rtf file='d:\example.rtf';

proc glm data=RUST alpha=0.05;      ***95%****;
class mach;
model delta=mach/ss3 solution clparm ;
quit;

ods rtf close;

   means mach/hovtest ;
   means mach/t clm;
lsmeans mach/stderr pdiff tdiff cl;
quit;


*******************CONFIDENCE INTERVALS*****;


ods rtf file='f:\example.rtf';


proc glm data=RUST alpha=0.05;      ***95%****;
class mach;
model delta=mach/ss3 solution clparm ;
*   means mach/hovtest ;
*   means mach/t clm;
*lsmeans mach/pdiff tdiff cl;
estimate 'intercept' intercept 1;                ****SAS is reading this as you want the CELL MEAN parameter estimate
															which is the grand mean*****;			
estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;
estimate 'mach 5 ' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'mach 6 ' intercept 1 mach 0 0 0 0 0 1 ;



*******a*******;
****H0: Avg of Old = Avg of Refurb -> Avg of Old - Avg of Refurb =0****;


estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'Avg_old' intercept 1 mach 0.5 0.5 0 0 0 0 ;


estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;
estimate 'avgref' intercept 1 mach 0 0 0.5 0.5 0 0;


estimate 'Avg_old' intercept 1 mach   0.5    0.5    0     0    0    0 ;
estimate 'avgref' intercept 1 mach     0     0     0.5    0.5  0    0;
estimate 'a' intercept 0 mach 0.5 0.5 -0.5 -0.5 0 0 ;
estimate 'a2'  mach 0.5 0.5 -0.5 -0.5 0 0 ;
contrast 'a2'  mach 0.5 0.5 -0.5 -0.5 0 0 ;

***D1***;

estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'D1' mach 1 -1 0 0 0 0;


****D2****;

estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;
estimate 'D2' mach 0 0 1 -1 0 0 ;

****D3*****;
estimate 'mach 5 ' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'mach 6 ' intercept 1 mach 0 0 0 0 0 1 ;
estimate 'D3' intercept 0 mach 0 0 0 0 1 -1;



*****l1******;

****H0: Avg of Old = Avg of Refurb -> Avg of Old - Avg of Refurb =0****;
estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'avg12' intercept 1 mach 0.5 0.5 0 0 0 0;



estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;
estimate 'avg34' intercept 1 mach 0 0 0.5 0.5 0 0;


estimate 'avg12' intercept 1 mach 0.5 0.5 0 0 0 0;
estimate 'avg34' intercept 1 mach 0 0 0.5 0.5 0 0;
estimate 'a' intercept 0 mach 0.5 0.5 -0.5 -0.5 0 0;
estimate 'L1' mach 0.5 0.5 -0.5 -0.5 0 0;
contrast 'a2' mach 0.5 0.5 -0.5 -0.5 0 0 ;


****l2****;

****H0: Avg of Old = Avg of Mew -> Avg of Old - Avg of New = 0****;
estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'avg12' intercept 1 mach 0.5 0.5 0 0 0 0;



estimate 'mach 5 ' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'mach 6 ' intercept 1 mach 0 0 0 0 0 1 ;
estimate 'avg56' intercept 1 mach 0 0 0 0 0.5 0.5 ;


estimate 'avg12' intercept 1 mach 0.5 0.5 0 0 0 0;
estimate 'avg56' intercept 1 mach 0 0 0 0 0.5 0.5 ;
estimate 'L2' intercept 0 mach 0.5 0.5 0 0 -0.5 -0.5 ;

*****L3: Avg 1256 = avg34****;

estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'mach 5 ' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'mach 6 ' intercept 1 mach 0 0 0 0 0 1 ;
estimate 'Avg1256' intercept 1 mach 0.25 0.25 0 0 0.25 0.25;


estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;
estimate 'avg34' intercept 1 mach 0 0 0.5 0.5 0 0;


estimate 'Avg1256' intercept 1 mach 0.25 0.25 0 0 0.25 0.25;
estimate 'avg34' intercept 1 mach 0 0 0.5 0.5 0 0;
estimate 'L3' mach 0.25 0.25 -0.5 -0.5 0.25 0.25;



*****L4: Avg 1234 = avg56****;

estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;

estimate 'Avg1234' intercept 1 mach 0.25 0.25   0.25 0.25 0 0 ;

estimate 'mach 5 ' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'mach 6 ' intercept 1 mach 0 0 0 0 0 1 ;
estimate 'avg56' intercept 1 mach 0 0 0 0 0.5 0.5 ;


estimate 'Avg1234' intercept 1 mach  0.25  0.25    0.25   0.25     0   0 ;
estimate 'avg56' intercept 1 mach      0     0        0     0    0.5   0.5 ;
estimate 'L4' mach 0.25 0.25 0.25 0.25 -0.5 -0.5;

quit;




proc glm data=RUST alpha=0.05;      ***95%****;
class mach;
model delta=mach/ss3 solution clparm ;
   means mach/hovtest ;
   means mach/t clm;
lsmeans mach/pdiff tdiff cl;
/*estimate 'intercept' intercept 1;
estimate 'mach 1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'mach2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'mach3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'mach 4' intercept 1 mach 0 0 0 1 0 0;
estimate 'mach 5 ' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'mach 6 ' intercept 1 mach 0 0 0 0 0 1 ;
*/



estimate 'D1' mach 1 -1 0 0 0 0;
estimate 'D2' mach 0 0 1 -1 0 0 ;
estimate 'D3' intercept 0 mach 0 0 0 0 1 -1;
estimate 'L1' mach 0.5 0.5 -0.5 -0.5 0 0;
estimate 'L2' intercept 0 mach 0.5 0.5 0 0 -0.5 -0.5 ;
estimate 'L3' mach 0.25 0.25 -0.5 -0.5 0.25 0.25;
estimate 'L4' mach 0.25 0.25 0.25 0.25 -0.5 -0.5;

ods output Estimates=est;

quit;

ods trace off;


proc print data=est;
quit;


proc contents data=est;
quit;



data est;
set est;
S_sq = (5)*FINV(0.90,5,114); ****5 is 6-1, 6= nr of levels, .90 is Confidence, 114 DDF****;

S_Lower = Estimate - sqrt(S_sq)*StdErr;
S_Upper = Estimate + sqrt(S_sq)*StdErr;
run;

quit;

proc print data=est;
quit;

data est;
set est;
B = TINV(1-0.10/(2*7),114);*****114 is DDF, 7 is the number of contrasts, .10 is alpha****;

B_Lower = Estimate - B*StdErr;
B_Upper = Estimate + B*StdErr;
run;

quit;

proc print data=est;
quit;

data est;
set est;
q = probmc("RANGE", ., 0.90, 114, 6);  ****Last 3 vaLUES ARE THE cONF, DDF, nR OF LEVELS, .90 is level of confidece*****;



T = (1/SQRT(2))*q;

T_Lower = Estimate - T*StdErr;
T_Upper = Estimate + T*StdErr;
run;

quit;

proc print data=est;
quit;




*****QC our contrast coding with the Bonferroni and the Tukey for contrast*****;


proc glm data=RUST alpha=0.05;      ***95%****;
class mach;
model delta=mach/ss3 solution clparm ;
   means mach/hovtest ;
   means mach/t clm;
lsmeans mach/pdiff tdiff cl alpha=0.01428;
lsmeans mach/pdiff tdiff cl alpha=0.10 adjust=tukey;
quit;



