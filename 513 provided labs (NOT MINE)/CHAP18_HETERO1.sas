options formdlim=' ' ls=90 ps=50 nofmterr;

libname hetanova v6 '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets';


data one;
set hetanova.hetanova;
run;
data one;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\hetanova';
run;

data one;
set wcu.hetanova;
run;

proc means data=hetanova.hetanova;
quit;


proc means data=hetanova.hetanova n mean std var clm maxdec=3;
class txconda;
var bhamtot;
quit;

	**************************************************;

proc sort data=hetanova.hetanova;
by txconda;
quit;



proc means data=one ;
var bhamtot; by txconda;
   output out=K2 mean=avham17;
quit;

proc print data=K2;quit;


proc print data=one; quit;
proc print data=K2; quit;

proc sql;
create tables K3 as
select a.*, b.*
from one a left join K2 b
on a.txconda = b.txconda;
quit;


proc print data=K3; quit;


                    
                                                                                                                                        
       proc sgplot data=K3 noautolegend;                                                                                              
xaxis type=discrete Label = 'TXCONDA';                                                                                             
yaxis label ="HAM-D";;                                                                                                             
series x=txconda y=avham17;                                                                                                        
scatter x=txconda y=bhamtot / markerattrs=(size=10) ;
quit;
                                                                                                  
run                                                                                                                                     
;                                

    **************************************************;



proc glm data=one  PLOTS=all;
class txconda;
model bhamtot= txconda;
means txconda/hovtest=levene;
means txconda/hovtest=bf;
lsmeans txconda /plots=(meanplot (join cl)) tdiff pdiff;
quit;

	************PROC GLM WON'T SAY WHAT VARIANCES ARE SEPARATING / ONLY THE MEANS****;
	*******WORK AROUND to see what's driving the unequal variance******;
proc TTEST DATA=one;
class txconda;
where txconda in (1,2);
var bhamtot;
quit;

proc TTEST DATA=one;
class txconda;
where txconda in (1,3);  ****realize the df are off here****;
var bhamtot;
quit;
proc TTEST DATA=one;
class txconda;
where txconda in (2,3);
var bhamtot;
quit;



proc means data=one n mean std var maxdec=3;
class txconda;
var bhamtot;
quit;


proc print data=one;
quit;

proc means data=one n mean std var maxdec=3;
var bhamtot;
quit;

proc glm data=one;
class txconda;
model bhamtot= txconda;
quit;

proc means data=one n mean std var maxdec=3;
class txconda;
var bhamtot;
quit;


ods trace off;

proc mixed data=one covtest PLOTS=all;
class txconda;
model bhamtot = txconda /s outpm=phat;  ****THIS OUTPM gives the predicted values and residuals*****;
repeated /group=txconda  r;
lsmeans txconda/tdiff pdiff cl;
quit;



proc sort data = phat;
by txconda;
run;

proc means data = phat;
by txconda;
var resid;
output out = group_sd std = group_std;

data phat;
merge phat group_sd;
by txconda;
studentresid = resid/group_std;
run;

proc print data = phat;
run;

proc sort data=one;
by txconda;
quit;

proc univariate data=one normal;
by txconda;
var bhamtot;
quit;


proc contents data=phat ;
quit;

proc univariate data=phat normal;
var resid;
quit;




proc mixed data=one covtest PLOTS=all;
class txconda;
model bhamtot = txconda /s ;
repeated /group=txconda  ;
lsmeans txconda/tdiff pdiff cl;
lsmeans txconda/tdiff pdiff cl adjust=tukey;
quit;

