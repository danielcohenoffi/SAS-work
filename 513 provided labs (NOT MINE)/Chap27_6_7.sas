*
options formdlim=' ' ls=90 ps=50;
data GFruit;
  input cost store lev;
cards;
62.1      1      1
   61.3      1      2
   60.8      1      3
   58.2      2      1
   57.9      2      2
   55.1      2      3
   51.6      3      1
   49.2      3      2
   46.2      3      3
   53.7      4      1
   51.5      4      2
   48.3      4      3
   61.4      5      1
   58.7      5      2
   56.6      5      3
   58.5      6      1
   57.2      6      2
   54.3      6      3
   46.8      7      1
   43.2      7      2
   41.5      7      3
   51.2      8      1
   49.8      8      2
   47.9      8      3
 ;
run;

proc print data=GFruit;
quit;



proc sort data=Gfruit;
by store lev;
quit;


proc means data=GFruit;
   var cost;
by store ;
   output out=a2 mean=avgCost;
quit;

proc print data=a2;
quit;

        
proc sort data=a2;
by store;
quit;

proc sort data=GFruit;
by store lev;
quit;

proc sql;
create table Gfruit as
select a.*, b.*
from Gfruit a left join a2 b
on a.store = b.store;
quit;



proc print data=GFruit;
quit;
                                                                                                                                                                     
    
goptions reset=global gunit=pct noborder rotate=landscape  noprompt hby=4
ftext=swissb htitle=6 htext=3;
                                                                                                                                                                                      
                                                                                                                                                                                          
                       

*****TWo-WAY PLOT***;
                                                                                                                                                              
                                                                                                                                                                                          
                               
                                                                                                                                                                    
                                                                                                                                                                                          
       proc sgplot data=Gfruit ;                                                                                                                                                           
xaxis type=discrete Label = 'Store';;                                                                                                                                             
yaxis label ="Cost";;                                                                                                                                                                     
series x=store y=avgCost ;                                                                                                                                                     
scatter x=store y=cost /group=Lev markerattrs=(size=10) ;                                                                                                                                
quit;                                                                                                                                                                                     
           


	***********COVARIANCE STRUCTURES***********; 
		*********EXCEL FILE FOR NESTED FIT****;


****With only 3 we may be limited in the Number of designs we can fit*****;


proc mixed data=GFruit covtest;  
class store lev;
model cost =  lev /outpm = resid;
repeated lev /type=un subject=store ;
lsmeans lev/tdiff pdiff cl;
quit;

proc mixed data=GFruit covtest;  
class store lev;
model cost =  lev /outpm = resid;
repeated lev /type=un subject=store  r rcorr;
lsmeans lev/tdiff pdiff cl;
quit;



proc mixed data=GFruit covtest;  
class store lev;
model cost =  lev /outpm = resid;
repeated lev /type=toep subject=store r rcorr;
lsmeans lev/tdiff pdiff cl;
quit;



proc mixed data=GFruit covtest;  
class store lev;
model cost =  lev /outpm = resid;
repeated lev /type=cs subject=store r rcorr;
lsmeans lev/tdiff pdiff cl;
quit;



proc mixed data=GFruit covtest;  
class store lev;
model cost =  lev /outpm = resid;
repeated lev /type=ar(1) subject=store r rcorr;
lsmeans lev/tdiff pdiff cl;
quit;



*****Using the Spreadsheet we see AR(1) fit best*****;




proc mixed data=GFruit covtest;  
class store lev;
model cost =  lev /outpm = resid;   ****THIS IS WHERE WE OUTPUT RESIDUALS AND PREDICTED VALUES****;
repeated lev /type=ar(1) subject=store r rcorr;
lsmeans lev/tdiff pdiff cl;
quit;




******Residuals are correlated*****;

******For us to look at normality, we can't do an overall Normality test with the data not
				being independent,

*From STA 505/504  Univiarte Normality implies Multivariate Normality - not necessarily the other way****;


proc sort data=resid;
by lev;
quit;

proc univariate data=resid normal;
by lev;
var resid;
quit;


***Each being normal implies our collection of residuals meets Multivariate Normality*****;



*****If there is FAILURE at any/even 1 repeated measure, then we fail Multivariate Normality****;




proc print data=resid;
quit;
                                                                                                                                                 
                                                                                                                                                                                          
       proc sgplot data=resid ;                                                                                                                                                           
xaxis type=discrete Label = 'Store';;                                                                                                                                             
yaxis label ="Cost";;                                                                                                                                                       
scatter x=pred y=resid /group=Lev markerattrs=(size=10) ;                                                                                                                                
quit;                               

                                                                                                                                                 
                                                                                                                                                                                          
       proc sgplot data=resid ;                                                                                                                                                           
xaxis type=discrete Label = 'Store';;                                                                                                                                             
yaxis label ="RESID";;                                                                                                                                                       
scatter x=store y=resid /group=Lev markerattrs=(size=10) ;                                                                                                                                
quit;                                                                                                                                                                                     
           


proc mixed data=GFruit covtest alpha=.01;  
class store lev;
model cost =  lev /outpm = resid;   ****THIS IS WHERE WE OUTPUT RESIDUALS AND PREDICTED VALUES****;
repeated lev /type=ar(1) subject=store r rcorr;
lsmeans lev/tdiff pdiff cl adjust=tukey;
quit;



proc mixed data=GFruit covtest alpha=.05;  
class store lev;
model cost =  lev /outpm = resid;   ****THIS IS WHERE WE OUTPUT RESIDUALS AND PREDICTED VALUES****;
repeated lev /type=ar(1) subject=store r rcorr;
lsmeans lev/tdiff pdiff cl adjust=tukey;
quit;
