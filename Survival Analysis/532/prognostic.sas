libname rhr 'C:\Users\75RRIEGER\OneDrive - West Chester University of PA\Documents\summer 2019';



data cirr_f312;
	set rhr.cirr;
	if case le 312;	
	/*if case le 161 then trans=1;
	else trans=0;*/
	years=days/365;

run;

/* LAST CLASS EXAMPLE OF PROGNOSTIC INDEX*/

/* STEP 3 */

data createdata;
	set cirr_f312;
	rand=ranuni(7);	
run;

proc print;
run;

proc sort data=createdata;
by rand;
run; 

data train hold;
	set createdata;
	if _N_<201 then output train;
	else output hold;
run;

proc print data=train;
run;

/* TASK 5 */

proc phreg data=train;
	
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


proc phreg data=train;
	
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


/* sex spiders bilirubin albumin stage */


proc phreg data=train outest=out1 ;
	model years*status(0,1) = sex spiders bilirubin albumin stage ;
run;

proc print data=out1;
run;

data train;
	set train;
	length risk $8;
	/* note that log H absorbs the baseline risk */
	log_H=-1.10607*sex + 0.42872*spiders+  0.13237*bilirubin
	-0.97539*albumin + 0.38495*stage; 
/*based on univariate */
/*risk="Low";
if log_H > -3.5 then risk ="Medium";
if log_H > -2.5 then risk="High"; 
*/
run;

proc print;
run;

proc univariate data=train plots;
	var log_H;
run;

proc sort data=train;
	by log_h;
run;

proc print;
var log_h;
run;

data train;
 set train;
 risk="Low";
if log_H > -3.33333 then risk ="Medium";
if log_H > -2.5 then risk="High"; 
run;

proc print data=train;
var log_h risk;
run;

proc freq data=train;
tables risk;
run;


/* STEP 8*/
proc lifetest data=train plot=(s) graphics;
	time years*status(0,1);
	strata risk;
	symbol1 v=none color=blue line=1;
	symbol2 v=none color=red line=2;
	symbol3 v=none color=black line=7;
run;
 

/* step 9 */

data hold;
	set hold;
	log_H=-1.10607*sex + 0.42872*spiders+  0.13237*bilirubin
	-0.97539*albumin + 0.38495*stage; 
	risk="Low";
if log_H > -3.33333 then risk ="Medium";
if log_H > -2.5 then risk="High"; 
run;


proc lifetest data=hold plot=(s) graphics;
	time years*status(0,1);
	strata risk;
	symbol1 v=none color=blue line=1;
	symbol2 v=none color=red line=2;
	symbol3 v=none color=black line=7;
run;


data c;
	set cirr_f312;
	if status ne 1;
run;


/*Scenario 1*/
/* events just after censoring*/

data scen1;
	set c;
	if status=0 then do;
		status=1;
		years=years+(1/365);
	end;
run;

proc print;
run;

proc phreg data=scen1;
	model years*status(0) = age albumin stage bilirubin stage_t bil_t;
	stage_t=stage*years;
	bil_t=bilirubin*years;
run;

/* scenario 2 */
/* censored survived longer than longest individual*/
/* still removed status=2 for convenience */


proc means data=c;
var years;
run;

data scen2;
	set c;
	if status=0 then do;
		status=1;
		years=12.5;
	end;
run;


proc phreg data=scen2;
	model years*status(0) = age albumin stage bilirubin stage_t bil_t;
	stage_t=stage*years;
	bil_t=bilirubin*years;
run;

