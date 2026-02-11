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



proc print data=Castle;
quit;

proc glm data=Castle;
   class height width;
   model sales=height width height*width;
   means height width height*width;
   lsmeans height width height*width;
    quit;

proc glm data=Castle;
   class height width;
   model sales= height*width height width;
   means height width height*width /hovtest;
   lsmeans height width height*width;
    quit;



data Castle; set Castle;
   if height eq 1 and width eq 1 then hw='1_BR';
   if height eq 1 and width eq 2 then hw='2_BW';
   if height eq 2 and width eq 1 then hw='3_MR';
   if height eq 2 and width eq 2 then hw='4_MW';
   if height eq 3 and width eq 1 then hw='5_TR';
   if height eq 3 and width eq 2 then hw='6_TW';
run;

proc glm data=Castle;
   class hw;
   model sales= hw;
        means hw/hovtest;
    quit;



data Castle; set Castle;
   if height eq 1 and width eq 1 then hw='1_BR';
   if height eq 1 and width eq 2 then hw='2_BW';
   if height eq 2 and width eq 1 then hw='3_MR';
   if height eq 2 and width eq 2 then hw='4_MW';
   if height eq 3 and width eq 1 then hw='5_TR';
   if height eq 3 and width eq 2 then hw='6_TW';
run;


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
symbol1 v=dot i=none h=3;
proc gplot data=Castle;
   plot sales*hw/frame;
run;quit;

proc means data=Castle;
   var sales;
   by height width;
   output out=a2 mean=avsales;
quit;

proc print data=a2;
quit;

symbol1 v=square i=join c=black;
symbol2 v=diamond i=join c=black;


proc gplot data=a2;
   plot avsales*height=width/frame;
run;quit;


proc sort data=a2;
by height width;
quit;

proc sort data=Castle;
by height width;
quit;

DATA A2ALL;
MERGE castle a2;
by height width;
run;


proc print data=A2all;
quit;




 proc sgplot data=A2All noautolegend;
xaxis type=discrete Label = 'Height and Width';
yaxis label ="Sales";;
series x=hw y=avsales;
quit;

run
;




       proc sgplot data=A2All noautolegend;
xaxis type=discrete Label = 'Height and Width';;
yaxis label ="Sales";;
scatter x=hw y=sales / markerattrs=(size=10) ;
quit;

run
;

       proc sgplot data=A2All noautolegend;
xaxis type=discrete Label = 'Height and Width';;
yaxis label ="Sales";;
series x=hw y=avsales;
scatter x=hw y=sales / markerattrs=(size=10) ;
quit;

run
;



data a2All;
set a2all;
width2 = width+2;
run;

symbol1 v=square i=join c=black;
symbol2 v=diamond i=join c=black;
symbol3 v=square i=none c=RED;
symbol4 v=diamond i=none c=RED;

proc gplot data=a2all;
   plot avsales*height=width/frame haxis = 1 to 3 by 1
                 vaxis = 20 to 80 by 10;;
plot2 sales*height=width2/frame haxis = 1 to 3 by 1
                 vaxis = 20 to 80 by 10;;
run;quit;





       proc sgplot data=A2All noautolegend;
xaxis type=discrete Label = 'Height and Width';;
yaxis label ="Sales";;
series x=height y=avsales /group=width;
scatter x=height y=sales /group=width markerattrs=(size=10) ;
quit;





proc glm data=CASTLE;
   class height width;
   model sales=height width height*width/solution;
   means height*width;
quit;


proc glm data=Castle alpha=0.05 PLOTS=all;  ****AUTO PLTS***;
   class height width;
   model sales=height width height*width/solution;
   means height width height*width /t clm; ***Get CI for MEANS***;
   lsmeans height*width /pdiff cl alpha=0.05 plots=(meanplot (join cl));  **GET 95% CI FOR LSMEANS**;
format sales 6.2;
    quit;






data Castle2;
input sales height width store;
cards;
  47  1  1  1
  43  1  1  2
  46  1  2  1
  40  1  2  2
  62  2  1  1
  68  2  1  2
  62  2 1 3
  67  2  2  1
  71  2  2  2
  42  3  2  1
  46  3  2  2
;
run;



proc glm data=CASTLE2;
   class height width;
   model sales=height width height*width/solution;
   means height*width;
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



proc glm data=Castle alpha=0.01;  ****Change alpha for CI in Means***;
   class height width;
   model sales=height width height*width/solution;
   means height width height*width /t clm; ***Get CI for MEANS***;
   lsmeans height width height*width /pdiff cl alpha=0.01;  **GET 99% CI FOR LSMEANS**;
format sales 6.2;
    quit;

proc glm data=Castle alpha=0.01 plots = none;  ****Change alpha for CI in Means***;
   class height width;
   model sales=height width height*width/solution;
   means height width height*width /t clm; ***Get CI for MEANS***;
   lsmeans height width height*width /adjust=scheffe pdiff cl alpha=0.01;  **GET 99% CI FOR LSMEANS**;
format sales 6.2;
    quit;


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


proc glm data=Castle ;
   class height width;
   model sales=height width height*width/ solutions;
   lsmeans height*width/tdiff pdiff cl;
   lsmeans height*width/tdiff pdiff cl adjust=tukey;
   lsmeans height*width/tdiff pdiff cl adjust=scheffe;
   lsmeans height*width/tdiff pdiff cl adjust=bon;
quit;

proc glm data=Castle alpha=0.01;
   class height width;
   model sales=height width height*width/clparm solutions;
***CI for Pest & est***;
lsmeans height width/tdiff pdiff cl;    ***Pdiff for Lsmeans***;
lsmeans  height*width/tdiff pdiff cl;    ***Pdiff for Lsmeans***;
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


estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'avg_mid' intercept 1 height 0 1 0 width 0.5 0.5 height*width 0 0 0.5 0.5 0 0 ;

estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;
estimate 'mu32' intercept 1 height 0 0 1 width 0 1 height*width 0 0 0 0 0 1;
estimate 'AvgRest' intercept 1 height 0.5 0 0.5 width 0.5 0.5 height*width 0.25 0.25 0 0 0.25 0.25;


estimate 'avg_mid' intercept 1 height 0 1 0 width 0.5 0.5 height*width 0 0 0.5 0.5 0 0 ;
estimate 'AvgRest' intercept 1 height 0.5 0 0.5 width 0.5 0.5 height*width 0.25 0.25 0 0 0.25 0.25;
estimate 'contrast1' height -0.5 1 -0.5  height*width -0.25 -0.25 0.5 0.5 -0.25 -0.25; 
estimate 'contrast1b'intercept 0 height -0.5 1 -0.5 width 0 0  height*width -0.25 -0.25 0.5 0.5 -0.25 -0.25; 
contrast 'contrast1' height -0.5 1 -0.5  height*width -0.25 -0.25 0.5 0.5 -0.25 -0.25; 


estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;

estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;
estimate 'mu32' intercept 1 height 0 0 1 width 0 1 height*width 0 0 0 0 0 1;


estimate 'mu21' intercept 3 height 0 3 0 width 3 0 height*width 0 0 3 0 0 0 /divisor = 3;
estimate 'AvgNext3' intercept 3 height 0 1 2 width 1 2 height*width 0 0 0 1 1 1 /divisor = 3;
estimate 'contrast2' height 0 2 -2 width 2 -2 height*width 0 0 3 -1 -1 -1 /divisor = 3;
contrast 'contrast2'  height 0 2 -2 width 2 -2 height*width 0 0 3 -1 -1 -1 ;



estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;

estimate 'AvgReg' intercept 3 height 1 1 1 width 3 0 height*width 1 0 1 0 1 0 /divisor = 3;


estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'mu32' intercept 1 height 0 0 1 width 0 1 height*width 0 0 0 0 0 1;
estimate 'AvgWide' intercept 3 height 1 1 1 width 0 3 height*width 0 1 0 1 0 1 /divisor = 3;

estimate 'AvgReg' intercept 3 height 1 1 1 width 3 0 height*width 1 0 1 0 1 0 /divisor = 3;
estimate 'AvgWide' intercept 3 height 1 1 1 width 0 3 height*width 0 1 0 1 0 1 /divisor = 3;
estimate 'Contrast3' width 3 -3 height*width 1 -1 1 -1 1 -1  /divisor = 3;
estimate 'Contrast3' width 3 -3   /divisor = 3;



estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'del1' width 1 -1 height*width 1 -1 0 0 0 0 ;


estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'del2' width 1 -1 height*width 0 0 1 -1 0 0 ;

estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;
estimate 'mu32' intercept 1 height 0 0 1 width 0 1 height*width 0 0 0 0 0 1;
estimate 'del3' width 1 -1 height*width 0 0 0 0 1 -1;


estimate 'del1' width 1 -1 height*width 1 -1 0 0 0 0 ;
estimate 'del2' width 1 -1 height*width 0 0 1 -1 0 0 ;
estimate 'diff of 12' height*width 1 -1 -1 1 0 0;

estimate 'del1' width 1 -1 height*width 1 -1 0 0 0 0 ;
estimate 'del3' width 1 -1 height*width 0 0 0 0 1 -1;
estimate 'diff of 13' height*width 1 -1 0 0 -1 1 ;


estimate 'del2' width 1 -1 height*width 0 0 1 -1 0 0 ;
estimate 'del3' width 1 -1 height*width 0 0 0 0 1 -1;
estimate 'diff of 23' height*width 0 0 1 -1 -1 1;


estimate 'diff of 12' height*width 1 -1 -1 1 0 0;
estimate 'diff of 13' height*width 1 -1 0 0 -1 1 ;
estimate 'diff of 23' height*width 0 0 1 -1 -1 1;

contrast 'Simul' height*width 1 -1 -1 1 0 0, height*width 1 -1 0 0 -1 1 , height*width 0 0 1 -1 -1 1;


   quit;



/*  Change around as needed 

lsmeans  height*width/tdiff pdiff cl;    ***Pdiff for Lsmeans***;


   quit;

estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;




estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;





estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1  width 1 0 height*width 0 0 0 0 1 0 ;
estimate 'mu32' intercept 1 height 0 0 1  width 0 1 height*width 0 0 0 0 0 1 ;

                        ***************LET^S ESTIMATE THE DELTA ACROSS WIDTH PER HEIGHT****;

estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;


estimate 'delta1' intercept 0 height 0 0 0 width 1 -1 height*width 1 -1 0 0 0 0 ;
estimate 'delta1a' width 1 -1 height*width 1 -1 0 0 0 0 ;
estimate 'delta1b' width 1 -1 height*width 1 -1  ;

estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'delta2' width 1 -1 height*width 0 0 1 -1 0 0 ;

estimate 'mu31' intercept 1 height 0 0 1  width 1 0 height*width 0 0 0 0 1 0 ;
estimate 'mu32' intercept 1 height 0 0 1  width 0 1 height*width 0 0 0 0 0 1 ;
estimate 'delta3' width 1 -1 height*width 0 0 0 0 1 -1;


estimate 'delta1a' width 1 -1 height*width 1 -1 0  0  0 0 ;
estimate 'delta2' width 1 -1 height*width  0  0 1 -1  0 0 ;
estimate 'delta3' width 1 -1 height*width 0 0 0 0 1 -1;


estimate 'delta1-delta2' height*width 1 -1 -1 1 0 0 ;
estimate 'delta2-delta3' height*width 0 0 1 -1 -1 1;

contrast 'interaction' height*width 1 -1 -1 1 0 0 ,height*width 0 0 1 -1 -1 1;




 quit;


estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
 */
quit;


proc glm data=Castle alpha=0.01;
   class height width;
   model sales=height width height*width/clparm solutions;***CI for Pest & est***;

lsmeans height height*width/pdiff cl;    ***Pdiff for Lsmeans***;
estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1  width 1 0 height*width 0 0 0 0 1 0 ;
estimate 'mu32' intercept 1 height 0 0 1  width 0 1 height*width 0 0 0 0 0 1 ;

estimate 'mu31' intercept 1 height 0 0 1 width 1 0 height*width 0 0 0 0 1 0;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;


estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'Avg21_22' intercept 1 height 0 1 0 width 0.5 0.5 height*width 0 0 0.5 0.5 0 0 ;

estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1  width 1 0 height*width 0 0 0 0 1 0 ;
estimate 'mu32' intercept 1 height 0 0 1  width 0 1 height*width 0 0 0 0 0 1 ;
estimate 'Avg11_12_31_32' intercept 1 height 0.5 0 0.5 width 0.5 0.5 height*width 0.25 0.25 0 0 0.25 0.25;



estimate 'Avg21_22' intercept 1 height 0 1 0 width 0.5 0.5 height*width 0 0 0.5 0.5 0 0 ;
estimate 'Avg11_12_31_32' intercept 1 height 0.5 0 0.5 width 0.5 0.5 height*width 0.25 0.25 0 0 0.25 0.25;
estimate 'H0' height -0.5 1 -0.5  height*width -0.25 -0.25 0.5 0.5 -0.25 -0.25;
estimate 'H0a' intercept 0 height -0.5 1 -0.5 width 0 0   height*width -0.25 -0.25 0.5 0.5 -0.25 -0.25;


contrast 'H0' height -0.5 1 -0.5  height*width -0.25 -0.25 0.5 0.5 -0.25 -0.25;

quit;





proc glm data=Castle alpha=0.01;
   class height width;
   model sales=height width height*width/clparm solutions;***CI for Pest & est***;

lsmeans height height*width/pdiff cl slice=height;    ***Pdiff for Lsmeans***;
estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1  width 1 0 height*width 0 0 0 0 1 0 ;
estimate 'mu32' intercept 1 height 0 0 1  width 0 1 height*width 0 0 0 0 0 1 ;
        *******We can use the estimates statements to dissect the interaction****;
estimate 'mu11' intercept 1 height 1 0 0 width 1 0 height*width 1 0 0 0 0 0 ;
estimate 'mu12' intercept 1 height 1 0 0 width 0 1 height*width 0 1 0 0 0 0 ;
estimate 'delta in Low Dis' width 1 - 1 height*width 1 -1 0 0 0 0 ;
estimate 'mu21' intercept 1 height 0 1 0 width 1 0 height*width 0 0 1 0 0 0 ;
estimate 'mu22' intercept 1 height 0 1 0 width 0 1 height*width 0 0 0 1 0 0 ;
estimate 'delta in Mid Dis' width 1 -1 height*width 0 0 1 -1 0 0 ;
estimate 'mu31' intercept 1 height 0 0 1  width 1 0 height*width 0 0 0 0 1 0 ;
estimate 'mu32' intercept 1 height 0 0 1  width 0 1 height*width 0 0 0 0 0 1 ;
estimate 'delta in Top Dis' width 1 -1 height*width 0 0 0 0 1 -1;


estimate 'delta in Low Dis' width 1 - 1 height*width 1 -1 0 0 0 0 ;
estimate 'delta in Mid Dis' width 1 -1 height*width 0 0 1 -1 0 0 ;
estimate 'delta in Top Dis' width 1 -1 height*width 0 0 0 0 1 -1;

estimate 'Low vs MID delta' height*width 1 -1 -1 1 0 0 ;
estimate 'Low vs Top Delta' height*width 1 -1 0 0 -1 1;
estimate 'Mid vs top delta' height*width 0 0 1 -1 -1 1;

contrast 'interaction' height*width 1 -1 -1 1 0 0 , height*width 1 -1 0 0 -1 1, height*width 0 0 1 -1 -1 1;



quit;






****MULTIPLE COMPARISONS Interaction MODEL****;



proc glm data=Castle;
   class height width;
   model sales=height|width;
 * model sales = height width height*width;
   lsmeans height*width /tdiff pdiff cl adjust=tukey ;
   lsmeans height*width /tdiff pdiff cl adjust=scheffe ;
   lsmeans height*width /tdiff pdiff cl adjust=bon ;
quit;


****MULTIPLE COMPARISONS MAIN EFFECT MODEL****;



proc glm data=Castle;
   class height width;
   model sales=height width;
   lsmeans height /tdiff adjust=tukey ;
   lsmeans height /tdiff adjust=scheffe ;
   lsmeans height /tdiff adjust=bon ;
quit;




*************MEANS versus LSMEANS****;

ods rtf file='c:\example.rtf';
proc glm data=Castle;
   class height width;
   model sales=height width;
   means height  ;
   lsmeans height  ;
quit;

ods rtf close;


******************CONTRASTS****;


proc glm data=Castle;
   class height width;
   model sales=height|width;
*   model sales=height width height*width;
   means height*width/hovtest  ;
quit;

******HOV test:  USE THE OFATA****;


proc freq data=Castle;
tables height*width*hw/list;
quit;


proc glm data=Castle;
   class height width hw;
   model sales=hw;
means hw/hovtest=bar;
*means hw/hovtest=levene;  ***levene is what we should be using***;
*means hw/hovtest=obrien;
*means hw/hovtest=bf;
quit;


proc glm data=Castle;
   class height width;
   model sales=height|width;
   lsmeans height*width /tdiff adjust=tukey ;
   lsmeans height*width /tdiff adjust=scheffe ;
   lsmeans height*width /tdiff adjust=bon ;
quit;




****WITH MIXED***;

proc mixed data=Castle;
   class height width hw;
   model sales=height|width;
repeated / group=hw subject = store (height*width);  ***KEY LINE TO GET THE UNEQUAL VARIANCES ACROSS
                                                                                                                        THE CELLS****;

quit;

proc mixed data=Castle ;
   class height width hw;
   model sales=height|width;  ***NO REPEATED LINE PRODUCES THE SAME RESULTS AS HOMOGENEOUS ANOVA MODEL***;
quit;



************CONTRAST AND ESTIMATE STATEMENT IN THE TWO-WAY Interaction model***;




proc glm data=Castle;
   class height width;
   model sales=height width height*width;
   contrast 'middle two vs all others'
      height -.5 1 -.5
      height*width -.25 -.25 .5 .5 -.25 -.25 ;
   estimate 'middle two vs all others'
      height -.5 1 -.5
      height*width -.25 -.25 .5 .5 -.25 -.25;
   lsmeans height*width;
quit;
