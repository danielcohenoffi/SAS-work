

options formdlim=' ' ls=90 ps=50 nofmterr;

libname coke 'C:\Users\SMSTAT\Documents\WCULaptop\STA513\Presentations';

data coke;
set coke.finalcoke;
run;


proc contents data=coke position;
quit;




data reduce;
set coke;
keep patno dru_sub zm0 month tx_cond m0asidr site m0cpi;
run;

proc means data=reduce;
quit;



proc sort data=reduce;
by month tx_cond;
quit;




proc univariate  data =reduce noprint;
by month tx_cond;
var dru_sub;
output out=o mean=mndru_sub;
quit;



goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;
symbol1 v=circle i=join c=red;
symbol2 v=dot i=join c=blue;
symbol3 v=star i=join c=green;
symbol4 v=triangle i=join c=gold;


proc gplot data=o;
   plot mndru_sub*month=tx_cond/frame;
run;quit;




proc sort data=reduce;
by patno month tx_cond;
quit;


proc print data=reduce (obs=25);
var patno month dru_sub m0asidr tx_cond;
quit;




                        *******We^re going to run a Mixed Model Anova****;

******DELETE THE BASELINE and use the BASELINE AS A COVARIATE****;

           *****M0ASIDR IS THE BASELINE MEASUREMENT OF THE DRU_SUB****;

DATA reduce1;
set reduce;
if month gt 0;
run;


proc freq data=reduce1;
tables patno/out=n noprint;
quit;



                *******MAIN EFFECTS FOR TX and TIME***;

proc mixed data=reduce1 ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;


*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;


repeated month / type =  un         subject=patno;


                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;



*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

quit;



                *******RERUNNING THE MODELS****;

ods listing close;


               *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  cs         subject=patno;
                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

  ods output InfoCrit=ic_cs;
quit;
                *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  csh         subject=patno;
                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;
  ods output InfoCrit=ic_csh;
quit;
                *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  ar(1)         subject=patno;
                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

  ods output InfoCrit=ic_ar1;
quit;
                *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  arh(1)         subject=patno;
                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

  ods output InfoCrit=ic_arh1;
quit;
   *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  toep         subject=patno;
                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

  ods output InfoCrit=ic_toep;
quit;
                *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  toeph         subject=patno;

                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

  ods output InfoCrit=ic_toeph;
quit;
  *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1 ic ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;   ****we include baseline as a covariate
                                        this parallels an ANCOVA model
                                        but is its extension for Repeated Measures***;
*repeated ________________/type= _____        subject=_____________;
         **time indic***;    **forms of R***;  **Patient identifier**;
repeated month / type =  un         subject=patno;
                ****MOST COMMON STRUCTURES FOR MIXED MODEL ANOVA:
                        CS, CSH, AR(1), ARH(1), TOEP, TOEPH, UN***;
*lsmeans month/pdiff tdiff cl;
*lsmeans tx_cond/pdiff tdiff cl;

  ods output InfoCrit=ic_un;
quit;


ods listing;


proc print data=ic_cs; quit;
proc print data=ic_csh; quit;
proc print data=ic_ar1; quit;
proc print data=ic_arh1; quit;
proc print data=ic_toep; quit;
proc print data=ic_toeph; quit;
proc print data=ic_un; quit;




data icfull;
set ic_cs ic_csh ic_ar1 ic_arh1 ic_toep ic_toeph ic_un;
run;


proc print data=icfull;
quit;



 PROC EXPORT DATA= WORK.ICFULL
            OUTFILE= "C:\Users\SMSTAT\Documents\WCULaptop\STA513\Chap27_MMANOVAFit.xls"
            DBMS=EXCEL REPLACE;
     SHEET="FIT";
RUN;



         *****BASED on our Comparison TOEPH is the best fitting structure***;


   *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1  ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month tx_cond  m0asidr;
repeated month / type =  toeph         subject=patno   r rcorr=1,2,3;

lsmeans month/pdiff tdiff cl;
lsmeans tx_cond/pdiff tdiff cl;

quit;



   *******MAIN EFFECTS and Interaction FOR TX and TIME***;
proc mixed data=reduce1  ;
class  patno  month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub = month|tx_cond  m0asidr;
repeated month / type =  toeph         subject=patno   r rcorr=1,2,3;

lsmeans month/pdiff tdiff cl;
lsmeans tx_cond/pdiff tdiff cl;

quit;



                *******GOOFING AROUND WITH ADDITIONAL COVARIATES****;



   *******MAIN EFFECTS FOR TX and TIME***;
proc mixed data=reduce1  ;
class  patno site month tx_cond; ****PATNO - WHICH DISTINGUISHES WHEN
                                MEASUREMENTS ARE REPEATED IS ALSO IN THE CLASS
                                        statement***;
MODEL dru_sub =site month tx_cond  m0asidr /outp=Pred;
repeated month / type =  toeph         subject=patno   r rcorr=1,2,3;

lsmeans month/pdiff tdiff cl;
lsmeans tx_cond/pdiff tdiff cl;

quit;
