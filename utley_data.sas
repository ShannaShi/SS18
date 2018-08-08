*********************************************************;
* Program: utley_data                                   *;
* Date: 04.04.18                                        *;
* Programmer: Shanna Shi                                *;
*                                                       *;
* Purpose: This program creates the dataset used for    *;
* the Chase Utley HBP Prediction Model™                 *;
*********************************************************;

libname baseball "H:\";

proc format;
	value homeaway
		0="Home"
		1="Away";

	value hbp
		0="No"
		1="Yes";

	value score3cat
		0="Ahead"
		1="Tied"
		2="Behind";

	value yesnoa
		0="No"
		1="Yes";

	value team
		1="Phillies"
		2="Dodgers";

	value opponents
		1="Arizona Diamondbacks"
		2="Atlanta Braves"
		3="Baltimore Orioles"
		4="Boston Red Sox"
		5="Chicago Cubs"
		6="Chicago White Sox"
		7="Cincinnati Reds"
		8="Cleveland Baseball Club"
		9="Colorado Rockies"
		10="Detroit Tigers"
		11="Florida (Miami) Marlins"
		12="Houston Astros"
		13="Kansas City Royals"
		14="Los Angeles Angels"
		15="Los Angeles Dodgers"
		16="Milwaukee Brewers"
		17="Minnesota Twins"
		18="Montreal Expos (RIP)"
		19="New York Mets"
		20="New York Yankees"
		21="Oakland Athletics"
		22="Philadelphia Phillies"
		23="Pittsburgh Pirates"
		24="San Diego Padres"
		25="Seattle Mariners"
		26="San Francisco Giants"
		27="St. Louis Cardinals"
		28="Tampa Bay (Devil) Rays"
		29="Texas Rangers"
		30="Toronto Blue Jays"
		31="Washington Walgreens";

run;

data utleypa;
set baseball.utley_pa
	(rename=(cr_=career_pa yr_=year_pa));

label out="Number of outs";

*extracts the year from the date;
year=year(date);

*cleans up the doubleheader dates;
if career_pa in(392, 393, 394, 395, 396, 397, 398, 399) then year=2004;
if career_pa in(423, 424, 425, 426, 427, 428, 429, 430, 431) then year=2004;
if career_pa in(588, 589, 590, 591, 592, 593, 594, 595) then year=2005;
if career_pa in(870, 871, 872, 873, 874, 875, 876, 877) then year=2005;
if career_pa in(1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092) then year=2006;
if career_pa in(1402, 1403, 1404, 1405, 1406, 1407, 1408, 1409, 1410) then year=2006;
if career_pa in(1525, 1526, 1527, 1528, 1529, 1530, 1531, 1532, 1533) then year=2006;
if career_pa in(1665, 1666, 1667, 1668, 1669, 1670, 1671, 1672, 1673, 1674, 1675, 1676, 1677, 1678, 1679, 1680, 1681, 1682, 1683) then year=2006;
if career_pa in(1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721) then year=2006;
if career_pa in(2159, 2160, 2161, 2162, 2163, 2164, 2165, 2166) then year=2007;
if career_pa in(3040, 3041, 3042, 3043, 3044, 3045, 3046, 3047) then year=2008;
if career_pa in(3069, 3070, 3071, 3072, 3073, 3074, 3075, 3076) then year=2008;
if career_pa in(3267, 3268, 3269, 3270) then year=2009;
if career_pa in(3731, 3732, 3733, 3734, 3735, 3736, 3737) then year=2009;
if career_pa in(3764, 3765, 3766, 3767, 3768, 3769, 3770, 3771, 3772) then year=2009;
if career_pa in(4216, 4217, 4218, 4219, 4220, 4221, 4222, 4223, 4224) then year=2010;
if career_pa in(4410, 4411, 4412, 4413, 4414, 4415, 4416, 4417, 4418) then year=2011;
if career_pa in(4718, 4719, 4720, 4721, 4722) then year=2011;
if career_pa in(4742, 4743, 4744, 4745) then year=2011;
if career_pa in(4754, 4755, 4756, 4757) then year=2011;
if career_pa in(5035, 5036, 5037, 5038, 5039, 5040, 5041, 5042, 5043, 5044) then year=2012;
if career_pa in(5406, 5407, 5408, 5409, 5410, 5411) then year=2013;
if career_pa in(6005, 6006, 6007, 6008, 6009) then year=2014;
if career_pa in(7229, 7230, 7231, 7232, 7233) then year=2016;
if career_pa in(7630, 7631, 7632, 7633) then year=2017;

*classifies games as home or away;
if opp =: "@" then home=0;
	else home=1;

*codes inning as a numerical variable;
if inn="t1" or inn="b1" then inning=1;
	else if inn="t2" or inn="b2" then inning=2;
	else if inn="t3" or inn="b3" then inning=3;
	else if inn="t4" or inn="b4" then inning=4;
	else if inn="t5" or inn="b5" then inning=5;
	else if inn="t6" or inn="b6" then inning=6;
	else if inn="t7" or inn="b7" then inning=7;
	else if inn="t8" or inn="b8" then inning=8;
	else if inn="t9" or inn="b9" then inning=9;
	else if inn="t10" or inn="b10" then inning=10;
	else if inn="t11" or inn="b11" then inning=11;
	else if inn="t12" or inn="b12" then inning=12;
	else if inn="t13" or inn="b13" then inning=13;
	else if inn="t14" or inn="b14" then inning=14;
	else if inn="t15" or inn="b15" then inning=15;
	else if inn="t16" or inn="b16" then inning=16;
	else if inn="t17" or inn="b17" then inning=17;
	else if inn="t18" or inn="b18" then inning=18;

inn_cent=inning-1;

*categorizes the current score into 3 bins;
if score=: "ahead" then score3cat=0;
	else if score=: "tied" then score3cat=1;
	else if score=: "down" then score3cat=2;
label score3cat="3-category score";

*is it a HBP?;
if event_type="HBP" then hbp=1;
	else hbp=0;

*was he with the dodgers or phillies;
if tm="PHI" then team=1;
	else team=2;

*creates a variable for opposing team;
if index(opp,'ARI') then opponent=1;
	else if index(opp,'ATL') then opponent=2;
	else if index(opp,'BAL') then opponent=3;
	else if index(opp,'BOS') then opponent=4;
	else if index(opp,'CHC') then opponent=5;
	else if index(opp,'CHW') then opponent=6;
	else if index(opp,'CIN') then opponent=7;
	else if index(opp,'CLE') then opponent=8;
	else if index(opp,'COL') then opponent=9;
	else if index(opp,'DET') then opponent=10;
	else if index(opp,'FLA') or index(opp,'MIA') then opponent=11;
	else if index(opp,'HOU') then opponent=12;
	else if index(opp,'KCR') then opponent=13;
	else if index(opp,'LAA') then opponent=14;
	else if index(opp,'LAD') then opponent=15;
	else if index(opp,'MIL') then opponent=16;
	else if index(opp,'MIN') then opponent=17;
	else if index(opp,'MON') then opponent=18;
	else if index(opp,'NYM') then opponent=19;
	else if index(opp,'NYY') then opponent=20;
	else if index(opp,'OAK') then opponent=21;
	else if index(opp,'PHI') then opponent=22;
	else if index(opp,'PIT') then opponent=23;
	else if index(opp,'SDP') then opponent=24;
	else if index(opp,'SEA') then opponent=25;
	else if index(opp,'SFG') then opponent=26;
	else if index(opp,'STL') then opponent=27;
	else if index(opp,'TBD') or index(opp,'TBR') then opponent=28;
	else if index(opp,'TEX') then opponent=29;
	else if index(opp,'TOR') then opponent=30;
	else if index(opp,'WSN') then opponent=31;
label opponent="Opponent team";

/*yeah this isn't necessary
*creates dummy variables for opposing team;
if opponent=1 then do;
	ari=1; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=2 then do;
	ari=0; atl=1; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=3 then do;
	ari=0; atl=0; bal=1; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=4 then do;
	ari=0; atl=0; bal=0; bos=1; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=5 then do;
	ari=0; atl=0; bal=0; bos=0; chc=1; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=6 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=1; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=7 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=1; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=8 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=1; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=9 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=1; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=10 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=1; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=11 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=1;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=12 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=1; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=13 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=1; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=14 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=1; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=15 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=1; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=16 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=1; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=17 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=1; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=18 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=1; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=19 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=1; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=20 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=1; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=21 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=1; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=22 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=1; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=23 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=1; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=24 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=1; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=25 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=1; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=26 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=1; stl=0; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=27 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=1; tbr=0; tex=0; tor=0; wsn=0;
	end;
else if opponent=28 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=1; tex=0; tor=0; wsn=0;
	end;
else if opponent=29 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=1; tor=0; wsn=0;
	end;
else if opponent=30 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=1; wsn=0;
	end;
else if opponent=31 then do;
	ari=0; atl=0; bal=0; bos=0; chc=0; chw=0; cin=0; cle=0; col=0; det=0; hou=0; kcr=0; laa=0; lad=0; mia=0;
	mil=0; min=0; mon=0; nym=0; nyy=0; oak=0; phi=0; pit=0; sdp=0; sea=0; sfg=0; stl=0; tbr=0; tex=0; tor=0; wsn=1;
	end;
*/

*creates a variable to count the number of PAs since last HBP event;	
pa_since_hbp+1;
if lag1(hbp)=1 then pa_since_hbp=0;

*drops extraneous variables;
drop pitcher date rob pit_cnt_ rbi wpa re24 li play_description;

run;

/*this is pointless
proc sgplot data=utleypa;
scatter y=hbp x=game;
run;
*/

*model selection;

/*just do a class statement
proc genmod data=utleypa descending;
	model hbp=year_pa pa_since_hbp team score3cat inn_cent out year home ari atl bal bos chc chw cin cle col det hou kcr laa lad mia mil min mon nym nyy oak phi pit sdp sea sfg stl tbr tex tor wsn; selection=stepwise slentry=0.025 slstay=0.025;
run;
quit;
*/

*removing the stepwise selection to evaluate predictors one by on because statistical significance is a SCAM;
proc genmod data=utleypa descending;
	class opponent;
	model hbp=year_pa pa_since_hbp team score3cat inn_cent out year home opponent;*/selection=stepwise slentry=0.025 slstay=0.025;
run;
quit;

proc logistic data=utleypa descending;
	model hbp=inn_cent nym/expb;
	*output out=hbp_p p=risk l=l95 u=u95;
run;
quit;


data utleyhbp;
	set utleypa;
	where hbp=1;

/* this is unnecessary
	id=1;
	offset=log(pa_since_hbp);

	if nym=1 then nym2=1;
		else nym2=2;
*/
run;


  ods graphics on;
  ods select survivalplot(persist) failureplot(persist);

proc lifetest data=utleyhbp atrisk plots=survival(failure) outs=outhbp;
time pa_since_hbp;
run;

/*this is unnecessary since i figured out how to graph this in lifetest, yay;
data survival;
set outhbp;

p=1-survival;
run;

proc sgplot data=survival;
	series x=pa_since_hbp y=p;
	xaxis label="Plate Appearances Since Last HBP" labelattrs=(size=10 weight=bold);
	yaxis label="Probability of HBP" labelattrs=(size=10 weight=bold);
run;
*/
