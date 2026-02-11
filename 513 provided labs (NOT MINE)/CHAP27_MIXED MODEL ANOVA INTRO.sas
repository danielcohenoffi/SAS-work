********************************************************************************************
* MIXED MODEL ANOVA                                     Statistician:   Robert J. Gallop   *
*                                                                                          *
* Investigator: STAT 513                                                                   *
*                                                                                          *
* Purpose: MIXED MODEL ANOVA                                                               *
*                                                                                          *
*                                                                                          *
********************************************************************************************
;

options ls=90 ps=50 formdlim=' ';


*create dataset called wide, based on data from Keppel ;
*   each record has the data for one subject;
*   8 subjects (sub) ;
*   1 between subjects IV with 2 levels (group) ;
*   1 within subjects iv with 4 levels (indicated by position dv1-dv4) ;
*   1 dependent measure ;


Data flat;
  input sub group dv1 dv2 dv3 dv4;
cards;
1 1  3  9  5  3
2 1  6  13 7  9
3 1  7 18 11 11
4 1  0  8  6  6
5 2  5  12 1  7
6 2 10 12 8 15
7 2 10 15 5 14
8 2  5  9 6  9
;
Run;


* create dataset narrow, based on wide to use with proc mixed ;
*   each record has the data for ONE OBSERVATION;
*   8 subjects (sub) ;
*   1 between subjects IV with 2 levels (group) ;
*   1 within subjects iv with 4 levels (trial) ;
*   1 dependent measure (dv) ;
Data stacked;
  Set flat;
  dv = dv1; trial = 1; output;
  dv = dv2; trial = 2; output;
  dv = dv3; trial = 3; output;
  dv = dv4; trial = 4; output;
Run;



proc print data=flat; quit;

proc print data=stacked; quit;



proc sort data=stacked;
by sub;
quit;


goptions reset=all noborder ftext=swiss htext=3 hby=3 noprompt;
proc gplot data=stacked uniform gout=mix1;
  by sub;
  note justify=center 'ID #byval(ID)';
  symbol color=black interpol=reg value=dot height=2 ;
  axis1 label=("TRIAL") order=(1 to 4 by 1) offset=(5) minor=none ;
  axis2 label=("DV")  minor=none;
  plot dv*trial / nolegend haxis=axis1 vaxis=axis2 noframe;
run;
quit;





goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
proc gplot data=stacked;
   plot dv*trial=sub /nolegend;
   symbol v=none repeat=8 i=join color=blue;
   label time='TRIAL';
   title 'DV Data';
run;
quit;



********SUPERIMPOSE AVG TRAJECTORY*****;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
proc gplot data=stacked;
   plot dv*trial=sub /nolegend;
        plot2 dv*trial;
   symbol v=none repeat=8 i=join color=blue;
   symbol2 v=none i=sm50s color=RED width=3;
   label time='TRIAL';
   title 'DV Data';
run;
quit;



proc sort data=stacked;
by group;
quit;


proc means data=stacked;
where trial = 1;
cLASS group;
QUIT;




data info;
set stacked;
run;



********SUPERIMPOSE AVG TRAJECTORY*****;
goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
proc gplot data=info gout=sump;
where  group= 1;
   plot dv*trial=sub /nolegend;
        plot2 dv*trial;
   symbol v=none repeat=4 i=join color=blue;
   symbol2 v=none i=sm50s color=RED width=3;
   label trial='Trial';
   title 'Alliance Data group = 1 (se)';
run;
quit;title;

proc gplot data=info gout=sump;
where  group= 2;
   plot dv*trial=sub /nolegend;
        plot2 dv*trial;
   symbol v=none repeat=4 i=join color=blue;
   symbol2 v=none i=sm50s color=RED width=3;
   label trial='Trial';
   title 'Alliance Data group = 2 (CT)';
run;
quit;title;
quit;title;


goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
proc gplot data=info gout=sump;

plot dv*trial=group;
   symbol1 v=none  i=sm50s color=blue;
   symbol2 v=none i=sm50s color=RED width=3;
   label trial='Trial';               ;
run;
quit;title;






**************************REPEATED MEASURES ANOVA LAYOUT*******;

PROC GLM DATA = flat ;
CLASS group  ;
MODEL dv1 dv2 dv3 dv4 = group ;
REPEATED trials 4 / PRINTE ;
LSMEANS group  ;
quit;

PROC GLM DATA = flat ;***MANOVA LAYOUT****;
CLASS group  ;
MODEL dv1 dv2 dv3 dv4 = group ;;
REPEATED trials 4 / PRINTE ;
manova h = group/ printe printh;
LSMEANS group  ;
quit;

* show how to get anova for mixed design using proc mixed;

PROC GLM DATA = flat ;
CLASS group  ;
MODEL dv1 dv2 dv3 dv4 = group ;
REPEATED trials 4 / PRINTE ;
LSMEANS group  ;
quit;

proc mixed data=info;
  class sub group trial;
  model dv = group|trial ;
  lsmeans group;
  repeated trial / subject = sub type=cs r;
quit;

proc mixed data=info;
  class sub group trial;   ****Classified as a Mixed Model ANOVA where GROUP AND TIME (TRIAL) are treated as FACTORS****;
  model dv = group|trial ;

  lsmeans group;      ****ESTIMATES THE MEAN OUTCOME PER GROUP OVER THE LONGITUDINAL PERIOD****;

  repeated trial / subject = sub type=cs r rcorr; 
  lsmeans group*trial/slice=trial tdiff pdiff cl;
quit;

proc mixed data=info;
  class sub group trial;   ****Classified as a Mixed Model ANOVA where GROUP AND TIME (TRIAL) are treated as FACTORS****;
  model dv = group|trial ;

  lsmeans group;      ****ESTIMATES THE MEAN OUTCOME PER GROUP OVER THE LONGITUDINAL PERIOD****;

  random sub /  v vcorr; 
  lsmeans group*trial/slice=trial tdiff pdiff cl;
quit;



************************GET THE BEST COVARIANCE MATRIX*****;

* show how to get anova for mixed design using proc mixed;

ods listing close;


proc mixed data=info ic;
  class sub group trial;
  model dv = group trial group*trial;
  repeated trial / subject = sub type=cs;
  ods output InfoCrit=ic_cs;

quit;

* show how to get anova for mixed design using proc mixed;
proc mixed data=info ic;
  class sub group trial;
  model dv = group trial group*trial;
  repeated trial / subject = sub type=csh;
  ods output InfoCrit=ic_csh;
quit;


* show how to get anova for mixed design using proc mixed;
proc mixed data=info ic;
  class sub group trial;
  model dv = group trial group*trial;
  repeated trial / subject = sub type=ar(1);
  ods output InfoCrit=ic_ar;
quit;


* show how to get anova for mixed design using proc mixed;
proc mixed data=info ic;
  class sub group trial;
  model dv = group trial group*trial;
  repeated trial / subject = sub type=toep;
  ods output InfoCrit=ic_toep;
quit;


* show how to get anova for mixed design using proc mixed;
proc mixed data=info ic;
  class sub group trial;
  model dv = group trial group*trial;
  repeated trial / subject = sub type=un;
  ods output InfoCrit=ic_un;
quit;

ods listing ;

data ic_cs;
set ic_cs;
type='COMPOUND SYMMETRY';
run;

data ic_csh;
set ic_csh;
type='CS-Hetero';
run;
data ic_ar;
set ic_ar;
type='Autoregressive';
run;

data ic_toep;
set ic_toep;
type='Toeplitz';
run;

data ic_un;
set ic_un;
type='Unstructured';
run;


data ic;
set ic_cs ic_csh ic_ar ic_toep ic_un;
run;

proc print data=ic;
id type;
quit;


proc corr data=flat;
var dv1-dv4;
quit;



proc mixed data=info ic;
  class sub group trial;
  model dv = group trial group*trial;
  repeated trial / subject = sub type=cs;
  lsmeans group*trial/slice=trial;
quit;



* show how to get anova for mixed design using proc glm ;
proc glm data=flat;
  class group;
  model dv1-dv4 = group;
  repeated trial 4;
quit;





Data flat2;
  input sub group dv1 dv2 dv3 dv4;
cards;
1 1  3  9  5  .
2 1  6  13 7  9
3 1  7 18 . 11
4 1  0  .  6  6
5 2  5  12 1  7
6 2 10 12 . 15
7 2 10 15 5 14
8 2  5  9 6 .
;
Run;






PROC GLM DATA = flat ;
CLASS group  ;
MODEL dv1 dv2 dv3 dv4 = group ;
REPEATED trials 4 / PRINTE ;
LSMEANS group  ;
quit;



PROC GLM DATA = flat2 ;   ****with the missing observations above, this analysis deletes all 5 rows of data****;
CLASS group  ;
MODEL dv1 dv2 dv3 dv4 = group ;
REPEATED trials 4 / PRINTE ;
LSMEANS group  ;
quit;


 Data stacked2;
  Set flat2;
  dv = dv1; trial = 1; output;
  dv = dv2; trial = 2; output;
  dv = dv3; trial = 3; output;
  dv = dv4; trial = 4; output;
Run;





proc mixed data=stacked2;   ****This analysis will retain all non-missing data per person, so the only thing we lose
							are those 5 missing timepoints above not the 5 patients with all their data values****;

  class sub group trial;
  model dv = group|trial ;
  lsmeans group;
  repeated trial / subject = sub type=cs r;

quit;

