***two-way anova with one observation per cell using data in Table 20.2;



data policy;
   input premium size region;
cards;
  140  1  1
  100  1  2
  210  2  1
  180  2  2
  220  3  1
  200  3  2
;
run;

data policy;
set policy;

if size=1 then sizea='small ';
if size=2 then sizea='medium';
if size=3 then sizea='large ';
run;



proc glm data=policy  PLOTS=all;  ****AUTO PLTS***;;   
;
   class sizea region;
   model premium=sizea|region/solution;
   *model premium = sizea region sizea*region/solution;
quit;

proc glm data=policy  PLOTS=all;  ****AUTO PLTS***;;   
;
   class sizea region;
   model premium=sizea region/solution;
   means sizea region / tukey;
   output out=a2 p=muhat;
quit;


proc print data=a2; run;
symbol1 v='E' i=join c=black;
symbol2 v='W' i=join c=black;
title1 'Plot of the data';
proc gplot data=a2;
   plot premium*sizea=region/frame;
run; quit;

symbol1 v='E' i=join c=black;
symbol2 v='W' i=join c=black;
title1 'Plot of the model estimates';
proc gplot data=a2;
   plot muhat*sizea=region/frame;
run;quit;



*****TUKEY ADDITIVITY FOR INTERACTION EFFECT****;

proc glm data=policy  PLOTS=all;  ****AUTO PLTS***;;   
;
   class size;
   model premium=size;
   output out=aA p=muhatA;
quit;

proc print data=aA;
quit;

proc glm data=policy;
   class region;
   model premium=region;
   output out=aB p=muhatB;
quit;

proc print data=aB;
quit;

;
data Tukey;
merge a2 aA aB;
   alpha=muhatA-muhat;
   beta=muhatB-muhat;
   ab=alpha*beta;
run;


proc print data=Tukey;
   var size region muhat muhatA muhatB alpha beta ab;
quit;

proc glm data=Tukey  PLOTS=all;  ****AUTO PLTS***;;   
;
   class size region;
   model premium=size region ab/solution;
quit;
