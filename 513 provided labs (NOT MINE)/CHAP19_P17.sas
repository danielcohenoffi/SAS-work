*Pb 19.12, two-way anova

options formdlim=' ' ls=90 ps=50;
data disk;
input time tech make id;
cards;
   62.0      1      1      1
   48.0      1      1      2
   63.0      1      1      3
   57.0      1      1      4
   69.0      1      1      5
   57.0      1      2      1
   45.0      1      2      2
   39.0      1      2      3
   54.0      1      2      4
   44.0      1      2      5
   59.0      1      3      1
   53.0      1      3      2
   67.0      1      3      3
   66.0      1      3      4
   47.0      1      3      5
   51.0      2      1      1
   57.0      2      1      2
   45.0      2      1      3
   50.0      2      1      4
   39.0      2      1      5
   61.0      2      2      1
   58.0      2      2      2
   70.0      2      2      3
   66.0      2      2      4
   51.0      2      2      5
   55.0      2      3      1
   58.0      2      3      2
   50.0      2      3      3
   69.0      2      3      4
   49.0      2      3      5
   59.0      3      1      1
   65.0      3      1      2
   55.0      3      1      3
   52.0      3      1      4
   70.0      3      1      5
   58.0      3      2      1
   63.0      3      2      2
   70.0      3      2      3
   53.0      3      2      4
   60.0      3      2      5
   47.0      3      3      1
   56.0      3      3      2
   51.0      3      3      3
   44.0      3      3      4
   50.0      3      3      5
;
run;



proc print data=disk;
quit;


proc format;
value techfmt 1='1' 2='2' 3='3';
value techgmt 4='1' 5='2' 6='3';
value makfmt 1='1' 2='2' 3='3';

quit;


*************RUN 2-way model with interaction****;



proc glm data=disk PLOTS(only) = diagnostics intplot order=internal;  ****AUTO PLTS***;;
   class tech make;
   model time=tech|make /ss1 ss3;
   means tech*make;
   lsmeans tech*make/slice=tech;
   lsmeans tech*make/slice=make;
   lsmeans tech*make/pdiff cl alpha=0.05 plots=(meanplot (join cl));
   ods exclude lsmeansplots;
format tech techfmt.;
format make makfmt.;
    quit;



proc glm data=disk PLOTS=all;  ****AUTO PLTS***;;
   class make tech;
   model time=make|tech /ss1 ss3;
format tech techfmt.;
format make makfmt.;
    quit;



************INTERACTION IS SIGNIFICANT - We would not reduce the model to a MAIN EFFECTS MODEL****;
                                ****Except part d is asking you to look at the main effects model alone***;


proc glm data=disk;
   class make tech;
   model time=make tech /ss1 ss3;
format tech techfmt.;
format make makfmt.;
    quit;


        ****WE COULD FOCUS On THE MAIN EFFECTS TERMS WITHIN THE MODEL INCLUDING THE INTERACTION.
        THAT IS THE MORE APPROPRIATE WAY TO DO IT WITH A SIGNIFICANT INTERACTION****;




proc glm data=disk;
   class make tech;
   model time=make|tech /ss1 ss3;
format tech techfmt.;
format make makfmt.;
    quit;



        ****kIMBALL^S INEQUALITY TO SET THE ALPHA-LEVEL****;
*****usually done in confirmatory models not exploratory models****;

       ****Alpha per equation 19.53 should be set to alpha  =1 - (1-0.05)**3   ;
        proc iml;
        alpha = 1 - (1-0.05)**3;
        print alpha;  ****Kimball^s alpha-level if we don't adjust***;

        quit;

***Alpha per equation 19.53 should be set to alpha  =1 - (1-0.05)**3   ;
        proc iml;
        alpha = 1 - (1-0.05/3)**3;
        print alpha;  ****Kimball^s alpha-level if we don't adjust***;

        set_alpha = 0.05/3;
        print set_alpha;

        quit;



        proc iml;
        alpha = 1 - (1-0.01/3)**3;
        print alpha;  ****Kimball^s alpha-level if we don't adjust***;

        set_alpha = 0.01/3;
        print set_alpha;

        quit;



proc glm data=disk;
   class make tech;
   model time=make|tech /ss1 ss3;
format tech techfmt.;
format make makfmt.;
    quit;





**************************don^t forget GOODNESS OF FIT in the TWO-WAY MODEL****;
