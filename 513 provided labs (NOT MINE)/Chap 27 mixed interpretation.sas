
***********************************************************************
* Mixed Interpretation of Data         Statistician:   Bob Gallop     *
*                                                                     *
*                                                                     *
* Purpose: Illustrate that Naive ways to look at Data may result in   *
*          erroneous interpretations                                  *
*                                                                     *
* File: C:\bobextra\statexp\mypapers\mixed interpretation.sas         *
*                                                                     *
***********************************************************************
;



options formdlim=' ' ls=90 ps=50 nofmterr;


libname bob 'C:\Users\SMSTAT\Documents\WCULaptop\STA513\Materials513\Data';



data score;
set bob.mix;
run;


proc print data=score;
quit;


                                                                                                       
      proc sgplot data =SCORE;                                                                                                       
            yaxis grid label='SCORE' ;                                                                        
            xaxis   LABEL='iip' ;                                                                                           
              loess x = iip y = SCORE/MARKERATTRS=( symbol=circle) NOLEGFIT      ;                                   
                                                                                                                                        
                                                                                                                                        
      quit;                                                                                                                             
                                                                                                                                        
                       



proc glm data=score;
model score = iip /ss3;
quit;

                              


goptions reset=symbol gunit=pct noborder noprompt rotate=landscape
htitle=5 htext=3 hby=6 fby=swissb noprompt;
proc gplot data=score  ;
symbol1 v=dot h=3.5  c=red i=rl ci=red ;
symbol2 v=dot h=3.5  c=blue i=rl ci=blue ;
symbol3 v=dot h=3.5  c=green i=rl ci=green ;
symbol4 v=dot h=3.5  c=yellow i=rl ci=yellow ;
symbol5 v=dot h=3.5  c=black i=rl ci=black ;
symbol6 v=dot h=3.5  c=purple i=rl ci=purple ;
symbol7 v=dot h=3.5  c=orange i=rl ci=orange ;
symbol8 v=dot h=3.5  c=brown i=rl ci=brown ;
symbol9 v=dot h=3.5  c=gold i=rl ci=gold ;
symbol10 v=dot h=3.5  c=grey i=rl ci=grey ;
symbol11 v=star h=3.5  c=red i=rl ci=red ;
symbol12 v=star h=3.5  c=blue i=rl ci=blue ;
symbol13 v=star h=3.5  c=green i=rl ci=green ;
symbol14 v=star h=3.5  c=yellow i=rl ci=yellow ;
symbol15 v=star h=3.5  c=black i=rl ci=black ;
axis1  label = (c=black f=swissb h=5 'IIP') value=(h=2.3 f=swissb) minor=none;
axis2  label = (c=black a=90 h=5 f=swissb 'Score')
             value=(h=3.5 f=swissb) minor=none  ;
plot score*iip=patid  /overlay
         haxis=axis1 vaxis=axis2 frame ;
run;
quit; title;


proc mixed data=score;
class patid;
model score =patid iip /s ddfm = satterth;   *****Satterthwaite approach estimated degrees of freedom****;

repeated /type = ar(1) sub=patid r rcorr ;   ********r prints out the variance-covariance matrix for the repeated measures****;
											******rcorr prints out the correlation matrix***;
											***sub - flags the variable in the data set where we have repeated measures****;

											***ar(1)  Autoregressive design: assumes an equal variance at each timepoint
											but assumes points closer in time are more correlated than points further spaced
											in time****;


*repeated /type = toep sub=patid r rcorr ; ****TOEPLITZ DESIGN equal variance at each timepoint.  Assumes equal covariance/correlation between
												pairs of points equal spaced in time, but makes no restriction about whehter
												points closer in time have bigger or smaller correlations****;



*repeated /type = un sub=patid r rcorr ; ****UNSTRUCTUED DESIGN: most liberal design of them all.  allows seperate variance at each timepoint
											and separate covariance/correlation between any pairs of timepoints****;

*repeated /type = cs sub=patid r rcorr ;   ****COMPOUND SYMMETRY DESIGN: matches the exchangeable design of GEE
											equal variance at each timepoint
											equal covariance/correelation between any pair of timepoints****;
				


quit;




proc glm data=score;
model score = iip /ss3;
quit;


proc mixed data=score;
class patid;
model score = patid iip/s ddfm = satterth;
repeated /type = un sub=patid r rcorr ;
quit;



*******Best fitting structure****;

proc mixed data=score;
class patid;
model score = patid iip/ ddfm = satterth;
repeated /type = cs sub=patid r rcorr ;
quit;
proc mixed data=score;
class patid;
model score = patid iip/ ddfm = satterth;
repeated /type = ar(1) sub=patid r rcorr ;
quit;

proc mixed data=score;
class patid;
model score = patid iip/ ddfm = satterth;
repeated /type = toep sub=patid r rcorr ;
quit;

proc mixed data=score;
class patid;
model score = patid iip/ ddfm = satterth;
repeated /type = un sub=patid r rcorr ;
quit;


*****To compare between two covariance structures, we look at the difference in the -2RES LL between the two models &
			the difference in the number of parameters estimated by each model.  That difference in -2RESLL follows a
			Chi-square distribution with DF equal to the difference in the number of parameters.


if that chi-square is significant, then the more complex structure is warranted and therefore fit.
if the chi-square is non-signficant then the we don't have sufficient evidence indicating the need
for the more complex structure, therefore we assume the more simplistic structure is sufficient for modeling purposes***;
