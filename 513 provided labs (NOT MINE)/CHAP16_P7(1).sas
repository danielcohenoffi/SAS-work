********************************************************************************************
* Basic ANOVA Modeling                                  Statistician:   Robert J. Gallop   *
*                                                                                          *
* Investigator: STAT 513                                                                   *
* PRB 7                                                                                    *
********************************************************************************************
;

options ls=90 ps=50 formdlim=' ';

***********************************************************************************;
***********************************************************************************;
;

 ***CREATE A WORK FILE FOR THE DATA***;
data prob1;
input prodimp group id @@;
cards;
7.6 1 1 8.2 1 2 6.8 1 3 5.8 1 4 6.9 1 5 6.6 1 6 6.3 1 7 7.7 1 8 6.0 1 9
6.7 2 1 8.1 2 2 9.4 2 3 8.6 2 4 7.8 2 5 7.7 2 6 8.9 2 7 7.9 2 8 8.3 2 9 8.7 2 10 7.1 2 11 8.4 2 12
8.5 3 1 9.7 3 2 10.1 3 3 7.8 3 4 9.6 3 5 9.5 3 6
;
run;


        ***LOOK AT WHAT IS INSIDE***;
proc contents data=prob1 position;

quit;

proc print data=prob1;
quit;                         *****NOTE WE DO NOT HAVE BALANCED DATA*****;


    *****Graphically Look at the Relationship****;

goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=prob1 gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
legend1  frame value=(height=2.5             )

                across=3
                label=none
                ;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'ID')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT prodimp*id=group/ HAXIS=AXIS1 VAXIS=AXIS2  frame legend=legend1;
                        ;
RUN;
QUIT; TITLE; title2;
                              *****NOTE: Patients are not crossed but nested****;

symbol1 v=circle i=none;
proc gplot data=prob1; plot prodimp*group/frame;
run;quit;


proc means data=prob1; var prodimp; by group;
   output out=K2 mean=avpi;
quit;

symbol1 v=circle i=join;
proc gplot data=K2;
plot avpi*group/frame;
run;quit;


proc sql;
create tables K3 as
select a.*, b.*
from prob1 a left join K2 b
on a.group = b.group;
quit;


proc print data=K3; quit;

symbol1 v=circle i=none c=red;

symbol2 v=star i=join c=green w=3;
proc gplot data=K3; plot prodimp*group=1 avpi*group=2/overlay frame;
run;quit;




                                                                                             
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'Group';                                                                                             
yaxis label ="Improvement";;                                                                                                             
series x=group y=avpi;    
quit;
                                                                                                  
run                                                                                                                                     
;                              
                                                                                               
            
                                                                                                           
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'Group';                                                                                             
yaxis label ="Improvement";;                                                                                                        
scatter x=group y=prodimp / markerattrs=(size=10) ;
quit;
                                                                                                  
run                                                                                                                                     
;                               
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'Group';                                                                                             
yaxis label ="Improvement";;                                                                                                             
series x=group y=avpi;                                                                                                        
scatter x=group y=prodimp / markerattrs=(size=10) ;
quit;
                                                                                                  
run                                                                                                                                     
;                             



        ***ANOVA - GROUP PREDICTING Productivity Improvement**;


ods graphics on;


proc glm data=prob1  PLOTS=all;
class group;
model prodimp = group/solution ;
means group/hovtest  ;
lsmeans group /tdiff pdiff plots=(meanplot (join cl));

output out=info r=resid p=phat  rstudent=stdresid DFFITS=dffits ;
quit;



proc format;
value gpfmt 1='Ref' 2='Gp 2' 3='Gp 3';
quit;


proc glm data=prob1 ;
class group;
model prodimp = group/solution ;
means group/hovtest  ;
format group gpfmt.;

lsmeans group/pdiff;
output out=info r=resid p=phat  rstudent=stdresid DFFITS=dffits ;
quit;


                        ****STANDARDIZED RESIDUAL IS THE JACKNIFE***;




  proc print data=info;
  id group id;
  var prodimp phat resid stdresid dffits;
 quit;

 proc univariate data=info normal plot;
  var resid;
  quit;


  proc means data=info n mean sum;
  class group;
  var resid;
  quit;


  proc univariate data=info normal plot;
  var resid;
  quit;
