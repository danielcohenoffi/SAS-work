data ch11_1;
set '\\apporto.com\dfs\WCUPA\Users\dc1030974_wcupa\Desktop\Datasets\ch16q01';
run;



proc contents data=ch11_1;
run;

proc print data=ch11_1;
run;

*Question 1a;

proc reg;
model wgt=hgt age age2;
run;

*A model with the covariates age and age2 gives us our adjusted coefficient of .72369.  This adjusts for all
covariates of interest hence it is the "gold standard" we will compare all other models to.  It should be
noted that the associated standard error is .27696;

*Question 1b;

proc reg;
model wgt=hgt;
run;

*Our raw coefficient is 1.07223.  Using our 10% criteria this is "meaningfully" different than .72369.  Note that 
we should confirm this conclusion with a subject specialist as well.  This means that confounding does exist due to 
Age and/or Age2.

*Question 1c;

proc reg;
model wgt=hgt age;
run;

*Our coefficient is .72044.  Using our 10% rule this is not meaningfully different than .72369. Hence Age2 is not
needed to control for confounding;

*Question 1d and 1e;

*This wasn't explicitly covered in lecture but it is in the textbook and should be intuitive.  If we have
two "equivalent" models -- this case the hgt/age model and the hgt/age/age2 model then we can opt to 
selec the model that has the smallest standard error for the hgt variable (our variable of interest).  
In this example the hgt/age model has the smallest standard error of .26081 so we would pick that
model if worried/focused on precision.  This model both controls for confounding and has a more
precice estimate -- as an added bonus its a simpler, more parsimonous model!;


*Questions 1f and 1g;

*Here I will opt for a chunkwise test for interaction;

data new;
set ch11_1;
int1 = hgt*age;
int2 = hgt*age2;
run;


proc reg plots = none;
model wgt=hgt age age2 int1 int2;
test int1, int2, age2, age;
run;

*Pvalue is .4687;

*Hence at the .05 signifiance level we would conclude that there does not appear significant interaction between
hgt and age as well as hgt and age2;









 
