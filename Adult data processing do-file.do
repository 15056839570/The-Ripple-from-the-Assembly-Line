***2010
***大五人格
qz210 qm704 qm702 //尽责性
qm403 qm503 qm505 qz208  //外向性，qm403与qm503问题重复，这里仅考虑qm503
qm502 qz206  //宜人性
qz209 qm404 qm509 //开放性
qq601 qq602 qq603 qq605 qq604//情绪稳定性
use "G:\2010-2022数据汇总\cfps2010adult_202008.dta",clear
sum qz210 qm704 qm702 qm403 qm503 qm505 qz208 qm502 qz206 qz209 qm404 qm509 qq601 qq602 qq603 qq605 qq604
des  qz210 qm704 qm702 qm403 qm503 qm505 qz208 qm502 qz206 qz209 qm404 qm509  //1-5/7从不重要到非常重要
des qq601 qq602 qq603 qq605 qq604  //1-5从几乎每天到从不
replace qz210=. if qz210<0
replace qm704=. if qm704<0
replace qm702=. if qm702<0
replace qm403=. if qm403<0
replace qm503=. if qm503<0
replace qm505=. if qm505<0
replace qz208=. if qz208<0
replace qm502=. if qm502<0
replace qz206=. if qz206<0
replace qz209=. if qz209<0
replace qm404=. if qm404<0
replace qm509=. if qm509<0
recode qm509(5=1)(4=2)(2=4)(1=5),gen(qm509_new)  //修改后传宗接代1表示非常重要，也说明越保守；5表示越不重要，说明越开放
replace qq601=. if qq601<0
replace qq602 =. if qq602<0
replace qq603=. if qq603<0
replace qq605=. if qq605<0
replace qq604=. if qq604<0

egen std_qz210=std(qz210)
egen std_qm704=std(qm704)
egen std_qm702=std(qm702)
egen std_qm403 = std(qm403)
egen std_qm503 = std(qm503)
egen std_qm505 = std(qm505)
egen std_qz208 = std(qz208)
egen std_qm502 = std(qm502)
egen std_qz206 = std(qz206)
egen std_qz209 = std(qz209)
egen std_qm404= std(qm404)
egen std_qm509_new = std(qm509_new)
egen std_qq601 = std(qq601)
egen std_qq602 = std(qq602)
egen std_qq603 = std(qq603)
egen std_qq604 = std(qq604)
egen std_qq605 = std(qq605)
***生成综合指标之前，要先整清楚所有变量的方向，尽可能调成正的
egen duty=rowmean(std_qz210 std_qm704 std_qm702)
list std_qz210 std_qm704 duty in 1/5
egen extraversion=rowmean(std_qm503 std_qm505 std_qz208)
egen pleasant=rowmean(std_qm502 std_qz206)
egen openness=rowmean(std_qz209 std_qm404 std_qm509_new)
egen stability=rowmean(std_qq601 std_qq602 std_qq603 std_qq604 std_qq605)
list std_qq601 std_qq602 std_qq603 std_qq604 std_qq605 stability in 1/5
sum duty extraversion pleasant openness stability
keep pid fid cid provcd countyid urban cyear gender qg3 qg408 qg501 qg502 qg503 qg504 qg505 qg506 qg6 qa1age qa5code qa2 qh405isco qh405isei qh405siops qh4 foccupisco foccupcode feduc fparty mparty moccupisco moccupcode meduc qk601 income qg4 qh4 qh411 qm404 duty extraversion pleasant openness stability
rename income income
rename qh4 nonfarmwork
rename qg4 farmwork_m
rename qh411 nonfarmincome  //月收入
rename feduc edu_f
rename meduc edu_m
rename foccupisco qv103code_isco
rename moccupisco qv203code_isco
rename fparty qv104
rename mparty qv204
gen qg11=.
replace qg11=qk601/12
merge m:1 fid using "G:\2010-2022数据汇总\cfps2010famecon_202008.dta",keepusing(fh404 familysize ff2 ff302_a_1 ff302_a_2 total_asset faminc_net_old indinc_net faminc_net)
keep if _merge==3
drop _merge
gen ft201=ff302_a_1+ff302_a_2
drop ff302_a_1 ff302_a_2
rename faminc_net_old fincome1
rename faminc_net fincome1_adj
rename indinc_net fincome1_per_adj
***个人问卷qg3 qg408 qg501 qg502 qg503 qg504 qg505 qg506 qg6 qm404
***按家庭资产分类 qk601 ff2 fh404 fincome1_adj fincome1_per_adj fincome1 total_asset ft201 qg11
sum qk601 ff2 fh404 fincome1_adj fincome1_per_adj fincome1 total_asset ft201 qg11
gen fp5101=.
replace fp510=. if fh404<0
replace fp5101=fh404/1.02 if cyear==2011
replace fp5101=fh404 if cyear==2010
replace qk601=. if qk601<0
replace ff2=. if ff2<0
replace fh404=. if fh404<0
replace fincome1_adj=. if fincome1_adj<0
replace fincome1_per_adj=. if fincome1_per_adj<0
replace ft201=. if ft201==-8
replace income=. if income<0
replace nonfarmwork=. if nonfarmwork<0
replace nonfarmincome=. if nonfarmincome<0
replace farmwork=. if farmwork<0
sum total_asset fincome1 qg11 income,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<118635  
replace totalasset_stage=3 if total_asset>=118635 & total_asset<=3.00e+07
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1>=0 & fincome1<22000     
replace fincome1_stage=2 if fincome1>= 22000 & fincome1<=2040830
gen qg11_stage=.
replace qg11_stage=1 if qg11>=0 & qg11<250
replace qg11_stage=2 if qg11>= 250 & qg11<=66666.66
gen income_stage=.
replace income_stage=1 if income<300
replace income_stage=2 if income>= 300 & income<13000 
replace income_stage=3 if income>=13000 & income<=800000
drop cyear
gen year=2010
save "D:\tongyi data\2010a.dta",replace
***2012
qz210 qz5  //尽责性
qq60116 qq60114 qz208 qq60113 //外向性
qn10024 qn1001 qz206  //宜人性
qz209 qn12014   //开放性
qq6016 qq6017 qq6013 qq60120 //情绪稳定性
use "G:\2010-2022数据汇总\cfps2012adult_201906.dta",clear
sum qz210 qz5 qq60116 qq60114 qz208 qq60113 qn10024 qn1001 qz206 qz209 qn12014 qq6016 qq6017 qq6013 qq60120
des qz210 qz5 qq60116 qq60114 qz208 qq60113 qn10024 qn1001 qz206 qz209 qn12014 qq6016 qq6017 qq6013 qq60120
replace qz210=. if qz210<0
replace qz5=. if qz5<0
recode qz5(7=1)(6=2)(5=3)(3=5)(2=6)(1=7),gen(qz5_new)
replace qq60116=. if qq60116<0
replace qq60114=. if qq60114<0
recode qq60114(4=1)(3=2)(2=3)(1=4),gen(qq60114_new)
replace qz208=. if qz208<0
replace qq60113=. if qq60113<0
recode qq60113(4=1)(3=2)(2=3)(1=4) ,gen(qq60113_new)
replace qn10024=. if qn10024<0
replace qn1001=. if qn1001<0
recode qn1001(1=5)(5=1),gen(qn1001_new)
replace qz206=. if qz206<0
replace qz209=. if qz209<0
replace qn12014=. if qn12014<0
replace qq6016=. if qq6016<0
recode qq6016(4=1)(3=2)(2=3)(1=4) ,gen(qq6016_new)
replace qq6017=. if qq6017<0
recode qq6017(4=1)(3=2)(2=3)(1=4) ,gen(qq6017_new)
replace qq6013=. if qq6013<0
recode qq6013(4=1)(3=2)(2=3)(1=4) ,gen(qq6013_new)
replace qq60120=. if qq60120<0
recode qq60120(4=1)(3=2)(2=3)(1=4) ,gen(qq60120_new)

egen std_qz210=std(qz210)
egen std_qz5_new=std(qz5_new)
egen std_qq60116=std(qq60116)
egen std_qq60114_new=std(qq60114_new)
egen std_qz208=std(qz208)
egen std_qq60113_new=std(qq60113_new)
egen std_qn10024=std(qn10024)
egen std_qn1001_new=std(qn1001_new)
egen std_qz206=std(qz206)
egen std_qz209=std(qz209)
egen std_qn12014=std(qn12014)
egen std_qq6016_new=std(qq6016_new)
egen std_qq6017_new=std(qq6017_new)
egen std_qq6013_new=std(qq6013_new)
egen std_qq60120_new=std(qq60120_new)

egen duty=rowmean(std_qz210 std_qz5_new)
list std_qz210 std_qz5_new duty in 1/5
egen extraversion=rowmean(std_qq60116 std_qq60114_new std_qz208 std_qq60113_new)
egen pleasant=rowmean(std_qn10024 std_qn1001_new std_qz206 )
egen openness=rowmean(std_qz209 std_qn12014)
egen stability=rowmean(std_qq6016_new std_qq6017_new std_qq6013_new std_qq60120_new)
list std_qq6016_new std_qq6017_new std_qq6013_new std_qq60120_new stability in 1/5
sum duty extraversion pleasant openness stability
keep pid fid12 provcd countyid cid urban12 cyear qa301 qg101 qg305 qg304 edu2012 qc301 qn12014 cfps2012_age cfps2012_gender cfps_minzu nchd3 qv102 qv104 qv202 qv204 qv203code_best qv203_isco qv103code_best qv103_isco qg402 sg417 qg401 duty extraversion pleasant openness stability
rename sg417 income
rename qg401 nonfarmwork
rename qv203_isco qv203code_isco
rename qv103_isco qv103code_isco
rename edu2012 edu_last
rename nchd3 child16n
rename qv102 edu_f
rename qv202 edu_m
gen qgb4=.
replace qgb4=1 if qg402>0
replace qgb4=0 if qg402<0
gen qg11=.
replace qg11=income/12
merge m:1 fid using "G:\2010-2022数据汇总\cfps2012famecon_201906.dta",keepusing(stock funds derivative otherfinance savings ft1 familysize fp508 ft301 ft401 ft501 ft601 ft701 fincome1 fincome1_adj fincome1_per fincome1_per_adj total_asset)
gen ft201=ft301+ft401+ft501+ft601+ft701
drop ft301 ft401 ft501 ft601 ft701
keep if _merge==3
drop _merge
***以2010年为基期进行折算 qg305 qg416_a_1 ft1 fp508 savings stock funds derivative otherfinance total_asset fincome1 fincome1_adj fincome1_per fincome1_per_adj ft201
gen fp5101=.
replace fp510=. if fp508<0
replace fp5101=fp508/1.029
replace qg305=. if qg305<0
replace qg305=qg305/1.029
replace ft1=. if ft1<0
replace ft1=ft1/1.029
replace savings=. if savings<0
replace savings=savings/1.029
replace stock=. if stock<0
replace stock=stock/1.029
replace funds=. if funds<0
replace funds=funds/1.029
replace derivative=. if derivative<0
replace derivative=derivative/1.029
replace otherfinance=. if otherfinance<0
replace otherfinance=otherfinance/1.029
replace total_asset=total_asset/1.029
replace fincome1=. if fincome1<0
replace fincome1=fincome1/1.029
replace fincome1_adj=. if fincome1_adj<0
replace fincome1_adj=fincome1_adj/1.029
replace fincome1_per=. if fincome1_per<0
replace fincome1_per=fincome1_per/1.029
replace fincome1_per_adj=. if fincome1_per_adj<0
replace fincome1_per_adj=fincome1_per_adj/1.029
replace ft201=. if ft201==-8
replace ft201=ft201/1.029
replace qg11=. if qg11<0
replace qg11=qg11/1.029
replace income=. if income<0
replace income=income/1.029
replace nonfarmwork=. if nonfarmwork<0
***将家庭资产进行分类
sum total_asset fincome1  fincome1_per qg11 income ,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<161139.5
replace totalasset_stage=3 if total_asset>=161139.5 & total_asset<=3.31e+07  
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1< 33562.68      
replace fincome1_stage=2 if fincome1>= 33562.68 & fincome1<=2950482    
gen fincome1per_stage=.
replace fincome1per_stage=1 if fincome1_per<7993.197  
replace fincome1per_stage=2 if fincome1_per>=7993.197 & fincome1_per<=1475241
gen qg11_stage=.
replace qg11_stage=1 if qg11<1619.696
replace qg11_stage=2 if qg11>=1619.696 & qg11<=23323.62
gen income_stage=.
replace income_stage=1 if income< 9718.173
replace income_stage=2 if income>=9718.173 & income<29154.52
replace income_stage=3 if income>=29154.52 & income<=279883.4
drop cyear
gen year=2012
save "D:\tongyi data\2012a.dta",replace
***2014
qz5 qz210  //尽责性
qn12012 qz208  //外向性
qn1001 qn10024 qz206  //宜人性
qz209 qn12014 qm1004   //开放性
qq601 qq602 qq603 qq605 qq604 //情绪稳定性
use "G:\2010-2022数据汇总\cfps2014adult_201906.dta",clear
sum qz5 qz210 qn12012 qz208 qn1001 qn10024 qz206 qz209 qn12014 qm1004 qq601 qq602 qq603 qq605 qq604
des qz5 qz210 qn12012 qz208 qn1001 qn10024 qz206 qz209 qn12014 qm1004 qq601 qq602 qq603 qq605 qq604
replace qz5=. if qz5<0
recode qz5(7=1)(6=2)(5=3)(3=5)(2=6)(1=7),gen(qz5_new)
replace qz210=. if qz210<0
replace qn12012=. if qn12012<0
replace qz208=. if qz208<0
replace qn1001=. if qn1001<0
recode qn1001(1=5)(5=1),gen(qn1001_new)
replace qn10024=. if qn10024<0
replace qz206=. if qz206<0
replace qz209=. if qz209<0
replace qn12014=. if qn12014<0
replace qm1004=. if qm1004<0
recode qm1004(5=1)(4=2)(2=4)(1=5),gen(qm1004_new)
replace qq601=. if qq601<0
replace qq602=. if qq602<0
replace qq603=. if qq603<0
replace qq605=. if qq605<0
replace qq604=. if qq604<0
egen std_qz5_new=std(qz5_new)
egen std_qz210=std(qz210)
egen std_qn12012=std(qn12012)
egen std_qz208=std(qz208)
egen std_qn1001_new=std(qn1001_new)
egen std_qn10024=std(qn10024)
egen std_qz206=std(qz206)
egen std_qz209=std(qz209)
egen std_qn12014=std(qn12014)
egen std_qm1004_new=std(qm1004_new)
egen std_qq601=std(qq601)
egen std_qq602=std(qq602)
egen std_qq603=std(qq603)
egen std_qq605=std(qq605)
egen std_qq604=std(qq604)

egen duty=rowmean(std_qz5_new std_qz210)
list std_qz5_new std_qz210 duty in 1/5
egen extraversion=rowmean(std_qn12012 std_qz208)
egen pleasant=rowmean(std_qn1001_new std_qn10024 std_qz206)
egen openness=rowmean(std_qz209 std_qn12014 std_qm1004_new)
egen stability=rowmean(std_qq601 std_qq602 std_qq603 std_qq605 std_qq604)
list std_qq601 std_qq602 std_qq603 std_qq605 std_qq604 stability in 1/5
sum duty extraversion pleasant openness stability

keep pid fid14 provcd14 countyid14 cid14 urban14 cfps_gender te4 cyear qc201 qc301 cfps2012_latest_edu employ2014 qn12014 qg101 qg4 qg5 qg6 qg9_s_1 qg9_s_2 qg9_s_3 qg9_s_4 qg9_s_5 qg11 cfps2014_age qa301 qa701code  cfps2012_latest_edu qga401code qga4code qgb4 incomeb egc2021_b_1 duty extraversion pleasant openness stability
rename incomeb income
tab qg101
recode qg101(1=0)(5=1),gen(nonfarmwork)
rename cfps2012_latest_edu edu_last
merge m:1 fid14 using "G:\2010-2022数据汇总\cfps2014famecon_201906.dta",keepusing(fincome1_per fincome1 fincome1_per_p fw7 fw241 fw8 fw23 fz202 total_asset fp510 familysize ft1 ft101 ft201)
keep if _merge==3
drop _merge
merge 1:m pid using "G:\2010-2022数据汇总\cfps2014famconf_170630.dta",keepusing(tb4_a14_f tb4_a14_m)
keep if _merge==3
drop _merge
rename tb4_a14_f edu_f
rename tb4_a14_m edu_m
***以2010年为基期进行折算qg11 fp510 ft1 ft101 ft201 total_asset fincome1 fincome1_per
sum qg11 fp510 ft1 ft101 ft201 total_asset fincome1 fincome1_per
gen fp5101=.
replace fp510=. if fp510<0
replace fp5101=fp510/1.086
replace qg11=. if qg11<0
replace qg11=qg11/1.086
replace ft1=. if ft1<0
replace ft1=ft1/1.086
replace ft101=. if ft101<0
replace ft101=ft101/1.086
replace ft201=. if ft201<0
replace ft201=ft201/1.086
replace total_asset=total_asset/1.086
replace fincome1=fincome1/1.086
replace fincome1_per=fincome1_per/1.086
replace income=. if income<0
replace income=income/1.086
replace nonfarmwork=. if nonfarmwork<0

***按家庭资产分类
sum total_asset fincome1 fincome1_per qg11 income ,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset< 185727.4  
replace totalasset_stage=3 if total_asset>=185727.4 & total_asset<=1.71e+07 
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1<38674.03    
replace fincome1_stage=2 if fincome1>=38674.03 & fincome1<=5780847
gen fincome1per_stage=.
replace fincome1per_stage=1 if fincome1_per<9590.239
replace fincome1per_stage=2 if fincome1_per>=9590.239 & fincome1_per<=3333333
gen qg11_stage=.
replace qg11_stage=1 if qg11<2302.026
replace qg11_stage=2 if qg11>=2302.026 & qg11<=110497.2
gen income_stage=.
replace income_stage=1 if income<11049.72
replace income_stage=2 if income<35359.12 & income>=11049.72
replace income_stage=3 if income>=35359.12 & income<=736648.3
drop cyear
gen year=2014
save "D:\tongyi data\2014a.dta",replace
***2016
qz5 qz210  //尽责性
pn416 pn414 qz208  //外向性
qn10024 pn1001 qz206  //宜人性
qz209 qn12014  //开放性
pn406 pn407 pn418 pn420 //情绪稳定性
use "G:\2010-2022数据汇总\cfps2016adult_201906.dta",clear
sum qz5 qz210 pn416 pn414 qz208 qn10024 pn1001 qz206 qz209 qn12014 pn406 pn407 pn418 pn420 
des qz5 qz210 pn416 pn414 qz208 qn10024 pn1001 qz206 qz209 qn12014 pn406 pn407 pn418 pn420   
replace qz5=. if qz5<0
recode qz5(7=1)(6=2)(5=3)(3=5)(2=6)(1=7),gen(qz5_new)
replace qz210=. if qz210<0
replace pn416=. if pn416<0
replace pn414=. if pn414<0
recode pn414(4=1)(3=2)(2=3)(1=4),gen(pn414_new)
replace qz208=. if qz208<0
replace qn10024=. if qn10024<0
replace pn1001=. if pn1001<0
recode pn1001(1=5)(5=1),gen(pn1001_new)
replace qz206=. if qz206<0
replace qz209=. if qz209<0
replace qn12014=. if qn12014<0
replace pn406=. if pn406<0
recode pn406(4=1)(3=2)(2=3)(1=4),gen(pn406_new)
replace pn407=. if pn407<0
recode pn407(4=1)(3=2)(2=3)(1=4),gen(pn407_new)
replace pn418=. if pn418<0
recode pn418(4=1)(3=2)(2=3)(1=4),gen(pn418_new)
replace pn420=. if pn420<0
recode pn420(4=1)(3=2)(2=3)(1=4),gen(pn420_new)

egen std_qz5_new=std(qz5_new)
egen std_qz210=std(qz210)
egen std_pn416=std(pn416)
egen std_pn414_new=std(pn414_new)
egen std_qz208=std(qz208)
egen std_qn10024=std(qn10024)
egen std_pn1001_new=std(pn1001_new)
egen std_qz206=std(qz206)
egen std_qz209=std(qz209)
egen std_qn12014=std(qn12014)
egen std_pn406_new=std(pn406_new)
egen std_pn407_new=std(pn407_new)
egen std_pn418_new=std(pn418_new)
egen std_pn420_new=std(pn420_new)

egen duty=rowmean(std_qz5_new std_qz210)
list std_qz5_new std_qz210 duty in 1/5
egen extraversion=rowmean(std_pn416 std_pn414_new std_qz208)
egen pleasant=rowmean(std_qn10024 std_pn1001_new std_qz206)
egen openness=rowmean(std_qz209 std_qn12014)
egen stability=rowmean(std_pn406_new std_pn407_new std_pn418_new std_pn420_new)
list std_pn406_new std_pn407_new std_pn418_new std_pn420_new stability in 1/5
sum duty extraversion pleasant openness stability

keep pid fid16 provcd16 countyid16 cid16 urban16 cfps_birthy cfps_age cfps_gender cyear cfps_latest_edu employ jobclass_base jobclass qg101 qg401 qg402 qg403 qg404 qg405 qg406 qg5 qg501 qg6 qg11 qn12014 qc301 pa301 pa701code qgb4 qga4code qga401code_isco qga401code_isei qga401code_siops incomeb egc2021_b_1 duty extraversion pleasant openness stability
rename incomeb income
tab qg101
recode qg101(1=0)(5=1),gen(nonfarmwork)
rename cfps_latest_edu edu_last
merge m:1 fid16 using "G:\2010-2022数据汇总\cfps2016famecon_201807.dta",keepusing(total_asset fincome1 fincome1_per fincome1_per_p finance_asset ft101 ft200 ft201 fp510 familysize16 ft1)
keep if _merge==3
drop _merge
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2016famconf_201804.dta",keepusing(tb4_a16_f tb4_a16_m)
keep if _merge==3
drop _merge
rename tb4_a16_f edu_f
rename tb4_a16_m edu_m
***以2010年为基期进行折算qg11 fp510 ft1 ft101 ft201 finance_asset total_asset fincome1 fincome1_per
sum qg11 fp510 ft1 ft101 ft201 finance_asset total_asset fincome1 fincome1_per
gen fp5101=.
replace fp510=. if fp510<0
replace fp5101=fp510/1.126
replace qg11=. if qg11<0
replace qg11=qg11/1.126
replace ft1=. if ft1<0
replace ft1=ft1/1.126
replace ft101=. if ft101<0
replace ft101=ft101/1.126
replace ft201=ft201/1.126
replace ft201=. if ft201<0
replace finance_asset=finance_asset/1.126
replace total_asset=total_asset/1.126
replace fincome1=. if fincome1<0
replace fincome1=fincome1/1.126
replace fincome1_per=. if fincome1_per<0
replace fincome1_per=fincome1_per/1.126
replace income=. if income<0
replace income=income/1.126
replace nonfarmwork=. if nonfarmwork<0

***按家庭资产分类
sum total_asset fincome1  fincome1_per qg11 income,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<201709.6   
replace totalasset_stage=3 if total_asset>=201709.6 & total_asset<=7.12e+07
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1<46133.21   
replace fincome1_stage=2 if fincome1>=46133.21 & fincome1<=1.01e+07   
gen fincome1per_stage=.
replace fincome1per_stage=1 if fincome1_per<11523.09
replace fincome1per_stage=2 if fincome1_per>=11523.09 & fincome1_per<=3701599
gen qg11_stage=.
replace qg11_stage=1 if qg11<2664.298
replace qg11_stage=2 if qg11>=2664.298 & qg11<=133214.9
gen income_stage=.
replace income_stage=1 if income<8880.995
replace income_stage=2 if income<35523.98 & income>=8880.995
replace income_stage=3 if income>=35523.98 & income<=1603908
drop cyear
gen year=2016
save "D:\tongyi data\2016a.dta",replace
***2018
qm211 qm201 qm207  //尽责性
qm202 qm208 qm212  //外向性
qm213 qm206 qm203  //宜人性
qm204 qm209 qm214  //开放性
qm205 qm210 qm215  //情绪稳定性
use "G:\2010-2022数据汇总\cfps2018person_202012.dta",clear
sum qm211 qm201 qm207 qm202 qm208 qm212 qm213 qm206 qm203 qm204 qm209 qm214 qm205 qm210 qm215
des qm211 qm201 qm207 qm202 qm208 qm212 qm213 qm206 qm203 qm204 qm209 qm214 qm205 qm210 qm215
replace qm211=. if qm211<0
replace qm201=. if qm201<0
replace qm207=. if qm207<0
recode qm207(5=1)(4=2)(2=4)(1=5),gen(qm207_new)
replace qm202=. if qm202<0
replace qm208=. if qm208<0
replace qm212=. if qm212<0
recode qm212(5=1)(4=2)(2=4)(1=5),gen(qm212_new)
replace qm213=. if qm213<0
replace qm206=. if qm206<0
replace qm203=. if qm203<0
recode qm203(5=1)(4=2)(2=4)(1=5),gen(qm203_new)
replace qm204=. if qm204<0
replace qm209=. if qm209<0
replace qm214=. if qm214<0
replace qm205=. if qm205<0
recode qm205(5=1)(4=2)(2=4)(1=5),gen(qm205_new)
replace qm210=. if qm210<0
recode qm210(5=1)(4=2)(2=4)(1=5),gen(qm210_new)
replace qm215=. if qm215<0
recode qm215(5=1)(4=2)(2=4)(1=5),gen(qm215_new)

egen std_qm211=std(qm211)
egen std_qm201=std(qm201)
egen std_qm207_new=std(qm207_new)
egen std_qm202=std(qm202)
egen std_qm208=std(qm208)
egen std_qm212_new=std(qm212_new)
egen std_qm213=std(qm213)
egen std_qm206=std(qm206)
egen std_qm203_new=std(qm203_new)
egen std_qm204=std(qm204)
egen std_qm209=std(qm209)
egen std_qm214=std(qm214)
egen std_qm205_new=std(qm205_new)
egen std_qm210_new=std(qm210_new)
egen std_qm215_new=std(qm215_new)

egen duty=rowmean(std_qm211 std_qm201 std_qm207_new)
list std_qm211 std_qm201 std_qm207_new duty in 1/5
egen extraversion=rowmean(std_qm202 std_qm208 std_qm212_new)
egen pleasant=rowmean(std_qm213 std_qm206 std_qm203_new)
egen openness=rowmean(std_qm204 std_qm209 std_qm214)
egen stability=rowmean(std_qm205_new std_qm210_new std_qm215_new)
list std_qm205_new std_qm210_new std_qm215_new stability in 1/5
sum duty extraversion pleasant openness stability

keep pid fid18 provcd18 countyid18 cid18 urban18 cyear age gender edu_last employ qg401 qg402 qg403 qg404 qg405 qg406 qg5 qg6 qg9_a_1 qg9_a_2 qg9_a_3 qg9_a_4 qg9_a_5 qg9_a_78 qn12016 qa301 qa701code pd503r pd503a qgb4 qga4code qga401code_isco qga401code_isei qga401code_siops qg11 incomeb qg101 duty extraversion pleasant openness stability 
rename incomeb income
tab qg101
recode qg101(1=0)(5=1),gen(nonfarmwork)
***child16n
merge m:1 fid18 using "G:\2010-2022数据汇总\cfps2018famecon_202101.dta",keepusing(finance_asset total_asset fincome1 fincome1_per fincome1_per_p ft200 ft101 ft201 fp510 familysize18 ft1 )
keep if _merge==3
drop _merge
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2018famconf_202008.dta",keepusing(tb4_a18_f tb4_a18_m)
keep if _merge==3
drop _merge
rename tb4_a18_f edu_f
rename tb4_a18_m edu_m
***以2010年为基期进行折算pd503r fp510 ft1 ft101 ft201 fincome1 fincome1_per finance_asset total_asset qg12 qg11
sum pd503r fp510 ft1 ft101 ft201 fincome1 fincome1_per finance_asset total_asset qg11
gen fp5101=.
replace fp510=. if fp510<0
replace fp5101=fp510/1.165
replace qg11=. if qg11<0
replace qg11=qg11/1.165
replace ft1=. if ft1<0
replace ft1=ft1/1.165
replace ft101=. if ft101<0
replace ft101=ft101/1.165
replace ft201=. if ft201<0
replace ft201=ft201/1.165
replace finance_asset=finance_asset/1.165
replace total_asset=total_asset/1.165
replace fincome1=. if fincome1<0
replace fincome1=fincome1/1.165
replace fincome1_per=. if fincome1_per<0
replace fincome1_per=fincome1_per/1.165
replace income=. if income<0
replace income=income/1.165
replace nonfarmwork=. if nonfarmwork<0
***按家庭资产分类
sum total_asset fincome1  fincome1_per qg11 income,d
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset< 261802.6 & total_asset>=0
replace totalasset_stage=3 if total_asset>=261802.6 & total_asset<=4.33e+07
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1<53476.39    
replace fincome1_stage=2 if fincome1>=53476.39 & fincome1<=7861631   
gen fincome1per_stage=.
replace fincome1per_stage=1 if fincome1_per< 13340.77
replace fincome1per_stage=2 if fincome1_per>=13340.77 & fincome1_per<=4858369 
gen qg11_stage=.
replace qg11_stage=1 if qg11<2575.107
replace qg11_stage=2 if qg11>=2575.107 & qg11<=85836.91
gen income_stage=.
replace income_stage=1 if income<15450.64
replace income_stage=2 if income<42918.45 & income>=15450.64
replace income_stage=3 if income>=42918.45 & income<=429184.5
drop cyear 
gen year=2018
save "D:\tongyi data\2018a.dta",replace
***2020
qz5 wv104 wv102   //尽责性
qn416 qn414 qu111  //外向性
qn10024 qn1001 qm2011  //宜人性
qn12016 qm1103   //开放性,跟参考文献有出入，不采用冒险精神qv03
qn406 qn407 qn418 qn420  //情绪稳定性
use "G:\2010-2022数据汇总\cfps2020person_202112.dta",clear
sum qz5 wv104 wv102 qn416 qn414 qu111 qn10024 qn1001 qm2011 qn12016 qm1103 qn406 qn407 qn418 qn420
des qz5 wv104 wv102 qn416 qn414 qu111 qn10024 qn1001 qm2011 qn12016 qm1103 qn406 qn407 qn418 qn420 
replace qz5=. if qz5<0
recode qz5(7=1)(6=2)(5=3)(3=5)(2=6)(1=7),gen(qz5_new)
replace wv104=. if wv104<0
replace wv102=. if wv102<0
replace qn416=. if qn416<0
replace qn414=. if qn414<0
recode qn414(4=1)(3=2)(2=3)(1=4),gen(qn414_new)
replace qu111=. if qu111<0
replace qn10024=. if qn10024<0
replace qn1001=. if qn1001<0
recode qn1001(1=5)(5=1),gen(qn1001_new)
replace qm2011=. if qm2011<0
replace qn12016=. if qn12016<0
replace qm1103=. if qm1103<0
recode qm1103(5=1)(4=2)(2=4)(1=5),gen(qm1103_new)
replace qn406=. if qn406<0
recode qn406(4=1)(3=2)(2=3)(1=4),gen(qn406_new)
replace qn407=. if qn407<0
recode qn407(4=1)(3=2)(2=3)(1=4),gen(qn407_new)
replace qn418=. if qn418<0
recode qn418(4=1)(3=2)(2=3)(1=4),gen(qn418_new)
replace qn420=. if qn420<0
recode qn420(4=1)(3=2)(2=3)(1=4),gen(qn420_new)

egen std_qz5_new=std(qz5_new)
egen std_wv104=std(wv104)
egen std_wv102=std(wv102)
egen std_qn416=std(qn416)
egen std_qn414_new=std(qn414_new)
egen std_qu111=std(qu111)
egen std_qn10024=std(qn10024)
egen std_qn1001_new=std(qn1001_new)
egen std_qm2011=std(qm2011)
egen std_qn12016=std(qn12016)
egen std_qm1103_new=std(qm1103_new)
egen std_qn406_new=std(qn406_new)
egen std_qn407_new=std(qn407_new)
egen std_qn418_new=std(qn418_new)
egen std_qn420_new=std(qn420_new)

egen duty=rowmean(std_qz5_new std_wv104 std_wv102)
list std_qz5_new std_wv104 std_wv102 duty in 1/5
egen extraversion=rowmean(std_qn416 std_qn414_new std_qu111)
egen pleasant=rowmean(std_qn10024 std_qn1001_new std_qm2011)
egen openness=rowmean(std_qn12016 std_qm1103_new)
egen stability=rowmean(std_qn406_new std_qn407_new std_qn418_new std_qn420_new)
list std_qn406_new std_qn407_new std_qn418_new std_qn420_new stability in 1/5
sum duty extraversion pleasant openness stability

keep pid fid20 provcd20 countyid20 urban20 age qa701code employ mincomea_a_1 qg401 qg402 qg403 qg404 qg405 qg406 qg5 qg501 qg6 qg9_a_1 qg9_a_2 qg9_a_3 qg9_a_4 qg9_a_5 qg9_a_78 qg11 qn12016 qm3015 qa301 pd5total pd5total_mn qgb2 fml_count cyear gender child16n qv102 qv104 qv202 qv204 qg303code_g qgb4 incomeb qg101 duty extraversion pleasant openness stability
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2020famconf_202306.dta", keepusing(tb4_a20_f tb4_a20_m tb1y_a_f tb1y_a_m familysize20) //合并父母亲受教育程度
keep if _merge == 3
drop _merge 
rename tb4_a20_f edu_f
rename tb4_a20_m edu_m
gen age_f=2020-tb1y_a_f
gen age_m=2020-tb1y_a_m
merge m:1 fid20  using "G:\2010-2022数据汇总\cfps2020famecon_202306.dta", keepusing( fp510 fincome1 fincome1_per fincome1_per_p total_asset ft101 ft201 ft1 ft200)
keep if _merge == 3
drop _merge
rename incomeb income
recode qg101(1=0)(5=1),gen(nonfarmwork)
***以2010年为基期进行折算pd5total pd5total_mn mincomea_a_1 qg11
sum pd5total pd5total_mn mincomea_a_1 qg11
gen fp5101=.
replace fp510=. if fp510<0
replace fp5101=fp510/1.219
replace pd5total_mn=. if pd5total_mn<0
replace pd5total_mn=pd5total_mn/1.219
replace mincomea_a_1=. if mincomea_a_1<0
replace mincomea_a_1=mincomea_a_1/1.219
replace qg11=. if qg11<0
replace qg11=qg11/1.219
replace income=income/1.219
replace income=. if income<0
replace nonfarmwork=. if nonfarmwork<0
replace fincome1=. if fincome1<0
replace fincome1=fincome1/1.219
replace fincome1_per=. if fincome1_per<0
replace fincome1_per=fincome1_per/1.219
replace fincome1_per_p=. if fincome1_per_p<0
replace ft200=. if ft200<0
replace total_asset=total_asset/1.219
replace ft101=. if ft101<0
replace ft101=ft101/1.219
replace ft1=. if ft1<0
replace ft1=ft1/1.219
replace ft201=. if ft201<0
replace ft201=ft201/1.219
***对家庭资产进行分类
sum  total_asset fincome1 fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<249384.7
replace totalasset_stage=3 if total_asset>=226415.1 & total_asset<=5.07e+07 
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1<61230.52 
replace fincome1_stage=2 if fincome1>=61230.52 & fincome1<= 4949631 
gen fincome1per_stage=.
replace fincome1per_stage=1 if fincome1_per<14578.11
replace fincome1per_stage=2 if fincome1_per>= 14578.11 & fincome1_per<=1649877
***按家庭资产分类
sum qg11 income,detail
gen qg11_stage=.
replace qg11_stage=1 if qg11<3035.275
replace qg11_stage=2 if qg11>=3035.275 & qg11<=246103.4
gen income_stage=.
replace income_stage=1 if income<16406.89
replace income_stage=2 if income<49220.67 & income>=16406.89
replace income_stage=3 if income>=49220.67 & income<=615258.4
rename cyear year 
save "D:\tongyi data\2020a.dta",replace
***2022
qz5 wv104 wv102  //尽责性
qn416 qn414 qu111  //外向性
qn10024 qn1001 qm2011  //宜人性
qn12016 qm1004  //开放性
qn406 qn407 qn418 qn420  //情绪稳定性
use "G:\2010-2022数据汇总\cfps2022person_202410.dta",clear
sum qz5 wv104 wv102 qn416 qn414 qu111 qn10024 qn1001 qm2011 qn12016 qm1004 qn406 qn407 qn418 qn420
des qz5 wv104 wv102 qn416 qn414 qu111 qn10024 qn1001 qm2011 qn12016 qm1004 qn406 qn407 qn418 qn420
replace qz5=. if qz5<0
recode qz5(7=1)(6=2)(5=3)(3=5)(2=6)(1=7),gen(qz5_new)
replace wv104=. if wv104<0
replace wv102=. if wv102<0
replace qn416=. if qn416<0
replace qn414=. if qn414<0
recode qn414(4=1)(3=2)(2=3)(1=4),gen(qn414_new)
replace qu111=. if qu111<0
replace qn10024=. if qn10024<0
replace qn1001=. if qn1001<0
recode qn1001(1=5)(5=1),gen(qn1001_new)
replace qm2011=. if qm2011<0
replace qn12016=. if qn12016<0
replace qm1004=. if qm1004<0
recode qm1004(5=1)(4=2)(2=4)(1=5),gen(qm1004_new)
replace qn406=. if qn406<0
recode qn406(4=1)(3=2)(2=3)(1=4),gen(qn406_new)
replace qn407=. if qn407<0
recode qn407(4=1)(3=2)(2=3)(1=4),gen(qn407_new)
replace qn418=. if qn418<0
recode qn418(4=1)(3=2)(2=3)(1=4),gen(qn418_new)
replace qn420=. if qn420<0
recode qn420(4=1)(3=2)(2=3)(1=4),gen(qn420_new)

egen std_qz5_new=std(qz5_new)
egen std_wv104=std(wv104)
egen std_wv102=std(wv102)
egen std_qn416=std(qn416)
egen std_qn414_new=std(qn414_new)
egen std_qu111=std(qu111)
egen std_qn10024=std(qn10024)
egen std_qn1001_new=std(qn1001_new)
egen std_qm2011=std(qm2011)
egen std_qn12016=std(qn12016)
egen std_qm1004_new=std(qm1004_new)
egen std_qn406_new=std(qn406_new)
egen std_qn407_new=std(qn407_new)
egen std_qn418_new=std(qn418_new)
egen std_qn420_new=std(qn420_new)

egen duty=rowmean(std_qz5_new std_wv104 std_wv102)
list std_qz5_new std_wv104 std_wv102 duty in 1/5
egen extraversion=rowmean(std_qn416 std_qn414_new std_qu111)
egen pleasant=rowmean(std_qn10024 std_qn1001_new std_qm2011)
egen openness=rowmean(std_qn12016 std_qm1004_new)
egen stability=rowmean(std_qn406_new std_qn407_new std_qn418_new std_qn420_new)
list std_qn406_new std_qn407_new std_qn418_new std_qn420_new stability in 1/5
sum duty extraversion pleasant openness stability

keep pid fid22 age gender provcd22 countyid22 cid22 urban22 cyear qa301 edu_last employ jobclass_base jobclass qg401 qg402 qg403 qg404 qg405 qg406 qg5 qg501 qg6 qg11 qg12 qn12016 child16n qgb4 qga4code qga401code_isco qga401code_isei qga401code_siops qv204 qv202 qv203code qv203code_isco qv203code_isei qv203code_siops qv104 qv102 qv103code qv103code_isco qv103code_isei qv103code_siops incomeb qg101 duty extraversion pleasant openness stability
rename incomeb income
recode qg101(1=0)(5=1),gen(nonfarmwork)
merge m:1 fid22 using "G:\2010-2022数据汇总\cfps2022famecon_202410.dta",keepusing(fp510 fincome1 total_asset savings financial_product finance_asset fincome1_per familysize22 ft101 ft201 ft1 ft200)
keep if _merge==3
drop _merge
rename qv102 edu_f
rename qv202 edu_m

***以2010年为基期进行折算 qg11 qg12 fp510 ft1 ft101 ft201 fincome1 savings financial_product finance_asset total_asset 
sum qg11 qg12 fp510 ft1 ft101 ft201 fincome1 savings financial_product finance_asset total_asset
gen fp5101=.
replace fp510=. if fp510<0
replace fp5101=fp510/1.318
replace ft1=ft1/1.318
replace ft1=. if ft1<0
replace ft101=ft101/1.318
replace ft101=. if ft101<0
replace fincome1=fincome1/1.318
replace total_asset=total_asset/1.318
replace fincome1_per=fincome1_per/1.318
replace ft201=ft201/1.318
replace ft201=. if ft201==-8
replace savings=savings/1.318
replace savings=. if savings<0
replace financial_product=financial_product/1.318
replace finance_asset=finance_asset/1.318
replace qg11=qg11/1.318
replace qg11=. if qg11<0
replace qg12=qg12/1.318
replace qg12=. if qg12<0
replace income=income/1.318
replace income=. if income<0
replace nonfarmwork=. if nonfarmwork<0
***按家庭资产分类
sum total_asset fincome1 fincome1_per qg11 income,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0 //欠债
replace totalasset_stage=2 if total_asset>=0 & total_asset<268873.3   //大于零小于中位数以下
replace totalasset_stage=3 if total_asset>=268873.3 & total_asset<=3.21e+07  //大于中位数
gen fincome1_stage=.
replace fincome1_stage=1 if fincome1<62690.06 
replace fincome1_stage=2 if fincome1>=62690.06 & fincome1<=1.21e+07
gen fincome1per_stage=.
replace fincome1per_stage=1 if fincome1_per<15720.79 
replace fincome1per_stage=2 if fincome1_per>=15720.79 & fincome1_per<=5224583 
gen qg11_stage=.
replace qg11_stage=1 if qg11<3110.774 
replace qg11_stage=2 if qg11>=3110.774 & qg11<91047.04
gen income_stage=.
replace income_stage=1 if income<18209.41
replace income_stage=2 if income<53110.77 & income>=18209.41
replace income_stage=3 if income>=53110.77 & income<=1365706
rename cyear year
save "D:\tongyi data\2022a.dta",replace


***合并
use "D:\tongyi data\2022a.dta",clear
append using "D:\tongyi data\2010a.dta",force
append using "D:\tongyi data\2012a.dta",force
append using "D:\tongyi data\2014a.dta",force
append using "D:\tongyi data\2016a.dta",force
append using "D:\tongyi data\2018a.dta",force
append using "D:\tongyi data\2020a.dta",force
rename provcd22 province
replace province = provcd20 if year == 2020
replace province = provcd18 if year == 2018
replace province = provcd16 if year == 2016
replace province = provcd14 if year == 2014
replace province = provcd if year == 2012
replace province = provcd if year == 2010
drop provcd20 provcd18 provcd16 provcd14 provcd
***countyid22 countyid countyid14 countyid16 countyid18 countyid20
replace countyid = countyid22 if year == 2022
replace countyid = countyid20 if year == 2020
replace countyid = countyid18 if year == 2018
replace countyid = countyid16 if year == 2016
replace countyid = countyid14 if year == 2014
drop countyid22 countyid20 countyid18 countyid16 countyid14 

replace fid=fid20 if year == 2020
replace fid=fid18 if year == 2018
replace fid=fid16 if year == 2016
replace fid=fid14 if year == 2014
replace fid=fid12 if year == 2012
replace fid=fid22 if year == 2022
drop fid22 fid20 fid18 fid16 fid14 fid12
replace urban=urban22 if year == 2022 
replace urban=urban20 if year == 2020
replace urban=urban18 if year == 2018
replace urban=urban16 if year == 2016
replace urban=urban14 if year == 2014
replace urban=urban12 if year == 2012
drop urban22 urban20 urban18 urban16 urban14 urban12
tab year if age!=.
tab year if cfps_age!=.
tab year if qa1age!=.
replace age=cfps_age if year == 2016
replace age=qa1age if year == 2010
replace age=cfps2012_age if year == 2012
replace age=cfps2014_age if year == 2014
drop cfps_age qa1age cfps2012_age cfps2014_age cfps_birthy
sum age
replace age=. if age<0


tab year if gender!=.
tab year if cfps_gender!=.
tab year if cfps2012_gender!=.
replace gender=cfps_gender if year==2014
replace gender=cfps_gender if year==2016
replace gender=cfps2012_gende if year==2012
drop cfps2012_gender cfps_gender
sum gender
replace gender=. if gender<0

tab year if pa301!=.
tab year if qa2!=.
tab year if qa301!=.
replace qa301=qa2 if year == 2010
replace qa301=pa301 if year == 2016
rename qa301 hukou
drop qa2 pa301
sum hukou 
replace hukou=. if hukou<1
replace hukou=. if hukou>3

tab year if qg101!=.
tab year if employ2014!=.
tab year if qg3!=.
tab year if employ!=.
replace employ=employ2014 if year == 2014
replace employ=qg101 if year == 2012
replace employ=qg3 if year == 2010
drop employ2014 qg101 qg3
sum employ
replace employ=. if employ<0
replace employ=. if employ>3

tab year if qa701code!=.
tab year if qa5code!=.
tab year if cfps_minzu!=.
replace qa701code=qa5code if year==2010
replace qa701code=cfps_minzu if year==2012
drop qa5code cfps_minzu
rename qa701code minzu
tab year if pa701code!=.
drop pa701code
sum minzu
replace minzu=. if minzu==79
replace minzu=. if minzu<1


tab year if qn12016!=.
tab year if qn12014!=.
tab year if qm404!=.
replace qn12014=qn12016 if year==2018
replace qn12014=qn12016 if year==2020
replace qn12014=qn12016 if year==2022
replace qn12014=qm404 if year==2010
drop qm404 qn12016
rename qn12014 faith
sum faith
replace faith=. if faith<0
replace faith=. if faith==79

tab year if familysize22!=.
tab year if familysize!=.
tab year if familysize18!=.
tab year if familysize16!=.
tab year if fml_count!=.
replace familysize=familysize22 if year == 2022
replace familysize=familysize16 if year == 2016
replace familysize=familysize18 if year == 2018
replace familysize=familysize20 if year == 2020
drop familysize22 familysize20 familysize18 familysize16 fml_count
tab year

tab year if ft101!=.
tab year if ft1!=.
tab year if ff2!=.
tab year if ft201!=.
replace ft101=ff2 if year==2010
replace ft1=ff2 if year==2010
replace ft101=savings if year==2012
drop ff2 savings stock funds derivative otherfinance

***fincome1 fp510 savings fh404 fp508  pd503r pd503a qgb2 pd5total pd5total_mn 
tab year if fincome1!=.
tab year if fp5101!=.
tab year if fh404!=.
tab year if fp508!=.
tab year if pd5total!=.
tab year if pd5total_mn!=.
tab year if pd503r!=.
tab year if pd503a!=.
replace fp5101=pd5total if year==2020
drop fh404 fp508 fp510 pd5total pd5total_mn pd503r 

**qc301 qgb2 qm3015 qc201
tab year if qc301!=.
tab year if qgb2!=.
tab year if qm3015!=.
tab year if qc201!=.
replace qc301=qgb2 if year==2020
drop qm3015 qc201 qgb2
tab year if qc301!=.
sum qc301
replace qc301=. if qc301<0


***qg402 qg403 qg404 qg405 qg406 qg502 qg503 qg504 qg505 qg506 qg408
tab year if qg401!=.
tab year if qg402!=.
tab year if qg403!=.
tab year if qg404!=.
tab year if qg405!=.
tab year if qg406!=.
tab year if qg408!=.
tab year if qg502!=.
tab year if qg503!=.
tab year if qg504!=.
tab year if qg505!=.
tab year if qg506!=.
replace qg402=qg502 if year==2010
replace qg403=qg503 if year==2010
replace qg404=qg504 if year==2010
replace qg405=qg505 if year==2010
replace qg406=qg506 if year==2010
drop qg408 qg502 qg503 qg504 qg505 qg506 
sum qg402 qg403 qg404 qg405 qg406 qg401
replace qg402=. if qg402<1
replace qg402=. if qg402>5
replace qg403=. if qg403<1
replace qg403=. if qg403>5
replace qg404=. if qg404<1
replace qg404=. if qg404>5
replace qg405=. if qg405<1
replace qg405=. if qg405>5
replace qg406=. if qg406<1
replace qg406=. if qg406>5
replace qg401=. if qg401<1
replace qg401=. if qg401>5
***qg501 qg6 qg11 qg12 qg304 qg305 qg416_a_1
tab year if qg9_s_1!=.
tab year if qg9_a_2!=.
drop qg9_a_1 qg9_a_2 qg9_a_3 qg9_a_4 qg9_a_5 qg9_a_78 qg4 qg9_s_1 qg9_s_2 qg9_s_3 qg9_s_4 qg9_s_5 
tab year if qg12!=.
tab year if qg11!=.
tab year if qg6!=.
tab year if qg501!=.
tab year if qg5!=.
tab year if qg305!=.
tab year if qg305!=.
replace qg6=qg304 if year==2012
drop  qg305 
sum qg11 qg6
replace qg6=. if qg6<0
replace qg11=. if qg11<0
***jobclass_base jobclass  
tab year if jobclass!=.
tab year if jobclass_base!=.
tab year if te4!=.
tab year if fw7!=.
tab year if fw8!=.
tab year if fw23!=.
tab year if fw241!=.
tab year if fz202!=.
drop fw7 fw8 fw23 fw241 fz202 te4 jobclass jobclass_base 

tab year if edu_last!=.
sum edu_last
replace edu_last=. if edu_last<1
replace edu_last=. if edu_last>8

tab year if qgb4!=.
replace qgb4=nonfarmwork if year==2010
sum qgb4
replace qgb4=. if qgb4<0
replace qgb4=. if qgb4==79
sum edu_f edu_m qv102 qv202 qga4code qg303code_g qga401code_isco qga401code_isei qga401code_siops
replace edu_f=. if edu_f<1
replace edu_m=. if edu_m<1
replace qv102=. if qv102<1
replace qv202=. if qv202<1
replace edu_f=. if edu_f>8
replace edu_m=. if edu_m>8
replace qv102=. if qv102>8
replace qv202=. if qv202>8
replace qg303code_g=. if qg303code_g==-8
replace qga4code=. if qga4code<0
replace qga401code_isco=. if qga401code_isco<0
drop pd503a 
tab year if edu_f!=.
tab year if edu_m!=.
tab year if qv102!=.
tab year if qv202!=.
replace qv202=edu_m if year==2020
replace qv102=edu_f if year==2020
drop edu_f edu_m
rename qv102 edu_f
rename qv202 edu_m
tab year if qg303code_g!=.
tab year if qga4code!=.
replace qga4code=qg303code_g if year==2020
drop qg303code_g 
drop mincomea_a_1 fincome1_per_p 
sum fincome1 fincome1_per ft201 total_asset
describe fincome1 fincome1_per ft201
tab year if ft201!=.
tab year if fincome1!=.
tab year if fincome1_per!=.
tab year if total_asset!=.
keep if hukou==1
sort province year
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province  
merge m:1 countyid using "D:\顺序码匹配.dta",keepusing (city cityname)  //损失15898个观测值
keep if _merge==3
drop _merge
save "D:\tongyi data\hebinga.dta",replace //139432个观测值

/*sum age
tab pid if age>65
keep if age<=65  //限定成人年龄在18-65之间
tab employ  //131847个观测值，10888处于失业，103161处于在业，17798退出劳动力市场
keep if employ!=.
tab income //52436个观测值
tab nonfarmwork //35891
tab qgb4  //55334 */
***将区县匹配到市，使用合并市层面的机器人渗透度
merge m:1 year city using "D:\tongyi data\2006-2019cityrobot.dta",keepusing(robot_installation robot_stock iv_installation iv_stock)  //使用city合并损失14892个观测值
keep if _merge==3
drop _merge
save "D:\tongyi data\hebingar.dta",replace //124540个观测值





