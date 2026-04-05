***机器人数据清理
use "D:\文献\robot待合并.dta",clear
describe province 
replace province="新疆维吾尔自治区" if province=="新疆"
replace province="广西壮族自治区" if province=="广西"
replace province="西藏自治区" if province=="西藏"
save "D:\robot"
use "D:\robot.dta"
replace year = year+3
save "D:\robot.dta",replace

***统一变量名
***2022 wc802
// 1. 生成新变量，初始设为缺失（.）
use "G:\2010-2022数据汇总\cfps2022childproxy_202410.dta",clear
gen survey_count = .
// 2. 按条件赋值：fid22与某个变量相等时，赋予对应次数
replace survey_count = 7 if fid22 == fid10 & fid22 == fid12 & fid22 == fid14 & fid22 == fid16 & fid22 == fid18 & fid22 == fid20 // 匹配fid10 → 7次
replace survey_count = 6 if fid22 == fid12 & fid22 == fid14 & fid22 == fid16 & fid22 == fid18 & fid22 == fid20 & survey_count == . // 匹配fid12 → 6次
replace survey_count = 5 if fid22 == fid14 & fid22 == fid16 & fid22 == fid18 & fid22 == fid20 & survey_count == . // 匹配fid14 → 5次
replace survey_count = 4 if fid22 == fid16 & fid22 == fid18 & fid22 == fid20 & survey_count == . // 匹配fid16 → 4次
replace survey_count = 3 if fid22 == fid18 & fid22 == fid20 & survey_count == . // 匹配fid18 → 3次
replace survey_count = 2 if fid22 == fid20 & survey_count == . // 匹配fid20 → 2次
replace survey_count = 1 if survey_count == .
// 查看前20行的匹配情况
list fid22 fid10 fid12 fid14 fid16 fid18 fid20 survey_count in 1/20
// 统计fin_count的分布，确认是否符合预期
tab survey_count, missing
keep if wa301 == 1
keep pid code fid22 fid_base age gender pid_a_f pid_a_m psu provcd22 countyid22 cid22 urban22 tb6_a22_p gene gender_pre minzu muru walk speak count pee ill preschool edu_last r1_last cyear wa301 wc1 wc2 school wc3 wb202 wb203 wf309a wf310a wb401 wb402 wb9 wa104 wa103 bmi wc3n wc0 wc701 wc8015 wd101code wd2 wd3 wd301 wd4 wd402 wc5 ws1101 wf602m wf604m wf607 wf608 wt1 wt2 wt201 wt3 wt301 wt4 wt401 wt5 wt501 wt6 wt601 wt7 wt701 wt8 wd503r wd501a wd5total wg301 wg302 wg303 wg304 wg308 wg305 wg306 wz1pid cfps2022edu cfps2022sch cfps2022eduy cfps2022eduy_im survey_count wc802 wd504a wd501b wd577rn wz301
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2022famconf_202410.dta", keepusing(tb4_a22_f tb4_a22_m tb1y_a_f tb1y_a_m familysize22) //合并父母亲受教育程度
keep if _merge==3
drop _merge 
gen age_f = 2022-tb1y_a_f
gen age_m = 2022-tb1y_a_m
rename provcd22 province
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
save "D:\2022.dta", replace 

use "D:\2022.dta",clear
merge m:1 fid22  using "G:\2010-2022数据汇总\cfps2022famecon_202410.dta", keepusing( fp510 fincome1 fincome1_per fincome1_per_p total_asset ft101 ft201 ft1 ft200 fu201 fn4)
rename fn4 jiekuan
replace ft200=. if 200<0
recode ft200(5=0),gen(ft200_n)
drop ft200
rename ft200_n ft200
keep if _merge == 3
drop _merge 
drop code fid_base psu tb6_a22_p gene gender_pre ill edu_last r1_last wc2 school wc3 wb9 bmi wc8015 wf602m wf604m  wf607 wf608 wz1pid cfps2022edu cfps2022sch cfps2022eduy cfps2022eduy_im  tb1y_a_f tb1y_a_m 
rename fid22 fid 
rename countyid22 countyid
rename urban22 urban
rename pid_a_f pid_f
rename pid_a_m pid_m
rename wa301 hukou
rename wc1 school
rename wc3n ill
rename wc5 grade
rename ws1101 takekids
rename familysize22 familysize
rename tb4_a22_f edu_f
rename tb4_a22_m edu_m
rename cid22 cid 
rename wd101code exp
rename cyear year
merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe
egen child_count = count(fid), by(fid)
tab  child_count
***以2010年为基期进行折算 wd503r wd501a wd5total ft1 ft101 ft201 fincome1 total_asset fincome1_per wc802 wd501b
sum wd503r wd501a wd5total ft1 ft101 ft201 fincome1 total_asset fincome1_per wc802 wd501b
gen edutotal=.
replace edutotal=wd5total/1.318
replace edutotal=. if wd5total<0
replace wd503r=wd503r/1.318
replace wd503r=. if wd503r<0
replace wd501a=. if wd501a<0
replace ft1=ft1/1.318
replace ft1=. if ft1<0
replace ft101=ft101/1.318
replace ft101=. if ft101<0
replace fincome1=fincome1/1.318
replace total_asset=total_asset/1.318
replace fincome1_per=fincome1_per/1.318
replace wc802 =wc802 /1.318
replace wc802=. if wc802<0
replace wd501b=wd501b/1.318
replace wd501b=. if wd501b<0
replace ft201=ft201/1.318
replace ft201=. if ft201==-8
replace fp510=fp510/1.318
replace fp510=. if fp510<0
replace fu201=. if fu201<0
replace fu201=fu201/1.318
replace jiekuan=. if jiekuan<0
replace jiekuan=jiekuan/1.318
***对其家庭纯收入和家庭净资产进行分类
sum  total_asset fincome1 fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<254173
replace totalasset_stage=3 if total_asset>=254173 & total_asset<=1.08e+07
gen fincome1_stage=.
replace fincome1_stage=0 if  fincome1<62670.71 
replace fincome1_stage=1 if fincome1>=62670.71 & fincome1<=2731411
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per<12139.61
replace fincome1per_stage=1 if fincome1_per>=12139.61 & fincome1_per<=546282.2
***对受教育水平进行分类edu_m edu_f grade
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade 
save "D:\tongyi data\20221.dta",replace

***2020
/*wt1 wt2 wt201 wt3 wt301 wt4 wt401 wt5 wt501 wt6 wt601 wt7 wt701 wt8 wd503r wd501a wd5total
处理2020年数据 缺少 cid exp child_count pid_f pid_m robot_CN iv2 iv1 fincome1 fincome1_per fincome1_per_p total_asset
*/
use "G:\2010-2022数据汇总\cfps2020childproxy_202112.dta",clear
gen survey_count = .
// 2. 按条件赋值：fid22与某个变量相等时，赋予对应次数
replace survey_count = 6 if fid20 == fid10 & fid20 == fid12 & fid20 == fid14 & fid20 == fid16 & fid20 == fid18 // 匹配fid10 → 7次
replace survey_count = 5 if fid20 == fid12  & fid20 == fid14 & fid20 == fid16 & fid20 == fid18 & survey_count == . // 匹配fid12 → 6次
replace survey_count = 4 if fid20 == fid14  & fid20 == fid16 & fid20 == fid18 & survey_count == . // 匹配fid14 → 5次
replace survey_count = 3 if fid20 == fid16  & fid20 == fid18 & survey_count == . // 匹配fid16 → 4次
replace survey_count = 2 if fid20 == fid18  & survey_count == . // 匹配fid18 → 3次
// 查看前20行的匹配情况
list fid10 fid12 fid14 fid16 fid18 fid20 survey_count in 1/20
// 统计fin_count的分布，确认是否符合预期
tab survey_count, missing
keep if wa301 == 1
keep pid code fid20 psu provcd20 countyid20 urban20 tb6_a20_p fidbaseline gene gender minzu muru walk speak count pee ill preschool edu_last r1_last wa002 ibirthy_update wa301 wc1 wc2 school wc3 wb202 wb203 wf309a wf310a wb401 wb402 wb9 wa104 wa103 bmi wc3n wc0 wc701 wc8015 wd101code wd2 wd4 wc5 ws1101 wf602m wf604m wt1 wt2 wt201 wt3 wt301 wt4 wt401 wt5 wt501 wt6 wt601 wt7 wt701 wt8 wd503r wd501a wd5total wg301 wg302 wg303 wg304 wg308 wg305 wg306 wz1pid cfps2020edu cfps2020sch cfps2020eduy cfps2020eduy_im survey_count age
save "D:\2020.dta",replace
***20年的父母亲受教育程度有问题，需注意
use "D:\2020.dta",clear
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2020famconf_202306.dta", keepusing(tb4_a20_f tb4_a20_m tb1y_a_f tb1y_a_m familysize20) //合并父母亲受教育程度
keep if _merge == 3
drop _merge 
rename tb4_a20_f edu_f
rename tb4_a20_m edu_m
gen age_f=2020-tb1y_a_f
gen age_m=2020-tb1y_a_m
merge m:1 fid20  using "G:\2010-2022数据汇总\cfps2020famecon_202306.dta", keepusing( fp510 fincome1 fincome1_per fincome1_per_p total_asset ft101 ft201 ft1 ft200 fu201 fn4)
rename fn4 jiekuan
replace ft200=. if 200<0
recode ft200(5=0),gen(ft200_n)
drop ft200
rename ft200_n ft200
keep if _merge == 3
drop _merge 
drop code tb6_a20_p psu fidbaseline gene ibirthy_update wa002 wc2 school wc3 wb9 bmi ill wc8015 wf602m wf604m  wd501a wz1pid cfps2020edu cfps2020sch cfps2020eduy cfps2020eduy_im edu_last r1_last
rename fid20 fid
rename provcd20 province
rename countyid20 countyid
rename urban20 urban
rename wa301 hukou
rename wc1 school
rename wc3n ill
rename wc5 grade
rename ws1101 takekids
gen year=2020
merge 1:1 pid  using "G:\2010-2022数据汇总\cfps2020childproxy_202112.dta", keepusing(wz301 we405 wr4 wd501b wd577rn wc802 wd402 wd3 wd301 we403)
keep if _merge==3 
drop _merge
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe
egen child_count = count(fid), by(fid)
tab  child_count
***以2010年为基期进行费用折算wd503r wd5total wc802 wr4 wd501b wd577rn wd402 wc701 
sum wd503r wd5total wc802 wr4 wd501b wd577rn wd402 wc701 fp510 fincome1 fincome1_per fincome1_per_p total_asset ft101 ft201 ft1 ft200
gen edutotal=.
replace edutotal=wd5total/1.219
replace edutotal=. if wd5total<0
replace wd503r=wd503r/1.219
replace wd503r=. if wd503r<0
replace wc802=wc802/1.219
replace wc802=. if wc802<0
replace wr4=wr4/1.219
replace wr4=. if wr4<0
replace wd501b=wd501b/1.219
replace wd501b=. if wd501b<0
replace wd577rn=wd577rn/1.219
replace wd577rn=. if wd577rn<0
replace wd402=wd402/1.219
replace wd402=. if wd402<0
replace wc701=wc701/1.219
replace wc701=. if wc701<0
replace fp510=. if fp510<0
replace fp510=fp510/1.219
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
replace fu201=. if fu201<0
replace fu201=fu201/1.219
replace jiekuan=. if jiekuan<0
replace jiekuan=jiekuan/1.219
***对家庭资产进行分类
sum  total_asset fincome1 fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<226415.1
replace totalasset_stage=3 if total_asset>=226415.1 & total_asset<=9298093 
gen fincome1_stage=.
replace fincome1_stage=0 if fincome1<58589.01 
replace fincome1_stage=1 if fincome1>=58589.01 & fincome1<= 2698934 
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per<10937.93
replace fincome1per_stage=1 if fincome1_per>=10937.93 & fincome1_per<=674733.4 
***对受教育程度进行分类 edu_f edu_m grade
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade
save "D:\tongyi data\20201.dta",replace


***2018
use "G:\2010-2022数据汇总\cfps2018childproxy_202012.dta",clear
gen survey_count = .
// 2. 按条件赋值：fid22与某个变量相等时，赋予对应次数
replace survey_count = 5 if fid18 == fid10 & fid18 == fid12 & fid18 == fid14 & fid18 == fid16 // 匹配fid10 → 7次
replace survey_count = 4 if fid18 == fid12 & fid18 == fid14 & fid18 == fid16 & survey_count == . // 匹配fid12 → 6次
replace survey_count = 3 if fid18 == fid14 & fid18 == fid16 & survey_count == . // 匹配fid14 → 5次
replace survey_count = 2 if fid18 == fid16 & survey_count == . // 匹配fid16 → 4次
replace survey_count = 1 if survey_count == .
// 查看前20行的匹配情况
list fid10 fid12 fid14 fid16 fid18 survey_count in 1/20

// 统计fin_count的分布，确认是否符合预期
tab survey_count, missing
keep pid fid18 provcd18 countyid18 cid18 psu urban18 tb6_a18_p pid_a_f pid_a_m gene  gender minzu muru walk speak count pee ill preschool edu_last r1_last exp cyear age wa301 wb202 wb203 wb1mr wb401 wb402 wb9 wa104 wa103 bmi wc3_b_1 wc0 wc701 wc8015 wd101code wd2 wd3 wd301 wd4 wd402 wc1_b_2 wc2 wc3_b_2 wc5_b_2 school ws1101 wf602m wf603m wf309a wf310a wt1 wt2 wt201 wt3 wt301 wt4 wt401 wt5 wt501 wt6 wt601 wt7 wt701 wt8 wd503r wd501a wd5total wg301 wg302 wg303 wg304 wg308 wg305 wg306 wz1pid cfps2018edu cfps2018sch cfps2018eduy cfps2018eduy_im survey_count
keep if wa301 == 1
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2018famconf_202008.dta", keepusing( tb4_a18_f tb4_a18_m tb1y_a_f tb1y_a_m familysize18)
keep if  _merge== 3
drop _merge
gen age_f = 2018-tb1y_a_f
gen age_m = 2018-tb1y_a_m
rename cyear year
rename provcd18 province
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
save "D:\2018.dta", replace


use "D:\2018.dta", clear
merge m:1 fid18 using "G:\2010-2022数据汇总\cfps2018famecon_202101.dta",keepusing(finance_asset total_asset fincome1 fincome1_per fincome1_per_p ft200 ft101 ft201 fp510 familysize18 ft1 fu201 fn4)
rename fn4 jiekuan
replace ft200=. if 200<0
recode ft200(5=0),gen(ft200_n)
drop ft200
rename ft200_n ft200
keep if _merge == 3
drop _merge
drop tb1y_a_f tb1y_a_m tb6_a18_p ill gene edu_last r1_last wb1mr wb9 bmi wf602m wf603m cfps2018edu cfps2018sch cfps2018eduy cfps2018eduy_im wz1pid
rename familysize18 familysize
rename wa301 hukou
rename tb4_a18_f edu_f
rename tb4_a18_m edu_m
rename wc3_b_1 ill
rename wc3_b_2 jieduan
rename wc5_b_2 grade
rename school school_state
rename wc1_b_2 school
rename wc2 holiday
rename fid18 fid
rename countyid18 countyid
rename cid18 cid
rename urban18 urban 
drop wd501a
rename ws1101 takekids 
rename pid_a_f pid_f
rename pid_a_m pid_m
drop psu wd503r 
drop holiday school_state jieduan
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2018childproxy_202012.dta",keepusing (wc802 wf801 wd503r wd501b wd577r wz301)
keep if _merge == 3
drop _merge wc8015
rename wd577r wd577rn
rename wf801 we405
merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe
egen child_count = count(fid), by(fid)
tab  child_count
***以2010年为基期进行折算 wd5total  fincome1 fincome1_per total_asset fp510 ft1 ft101 ft201 finance_asset wc802 wd503r wd501b wd577rn
sum wd5total  fincome1 fincome1_per total_asset fp510 ft1 ft101 ft201 finance_asset wc802 wd503r wd501b wd577rn
gen edutotal=.
replace edutotal=wd5total/1.165
replace edutotal=. if wd5total<0
replace wd503r=wd503r/1.165
replace wd503r=. if wd503r<0
replace ft1=ft1/1.165
replace ft1=. if ft1<0
replace ft101=ft101/1.165
replace ft101=. if ft101<0
replace fincome1=fincome1/1.165
replace total_asset=total_asset/1.165
replace fincome1_per=fincome1_per/1.165
replace wc802 =wc802 /1.165
replace wc802=. if wc802<0
replace wd501b=wd501b/1.165
replace wd501b=. if wd501b<0
replace ft201=ft201/1.165
replace ft201=. if ft201==-8
replace fp510=fp510/1.165
replace fp510=. if fp510<0
replace fu201=. if fu201<0
replace fu201=fu201/1.165
replace jiekuan=. if jiekuan<0
replace jiekuan=jiekuan/1.165

***对其家庭纯收入和家庭净资产进行分类
sum total_asset fincome1  fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<232188.8
replace totalasset_stage=3 if total_asset>=232188.8 & total_asset<=4.30e+07
gen fincome1_stage=.
replace fincome1_stage=0 if fincome1<51502.15    
replace fincome1_stage=1 if fincome1>= 51502.15 & fincome1<=1754292 
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per<9658.083 
replace fincome1per_stage=1 if fincome1_per>=9658.083 & fincome1_per<=350858.4 

***将受教育水平进行分类grade edu_f edu_m
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade 
drop year
gen year=2018
save "D:\tongyi data\20181.dta",replace


***2016
use "G:\2010-2022数据汇总\cfps2016child_201906.dta",clear
gen survey_count = .
// 2. 按条件赋值：fid22与某个变量相等时，赋予对应次数
replace survey_count = 4 if fid16 == fid10 & fid16 == fid12 & fid16 == fid14  
replace survey_count = 3 if fid16 == fid12 & fid16 == fid14 & survey_count == . 
replace survey_count = 2 if fid16 == fid14 & survey_count == . 
replace survey_count = 1 if survey_count == . 
// 查看前20行的匹配情况
list fid10 fid12 fid14 fid16 survey_count in 1/20
// 统计fin_count的分布，确认是否符合预期
tab survey_count, missing
keep if pa301 == 1
keep pid fid16 provcd16 countyid16 cid16 urban16 cfps_age cfps_gender cfps_exp pid_f pid_m pa301 pa701code wb202 wb203 wb401 wb402 wb5 wb6 wb8 wb9 wa105a wb7 wa103 wa104 wc3 wc0 pc701 wc8015 wd101code wd2 wd3 wd301 wd4 wd402 pc1_b_1 pc2_b_1 school_b_1 pc3_b_1 pc4_b_1 ppc5_b_1 pt1 pt2 pt201 pt3 pt301 pt4 pt401 pt5 pt501 pt6 pt601 pt7 pt701 pd501a pd5total wf309a wf310a wf604m wf602m wg301 wg302 wg303 wg304 wg308 wg305 wg306 cfps2016edu cfps2016sch cfps2016eduy cfps2016eduy_im survey_count

merge 1:1 pid using "G:\2010-2022数据汇总\cfps2016famconf_201804_clean.dta", keepusing( tb4_a16_f tb4_a16_m tb1y_a_f  tb1y_a_m  familysize16)
keep if _merge==3
drop _merge
gen age_f = 2016-tb1y_a_f
gen age_m = 2016-tb1y_a_m
rename tb4_a16_f edu_f
rename tb4_a16_m edu_m
gen year = 2016
rename provcd16 province
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
save "D:/2016.dta",replace


use "D:\2016.dta",clear
merge m:1 fid16 using "G:\2010-2022数据汇总\cfps2016famecon_201807.dta",keepusing(total_asset fincome1 fincome1_per fincome1_per_p finance_asset ft101 ft200 ft201 fp510 familysize16 ft1 fu201 fn4)
rename fn4 jiekuan 
keep if _merge == 3
drop _merge
replace ft200=. if 200<0
recode ft200(5=0),gen(ft200_n)
drop ft200
rename ft200_n ft200
merge 1:1 pid using "G:\2010-2022数据汇总\cfps2016child_201906.dta",keepusing(pd501b pd503r pd577r pd501b pd503r pd577r pd5total wf801 ks601n wz301 pc6_b_1 ps1101_b_1 wc802 wz301)
keep if _merge == 3
drop _merge
rename pc6_b_1 preschool
rename ps1101_b_1 takekids
rename cfps_age age 
rename cfps_gender gender
rename cfps_exp exp
rename pa301 hukou
rename pa701code minzu

drop wf602m wf604m cfps2016edu cfps2016sch cfps2016eduy cfps2016eduy_im tb1y_a_f  tb1y_a_m  pc4_b_1 wf602m wf604m
rename pc3_b_1 jieduan
rename ppc5_b_1 grade
rename familysize16 familysize
rename wb5 walk
rename wb6 speak
rename wb7 count
rename wb8 pee
rename wa105a muru
rename school_b_1 school_state
rename  wc3 ill
rename pc1_b_1 school
rename pc2_b_1 holiday
drop wb9 pd501a
rename fid16 fid
rename countyid16 countyid
rename cid16 cid
rename urban16 urban 
rename pd5total wd5total           
rename pt1 wt1
rename pt2 wt2
rename pt201 wt201
rename pt3 wt3
rename pt301 wt301 
rename pt4 wt4
rename pt401 wt401
rename pt5 wt5
rename pt501 wt501
rename pt6 wt6 
rename pt601 wt601
rename pt7 wt7
rename pt701 wt701 
rename wf801 we405 
rename pd501b wd501b 
rename pd503r wd503r 
rename pd577r wd577rn 
rename pc701 wc701
drop wc8015 holiday school_state jieduan ks601n 

merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe

egen child_count = count(fid), by(fid)
tab  child_count
***以2010年为基期进行折算wc701 wd402 wd5total  wd577rn wd503r wd501b wc802 finance_asset ft201 ft101 ft1 fp510 fincome1 fincome1_per total_asset
sum wc701 wd402 wd5total  wd577rn wd503r wd501b wc802 finance_asset ft201 ft101 ft1 fp510 fincome1 fincome1_per total_asset
gen edutotal=.
replace edutotal=wd5total/1.126
replace edutotal=. if wd5total<0
replace wd503r=wd503r/1.126
replace wd503r=. if wd503r<0
replace wc802=wc802/1.126
replace wc802=. if wc802<0
replace wd501b=wd501b/1.126
replace wd501b=. if wd501b<0
replace wd577rn=wd577rn/1.126
replace wd577rn=. if wd577rn<0
replace wd402=wd402/1.126
replace wd402=. if wd402<0
replace wc701=wc701/1.126
replace wc701=. if wc701<0
replace fp510=fp510/1.126
replace fp510=. if fp510<0
replace fincome1=fincome1/1.126
replace total_asset=total_asset/1.126
replace fincome1_per=fincome1_per/1.126
replace finance_asset=finance_asset/1.126
replace ft1=ft1/1.126
replace ft1=. if ft1<0
replace ft101=ft101/1.126
replace ft101=. if ft101<0
replace ft201=. if ft201==-8
replace ft201=ft201/1.126
replace fu201=. if fu201<0
replace fu201=fu201/1.126
replace jiekuan=. if jiekuan<0
replace jiekuan=jiekuan/1.126
***对其家庭纯收入和家庭净资产进行分类
sum total_asset fincome1 fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<183570.2 
replace totalasset_stage=3 if total_asset>=183570.2 & total_asset<= 4.53e+07 
gen fincome1_stage=.
replace fincome1_stage=0 if fincome1>=0 & fincome1< 44404.97    
replace fincome1_stage=1 if fincome1>= 44404.97 & fincome1<=1.01e+07   
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per>=0 & fincome1_per<8377.738
replace fincome1per_stage=1 if fincome1_per>=8377.738 & fincome1_per<= 1787152

***将受教育水平进行分类grade edu_f edu_m
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade 

save "D:\tongyi data\20161.dta",replace




***2014 缺少\holiday\school_state\jieduan\   wc802保留\wc8015需删除 变量数63
use "G:\2010-2022数据汇总\cfps2014child_201906.dta",clear
gen survey_count = .
// 2. 按条件赋值：fid22与某个变量相等时，赋予对应次数
replace survey_count = 3 if fid14 == fid10 & fid14 == fid12  
replace survey_count = 2 if fid14 == fid12 & survey_count == . 
replace survey_count = 1 if survey_count == . 
// 查看前20行的匹配情况
list fid10 fid12 fid14  survey_count in 1/20
// 统计fin_count的分布，确认是否符合预期
tab survey_count, missing
keep if wa4 == 1
keep pid fid14 provcd14 countyid14 cid14 urban14 code_b_1 cfps_birthy cfps2014_age cfps_gender cfps2012latest_school cfps2012_latest_edu cfps2012_latest_r1 cfps_muru cfps2012_child_walk cfps2012_child_speak cfps2012_child_count cfps2012_child_pee te4 wa103 wa104 wa4 wa6code wb202_new wb203_new wb401 wb402 wa105a wb5 wb6 wb7 wb8 wb9 wc3 wc0 wc701 wc802 wd1 wd101code wd2 wd3 wd301 wd4 wd402 wd501 wd507 wd502a wd511 wd505m wd512 wd513 wd504 wd503m wd577 wd5total_m we401 we402 we403 wf3m wf309a wf310a wf302 wf602m wf604m wg2 wg203m_s_1 wg203m_s_2 wg203m_s_3 wg204_a_1 wg204_a_2 wg204_a_3 wg204_a_4 wg204_a_5 wg204_a_6 dg204 wg301 wg302 wg303 wg304 wg308 wg305 wg306 code_a_f code_a_m cfps2014sch cfps2014edu cfps2014eduy cfps2014eduy_im survey_count
merge 1:1 pid fid14 using "G:\2010-2022数据汇总\cfps2014famconf_170630.dta", keepusing(tb4_a14_f tb4_a14_m tb1y_a_f alive_a14_f tb1y_a_m alive_a14_m familysize14)
keep if _merge==3
drop _merge
gen age_f = 2014-tb1y_a_f
gen age_m = 2014-tb1y_a_m
gen year = 2014
rename provcd14 province
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
save "D:/2014.dta",replace

use "D:\2014.dta",clear
merge m:1 fid14 using "G:\2010-2022数据汇总\cfps2014famecon_201906.dta",keepusing(fincome1_per fincome1 fincome1_per_p fw7 fw241 fw8 fw23 fz202 total_asset fp510 familysize ft1 ft101 ft201 fu201 fn4 fv4)
rename fn4 jiekuan
rename fv4 baifang
keep if _merge==3
drop _merge
gen ft200=0
replace ft200=1 if ft201>0
drop cfps_birthy  cfps2012latest_school cfps2012_latest_edu cfps2012_latest_r1 cfps_muru cfps2012_child_walk cfps2012_child_speak cfps2012_child_count cfps2012_child_pee te4 wf602m wf604m wg2 wg204_a_1 wg204_a_2 wg204_a_3 wg204_a_4 wg204_a_5 wg204_a_6 dg204 cfps2014sch cfps2014edu cfps2014eduy cfps2014eduy_im tb1y_a_f alive_a14_f tb1y_a_m alive_a14_m   code_b_1              
rename countyid14 countyid
rename cid14 cid
rename urban14 urban		   		   
rename cfps2014_age age
rename cfps_gender gender
rename wa105a muru
rename wa4 hukou
rename wa6code minzu
rename wb202_new wb202
rename wb203_new wb203
rename wb5 walk
rename wb6 speak
rename wb7 count
rename wb8 pee
rename wb9 TVtime
rename wc3 ill
rename wd1 exp
rename wd5total_m wd5total
rename wf3m school
rename wf302 grade
rename code_a_f fid_f
rename code_a_m fid_m
rename tb4_a14_f edu_f
rename tb4_a14_m edu_m
drop  familysize14 
rename wd503m wd503r
rename wd577 wd577rn
sum wg203m_s_1 wg203m_s_2 wg203m_s_3
gen wt2=0
replace wt2=1 if wg203m_s_1==1
replace wt2=1 if wg203m_s_2==1
replace wt2=1 if wg203m_s_3==1
gen wt3=0
replace wt3=1 if wg203m_s_1==2
replace wt3=1 if wg203m_s_2==2
replace wt3=1 if wg203m_s_3==2
gen wt4=0
replace wt4=1 if wg203m_s_1==3
replace wt4=1 if wg203m_s_2==3
replace wt4=1 if wg203m_s_3==3
gen wt5=0
replace wt5=1 if wg203m_s_1==4
replace wt5=1 if wg203m_s_2==4
replace wt5=1 if wg203m_s_3==4
gen wt6=0
replace wt6=1 if wg203m_s_1==5
replace wt6=1 if wg203m_s_2==5
replace wt6=1 if wg203m_s_3==5
sum wt2 wt3 wt4 wt5 wt6
drop wg203m_s_1 wg203m_s_2 wg203m_s_3

merge 1:1 pid using "G:\2010-2022数据汇总\cfps2014child_201906.dta",keepusing (pid_f pid_m wf113 wf101 we405 wz301)
keep if _merge==3
drop _merge
rename wf113 takekids
rename wf101 preschool
drop we401 we402 TVtime fid_f fid_m 
merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe

egen child_count = count(fid), by(fid)
tab  child_count
***以2010年为基期进行折算wc701 wc802 wd402 wd507 wd501 wd502a wd511 wd505m wd512 wd513 wd504 wd503r wd577rn wd5total total_asset fincome1 fincome1_per fp510 ft1 ft101 ft201
sum wc701 wc802 wd402 wd507 wd501 wd502a wd511 wd505m wd512 wd513 wd504 wd503r wd577rn wd5total total_asset fincome1 fincome1_per fp510 ft1 ft101 ft201
gen edutotal=.
replace edutotal=wd5total/1.086
replace edutotal=. if wd5total<0
replace wd503r=wd503r/1.086
replace wd503r=. if wd503r<0
replace wc802=wc802/1.086
replace wc802=. if wc802<0
replace wd577rn=wd577rn/1.086
replace wd577rn=. if wd577rn<0
replace wd402=wd402/1.086
replace wd402=. if wd402<0
replace wc701=wc701/1.086
replace wc701=. if wc701<0
replace fp510=fp510/1.086
replace fp510=. if fp510<0
replace fincome1=fincome1/1.086
replace total_asset=total_asset/1.086
replace fincome1_per=fincome1_per/1.086
replace ft1=ft1/1.086
replace ft1=. if ft1<0
replace ft101=ft101/1.086
replace ft101=. if ft101<0
replace ft201=ft201/1.086
replace ft201=. if ft201==-8
replace wd507=wd507/1.086
replace wd507=. if wd507<0
replace wd501=wd501/1.086
replace wd501=. if wd501<0
replace wd502a=wd502a/1.086
replace wd502a=. if wd502a<0
replace wd511=wd511/1.086
replace wd511=. if wd511<0
replace wd505m=wd505m/1.086
replace wd505m=. if wd505m<0
replace wd512=wd512/1.086
replace wd512=. if wd512<0
replace wd513=wd513/1.086
replace wd513=. if wd513<0
replace wd504=wd504/1.086
replace wd504=. if wd504<0
replace fu201=. if fu201<0
replace fu201=fu201/1.086
replace jiekuan=. if jiekuan<0
replace jiekuan=jiekuan/1.086
replace baifang=. if baifang<0

***对其家庭纯收入和家庭净资产进行分类
sum total_asset fincome1  fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<164364.6
replace totalasset_stage=3 if total_asset>=164364.6 & total_asset<=9816563 
gen fincome1_stage=.
replace fincome1_stage=0 if fincome1<34530.39   
replace fincome1_stage=1 if fincome1>=34530.39 & fincome1<=3703352  
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per<6577.216 
replace fincome1per_stage=1 if fincome1_per>=6577.216 & fincome1_per<=1234450

***将受教育水平进行分类grade edu_f edu_m
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade
save"D:\tongyi data\20141.dta",replace




***2012 缺少 wd101code wd3 wd301  有 wm401_b_1 wm402_b_1
use "G:\2010-2022数据汇总\cfps2012child_201906.dta",clear
gen survey_count = .
// 2. 按条件赋值：fid12与某个变量相等时，赋予对应次数
replace survey_count = 2 if fid12 == fid10   
replace survey_count = 1 if survey_count == . 
// 查看前20行的匹配情况
list fid10 fid12 survey_count in 1/20
// 统计survey_count的分布，确认是否符合预期
tab survey_count, missing
keep pid fid12 provcd countyid cid cfps_minzu cfps2012_birthy cfps2012_age cfps2012_gender cyear wa103 wa104 wa4 wb202 wb202_1 wb203 wb203_1 wb401 wb402 wb5 wb6 wb7 wb8 wc0 wc3 wc701 wd2 wd5total_m wd6total_m wf3m wf301m wf309a wf310a wf113 wf302 wf602m wf604m wg2 wa105a wc802 wd1 wd4 wd402 wd501 wd502a wd511 wd505m wd512 wd513 wd504 wd503m wd5total wz301 wz302 wf4_s_1 wf4_s_2 wf4_s_3 wf4_s_4 wf4_s_5 wf401_a_1 wf401_a_2 wf401_a_3 wf401_a_4 wf401_a_5 wf401_a_6 wf401_a_7 wf401_a_8 wf401_a_9 wf401_a_10 wf401_a_31 wg203m_s_1 wg203m_s_2 wg203m_s_3 wg203m_s_4 wg204_a_1 wg204_a_2 wg204_a_3 wg204_a_4 wg204_a_5 wg204_a_6 wg301 wg302 wg303 wg304 wg308 wg305 wg306 wc01 wc01ckp3 wh9 sch2012 edu2012 eduy2012 pid_f pid_m survey_count
keep if wa4 == 1

merge 1:1 pid fid12 using "G:\2010-2022数据汇总\cfps2012famconf_092015.dta", keepusing( tb4_a12_f tb4_a12_m tb1y_a_f alive_a_f tb1y_a_m alive_a_m familysize)
keep if _merge==3
drop _merge

gen age_f = 2012-tb1y_a_f
gen age_m = 2012-tb1y_a_m

rename cyear year
rename provcd province
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
save "D:/2012.dta",replace


use "D:\2012.dta",clear
merge m:1 fid12 using "G:\2010-2022数据汇总\cfps2012famecon_201906.dta",keepusing(stock funds derivative otherfinance savings ft1 familysize fp508 ft301 ft401 ft501 ft601 ft701 fincome1 fincome1_adj fincome1_per fincome1_per_adj total_asset ft3 ft4 ft5 ft6 ft7 fn5 fn3)
rename fn3 jiekuan 
rename fn5 fu201

gen ft201=ft301+ft401+ft501+ft601+ft701
gen ft200=0
replace ft200=1 if ft3==1|ft4==1|ft5==1|ft6==1|ft7==1
drop ft301 ft401 ft501 ft601 ft701 ft3 ft4 ft5 ft6 ft7
keep if _merge==3
drop _merge

replace wb202=wb202_1 if wb202==-8
replace wb203=wb203_1 if wb203==-8
rename fid12 fid
rename cfps_minzu minzu 
rename cfps2012_age age
rename cfps2012_gender gender 
rename wa4 hukou 
rename wa105a muru
rename wb5 walk
rename wb6 speak
rename wb7 count
rename wb8 pee
rename wf3m school
rename wf302 grade
rename wd1 exp
rename tb4_a12_f edu_f
rename tb4_a12_m edu_m
rename wf113 takekids
rename wc3 ill

drop cfps2012_birthy wb202_1 wb203_1 wd6total_m wf301m wf602m wf604m wg2 wd5total_m wg204_a_1 wg204_a_2 wg204_a_3 wg204_a_4 wg204_a_5 wg204_a_6 wc01ckp3 wh9 sch2012 edu2012 eduy2012 tb1y_a_f alive_a_f tb1y_a_m alive_a_m  wz301 wz302 wf4_s_3 wf4_s_4 wf4_s_5 wf401_a_5 wf401_a_6 wf401_a_7 wf401_a_8 wf401_a_9 wf401_a_10 wf401_a_31  wf4_s_1 wf4_s_2 wf401_a_1 wf401_a_2 wf401_a_3 wf401_a_4 fincome1_adj  fincome1_per_adj  wc01

sum wg203m_s_1 wg203m_s_2 wg203m_s_3 
gen wt2=0
replace wt2=1 if wg203m_s_1==1
replace wt2=1 if wg203m_s_2==1
replace wt2=1 if wg203m_s_3==1
gen wt3=0
replace wt3=1 if wg203m_s_1==2
replace wt3=1 if wg203m_s_2==2
replace wt3=1 if wg203m_s_3==2
gen wt4=0
replace wt4=1 if wg203m_s_1==3
replace wt4=1 if wg203m_s_2==3
replace wt4=1 if wg203m_s_3==3
gen wt5=0
replace wt5=1 if wg203m_s_1==4
replace wt5=1 if wg203m_s_2==4
replace wt5=1 if wg203m_s_3==4
gen wt6=0
replace wt6=1 if wg203m_s_1==5
replace wt6=1 if wg203m_s_2==5
replace wt6=1 if wg203m_s_3==5
sum wt2 wt3 wt4 wt5 wt6
drop wg203m_s_1 wg203m_s_2 wg203m_s_3 wg203m_s_4

merge 1:1 pid using "G:\2010-2022数据汇总\cfps2012child_201906.dta",keepusing (urban12 wf101 wd577 we405 we403 wz301)
keep if _merge == 3
drop _merge 
rename urban12 urban 
rename wf101 preschool
rename wd503m wd503r
rename wd577 wd577rn
merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe
egen child_count = count(fid), by(fid)
tab  child_count
***以2010年为基期进行折算wc701 wc802 wd402 wd501 wd502a wd511 wd505m wd512 wd513 wd504 wd503r wd5total total_asset fincome1 fincome1_per ft1 fp508 stock funds derivative otherfinance ft201 wd577rn savings

gen edutotal=.
replace edutotal=wd5total/1.029
replace edutotal=. if wd5total<0
replace wd503r=wd503r/1.029
replace wd503r=. if wd503r<0
replace wc802=wc802/1.029
replace wc802=. if wc802<0
replace wd577rn=wd577rn/1.029
replace wd577rn=. if wd577rn<0
replace wd402=wd402/1.029
replace wd402=. if wd402<0
replace wc701=wc701/1.029
replace wc701=. if wc701<0
replace fincome1=fincome1/1.029
replace total_asset=total_asset/1.029
replace fincome1_per=fincome1_per/1.029
replace ft1=ft1/1.029
replace ft1=. if ft1<0
replace savings=savings/1.029
replace savings=. if savings<0
replace stock=stock/1.029
replace stock=. if stock<0
replace funds=funds/1.029
replace funds=. if funds<0
replace derivative=derivative/1.029
replace derivative=. if derivative<0
replace otherfinance=otherfinance/1.029
replace otherfinance=. if otherfinance<0
replace ft201=ft201/1.029
replace ft201=. if ft201==-8
replace wd501=wd501/1.029
replace wd501=. if wd501<0
replace wd502a=wd502a/1.029
replace wd502a=. if wd502a<0
replace wd511=wd511/1.029
replace wd511=. if wd511<0
replace wd505m=wd505m/1.029
replace wd505m=. if wd505m<0
replace wd512=wd512/1.029
replace wd512=. if wd512<0
replace wd513=wd513/1.029
replace wd513=. if wd513<0
replace wd504=wd504/1.029
replace wd504=. if wd504<0
replace fu201=. if fu201<0
replace fu201=fu201/1.029
replace jiekuan=. if jiekuan<0
replace jiekuan=jiekuan/1.029

***对其家庭纯收入和家庭净资产进行分类
sum total_asset fincome1 fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<132021.4   
replace totalasset_stage=3 if total_asset>132021.4 & total_asset<=7860155 
gen fincome1_stage=.
replace fincome1_stage=0 if fincome1<26530.61   
replace fincome1_stage=1 if fincome1>= 26530.61 & fincome1<=735782.3  
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per<4904.033
replace fincome1per_stage=1 if fincome1_per>=4904.033 & fincome1_per<=168448.3

***将受教育水平进行分类grade edu_f edu_m
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade
drop year
gen year=2012
save "D:\tongyi data\20121.dta",replace



***2010  缺少takekids wd402 
use "G:\2010-2022数据汇总\cfps2010child_201906.dta",clear
gen survey_count = 1
keep if wa4 == 1
keep pid fid cid provcd countyid psu urban cyear gender wa1age wa103 wa104 wa4 wa6code wb5 wa105 wb6 wb7 wb8 wb1 wb2 wc3 wc4 wc701 wc802 wd2 wd3 wd301 wd4 wb4 wz302 wd1 wd101code wd501 wd502 wd503 wd504 wd505 wd506 wd5total wf3 wf1 wf301 wf302 wf309a wf310a wf4_s_1 wf4_s_2 wf4_s_3 wf4_s_4 wf4_s_5 wf4_s_6 wf401_a_1 wf401_a_2 wf401_a_3 wf401_a_4 wf401_a_5 wf401_a_6 wf401_a_7 wf401_a_8 wf401_a_9 wf401_a_10 wf401_a_11 wf401_a_77 wf602 wf604 kr401 kr410 kr411 kr412_s_1 kr412_s_2 kr412_s_3 kr412_s_4 kr412_s_5 kr412_s_6 kr412_s_7 wm207 wm208 tb4_a_f tb5_code_a_f tb501_a_f code_a_f code_a_m tb4_a_m tb5_code_a_m tb501_a_m cfps2010edu_best cfps2010eduy_best cfps2010sch_best feduc foccupcode foccupisco fparty moccupcode meduc moccupisco mparty survey_count 
merge 1:1 pid fid using "G:\2010-2022数据汇总\cfps2010famconf_202008.dta", keepusing( tb1b_a_f tb1b_a_m alive_a_f alive_a_m familysize)
rename _merge merge2
keep if  merge2 == 3
rename tb1b_a_f age_f
rename tb1b_a_m age_m
rename cyear year
rename provcd province
decode province, gen(province_str)  // 将数值标签转为字符串（生成新变量province_str）
drop province  // 删除原数值型变量
rename province_str province  // 新变量重命名为province（字符串型）
describe province
save "D:/2010.dta",replace 


use"D:\2010.dta",clear  
merge m:1 fid using "G:\2010-2022数据汇总\cfps2010famecon_202008.dta",keepusing(faminc_net  indinc_net total_asset fh404 ff2 ff302_a_1 ff302_a_2 fc301 ff3_s_1 ff3_s_2 ff3_s_3 fh201_a_3 fc1)
rename fc301 fu201
rename fh201_a_3 jiekuan
rename fc1 baifang
keep if _merge==3
drop _merge
gen ft201=ff302_a_1+ff302_a_2
gen ft200=0
replace ft200=1 if ff3_s_1==5| ff3_s_2==5| ff3_s_3==5
drop ff302_a_1 ff302_a_2 ff3_s_1 ff3_s_2 ff3_s_3
rename wa1age age 
rename wa4 hukou 
rename wa6code minzu
rename wb5 walk
rename wb6 speak
rename wb7 count
rename wb8 pee
rename wc3 ill
rename wd1 exp
rename wf1 preschool
rename wf3 school 
rename wf302 grade
rename faminc_net fincome1
rename indinc_net fincome1_per
rename tb4_a_f edu_f
rename tb4_a_m edu_m
drop wa105 wc4 wz302 wf301 wf4_s_1 wf4_s_2 wf4_s_3 wf4_s_4 wf4_s_5 wf4_s_6 wf401_a_1 wf401_a_2 wf401_a_3 wf401_a_4 wf401_a_5 wf401_a_6 wf401_a_7 wf401_a_8 wf401_a_9 wf401_a_10 wf401_a_11 wf401_a_77  wf602 wf604 kr401 kr410 kr411 kr412_s_1 kr412_s_2 kr412_s_3 kr412_s_4 kr412_s_5 kr412_s_6 kr412_s_7 wm207 wm208 cfps2010edu_best cfps2010eduy_best cfps2010sch_best alive_a_f alive_a_m 

merge 1:1 pid using "G:\2010-2022数据汇总\cfps2010child_201906.dta",keepusing (wc1 wa105 wd510 wg1 wg101 wg2 wg201 we405 we403 wz301 wg203_s_1 wg203_s_2 wg203_s_3 wg203_s_4 wg203_s_5 wg203_s_6 wg203_s_7 )
keep if _merge == 3
drop _merge
sum wg203_s_1 wg203_s_2 wg203_s_3 wg203_s_4 wg203_s_5 wg203_s_6 wg203_s_7
gen wt2=0
replace wt2=1 if wg203_s_1==1
replace wt2=1 if wg203_s_2==1
replace wt2=1 if wg203_s_3==1
replace wt2=1 if wg203_s_4==1
replace wt2=1 if wg203_s_5==1
replace wt2=1 if wg203_s_6==1
replace wt2=1 if wg203_s_7==1

replace wt2=1 if wg203_s_1==2
replace wt2=1 if wg203_s_2==2
replace wt2=1 if wg203_s_3==2
replace wt2=1 if wg203_s_4==2
replace wt2=1 if wg203_s_5==2
replace wt2=1 if wg203_s_6==2
replace wt2=1 if wg203_s_7==2

replace wt2=1 if wg203_s_1==3
replace wt2=1 if wg203_s_2==3
replace wt2=1 if wg203_s_3==3
replace wt2=1 if wg203_s_4==3
replace wt2=1 if wg203_s_5==3
replace wt2=1 if wg203_s_6==3
replace wt2=1 if wg203_s_7==3

gen wt3=.

gen wt4=0
replace wt4=1 if wg203_s_1==4
replace wt4=1 if wg203_s_2==4
replace wt4=1 if wg203_s_3==4
replace wt4=1 if wg203_s_4==4
replace wt4=1 if wg203_s_5==4
replace wt4=1 if wg203_s_6==4
replace wt4=1 if wg203_s_7==4

replace wt4=1 if wg203_s_1==5
replace wt4=1 if wg203_s_2==5
replace wt4=1 if wg203_s_3==5
replace wt4=1 if wg203_s_4==5
replace wt4=1 if wg203_s_5==5
replace wt4=1 if wg203_s_6==5
replace wt4=1 if wg203_s_7==5

replace wt4=1 if wg203_s_1==6
replace wt4=1 if wg203_s_2==6
replace wt4=1 if wg203_s_3==6
replace wt4=1 if wg203_s_4==6
replace wt4=1 if wg203_s_5==6
replace wt4=1 if wg203_s_6==6
replace wt4=1 if wg203_s_7==6

replace wt4=1 if wg203_s_1==7
replace wt4=1 if wg203_s_2==7
replace wt4=1 if wg203_s_3==7
replace wt4=1 if wg203_s_4==7
replace wt4=1 if wg203_s_5==7
replace wt4=1 if wg203_s_6==7
replace wt4=1 if wg203_s_7==7

replace wt4=1 if wg203_s_1==8
replace wt4=1 if wg203_s_2==8
replace wt4=1 if wg203_s_3==8
replace wt4=1 if wg203_s_4==8
replace wt4=1 if wg203_s_5==8
replace wt4=1 if wg203_s_6==8
replace wt4=1 if wg203_s_7==8

replace wt4=1 if wg203_s_1==9
replace wt4=1 if wg203_s_2==9
replace wt4=1 if wg203_s_3==9
replace wt4=1 if wg203_s_4==9
replace wt4=1 if wg203_s_5==9
replace wt4=1 if wg203_s_6==9
replace wt4=1 if wg203_s_7==9
gen wt5=0
replace wt5=1 if wg203_s_1==10
replace wt5=1 if wg203_s_2==10
replace wt5=1 if wg203_s_3==10
replace wt5=1 if wg203_s_4==10
replace wt5=1 if wg203_s_5==10
replace wt5=1 if wg203_s_6==10
replace wt5=1 if wg203_s_7==10
gen wt6=.
sum wt2 wt3 wt4 wt5 wt6
drop wg203_s_1 wg203_s_2 wg203_s_3 wg203_s_4 wg203_s_5 wg203_s_6 wg203_s_7 

rename wc1 wc0
rename wa105 muru
rename wg101 wt602
rename wg201 wt202

merge 1:1 pid using "G:\2010-2022数据汇总\cfps2010famconf_202008.dta",keepusing (pid_f pid_m)
keep if _merge == 3
drop _merge
drop mparty moccupisco moccupcode meduc fparty foccupisco foccupcode feduc tb501_a_m tb5_code_a_m tb501_a_f tb5_code_a_f code_a_m code_a_f

gen wb401=. 
replace wb401=(12-wb4/4)/2
gen wb402=wb401
label variable wb401 "过去12个月与父亲同住时间"
label variable wb402 "过去12个月与母亲同住时间（月）"
gen wb202=wb2
gen wb203=wb2
label variable wb202 "白天孩子谁照顾"
label variable wb203 "晚上孩子谁照顾"
drop wb1 wb2 wb4 psu

merge m:1 province year using "D:\robot.dta",keepusing(robot_CN iv1 iv2)
keep if _merge == 3
drop _merge 
describe
* 1. 计算变量fincome1_per的25%、50%、75%分位数
_pctile fincome1_per, p(25 50 75)
* 2. （可选）显示分位数，用于检查结果
display "25%分位数: " r(r1)
display "50%分位数（中位数）: " r(r2)
display "75%分位数: " r(r3)
* 3. 生成字符型分组变量（初始为空字符串，避免数值转字符的冗余）
gen fincome1_per_p = ""
* 4. 根据分位数结果进行分组（使用计算出的r(r1)/r(r2)/r(r3)，而非硬编码数值）
replace fincome1_per_p = "最低25%" if fincome1_per > 0 & fincome1_per <= r(r1)
replace fincome1_per_p = "中下25%" if fincome1_per > r(r1) & fincome1_per <= r(r2)
replace fincome1_per_p = "中上25%" if fincome1_per > r(r2) & fincome1_per <= r(r3)
replace fincome1_per_p = "最高25%" if fincome1_per > r(r3)
egen child_count = count(fid), by(fid)
tab  child_count

***生成edutotal wc701 wc802 fincome1 fincome1_per total_asset ff2 fh404 wd510 wt602 wt202 wd501 wd502 wd503 wd504 wd505 wd506 wd5total ft201
sum wc701 wc802 fincome1 fincome1_per total_asset ff2 fh404 wd510 wt602 wt202 wd501 wd502 wd503 wd504 wd505 wd506 wd5total ft201
replace wd5total=. if wd5total<0
gen edutotal=wd5total
replace wc701=. if wc701<0
replace wc802=. if wc802<0
replace ff2=. if ff2<0
replace fh404=. if fh404<0
replace wd510=. if wd510<0
replace wt602=. if wt602<0
replace wt202=. if wt202<0
replace wd501=. if wd501<0
replace wd502=. if wd502<0
replace wd503=. if wd503<0
replace wd504=. if wd504<0
replace wd505=. if wd505<0
replace wd506=. if wd506<0
replace ft201=. if ft201==-8
replace fu201=. if fu201<0
replace jiekuan=. if jiekuan<0
replace baifang=. if baifang<0
***对其家庭纯收入和家庭净资产进行分类
sum total_asset fincome1 fincome1_per,detail
gen totalasset_stage=.
replace totalasset_stage=1 if total_asset<0
replace totalasset_stage=2 if total_asset>=0 & total_asset<91000  
replace totalasset_stage=3 if total_asset>=91000 & total_asset<=3.00e+07  
gen fincome1_stage=.
replace fincome1_stage=0 if fincome1>=0 & fincome1<19000     
replace fincome1_stage=1 if fincome1>=19000 & fincome1<=2042105   
gen fincome1per_stage=.
replace fincome1per_stage=0 if fincome1_per<3750
replace fincome1per_stage=1 if fincome1_per>=3750 & fincome1_per<=340350.8
***将受教育水平进行分类grade edu_f edu_m
replace edu_m=. if edu_m<0
replace edu_f=. if edu_f<0
replace grade=0 if age<6 & age>=2 & school==1 & grade==-8
replace grade=. if grade<0
sum edu_f edu_m grade 
drop year
gen year=2010
save "D:\tongyi data\20101.dta",replace


***核算辅导班时间，合并其他年份的机器人数据，修改变量名，把所有数据都合并一起，跑双向固定效应回归。

use "D:\tongyi data\20221.dta",replace
append using "D:\tongyi data\20101.dta",force
append using "D:\tongyi data\20121.dta",force
append using "D:\tongyi data\20141.dta",force
append using "D:\tongyi data\20161.dta",force
append using "D:\tongyi data\20181.dta",force
append using "D:\tongyi data\20201.dta",force

sort province year

***we403 wd2 
***wd503r wd501a wd501 wd502 wd503 wd504 wd505 wd506 wd510 wd502a wd511 wd505m wd512 wd513 wd577rn wd507 wd501b wr4 wd504a wd501b wd577rn

tab year if wd507!=.
drop wd507 wr4
tab year if wd512!=.  //仅12-14、20有择校费
tab year if wd502!=.
tab year if wd502a!=.  //书本费
replace wd502a=wd502 if year==2010
drop wd502
tab year if wd503!=.
tab year if wd503r!=.  //课外辅导费
replace wd503r=wd503 if year==2010
drop wd503
tab year if wd505m!=.
tab year if wd505!=.  //交通费
replace wd505m=wd505 if year==2010
drop wd505
tab year if wd513!=. //住校伙食费
tab year if wd504!=.  //住校费
tab year if wd511!=.  //仅12-14年有教育软件费
tab year if wd506!=.
tab year if wd577rn!=.  //其他费用
replace wd577rn=wd506 if year==2010 
drop wd506
tab year if wd501!=.  //学杂费
tab year if wd501b!=.  //学校教育费用
replace wd501=wd577rn+wd501b if year==2016  //学杂费
replace wd501=wd577rn+wd501b if year==2018
replace wd501=wd512+wd577rn+wd501b if year==2020
replace wd501=wd577rn+wd501b if year==2022
drop wd501b wd577rn wd512 
tab year if we403!=.
des finance_asset otherfinance derivative funds stock savings  wd513 wd511 wd511 wd501 wd504 ff2 fh404 wd510 wt602 wt202
sum finance_asset otherfinance derivative funds stock savings wd513 wd511 wd511 wd501 wd504 ff2 fh404 wd510 wt602 wt202
sum ft200
replace ft200=. if ft200<0
sum finance_asset otherfinance derivative funds stock savings ff2
sum ft201 ft101 ft1
tab year if finance_asset!=.
tab year if otherfinance!=.
tab year if derivative!=.
tab year if funds!=.
tab year if stock!=.
tab year if ff2!=.
tab year if ft1!=.
tab year if ft101!=.
tab year if ft201!=.
replace ft1=ff2 if year==2010
replace ft1=ff2 if year==2011
drop ff2 finance_asset otherfinance derivative funds stock savings
sum wd513 wd511 wd501 wd504  fh404 wd510 wt602 wt202 wd5total fp510 edutotal
***wd501学杂费 wd503r课外辅导费(暂无需重新跑)
tab year if wd513!=.
tab year if wd5total!=.
tab year if wd511!=.
tab year if wd501!=.
tab year if wd504!=.
tab year if fh404!=.
tab year if wd510!=.
tab year if wt602!=.
tab year if wt202!=.
tab year if fp510!=.
tab year if edutotal!=.  //儿童教育费用支出
tab year if wd503r!=.   //儿童课外辅导支出
tab year if wd501!=.  //儿童学杂费
sum edutotal wd501 wd503r
drop wd513 wd511 wd504  fh404 wd510 wt602 wt202 wd5total fp510 
des fw7 fw8 fw23 fw241 fz202
tab year if fw7 !=.
tab year if fw8!=.
tab year if fw23!=.
tab year if fw241!=.
tab year if fz202!=.
drop fw7 fw8 fw23 fw241 fz202
sum exp wz301 we403 we405 wd502a
tab year if exp !=.
tab year if wz301!=.
tab year if we403!=.
tab year if we405!=.
tab year if wd502a!=.

replace wd2=. if wd2<3
replace wd2=. if wd2>9

replace wz301=. if wz301<1
replace wz301=. if wz301==79	 

replace we405=. if we405<1
replace we405=. if we405>5

replace we403=. if we403<1
replace we403=. if we403>5
sum wd2 wz301 we403  we405

replace wt1=. if wt1<0 //是否参加辅导班
replace wt1=. if wt1==79
replace wt2=. if wt2<0  //是否参加学校辅导
replace wt2=. if wt2==79
replace wt3=. if wt3<0  //是否参加竞赛辅导
replace wt3=. if wt3==79
replace wt4=. if wt4<0  //是否参加才艺培养
replace wt4=. if wt4==79
replace wt5=. if wt5<0  //是否参加心智开发
replace wt5=. if wt5==79
replace wt6=. if wt6<0  //是否参加亲子活动
replace wt6=. if wt6==79
replace wt7=. if wt7<0  //是否参加其他辅导班
replace wt7=. if wt7==79
replace wt8=. if wt8<0  //是否请家教
replace wt8=. if wt8==79
replace edu_f=. if edu_f==9
replace edu_m=. if edu_m==9
sum edu_f edu_m

sum edu_f edu_m total_asset familysize child_count gender age grade
replace gender =. if gender == -8
replace familysize =. if familysize == -8
winsor total_asset, gen(asset_new) p(0.01)
replace age=. if age<0
replace grade=. if grade<0
sum edutotal wz301 wd2 wd503r we405 ft1 ft200 we403 wt1 wt2 wt3 wt4 wt5 wt6 wt7 wt8 


tab year if fid!=.
replace fid=fid14 if year==2014
drop fid14
tab year if exp!=.
tab year if wd101code!=.
replace exp=wd101code if year==2020
drop wd101code

tab year if wg1!=.
tab year if wg2!=.
tab year if wt1!=.
replace wt1=wg1 if year==2010
replace wt8=wg2 if year==2010
replace wt6=wg1 if year==2010
drop wg1 wg2
drop merge2
drop wd501a wd504a wd502a wd505m
replace familysize=familysize20 if year==2020
drop familysize20
/*drop if edutotal==.  //删去=.的观测值
tab edutotal  //34694
tab wd503r  //n=25179
tab ft200   //n=20183
tab ft201   //23550
tab ft1  //26725
tab ft101 */
merge m:1 countyid using "D:\顺序码匹配.dta",keepusing (city cityname)  //损失3287个观测值
keep if _merge==3
drop _merge
save "D:\tongyi data\hebing1.dta",replace

***将区县匹配到市，使用合并市层面的机器人渗透度
merge m:1 year city using "D:\tongyi data\2006-2019cityrobot.dta",keepusing(robot_installation robot_stock iv_installation iv_stock)  //使用city合并损失5490个观测值，使用cityname合并损失个观测值
keep if _merge==3
drop _merge
merge m:1 year city using "D:\tongyi data\IT.dta",keepusing(internet)  //损失200个观测值
keep if _merge==3
drop _merge
merge m:1 year city using "D:\tongyi data\ITworker.dta",keepusing(ITworker) 
keep if _merge==3
drop _merge

save "D:\tongyi data\hebing12.dta",replace







