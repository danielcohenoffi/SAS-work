




data FILL;
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

proc print data=FILL;
quit;



proc glm data=fill;
class  mach;
model delta = mach /solution clparm;
means mach;
estimate 'u1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'u2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'u3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'u4' intercept 1 mach 0 0 0 1 0 0 ;
estimate 'u5' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'u6' intercept 1 mach 0 0 0 0 0 1 ;






estimate 'u1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'u2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'L1: u1-u2' mach 1 -1 0  0 0 0;



estimate 'u3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'u4' intercept 1 mach 0 0 0 1 0 0 ;
estimate 'L2: u3-u4' mach 0 0 1 -1 0 0;




estimate 'u1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'u2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'avg12' intercept 1 mach 0.5 0.5 0 0 0 0 ;


estimate 'u3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'u4' intercept 1 mach 0 0 0 1 0 0 ;
estimate 'avg34' intercept 1 mach 0 0 0.5 0.5 0 0 ;

estimate 'avg12' intercept 1 mach 0.5 0.5 0 0 0 0 ;
estimate 'avg34' intercept 1 mach 0 0 0.5 0.5 0 0 ;
estimate 'L3:avg12 - avg34' mach 0.5 0.5 -0.5 -0.5 0 0;


estimate 'u1' intercept 1 mach 1 0 0 0 0 0 ;
estimate 'u2' intercept 1 mach 0 1 0 0 0 0 ;
estimate 'u3' intercept 1 mach 0 0 1 0 0 0 ;
estimate 'u4' intercept 1 mach 0 0 0 1 0 0 ;
estimate 'avg1234' intercept 1 mach 0.25 0.25 0.25 0.25 0 0;


estimate 'u5' intercept 1 mach 0 0 0 0 1 0 ;
estimate 'u6' intercept 1 mach 0 0 0 0 0 1 ;
estimate 'avg56' intercept 1 mach 0 0 0 0 0.5 0.5  ;


estimate 'avg1234' intercept 1 mach 0.25 0.25 0.25 0.25 0 0;
estimate 'avg56' intercept 1 mach 0 0 0 0 0.5 0.5  ;

estimate 'L4: avg1234 - avg56' mach 0.25 0.25 0.25 0.25 -0.5 -0.5;

quit;


proc glm data=fill alpha=0.0125;  *  0.05 / 4***;

class  mach;
model delta = mach /solution clparm;
means mach;
estimate 'L1: u1-u2' mach 1 -1 0  0 0 0;
estimate 'L2: u3-u4' mach 0 0 1 -1 0 0;
estimate 'L3:avg12 - avg34' mach 0.5 0.5 -0.5 -0.5 0 0;
estimate 'L4: avg1234 - avg56' mach 0.25 0.25 0.25 0.25 -0.5 -0.5;

quit;


        ****L1 and L2 Contrasts****;

proc iml;
t = tinv((1-(0.05/4)/2), 594);  ***ASSUME Nt = 600 at first***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 61***;

print ni;
quit;




        ****L1 and L2 Contrasts****;

proc iml;
t = tinv((1-(0.05/4)/2), 360);  ***ASSUME Nt = 366 at second***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 61***;

print ni;
quit;




        *************If we started out with 4 per group****;
proc iml;
t = tinv((1-(0.05/4)/2), 18);  ***ASSUME Nt = 24 at first***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***value 75***;

print ni;
quit;



proc iml;
t = tinv((1-(0.05/4)/2), 444);  ***ASSUME Nt = 450 second iteration***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 61***;

print ni;
quit;

proc iml;
t = tinv((1-(0.05/4)/2), 6);  ***ASSUME Nt = 12 second iteration***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 120***;

print ni;
quit;

proc iml;
t = tinv((1-(0.05/4)/2), 714);  ***ASSUME Nt = 720 second iteration***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 61***;

print ni;
quit;

proc iml;
t = tinv((1-(0.05/4)/2), 360);  ***ASSUME Nt = 366 at second***;

print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 61***;

print ni;
quit;

        ****L3 Contrasts****;

proc iml;
t = tinv((1-(0.05/4)/2),66 );  ****Assume 12 per group****;
print t;

ni = (t*0.1759*sqrt(1)/0.08)**2;  ****CONVERGED On 32***;

print ni;
quit;

proc iml;
t = tinv((1-(0.05/4)/2),186 );  ****Assume 32 per group****;
print t;

ni = (t*0.1759*sqrt(1)/0.08)**2;  ****CONVERGED On 31***;

print ni;
quit;



proc iml;
t = tinv((1-(0.05/4)/2),180 );  ****Assume 31 per group****;
print t;

ni = (t*0.1759*sqrt(1)/0.08)**2;  ****CONVERGED On 31***;

print ni;
quit;

        ****L4 Contrasts****;

proc iml;
t = tinv((1-(0.05/4)/2), 174);  ****Assume 30 per group  ****
print t;

ni = (t*0.1759*sqrt(0.75)/0.08)**2;  ****CONVERGED On 24***;

print ni;
quit;

proc iml;
t = tinv((1-(0.05/4)/2), 138);  ****Assume 24 per group  ****
print t;

ni = (t*0.1759*sqrt(0.75)/0.08)**2;  ****CONVERGED On 24***;

print ni;
quit;



        ****2 Biggest Contrasts****;


proc iml;
t = tinv((1-(0.05/4)/2), 360);
print t;

ni = (t*0.1759*sqrt(2)/0.08)**2;   ***CONVERGED on 61***;

print ni;
quit;
