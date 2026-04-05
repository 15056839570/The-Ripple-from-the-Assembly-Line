use "D:\tongyi data\hebing12.dta", clear
**儿童样本数据再处理
encode province, generate(province_num)
gen lnedutotal=ln(edutotal+1)
gen lntotal_asset=ln(total_asset+1)
gen lnrobot_install=ln(robot_installation+1)
gen lnrobot_stock=ln(robot_stock+1)
gen lnwd503r=ln(wd503r+1)
gen lnwd501b=ln(wd501b+1)
gen lnwd577rn=ln(wd577rn+1)
gen lniv_install=ln(iv_installation+1)
gen lniv_stock=ln(iv_stock+1)
winsor2 total_asset ,cuts(1 99) by(year)
gen FamilyAsset=ln(total_asset_w+1)

rename lnedutotal EduExpenditure
rename lnwd503r TutorCost
rename lnrobot_install Robot
rename lniv_install IV_Robot
rename lnrobot_stock Robot_stock
rename lniv_stock IV_stock

gen fedu_s=0 
replace fedu_s=1 if edu_f>3 & edu_f<=8  //1表示父亲受高中及以上教育，0表示其他

gen medu_s=0
replace medu_s=1 if edu_m>3  & edu_m<=8  //1表示母亲受高中及以上教育，0表示其他

gen edu_s=0 
replace edu_s=1 if wf301>2 & wf301<=7  //1表示儿童上小学及以上，

gen EduExpectation=0
replace EduExpectation=1 if wd2>6 & wd2<10   //1表示父母期待孩子获得大专及以上的教育水平

gen FamilyCare=0
replace FamilyCare=1 if wz301>3 & wz301<6  //1表示父母同意和十分同意关心孩子教育

sum fu201,d
sum fu201 if year==2010,d
sum fu201 if year==2012,d
sum fu201 if year==2014,d
sum fu201 if year==2016,d
sum fu201 if year==2018,d
sum fu201 if year==2020,d
sum fu201 if year==2022,d
gen fu201_s=0
replace fu201_s=1 if fu201>1000 & year==2010  //礼金超出当年中位数为1
replace fu201_s=1 if fu201>0 & year==2012
replace fu201_s=1 if fu201>1841.62 & year==2014
replace fu201_s=1 if fu201>1776.2 & year==2016
replace fu201_s=1 if fu201>1716.74 & year==2018
replace fu201_s=1 if fu201>1640.69 & year==2020
replace fu201_s=1 if fu201>1517.45 & year==2022
rename fu201_s SocCapital

sum total_asset if year==2010,d
sum total_asset if year==2012,d
sum total_asset if year==2014,d
sum total_asset if year==2016,d
sum total_asset if year==2018,d
sum total_asset if year==2020,d
sum total_asset if year==2022,d

gen total_asset_s=0
replace total_asset_s=1 if total_asset>94375 & year==2010  //家庭净资产超出当年中位数为1
replace total_asset_s=1 if total_asset>138799.8  & year==2012
replace total_asset_s=1 if total_asset>173287.9 & year==2014
replace total_asset_s=1 if total_asset>190941.4  & year==2016
replace total_asset_s=1 if total_asset>232081.5 & year==2018
replace total_asset_s=1 if total_asset>217186.2  & year==2020
replace total_asset_s=1 if total_asset>253864.8 & year==2022

rename total_asset_s PhyCapital  //家庭净资产中位数及以上为1 

gen HumCapital=0 
replace HumCapital=1 if edu_m>3  & edu_m<=8 |edu_f>3 & edu_f<=8  //家庭人力资本

winsor2 edutotal wd503r, cuts(1 99) by(year)
gen EduExpenditure_w=ln(edutotal_w+1)
gen TutorCost_w=ln(wd503r_w+1)


drop if age_f<18 | age_f>100
drop if age_m<18 | age_m>100
sum age_f age_m if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & gender!=. & edu_s!=. & familysize!=. & fedu_s!=. & medu_s!=. & FamilyAsset!=. & EduExpectation !=.
tab age_m if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & gender!=. & edu_s!=. & familysize!=. & fedu_s!=. & medu_s!=. & FamilyAsset!=. & EduExpectation !=.
tab age_f if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & gender!=. & edu_s!=. & familysize!=. & fedu_s!=. & medu_s!=. & FamilyAsset!=. & EduExpectation !=.

***描述性统计
estpost summarize EduExpenditure TutorCost Robot gender age  edu_s familysize fedu_s medu_s  FamilyAsset province_num year IV_Robot EduExpectation if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & gender!=. & edu_s!=. & familysize!=. & fedu_s!=. & medu_s!=. & FamilyAsset!=. & EduExpectation !=.
esttab using "统计结果.rtf", ///
    cells("count mean sd min max ") ///
	 replace  
	
	
***基准回归	
reg EduExpenditure Robot i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & gender!=. & edu_s!=. & familysize!=. & fedu_s!=. & medu_s!=. & FamilyAsset!=. & EduExpectation !=., r
est store m1
reg TutorCost Robot i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & gender!=. & edu_s!=. & familysize!=. & fedu_s!=. & medu_s!=. & FamilyAsset!=. & EduExpectation !=. , r
est store m2
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r
est store m3
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r
est store m4
reg Robot IV_Robot gender i.age i.edu_s familysize  fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r
est store m5
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , first r
est store m6
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. ,first r
est store m7
estadd scalar Fstat = e(widstat)
estadd scalar Fpval = e(widpval)
estadd scalar LMstat = e(idstat)
estadd scalar LMpval = e(idp)
reg2docx m1 m2 m3 m4 m5 m6 m7 using "D:\manpower\基准回归.docx",    /// 
         replace  b(%9.3f) se(%7.3f)                            ///
		  scalars(r2 N )   ///
		  title("基准回归") 
  
***稳健性分析
gen is_muni = 0  // 初始全部设为非直辖市
replace is_muni = 1 if cityname == "北京" | cityname == "上海" | cityname == "天津" | cityname == "重庆市"

reg EduExpenditure Robot_stock gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r  //更换被解释变量，使用机器人存量估计机器人渗透度，可用作稳健性分析
est store m1
reg EduExpenditure_w Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r //正向显著
est store m2
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset ITworker i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r //以信息技术从业人数表示各城市信息技术发展水平
est store m3
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & is_muni==0  , r
est store m4
reg TutorCost Robot_stock gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=., r   //更换被解释变量，使用机器人存量估计机器人渗透度，可用作稳健性分析
est store m5
reg TutorCost_w Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r  
est store m6
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset ITworker i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r //以信息技术从业人数表示各城市信息技术发展水平   
est store m7
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & is_muni==0, r
est store m8

reg2docx m1 m2 m3 m4 m5 m6 m7 m8 using "D:\manpower\稳健性检验（ols）.docx",    /// 
         replace  b(%9.3f) se(%7.3f)                            ///
		 scalars(r2 N )   ///
		 title("稳健性检验（ols）") 

***内生性检验
reg Robot_stock IV_stock gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r		//一阶段 
est store first_stage
estadd scalar Fstat = e(F)
estadd scalar Fpval = Ftail(e(df_m), e(df_r), e(F))
***二阶段		 
ivreg2 FamilyCare (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r  //更换解释变量，父母对孩子学习的关心(1表示同意和非常同意)
est store m1
ivreg2 EduExpenditure (Robot_stock=IV_stock) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r  //更换被解释变量，使用机器人存量估计机器人渗透度，可用作稳健性分析
est store m2
ivreg2 EduExpenditure_w (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r //正向显著
est store m3
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset ITworker i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r //以信息技术从业人数表示各城市信息技术发展水平
est store m4
ivreg2 TutorCost (Robot_stock=IV_stock) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r   //更换被解释变量，使用机器人存量估计机器人渗透度，可用作稳健性分析
est store m5
ivreg2 TutorCost_w (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r  
est store m6
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset ITworker i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r //以信息技术从业人数表示各城市信息技术发展水平   
est store m7
estadd scalar Fstat = e(widstat)
estadd scalar Fpval = e(widpval)
estadd scalar LMstat = e(idstat)
estadd scalar LMpval = e(idp)

esttab m1 m2 m3 m4 m5 m6 m7 using "D:\manpower\稳健性分析（2sls）.rtf", ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    stats(Fstat Fpval LMstat LMpval N r2, ///
    fmt(2 4 2 4 0 3) ///
    labels("F-stat" "F p-value" "LM-stat" "LM p-value" "N" "R-squared")) ///
    mtitle("m1" "m2" "m3" "m4" "m5" "m6" "m7") replace		
	
***异质性分析
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==1,r  
est store m1
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==0,r  
est store m2
reg EduExpenditure Robot gender i.age i.edu_s familysize  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==1,r
est store m3
reg EduExpenditure Robot gender i.age i.edu_s familysize  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==0,r
est store m4
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==1,r
est store m5
reg EduExpenditure Robot gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==0,r
est store m6
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==1,r  
est store m7
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==0,r  
est store m8
reg TutorCost Robot gender i.age i.edu_s familysize  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==1,r
est store m9
reg TutorCost Robot gender i.age i.edu_s familysize  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==0,r
est store m10
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.   & PhyCapital==1,r
est store m11
reg TutorCost Robot gender i.age i.edu_s familysize fedu_s medu_s  i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==0,r
est store m12
reg2docx m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 using "D:\manpower\家庭层面异质性分析（ols）.docx",    ///
         replace  b(%9.3f) se(%7.3f)                            ///
		 scalars(r2 N )   ///
		 title("家庭层面异质性分析（ols）")  

***异质性分析（2sls）		 
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==1,r  
est store m1
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==0,r  
est store m2
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==1,r
est store m3
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==0,r
est store m4
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==1,r
est store m5
ivreg2 EduExpenditure (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==0,r
est store m6
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==1,r  
est store m7
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & SocCapital==0,r  
est store m8
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==1,r
est store m9
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=.  & HumCapital==0,r
est store m10
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==1,r
est store m11
ivreg2 TutorCost (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. & FamilyAsset!=.  & PhyCapital==0,r
est store m12		 
estadd scalar Fstat = e(widstat)
estadd scalar Fpval = e(widpval)
estadd scalar LMstat = e(idstat)
estadd scalar LMpval = e(idp)
esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 using "D:\manpower\家庭层面异质性分析（2sls）.rtf", ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    stats(Fstat Fpval LMstat LMpval N r2, ///
    fmt(3 4 3 4 0 3) ///
    labels("F-stat" "F p-value" "LM-stat" "LM p-value" "N" "R-squared")) ///
    mtitle( "m1" "m2" "m3" "m4" "m5" "m6" "m7" "m8" "m9" "m10" "m11" "m12") replace


***教育期望机制分析		 
reg EduExpectation Robot gender i.age i.edu_s familysize fedu_s medu_s  FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r
est store m1
ivreg2 EduExpectation (Robot=IV_Robot) gender i.age i.edu_s familysize fedu_s medu_s FamilyAsset i.province_num i.year if age>=4 & age<16 & EduExpenditure!=. & TutorCost!=. , r
est store m2
reg2docx m1 m2 using "D:\manpower\机制分析教育期望.docx",    /// 
         replace  b(%9.3f) se(%7.3f)                            ///
		 scalars(r2 N )   ///
		 title("机制分析教育期望") 

use "D:\tongyi data\hebingar.dta", clear  //成人数据看成人是否受到工业机器人就业冲击
***成人数据再处理
encode province, generate(province_num)
gen lnrobot_install=ln(robot_installation+1)
gen lniv_install=ln(iv_installation+1)
rename lnrobot_install Robot
rename lniv_install IV_Robot

recode edu_last(1/2=0)(3=6)(4=9)(5=12)(6=15)(7=16)(8=19),gen(edu_year)  //受教育年数
winsor2 income, cuts(5 95) by(year)
gen lnincome=ln(income_w+1)
winsor2 total_asset ,cuts(1 99) by(year)
gen FamilyAsset=ln(total_asset_w+1)

rename ft200  RiskPreference
***成人数据描述性统计
sum lnincome if age<=64 & lnincome!=. & FamilyAsset!=. & gender!=. & age!=. & minzu!=. & edu_year!=. & familysize!=. 
sum lnincome Robot gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=.

***技能溢价机制分析
reg lnincome Robot gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=. & FamilyAsset!=.,r
est store m1
reg lnincome Robot gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=. & FamilyAsset!=. & edu_year>=12 ,r  //大专及以上教育水平
est store m2
reg lnincome Robot gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=. & FamilyAsset!=. & edu_year<12 ,r
est store m3
ivreg2 lnincome (Robot=IV_Robot) gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=. & FamilyAsset!=. & lnincome!=.  ,r
est store m4
ivreg2 lnincome (Robot=IV_Robot) gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=. & FamilyAsset!=. & edu_year>=12 ,r
est store m5
ivreg2 lnincome (Robot=IV_Robot) gender age minzu edu_year familysize FamilyAsset i.province_num i.year if age<=64 & lnincome!=. & FamilyAsset!=. & edu_year<12 ,r
est store m6
estadd scalar Fstat = e(widstat)
estadd scalar Fpval = e(widpval)
estadd scalar LMstat = e(idstat)
estadd scalar LMpval = e(idp)
reg2docx m1 m2 m3 m4 m5 m6 using "D:\manpower\机制分析技能溢价.docx",    /// 
         replace  b(%9.3f) se(%7.3f)                            ///
		 scalars(r2 N )   ///
		 title("机制分析技能溢价")  


