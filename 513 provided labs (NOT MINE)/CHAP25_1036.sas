
/*Chapter 25: Random and Mixed Effects Models
Inputting the Apex Enterprises data, table 25.1, p. 1036.*/



options formdlim=' ' ls=90 ps=50;

data ratings;
  input rating officer candidate;
cards;
  76  1  1
  65  1  2
  85  1  3
  74  1  4
  59  2  1
  75  2  2
  81  2  3
  67  2  4
  49  3  1
  63  3  2
  61  3  3
  46  3  4
  74  4  1
  71  4  2
  85  4  3
  89  4  4
  66  5  1
  84  5  2
  80  5  3
  79  5  4
;
run;



proc print data=ratings;
quit;




goptions reset=global gunit=pct noborder rotate=landscape
         noprompt fby=swissl cby=black hby=4 device=win;



       proc sgplot data=ratings ;
xaxis type=discrete Label = 'Officer';
yaxis label ="RaTING";;
scatter x=Officer y=rating / markerattrs=(size=10) ;
quit;




proc sort data=ratings;
by officer;
quit;


proc means data=ratings;
   output out=a2 mean=avrate;
   var rating;
   by officer;
quit;



;

       proc sgplot data=A2 noautolegend;
xaxis type=discrete Label = 'Officer';
yaxis label ="Rating";;
scatter x=officer y=avrate;
quit;

run ;




proc sql;
create tables ratings as
select a.*, b.avrate
from Ratings a left join A2 b
on a.officer = b.officer;
quit;


proc print data=ratings; quit;




       proc sgplot data=ratings;
xaxis type=discrete Label = 'Officer';
yaxis label ="Rating";;
series x=officer y=avrate/ MARKERATTRS=( SIZE=10);
sCATTER x=officer y=avrate/ MARKERATTRS=(SYMBOL=STARFILLED SIZE=10);
scatter x=officer y=rating / markerattrs=(size=10) ;
quit;



*******ANALYSIS THROUGH GLM - RANDOM STATEMENT*******;

proc glm data=ratings;
   class officer;
   model rating=officer /e1;
   random officer/q test;
quit;

;
proc glm data=ratings;
   class officer;
   model rating=officer ;
  * random officer/q test;
quit;

;

******ANALYSIS THROUGH VARCOMP - VARIANCE COMPONENTS*****;



proc varcomp data=ratings;
   class officer;
   model rating=officer;
quit;


proc means data=ratings maxdec=2;
class officer;
quit;




proc mixed data=ratings covtest cl; ***CL for Variance Components****;
   class officer;
   model rating=officer/solution cl;       ****CL for Fixed Effects*****;
   *random intercept/subject=officer;
quit;;



proc mixed data=ratings covtest cl; ***CL for Variance Components****;
   class officer;
   model rating=/solution cl;       ****CL for Fixed Effects*****;
   random officer/v vcorr;



estimate 'lev1' intercept 1 | officer 1 0 0 0 0 ;
estimate 'lev2' intercept 1 | officer 0 1 0 0 0 ;
estimate 'lev3' intercept 1 | officer 0 0 1 0 0 ;
estimate 'lev4' intercept 1 | officer 0 0 0 1 0 ;
estimate 'lev5' intercept 1 | officer 0 0 0 0 1 ;

   

contrast 'F' |officer 1 -1 0 0 0 ,|officer 1 0 -1  0 0 , |officer 1 0 0 -1   0 , |officer 1 0 0 0 -1 ;



quit;






proc mixed data=ratings covtest cl; ***CL for Variance Components****;
   class officer;
   model rating=/solution cl;       ****CL for Fixed Effects*****;
   random officer/v vcorr;
estimate 'lev1' intercept 1 | officer 1 0 0 0 0 ;
estimate 'lev2' intercept 1 | officer 0 1 0 0 0 ;
estimate 'lev3' intercept 1 | officer 0 0 1 0 0 ;
estimate 'lev4' intercept 1 | officer 0 0 0 1 0 ;
estimate 'lev5' intercept 1 | officer 0 0 0 0 1 ;
lsmeans officer/tdiff pdiff;   ****CAN WE USE LSMEANS FOR PAIRWISE DIFFERENCES****;
                ****NO - LSMEANS ONLY FOR FIXED EFFECTS****;


quit;



proc mixed data=ratings covtest cl; ***CL for Variance Components****;
   class officer;
   model rating=/solution cl;       ****CL for Fixed Effects*****;
   random officer/v vcorr;
estimate 'lev1' intercept 1 | officer 1 0 0 0 0 ;
estimate 'lev2' intercept 1 | officer 0 1 0 0 0 ;
estimate 'lev3' intercept 1 | officer 0 0 1 0 0 ;
estimate 'lev4' intercept 1 | officer 0 0 0 1 0 ;
estimate 'lev5' intercept 1 | officer 0 0 0 0 1 ;


estimate 'lev1' intercept 1 | officer 1 0 0 0 0 ;
estimate 'lev2' intercept 1 | officer 0 1 0 0 0 ;
estimate 'lev1 - lev2' intercept 0 |officer 1 -1 0 0 0 ;
estimate 'lev1 - lev3' intercept 0 |officer 1 0 -1  0 0 ;
estimate 'lev1 - lev4' intercept 0 |officer 1 0 0 -1  0 ;
estimate 'lev1 - lev5' intercept 0 |officer 1 0 0 0 -1  ;

estimate 'lev2- lev3' intercept 0 |officer 0 1  -1  0 0 ;
estimate 'lev2 - lev4' intercept 0 |officer 0 1  0 -1  0 ;
estimate 'lev2 - lev5' intercept 0 |officer 0 1  0 0 -1  ;

estimate 'lev3 - lev4' intercept 0 |officer 0 0 1   -1  0 ;
estimate 'lev3 - lev5' intercept 0 |officer 0 0 1   0 -1  ;

estimate 'lev4 - lev5' intercept 0 |officer 0 0 0 1    -1  ;

estimate 'lev4 - lev5a'  |officer 0 0 0 1    -1  ;****Keep the intercept 0, DFs off, we want the smaller value *****;

quit;


proc mixed data=ratings covtest cl; ***CL for Variance Components****;
   class officer;                            *****OFFICER AS A FIXED EFFECT
                                                in PROC MIXED****;
   model rating=officer/solution cl;       ****CL for Fixed Effects*****;
   lsmeans officer /tdiff pdiff;
quit;

proc mixed data=ratings covtest cl alpha=0.10;
   class officer;
   model rating=/solution cl alpha=0.10;   ****90% CI****;

   random officer/vcorr;
quit;





/*Estimating the 90% confidence limit of sigma_mu2/(sigma_mu2 + sigma2),
p. 1040-1041.*/
ods listing close;
ods output overallanova=anova;
proc glm data=ratings;
   class officer;
   model rating = officer;
quit;
ods listing;
data _null_;
  set anova;
  if source='Model' then call symput('mstr', ms);  ****We need these sums of squares for the formula***;
  if source='Error' then call symput('mse', ms);    ***Were creating macro varibales with the CALL SYMPUT**;
  if source='Model' then call symput('dfmodel', df);
  if source='Error' then call symput('dferr', df);
run;
%put here are the macro variables: 394.925,&mstr,  &mse, &dfmodel and &dferr;
data temp;
  lower_f = finv( .95, &dfmodel, &dferr);
  upper_f = finv( .05, &dfmodel, &dferr);
  mstr =      &mstr;
  mse = &mse;
  ICCest = mstr/(mse+mstr);

  ***FORMULA PER THE TEXT FOR A SINGLE RANDOM EFFECTS MODEL***;
  L = (1/4)*((&mstr/&mse)*(1/lower_f) - 1 );   *****That 4 is the sample size per officer****;
  U = (1/4)*((&mstr/&mse)*(1/upper_f) - 1 );    ****If you have unequal sample sizes make it the avg***;
  L_star = L/(1+L);  ***ICC Bound Estimates****;

  U_star = U/(1+U);
run;
proc print data=temp;
title 'Con Bound for ICC';
quit; title;


title;

/*Estimating the 90% confidence interval of s_mu2 using MIXED.*/



proc mixed data=ratings covtest cl alpha=0.10;  ****90% CI****;
   class officer;
   model rating=;
   random officer/vcorr;
quit;



proc mixed data=ratings covtest cl alpha=0.10 ; ;
   class officer;
   model rating= /ddfm=satterth;*****Another one is the Kenward-Rogers technique ddmf=kr;
   random officer;
quit;
