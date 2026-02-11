
                *****we NEED TO CREATE A DATA SET WHICH HAS
                                        THE ESTIMATED MEANS PER CELL***;


Data Fluids;
   Input Fluid $ Dosage $ LacticAcid;
   CARDS;
         WATER LOW          35.6
         EZDZ1   LOW       33.7
         WATER HIGH      19
         EZDZ1  HIGH      25.9
;
run;


  Proc glmpower data=Fluids;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
*contrast 'Delta Low Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=.  Power=0.80;
Run;


  Proc glmpower data=Fluids;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
contrast 'Delta HIGH Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=.  Power=0.80;
Run;


  Proc glmpower data=Fluids;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
contrast 'Delta HIGH Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=100  Power=.;
Run;


  Proc glmpower data=Fluids;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
contrast 'Delta Low Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=102  Power=.;
Run;
      Data Fluids2;
   Input Fluid $ Dosage $ LacticAcid wt;
   CARDS;
         WATER LOW          35.6  5
         EZDZ1   LOW       33.7   2
         WATER HIGH      19       1
         EZDZ1  HIGH      25.9    2
;
run;

  Proc glmpower data=Fluids;
Class Fluid Dosage;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
contrast 'Delta HIGH Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
POWER STDDEV=10.2 alpha=0.05 Ntotal=.  Power=0.80;
Run;



  Proc glmpower data=Fluids2;
Class Fluid Dosage;
weight wt;
Model LacticAcid = FLUID DOSage FLUID*DOSAGE ;
contrast 'Delta HIGH Dosage' fluid 1 -1 fluid*dosage 1  0 -1 0 ;
contrast ' interact' fluid*dosage 1 -1 -1 1;
POWER STDDEV=10.2 alpha=0.05 Ntotal=.  Power=0.80;
Run;


ods trace off;
