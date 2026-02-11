                                                                                                                                
                                                                                                                                        
                                                                                                                                        
****************ILLUSTRATION OF A TWO-FACTOR MIXED MODEL********;    

*****3 TX arms: A  only TX we are interested in*****;
*****2 out of 5 therapist randomly chosen to rate each patient for each TX assignment****;


 
   data mixed;                                                                                                                          
input score a b id;                                                                                                                     
cards;                                                                                                                                  
   72.0      1      1      1                                                                                                            
   48.0      1      1      2                                                                                                            
   63.0      1      2      3                                                                                                            
   57.0      1      2      4                                                                                                            
   69.0      1      3      5                                                                                                             
   37.0      1      3      1                                                                                                            
   45.0      1      4      2                                                                                                            
   39.0      1      4      3                                                                                                            
   54.0      1      5      4                                                                                                            
   44.0      1      5      5                                                                                                            
   51.0      2      1      1                                                                                                            
   57.0      2      1      2                                                                                                            
   45.0      2      2      3                                                                                                            
   50.0      2      2      4                                                                                                            
   39.0      2      3      5                                                                                                            
   61.0      2      3      1                                                                                                            
   58.0      2      4      2                                                                                                            
   70.0      2      4      3                                                                                                            
   66.0      2      5      4                                                                                                            
   51.0      2      5      5                                                                                                            
   59.0      3      1      1                                                                                                            
   65.0      3      1      2                                                                                                            
   55.0      3      2      3                                                                                                            
   12.0      3      2      4                                                                                                            
   70.0      3      3      5                                                                                                            
   58.0      3      3      1                                                                                                            
   63.0      3      4      2                                                                                                            
   70.0      3      4      3                                                                                                            
   53.0      3      5      4                                                                                                            
   60.0      3      5      5                                                                                                            
                                                                                                                                        
      ;                                                                                                                                 
run;      


proc freq data=mixed;
tables id a b;
tables id*(a b);
quit;
 
      

proc freq data=mixed;
tables id*a*b/list;
quit;
 
data mixed;                                                                                                                             
set mixed;                                                                                                                              
newid = a*100+b*10+id;                                                                                                                  
run;       



proc freq data=mixed;
tables a;
tables b;
quit;


proc sort data=mixed;
by a b  newid;
quit;


proc print data=mixed;
var a b newid;
quit;


 
                                                                                                                                        
                                                                                                                                        
proc mixed data=mixed covtest cl method=type1;                                                                                          
class a b newid;                                                                                                                        
model score = a   /solution;                                                                                                            
random b a*b;                                                                                                                           
quit;                                                                                                                                   
            

                                                                                                                             
                                                                                                                                        
proc mixed data=mixed covtest cl method=type1;                                                                                          
class a b newid;                                                                                                                        
model score = a   /solution;                                                                                                            
random b ; * Parsimonuous model gets rid of the a*b interaction due to non-signficance;                                                                                                                           
quit;                                                                                                                                   
                                                                                                          
                                                                                                                                        
proc mixed data=mixed covtest cl method=reml;                                                                                          
class a b newid;                                                                                                                        
model score = a   /solution;                                                                                                            
random b a*b;                 ***0 component for b says the model is overparameterized****;
 
quit;                                                                                                                                   
                                                                                                                                        
                                                                                 
                  ***SIMPLIFIED****;
 
proc mixed data=mixed covtest cl method=reml;                                                                                          
class a b newid;                                                                                                                        
model score = a   /solution;                                                                                                            
random b ;
* we get rid of the interaction to simplify the model a*b;   
		***0 component for b says the model is overparameterized****;
 
quit;                                          
                      
*****Only thing we can fit is the fixed effect portion under REML*****;

proc mixed data=mixed covtest cl method=reml;                                                                                          
class a b newid;                                                                                                                        
model score = a   /solution;                                                                                                            
*random b ;
* we get rid of the interaction to simplify the model a*b;   
		***0 component for b says the model is overparameterized****;
 
quit;                  
