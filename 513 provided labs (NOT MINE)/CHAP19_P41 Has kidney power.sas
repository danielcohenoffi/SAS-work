*Pb 19.41, two-way anova

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
y = log10(days+1);
run;

proc glm data = kidney;

proc glm data=kidney;
   class A B;
   model Y=A|B;
lsmeans A|B /cl pdiff adjust = tukey lines;
run;

data kidney_means;
input A $ B $ Y;
datalines;
1 1 0.44
1 2 0.81
1 3 1.11
2 1 0.40
2 2 0.58
2 3 0.87
;
run;

proc glmpower data = kidney_means;
class A B;
model Y = A|B;
power 
  stddev = 0.32
  ntotal = .
  power = 0.90
  alpha = 0.025;  /* Bonferroni: 0.10/4 */
  contrast "A effect" A (1 -1);
  contrast "B1 vs B2" B (1 -1 0);
  contrast "B1 vs B3" B (1 0 -1);
  contrast "B2 vs B3" B (0 1 -1);
run;



proc glmpower data=kidney_means;
class A B;
model Y = A B A*B;
power 

	effects = (A B A*B)
  stddev = 0.32
	alpha = 0.10
  ntotal = .
  power = 0.80;
run; 

proc power;
onesamplemeans ci = t
halfwidth = 0.20
stdev = 0.32
probwidth = 0.5
ntotal = .
alpha = 0.025;
run;

data find_n;
do n = 10 to 40;
df = 6*n -6;
t_value = quantile('T' ,.975, df);
se = 0.32 * sqrt(2/n);
halfwidth =- t_value *SE;
output;
end;
run;


proc print data = find_n;
var n halfwidth;
where halfwidth <= 0.20;
run;

Proc glmpower data=Fluids;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
*contrast 'Delta Low Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=.  Power=0.80;
Run;




proc glmpower data = kidney;
class A B;
model Y = A|B;
power
groupmeans =  0.44 | 0.81 1.11    /* A1: B1=0.44, B2=0.81, B3=1.11 */
    0.40 | 0.58 0.87
effectsize = .50
contrast 'A' A 1 - 1;
contrast 'B1' B 1 -1 0;
contrast 'B2' B 1 0 -1;
contrast 'B3' B 0 1 -1;
stdev = .31
npergroup = .
power = .80;
run;


data sample;
do n = 1 to 100;
                                      *****17.22, we let n be
                                                the cell size in our
'                                                       6 cells of the twoway
                                                ANOVA***;

valueA = tinv((0.9875),(n-1)*2*3)*sqrt(2*0.32*0.32/(3*n));
valueB = tinv((0.9875),(n-1)*2*3)*sqrt(2*0.32*0.32/(2*n));

                        ****alpha = 0.10, alpha/2 = 0.05, divide by
                                        four for Bonferonni***;


output;
end;
run;

proc print data=sample;
quit;

  Proc glmpower data=kidney;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
contrast 'Delta HIGH Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=.  Power=0.80;
Run;
