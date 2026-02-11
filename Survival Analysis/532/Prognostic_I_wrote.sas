data cirr;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\cirr';
run;

data cirr_f312;
	set cirr;
	if case le 312;	
	/*
	if case le 161 then trans=1;
	else trans=0;*/
	years=days/365;
run;


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

proc phreg data = train;

	model years*status(0,1) =  drug age sex asictes hepatomegaly spiders edema albumin copper
	alkaline sgot triglicerides platelets prothrombin stage 
stage_t/asc_t spiders_t chol_t tri_t sgot_t proth_t / selection = backwards;
	stage_t=stage*years;
	asc_t = asictes*years;
	spiders_t = spiders*years;
	chol_t = cholesterol*years;
	tri_t = triglicerides*years;
	sgot_t = sgot*years;
	proth_t = prothrombin*years;
	
  run;
proc phreg data = train;

	model years*status(0,1) =  drug age sex asictes hepatomegaly spiders edema albumin copper
	alkaline sgot triglicerides platelets prothrombin stage stage_t; 
stage_t = stage*years;
run;



proc phreg data = train;
model years*status(0,1) = age edema copper sgot stage cholesterol edema_t stage_t chol_t asictes asc_t;
edema_t = edema*years;
stage_t = stage*years;
chol_t = cholesterol*years;
asc_t = asictes*years;
run;
