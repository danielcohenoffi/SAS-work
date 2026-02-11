
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
