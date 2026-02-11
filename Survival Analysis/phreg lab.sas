
data cirr;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\cirr';
run;

data cirrf312;
	set cirr;
	if case le 312;	
	
	if case le 161 then trans=1;
	else trans=0;
	years=days/365;

run;

/* LAB for PHREG */

proc freq data=cirr_f312;
	tables stage;
run;

data c;
	set cirr_f312;
	if stage=. then stage1=.;
	if stage =2 then stage2=1;
	else stage2=0;
	if stage =3 then stage3=1;
	else stage3=0;
	if stage =4 then stage4=1;
	else stage4=0;
run;

proc print;
	var stage stage2 stage3 stage4;
run;

proc sort;
by stage;
run;

proc print;
run;

proc means;
	var years;
	class stage;
run;

proc lifetest plots=(s);
time years*status(0,1);
strata stage;
run;

proc phreg data=c outest=out01;
	model years*status(0,1) = drug age sex albumin bilirubin stage2 stage3 stage4;
run;


proc phreg data=c outest=out01;
     class stage;
	model years*status(0,1) = drug age sex albumin bilirubin stage;
	test1vs2: test stage1=stage2; 
test23: test stage2=stage3;
test13: test stage1=stage3;
run;

proc phreg data=c outest=out01;
	model years*status(0,1) = drug age sex albumin bilirubin stage;
	
run;

/* -2logL are almost the same for 2 models above = use the 2nd */

/* plots of nominal variables*/
/* DRUG*/
proc phreg data=c;
	model years*status(0,1) = age sex albumin bilirubin stage;
	strata drug;
	baseline out=out01 loglogs=lls;
run;

proc gplot data=out01;
	plot lls*years=drug;
	symbol1 v=none i=join color=blue line=1;
	symbol2 v=none i=join color=red line=2;
run;


/*sex*/
proc phreg data=c;
	model years*status(0,1) = age drug albumin bilirubin stage;
	strata sex;
	baseline out=out01 loglogs=lls;
run;

proc gplot data=out01;
	plot lls*years=sex;
	symbol1 v=none i=join color=blue line=1;
	symbol2 v=none i=join color=red line=2;
run;

/*stage*/
proc phreg data=c;
	model years*status(0,1) = age drug albumin bilirubin sex;
	strata stage;
	baseline out=out01 loglogs=lls;
run;

proc print data=out01;
run;

proc gplot data=out01;
	plot lls*years=stage;
	symbol1 v=none i=join color=blue line=1;
	symbol2 v=none i=join color=red line=2;
symbol3 v=none i=join color=black line=6;
	symbol4 v=none i=join color=blue line=3;
run;
quit;

/*schoenfeld resids*/

proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin;
	output out=out01 ressch=schage schdrug schsex schalb schstage schbil;
run;

proc gplot data=out01;
	plot schage*years schdrug*years schalb*years schstage*years 
	schbil*years/vref=0;
	symbol v=dot h=0.35 i=none;
run;








data out02;
	set out01;
	lyear=log(years);
	year2=years**2;
run;


ods graphics on;
proc corr;
	var years lyear year2 schage  schalb schstage schbil;
run;
ods graphics off;





/* test for interaction */

/*bili significant*/
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin bil_t;
	bil_t=bilirubin*years;
run;


/* DRUG not significant */
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin drug_t;
	drug_t=drug*years;
run;

/*stage significant*/
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin stage_t;
	stage_t=stage*years;
run;


/*age NOT significant*/
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin age_t;
	age_t=age*years;
run;



/*alb not significant */
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin alb_t;
	alb_t=albumin*years;
run;




/* Martingale residuals*/
ods graphics on;
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin;
	assess ph / resample;
run;



/*final model */


proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin bil_t stage_t;
	bil_t=bilirubin*years;
stage_t=stage*years;
output out=out1 resdev=dev;
run;



proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin ;
	*bil_t=bilirubin*years;
*stage_t=stage*years;
output out=out1 resdev=dev;
run;

proc gplot data=out1;
	plot dev*age dev*albumin dev*stage dev*bilirubin;
run;
quit;



/* take out interactions */
proc phreg data=c;
	model years*status(0,1) = age drug sex albumin stage bilirubin ;
	
output out=out1 resdev=dev;
run;




proc gplot data=out1;
	plot dev*age dev*albumin dev*stage dev*bilirubin;
run;
quit;







/*selection*/
proc phreg data=c;
	class drug  sex;
	model years*status(0,1) =  
   
   drug
   age 
   sex
  asictes
   hepatomegaly   
spiders      
  edema          
   bilirubin 
   cholesterol 
   albumin 
 copper 
   alkaline 
   SGOT 
   triglicerides 
   platelets
   prothrombin 
  stage / selection=forward ;
run;;


proc phreg data=c;
	
	model years*status(0,1) =  
   
   drug
   age 
   sex
  asictes
   hepatomegaly   
spiders      
  edema          
   bilirubin 
   cholesterol 
   albumin 
 copper 
   alkaline 
   SGOT 
   triglicerides 
   platelets
   prothrombin 
  stage / selection=backward;
run;;

proc phreg data=c;
	
	model years*status(0,1) =  
   
   drug
   age 
   sex
  asictes
   hepatomegaly   
spiders      
  edema          
   bilirubin 
   cholesterol 
   albumin 
 copper 
   alkaline 
   SGOT 
   triglicerides 
   platelets
   prothrombin 
  stage / selection=stepwise;
run;;
