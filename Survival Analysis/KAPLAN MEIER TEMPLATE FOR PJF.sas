proc template;                                                                
   define statgraph Stat.Lifetest.Graphics.ProductLimitSurvival;              
      dynamic NStrata xName plotAtRisk plotCensored plotCL plotHW plotEP      
         labelCL labelHW labelEP maxTime xtickVals xtickValFitPol rowWeights  
         method StratumID classAtRisk plotTest GroupName Transparency         
         SecondTitle TestName pValue _byline_ _bytitle_ _byfootnote_;         
      BeginGraph;                                                             
         if (NSTRATA=1)                                                       
            if (EXISTS(STRATUMID))                                            
               entrytitle METHOD " Survival Estimate" " for " STRATUMID;      
            else                                                              
               entrytitle  "Kaplan-Meier Curve of Time to PJF" / textattrs=(size=14pt) ;                        
            endif;                                                            
            if (PLOTATRISK=1)                                                 
               entrytitle "With Number of Subjects at Risk" / textattrs=      
                  GRAPHVALUETEXT (size=11pt);                                             
            endif;                                                            
            layout overlay / xaxisopts=(shortlabel="Time-To-Event (Days)" label="Time-To-Event (Days)" offsetmin=.05        
               linearopts=(viewmax=MAXTIME tickvaluelist=XTICKVALS            
               tickvaluefitpolicy=XTICKVALFITPOL) labelattrs=(size=13pt) tickvalueattrs=(size=11pt)) yaxisopts=(label=          
               "Event-Free Probability" shortlabel="Survival" labelattrs=(size=13pt) tickvalueattrs=(size=11pt) linearopts=(      
               viewmin=0 viewmax=1 tickvaluelist=(0 .2 .4 .6 .8 1.0) ));       
               if (PLOTHW=1 AND PLOTEP=0)                                     
                  bandplot LimitUpper=HW_UCL LimitLower=HW_LCL x=TIME /       
                     displayTail=false modelname="Survival" fillattrs=        
                     GRAPHCONFIDENCE name="HW" /*legendlabel=LABELHW*/;           
               endif;                                                         
               if (PLOTHW=0 AND PLOTEP=1)                                     
                  bandplot LimitUpper=EP_UCL LimitLower=EP_LCL x=TIME /       
                     displayTail=false modelname="Survival" fillattrs=        
                     GRAPHCONFIDENCE name="EP" /*legendlabel=LABELEP*/;           
               endif;                                                         
               if (PLOTHW=1 AND PLOTEP=1)                                     
                  bandplot LimitUpper=HW_UCL LimitLower=HW_LCL x=TIME /       
                     displayTail=false modelname="Survival" fillattrs=        
                     GRAPHDATA1 datatransparency=.55 name="HW" /*legendlabel=   
                     LABELHW*/;                                                 
                  bandplot LimitUpper=EP_UCL LimitLower=EP_LCL x=TIME /       
                     displayTail=false modelname="Survival" fillattrs=        
                     GRAPHDATA2 datatransparency=.55 name="EP" /*legendlabel=   
                     LABELEP*/;                                                 
               endif;                                                         
               if (PLOTCL=1)                                                  
                  if (PLOTHW=1 OR PLOTEP=1)                                   
                     bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME /  
                        displayTail=false modelname="Survival" display=(      
                        outline) outlineattrs=GRAPHPREDICTIONLIMITS name="CL" 
                        legendlabel=LABELCL;                                  
                  else                                                        
                     bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME /  
                        displayTail=false modelname="Survival" fillattrs=     
                        GRAPHCONFIDENCE name="CL" legendlabel=LABELCL;        
                  endif;                                                      
               endif;                                                         
               stepplot y=SURVIVAL x=TIME / name="Survival" rolename=(_tip1=  
                  ATRISK _tip2=EVENT) tiplabel=(_tip1="Number at Risk" _tip2= 
                  "Observed Events") tip=(x y _tip1 _tip2) legendlabel=       
                  "Survival";                                                 
               if (PLOTCENSORED=1)                                            
                  scatterplot y=CENSORED x=TIME / markerattrs=(symbol=CIRCLE SIZE=8)   
                     tiplabel=(y="Survival Probability") name="Censored"      
                     legendlabel="Censored";                                  
               endif;                                                         
               if (PLOTCL=1 OR PLOTHW=1 OR PLOTEP=1)                          
                  discretelegend "Censored" "CL" "HW" "EP" / location=inside autoalign=(  
                        topright bottomleft);                    
               else                                                           
                  if (PLOTCENSORED=1)                                         
                     discretelegend "Censored" / location=inside autoalign=(  
                        topright bottomleft);                                 
                  endif;                                                      
               endif;                                                         
               if (PLOTATRISK=1)                                              
                  innermargin / align=bottom;                                 
                     axistable x=TATRISK value=ATRISK / display=(label)       
                        valueattrs=(size=9pt);                                
                  endinnermargin;                                             
               endif;                                                         
            endlayout;                                                        
         else                                                                 
            entrytitle METHOD " Survival Estimates";                          
            if (EXISTS(SECONDTITLE))                                          
               entrytitle SECONDTITLE / textattrs=GRAPHVALUETEXT;             
            endif;                                                            
            layout overlay / xaxisopts=(shortlabel="Time-To-Event (Days)" offsetmin=.05        
               linearopts=(viewmax=MAXTIME tickvaluelist=XTICKVALS            
               tickvaluefitpolicy=XTICKVALFITPOL)) yaxisopts=(label=          
               "Survival Probability" shortlabel="Survival" linearopts=(      
               viewmin=0 viewmax=1 tickvaluelist=(0 .2 .4 .6 .8 1.0)));       
               if (PLOTHW=1)                                                  
                  bandplot LimitUpper=HW_UCL LimitLower=HW_LCL x=TIME /       
                     displayTail=false group=STRATUM index=STRATUMNUM         
                     modelname="Survival" datatransparency=Transparency;      
               endif;                                                         
               if (PLOTEP=1)                                                  
                  bandplot LimitUpper=EP_UCL LimitLower=EP_LCL x=TIME /       
                     displayTail=false group=STRATUM index=STRATUMNUM         
                     modelname="Survival" datatransparency=Transparency;      
               endif;                                                         
               if (PLOTCL=1)                                                  
                  if (PLOTHW=1 OR PLOTEP=1)                                   
                     bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME /  
                        displayTail=false group=STRATUM index=STRATUMNUM      
                        modelname="Survival" display=(outline) outlineattrs=( 
                        pattern=ShortDash);                                   
                  else                                                        
                     bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME /  
                        displayTail=false group=STRATUM index=STRATUMNUM      
                        modelname="Survival" datatransparency=Transparency;   
                  endif;                                                      
               endif;                                                         
               stepplot y=SURVIVAL x=TIME / group=STRATUM index=STRATUMNUM    
                  name="Survival" rolename=(_tip1=ATRISK _tip2=EVENT) tiplabel
                  =(_tip1="Number at Risk" _tip2="Observed Events") tip=(x y  
                  _tip1 _tip2);                                               
               if (PLOTCENSORED=1)                                            
                  scatterplot y=CENSORED x=TIME / group=STRATUM index=        
                     STRATUMNUM tiplabel=(y="Survival Probability")           
                     markerattrs=(symbol=plus);                               
               endif;                                                         
               if (PLOTATRISK=1)                                              
                  innermargin / align=bottom;                                 
                     axistable x=TATRISK value=ATRISK / display=(label)       
                        valueattrs=(size=9pt) class=CLASSATRISK colorgroup=   
                        CLASSATRISK;                                          
                  endinnermargin;                                             
               endif;                                                         
               DiscreteLegend "Survival" / title=GROUPNAME location=outside;  
               if (PLOTCENSORED=1)                                            
                  if (PLOTTEST=1)                                             
                     layout gridded / rows=2 autoalign=(TOPRIGHT BOTTOMLEFT   
                        TOP BOTTOM) border=true BackgroundColor=              
                        GraphWalls:Color Opaque=true;                         
                        entry "+ Censored";                                   
                        if (PVALUE < .0001)                                   
                           entry TESTNAME " p " eval (PUT(PVALUE, PVALUE6.4));
                        else                                                  
                           entry TESTNAME " p=" eval (PUT(PVALUE, PVALUE6.4));
                        endif;                                                
                     endlayout;                                               
                  else                                                        
                     layout gridded / rows=1 autoalign=(TOPRIGHT BOTTOMLEFT   
                        TOP BOTTOM) border=true BackgroundColor=              
                        GraphWalls:Color Opaque=true;                         
                        entry "+ Censored";                                   
                     endlayout;                                               
                  endif;                                                      
               else                                                           
                  if (PLOTTEST=1)                                             
                     layout gridded / rows=1 autoalign=(TOPRIGHT BOTTOMLEFT   
                        TOP BOTTOM) border=true BackgroundColor=              
                        GraphWalls:Color Opaque=true;                         
                        if (PVALUE < .0001)                                   
                           entry TESTNAME " p " eval (PUT(PVALUE, PVALUE6.4));
                        else                                                  
                           entry TESTNAME " p=" eval (PUT(PVALUE, PVALUE6.4));
                        endif;                                                
                     endlayout;                                               
                  endif;                                                      
               endif;                                                         
            endlayout;                                                        
         endif;                                                               
         if (_BYTITLE_)                                                       
            entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT;                   
         else                                                                 
            if (_BYFOOTNOTE_)                                                 
               entryfootnote halign=left _BYLINE_;                            
            endif;                                                            
         endif;                                                               
      EndGraph;                                                               
   end;                                                                       
run;                                                                         
