*********************************************************;
* Program: tj_data                                      *;
* Date: 08.01.18                                        *;
* Programmer: Shanna Shi                                *;
*                                                       *;
* Purpose: This program analyzes Tommy John injury data *;
* and recovery times.                                   *;
*********************************************************;

libname baseball "H:\";

/*
*what am i dealing with?;
proc contents data=baseball.tjlist varnum;
run;
*/

data tj_data;
	set baseball.tjlist (rename=(Recovery_Time__months_=rectime));

	*creates a binary variable for return to play; 
	if rectime=. then rtp=0;
		else rtp=1;

	tday=today();
	format tday date9.;

	*survivaltime=round((tday-TJ_Surgery_Date)/30);

	*if they recover then 'survival' time is the time until recovery, otherwise survival time is 'infinite';
	if rtp=1 then survivaltime=rectime;
	else survivaltime=round((tday-TJ_Surgery_Date)/30);

run;

/*
*wrong approach because i forgot to censor, let's try that again;
proc lifetest data=tj_data atrisk plots=survival(failure) outs=outtj;
time rectime;
run;
*/

*code to manually modify the template so i can cut the axis off at 48 months;
proc template;
	source Stat.Lifetest.Graphics.ProductLimitFailure;
run;

proc template;
define statgraph Stat.Lifetest.Graphics.ProductLimitFailure;
   dynamic NStrata xName maxTime plotAtRisk plotCensored plotCL plotHW plotEP labelCL labelHW
      labelEP yMin xtickVals xtickValFitPol method StratumID classAtRisk plotTest GroupName
      Transparency rowWeights SecondTitle TestName pValue _byline_ _bytitle_ _byfootnote_;
   BeginGraph;
      if (NSTRATA=1)
         if (EXISTS(STRATUMID))
            entrytitle METHOD " Failure Curve" " for " STRATUMID;
         else
            entrytitle METHOD " Failure Curve";
         endif;
         if (PLOTATRISK=1)
            entrytitle "With Number of Subjects at Risk" / textattrs=GRAPHVALUETEXT;
         endif;
         layout overlay / xaxisopts=(shortlabel=XNAME offsetmin=.05 linearopts=(viewmax=48
            tickvaluelist=(0 6 12 18 24 30 36 42 48) tickvaluefitpolicy=XTICKVALFITPOL)) yaxisopts=(label=
            "Failure Probability" shortlabel="Failure" linearopts=(viewmin=0 viewmax=1
            tickvaluelist=(0 .2 .4 .6 .8 1.0)));
            if (PLOTHW=1 AND PLOTEP=0)
               bandplot LimitUpper=eval (1-HW_LCL) LimitLower=eval (1-HW_UCL) x=TIME /
                  displayTail=false modelname="Failure" fillattrs=GRAPHCONFIDENCE name="HW"
                  legendlabel=LABELHW;
            endif;
            if (PLOTHW=0 AND PLOTEP=1)
               bandplot LimitUpper=eval (1-EP_LCL) LimitLower=eval (1-EP_UCL) x=TIME /
                  displayTail=false modelname="Failure" fillattrs=GRAPHCONFIDENCE name="EP"
                  legendlabel=LABELEP;
            endif;
            if (PLOTHW=1 AND PLOTEP=1)
               bandplot LimitUpper=eval (1-HW_LCL) LimitLower=eval (1-HW_UCL) x=TIME /
                  displayTail=false modelname="Failure" fillattrs=GRAPHDATA1 datatransparency=
                  .55 name="HW" legendlabel=LABELHW;
               bandplot LimitUpper=eval (1-EP_LCL) LimitLower=eval (1-EP_UCL) x=TIME /
                  displayTail=false modelname="Failure" fillattrs=GRAPHDATA2 datatransparency=
                  .55 name="EP" legendlabel=LABELEP;
            endif;
            if (PLOTCL=1)
               if (PLOTHW=1 OR PLOTEP=1)
                  bandplot LimitUpper=eval (1-SDF_LCL) LimitLower=eval (1-SDF_UCL) x=TIME /
                     displayTail=false modelname="Failure" display=(outline) outlineattrs=
                     GRAPHPREDICTIONLIMITS name="CL" legendlabel=LABELCL;
               else
                  bandplot LimitUpper=eval (1-SDF_LCL) LimitLower=eval (1-SDF_UCL) x=TIME /
                     displayTail=false modelname="Failure" fillattrs=GRAPHCONFIDENCE name="CL"
                     legendlabel=LABELCL;
               endif;
            endif;
            stepplot y=eval (1-SURVIVAL) x=TIME / name="Failure" rolename=(_tip1=ATRISK _tip2=
               EVENT) tiplabel=(y="Failure Probability" _tip1="Number at Risk" _tip2=
               "Observed Events") tip=(x y _tip1 _tip2) legendlabel="Failure";
            if (PLOTCENSORED)
               scatterplot y=eval (1-CENSORED) x=TIME / tiplabel=(y="Failure Probability")
                  markerattrs=(symbol=plus) name="Censored" legendlabel="Censored";
            endif;
            if (PLOTCL=1 OR PLOTHW=1 OR PLOTEP=1)
               discretelegend "Censored" "CL" "HW" "EP" / location=outside halign=center;
            else
               if (PLOTCENSORED=1)
                  discretelegend "Censored" / location=inside autoalign=(topleft bottomright);
               endif;
            endif;
            if (PLOTATRISK=1)
               innermargin / align=bottom;
                  axistable x=TATRISK value=ATRISK / display=(label) valueattrs=(size=7pt);
               endinnermargin;
            endif;
         endlayout;
      else
         entrytitle METHOD " Failure Curves";
         if (EXISTS(SECONDTITLE))
            entrytitle SECONDTITLE / textattrs=GRAPHVALUETEXT;
         endif;
         layout overlay / xaxisopts=(shortlabel=XNAME offsetmin=.05 linearopts=(viewmax=MAXTIME
            tickvaluelist=XTICKVALS tickvaluefitpolicy=XTICKVALFITPOL)) yaxisopts=(label=
            "Failure Probability" shortlabel="Failure" linearopts=(viewmin=0 viewmax=1
            tickvaluelist=(0 .2 .4 .6 .8 1.0)));
            if (PLOTHW=1)
               bandplot LimitUpper=eval (1-HW_LCL) LimitLower=eval (1-HW_UCL) x=TIME /
                  displayTail=false group=STRATUM index=STRATUMNUM modelname="Failure"
                  datatransparency=Transparency;
            endif;
            if (PLOTEP=1)
               bandplot LimitUpper=eval (1-EP_LCL) LimitLower=eval (1-EP_UCL) x=TIME /
                  displayTail=false group=STRATUM index=STRATUMNUM modelname="Failure"
                  datatransparency=Transparency;
            endif;
            if (PLOTCL=1)
               if (PLOTHW=1 OR PLOTEP=1)
                  bandplot LimitUpper=eval (1-SDF_LCL) LimitLower=eval (1-SDF_UCL) x=TIME /
                     displayTail=false group=STRATUM index=STRATUMNUM modelname="Failure"
                     display=(outline) outlineattrs=(pattern=ShortDash);
               else
                  bandplot LimitUpper=eval (1-SDF_UCL) LimitLower=eval (1-SDF_LCL) x=TIME /
                     displayTail=false group=STRATUM index=STRATUMNUM modelname="Failure"
                     datatransparency=Transparency;
               endif;
            endif;
            stepplot y=eval (1-SURVIVAL) x=TIME / group=STRATUM index=STRATUMNUM name="Failure"
               rolename=(_tip1=ATRISK _tip2=EVENT) tiplabel=(y="Failure Probability" _tip1=
               "Number at Risk" _tip2="Observed Events") tip=(x y _tip1 _tip2);
            if (PLOTCENSORED=1)
               scatterplot y=eval (1-CENSORED) x=TIME / tiplabel=(y="Failure Probability")
                  group=STRATUM index=STRATUMNUM markerattrs=(symbol=plus);
            endif;
            if (PLOTATRISK=1)
               innermargin / align=bottom;
                  axistable x=TATRISK value=ATRISK / display=(label) valueattrs=(size=7pt)
                     class=CLASSATRISK colorgroup=CLASSATRISK;
               endinnermargin;
            endif;
            DiscreteLegend "Failure" / title=GROUPNAME location=outside;
            if (PLOTCENSORED=1)
               if (PLOTTEST)
                  layout gridded / rows=2 autoalign=(TOPLEFT BOTTOMRIGHT BOTTOM TOP) border=
                     true BackgroundColor=GraphWalls:Color Opaque=true;
                     entry "+ Censored";
                     if (PVALUE < .0001)
                        entry TESTNAME " p " eval (PUT(PVALUE, PVALUE6.4));
                     else
                        entry TESTNAME " p=" eval (PUT(PVALUE, PVALUE6.4));
                     endif;
                  endlayout;
               else
                  layout gridded / rows=1 autoalign=(TOPLEFT BOTTOMRIGHT BOTTOM TOP) border=
                     true BackgroundColor=GraphWalls:Color Opaque=true;
                     entry "+ Censored";
                  endlayout;
               endif;
            else
               if (PLOTTEST=1)
                  layout gridded / rows=1 autoalign=(TOPLEFT BOTTOMRIGHT BOTTOM TOP) border=
                     true BackgroundColor=GraphWalls:Color Opaque=true;
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

ods graphics on;
*let's try that again;
proc lifetest data=tj_data atrisk plots=survival(failure);
	time survivaltime*rtp(0);
run;
ods graphics off;


*restores the default templates;
%SurvivalTemplateRestore;

  proc template;
     delete Stat.Lifetest.Graphics.ProductLimitSurvival  / store=sasuser.templat;
     delete Stat.Lifetest.Graphics.ProductLimitSurvival2 / store=sasuser.templat;
run;
