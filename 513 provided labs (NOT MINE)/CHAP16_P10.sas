********************************************************************************************
* Basic ANOVA Modeling                                  Statistician:   Robert J. Gallop   *
*                                                                                          *
* Investigator: STAT 513                                                                   *
* LAB 2                                                                                    *
********************************************************************************************
;

options ls=90 ps=50 formdlim=' ';

***********************************************************************************;
***********************************************************************************;
;

 ***CREATE A WORK FILE FOR THE DATA***;
data prob1;
input cash group id;
cards;
   23.0      1      1
   25.0      1      2
   21.0      1      3
   22.0      1      4
   21.0      1      5
   22.0      1      6
   20.0      1      7
   23.0      1      8
   19.0      1      9
   22.0      1     10
   19.0      1     11
   21.0      1     12
   28.0      2      1
   27.0      2      2
   27.0      2      3
   29.0      2      4
   26.0      2      5
   29.0      2      6
   27.0      2      7
   30.0      2      8
   28.0      2      9
   27.0      2     10
   26.0      2     11
   29.0      2     12
   23.0      3      1
   20.0      3      2
   25.0      3      3
   21.0      3      4
   22.0      3      5
   23.0      3      6
   21.0      3      7
   20.0      3      8
   19.0      3      9
   20.0      3     10
   22.0      3     11
   21.0      3     12
;
run;


        ***LOOK AT WHAT IS INSIDE***;
proc contents data=prob1 position;

quit;

proc print data=prob1;
quit;


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
PLOT cash*id=group/ HAXIS=AXIS1 VAXIS=AXIS2  frame legend=legend1;
                        ;
RUN;
QUIT; TITLE; title2;



proc means data=prob1;
class group;
quit;

proc sort data=prob1;
by group;
quit;


proc means data=prob1;
   output out=a2 mean=avgcash;
   by group;
quit;




proc sql;
create tables K3 as
select a.*, b.*
from prob1 a left join A2 b
on a.group = b.group;
quit;


proc print data=K3; quit;





                                                                                             
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'GROUP';                                                                                             
yaxis label ="CASH";;                                                                                                             
series x=group y=avgcash; 
quit;
                                                                                                  
run                                                                                                                                     
;                              
                                                                                               
            
                                                                                                           
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'GROUP';                                                                                             
yaxis label ="CASH";;                                                                                                        
scatter x=group y=cash / markerattrs=(size=10) ;
quit;
                                                                                                  
run                                                                                                                                     
;                               
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'GROUP';                                                                                             
yaxis label ="CASH";;                                                                                                             
series x=group y=avgcash;                                                                                                        
scatter x=group y=cash / markerattrs=(size=10) ;
quit;
                                                                                                  
run                                                                                                                                     
;                             


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
PROC GPLOT DATA=a2 gout=hwone;
SYMBOL1 v=circle  i=none C=green ci=green height=2.5;
SYMBOL2 v=star  i=none C=blue ci=blue height=2.5;
SYMBOL3 v=dot  i=none C=red ci=red height=2.5;
AXIS1 LABEL = (C=BLACK F=SWISSL H=4 'GROUP')
value=(h=3 f=swissb) minor=none ;
AXIS2 LABEL = (C=BLACK A=90 H=4 F=SWISSL 'Outcome')
value=(h=3 f=swissb) minor=none ;
PLOT avgcash*group=1/ HAXIS=AXIS1 VAXIS=AXIS2  frame ;
                        ;
RUN;
QUIT; TITLE; title2;



symbol1 v=circle i=none c=red;

symbol2 v=star i=join c=green w=3;
proc gplot data=K3; plot CASH*group=1 avGCASH*group=2/overlay frame;
run;quit;





ods graphics on;
proc glm data=prob1  PLOTS=all ;
class group;
model CASH = group/solution ;
means group/hovtest  ;
lsmeans group/pdiff;
lsmeans group/plots=(meanplot (join cl));
output out=info r=resid p=phat  rstudent=stdresid DFFITS=dffits ;
quit;



proc means data=info;
class group;
quit;



proc glm data=prob1  ;
class group;
model CASH = group ;
lsmeans group/TDIFF PDIFF  CL STDERR;
QUIT;


proc glm data=prob1 alpha=0.10 ;
class group;
model CASH = group ;
lsmeans group/TDIFF PDIFF  CL STDERR;
QUIT;
