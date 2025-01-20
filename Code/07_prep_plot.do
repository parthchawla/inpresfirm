* ------------------------------------------------------------------------------
*
*        Created by: Parth Chawla
*        Created on: Jan 9, 2025
*
* ------------------------------------------------------------------------------

cls
clear all
macro drop _all
if "`c(username)'"=="parthchawla1"	{
	global root "/Users/parthchawla1/GitHub/inpresfirm"
	global data "$root/Data"
	global graphs "$root/Graphs"
	global results "$root/Results"
}

/*
********************************************************************************
*** GDP deflator to adjust for inflation
********************************************************************************

import excel using "$data/GDP deflator.xls", clear case(lower) firstrow ///
sheet("Data")
keep if countrycode == "IDN"
drop countryname indicatorname indicatorcode

local y 1960
foreach var of varlist e-bp {
	rename `var' y_`y'
	local y = `y' + 1
}

* GDP deflator by country
reshape long y_, i(countrycode) j(year)
keep year y_
rename y_ gdp_deflator // default base year is 2010

* Create new variable for rebased deflator (1995=100)
gen gdp_deflator_1995 = gdp_deflator if year == 1995
egen base_1995 = mean(gdp_deflator_1995)
gen gdp_deflator_base1995 = (gdp_deflator/base_1995) * 100
keep year gdp_deflator_base1995

tempfile deflator
save `deflator'

********************************************************************************
*** Prep vars
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear
merge 1:1 PSID year regency_code kblir2 using "$data/firms_86_99_merged.dta", nogen

** Ed attainment ***************************************************************

* Total production workers by education level
egen edatt_prod_noprimary = rowtotal(edatt_prod_male_noprimary edatt_prod_female_noprimary), missing
egen edatt_prod_primary = rowtotal(edatt_prod_male_primary edatt_prod_female_primary), missing
egen edatt_prod_juniorhigh = rowtotal(edatt_prod_male_juniorhigh edatt_prod_female_juniorhigh), missing
egen edatt_prod_seniorhigh = rowtotal(edatt_prod_male_seniorhigh edatt_prod_female_seniorhigh), missing
egen edatt_prod_diploma3 = rowtotal(edatt_prod_male_diploma3 edatt_prod_female_diploma3), missing
egen edatt_prod_bachelor = rowtotal(edatt_prod_male_bachelor edatt_prod_female_bachelor), missing
egen edatt_prod_master = rowtotal(edatt_prod_male_master edatt_prod_female_master), missing
egen edatt_prod_phd = rowtotal(edatt_prod_male_phd edatt_prod_female_phd), missing

* Total workers (production + non-production) by education level
egen edatt_noprimary = rowtotal(edatt_prod_male_noprimary edatt_prod_female_noprimary edatt_nonprod_male_noprimary edatt_nonprod_female_noprimary), missing
egen edatt_primary = rowtotal(edatt_prod_male_primary edatt_prod_female_primary edatt_nonprod_male_primary edatt_nonprod_female_primary), missing
egen edatt_juniorhigh = rowtotal(edatt_prod_male_juniorhigh edatt_prod_female_juniorhigh edatt_nonprod_male_juniorhigh edatt_nonprod_female_juniorhigh), missing
egen edatt_seniorhigh = rowtotal(edatt_prod_male_seniorhigh edatt_prod_female_seniorhigh edatt_nonprod_male_seniorhigh edatt_nonprod_female_seniorhigh), missing
egen edatt_diploma3 = rowtotal(edatt_prod_male_diploma3 edatt_prod_female_diploma3 edatt_nonprod_male_diploma3 edatt_nonprod_female_diploma3), missing
egen edatt_bachelor = rowtotal(edatt_prod_male_bachelor edatt_prod_female_bachelor edatt_nonprod_male_bachelor edatt_nonprod_female_bachelor), missing
egen edatt_master = rowtotal(edatt_prod_male_master edatt_prod_female_master edatt_nonprod_male_master edatt_nonprod_female_master), missing
egen edatt_phd = rowtotal(edatt_prod_male_phd edatt_prod_female_phd edatt_nonprod_male_phd edatt_nonprod_female_phd), missing

* Total male workers (production + non-production) by education level
egen edatt_male_noprimary = rowtotal(edatt_prod_male_noprimary edatt_nonprod_male_noprimary), missing
egen edatt_male_primary = rowtotal(edatt_prod_male_primary edatt_nonprod_male_primary), missing
egen edatt_male_juniorhigh = rowtotal(edatt_prod_male_juniorhigh edatt_nonprod_male_juniorhigh), missing
egen edatt_male_seniorhigh = rowtotal(edatt_prod_male_seniorhigh edatt_nonprod_male_seniorhigh), missing
egen edatt_male_diploma3 = rowtotal(edatt_prod_male_diploma3 edatt_nonprod_male_diploma3), missing
egen edatt_male_bachelor = rowtotal(edatt_prod_male_bachelor edatt_nonprod_male_bachelor), missing
egen edatt_male_master = rowtotal(edatt_prod_male_master edatt_nonprod_male_master), missing
egen edatt_male_phd = rowtotal(edatt_prod_male_phd edatt_nonprod_male_phd), missing

* Share of X educ-level and above
egen edatt_prod_tot = rowtotal(edatt_prod_male_tot edatt_prod_female_tot), missing
egen edatt_tot = rowtotal(edatt_prod_male_tot edatt_prod_female_tot edatt_nonprod_male_tot edatt_nonprod_female_tot), missing
egen edatt_male_tot = rowtotal(edatt_prod_male_tot edatt_nonprod_male_tot), missing
summ edatt_prod_tot edatt_tot edatt_male_tot

gen share_primary_prod = (edatt_prod_primary+edatt_prod_juniorhigh+edatt_prod_seniorhigh+edatt_prod_diploma3+edatt_prod_bachelor+edatt_prod_master+edatt_prod_phd)/edatt_prod_tot

gen share_juniorhigh_prod = (edatt_prod_juniorhigh+edatt_prod_seniorhigh+edatt_prod_diploma3+edatt_prod_bachelor+edatt_prod_master+edatt_prod_phd)/edatt_prod_tot

gen share_seniorhigh_prod = (edatt_prod_seniorhigh+edatt_prod_diploma3+edatt_prod_bachelor+edatt_prod_master+edatt_prod_phd)/edatt_prod_tot

gen share_bachelor_prod = (edatt_prod_bachelor+edatt_prod_master+edatt_prod_phd)/edatt_prod_tot

summ share_primary_prod share_juniorhigh_prod share_seniorhigh_prod share_bachelor_prod if year==1995
summ share_primary_prod share_juniorhigh_prod share_seniorhigh_prod share_bachelor_prod if year==1996
summ share_primary_prod share_juniorhigh_prod share_seniorhigh_prod share_bachelor_prod if year==1997

gen share_primary = (edatt_primary+edatt_juniorhigh+edatt_seniorhigh+edatt_diploma3+edatt_bachelor+edatt_master+edatt_phd)/edatt_tot

gen share_juniorhigh = (edatt_juniorhigh+edatt_seniorhigh+edatt_diploma3+edatt_bachelor+edatt_master+edatt_phd)/edatt_tot

gen share_seniorhigh = (edatt_seniorhigh+edatt_diploma3+edatt_bachelor+edatt_master+edatt_phd)/edatt_tot

gen share_bachelor = (edatt_bachelor+edatt_master+edatt_phd)/edatt_tot

summ share_primary share_juniorhigh share_seniorhigh share_bachelor if year==1995
summ share_primary share_juniorhigh share_seniorhigh share_bachelor if year==1996
summ share_primary share_juniorhigh share_seniorhigh share_bachelor if year==1997

gen share_primary_male = (edatt_male_primary+edatt_male_juniorhigh+edatt_male_seniorhigh+edatt_male_diploma3+edatt_male_bachelor+edatt_male_master+edatt_male_phd)/edatt_male_tot

gen share_juniorhigh_male = (edatt_male_juniorhigh+edatt_male_seniorhigh+edatt_male_diploma3+edatt_male_bachelor+edatt_male_master+edatt_male_phd)/edatt_male_tot

gen share_seniorhigh_male = (edatt_male_seniorhigh+edatt_male_diploma3+edatt_male_bachelor+edatt_male_master+edatt_male_phd)/edatt_male_tot

gen share_bachelor_male = (edatt_male_bachelor+edatt_male_master+edatt_male_phd)/edatt_male_tot

summ share_primary_male share_juniorhigh_male share_seniorhigh_male share_bachelor_male if year==1995
summ share_primary_male share_juniorhigh_male share_seniorhigh_male share_bachelor_male if year==1996
summ share_primary_male share_juniorhigh_male share_seniorhigh_male share_bachelor_male if year==1997

* Extrapolate 1996 (pre-crisis) firm-level overall educ shares to later
gen share_primary_96 = share_primary if year==1996
egen share_primary_pre = mean(share_primary_96) if year>=1996, by(PSID)

gen share_juniorhigh_96 = share_juniorhigh if year==1996
egen share_juniorhigh_pre = mean(share_juniorhigh_96) if year>=1996, by(PSID)

gen share_seniorhigh_96 = share_seniorhigh if year==1996
egen share_seniorhigh_pre = mean(share_seniorhigh_96) if year>=1996, by(PSID)

gen share_bachelor_96 = share_bachelor_prod if year==1996
egen share_bachelor_pre = mean(share_bachelor_96) if year>=1996, by(PSID)

summ share_primary_pre share_juniorhigh_pre share_seniorhigh_pre share_bachelor_pre if year==1996
summ share_primary_pre share_juniorhigh_pre share_seniorhigh_pre share_bachelor_pre if year==1997
summ share_primary_pre share_juniorhigh_pre share_seniorhigh_pre share_bachelor_pre if year==1998
summ share_primary_pre share_juniorhigh_pre share_seniorhigh_pre share_bachelor_pre if year==1999
 
********************************************************************************

** Exports
replace pct_prod_exp = 100 if pct_prod_exp > 100
replace pct_prod_exp = pct_prod_exp/100
replace _OUTPUT = . if _OUTPUT < 0
gen exports = _OUTPUT * pct_prod_exp
gen exports_pw = exports/tot_workers

** Output
rename _OUTPUT output
gen output_pw = output/tot_workers
gen tot_goods_pw = tot_goods_produced/tot_workers

** VA, K
gen value_added_pw = value_added/tot_workers
gen total_est_val_pw = total_est_val/tot_workers

** Investment
gen inv_total_pw = inv_total/tot_workers
gen inv_private_pw = inv_private/tot_workers
gen inv_gov_pw = inv_gov/tot_workers

** Wage and Workers
egen tot_wage = rowtotal(w_sal_prod_cash w_sal_prod_inkind w_sal_nonprod_cash ///
w_sal_nonprod_inkind)
egen tot_wage_prod = rowtotal(w_sal_prod_cash w_sal_prod_inkind)
egen tot_wage_nonprod = rowtotal(w_sal_nonprod_cash w_sal_nonprod_inkind)

gen tot_wage_pw = tot_wage/tot_workers
gen tot_wage_prod_pw = tot_wage_prod/tot_paid_prod
gen tot_wage_nonprod_pw = tot_wage_nonprod/tot_paid_other
gen num_shifts_pw = num_shifts/tot_workers

** Equipment
egen tot_mach = rowtotal(mach_acq_new mach_acq_used veh_acq_new veh_acq_used)
gen tot_mach_pw = tot_mach/tot_workers

** Expenses
gen exp_rd_eng_pw = exp_rd_eng_000/tot_workers
gen exp_hr_training_pw = exp_hr_training_000/tot_workers

** Adjust for inflation
merge m:1 year using `deflator'
drop if _merge == 2
drop _merge

foreach var of varlist output output_pw ///
tot_goods_produced tot_goods_pw ///
value_added value_added_pw /// FIXED CAPITAL IS ALREADY DEFLATED
exports exports_pw ///
inv_total inv_total_pw inv_private inv_private_pw inv_gov inv_gov_pw ///
tot_wage tot_wage_pw ///
tot_wage_prod tot_wage_prod_pw tot_wage_nonprod tot_wage_nonprod_pw ///
exp_rd_eng_000 exp_rd_eng_pw ///
exp_hr_training_000 exp_hr_training_pw {
	replace `var' = `var' * (100/gdp_deflator_base1995)
}

** Log outcomes
foreach var of varlist output output_pw ///
tot_goods_produced tot_goods_pw ///
value_added value_added_pw ///
total_est_val total_est_val_pw ///
exports exports_pw ///
inv_total inv_total_pw inv_private inv_private_pw inv_gov inv_gov_pw ///
tot_mach tot_mach_pw ///
tot_wage tot_wage_pw ///
tot_wage_prod tot_wage_prod_pw tot_wage_nonprod tot_wage_nonprod_pw ///
tot_workers tot_paid_workers tot_paid_prod tot_paid_other ///
num_shifts num_shifts_pw ///
exp_rd_eng_000 exp_rd_eng_pw ///
exp_hr_training_000 exp_hr_training_pw {
	gen ln_`var' = ln(`var')
}

rename _DYRSTR launch_yr

// Anyone born between 1968 and 1972 were fully exposed to the program.
// These people turned 20 in 1988 and 1992, and jointed the workforce.

xtset PSID year
save "$data/temp_reg.dta", replace
*/

********************************************************************************
*** Plot
********************************************************************************

use "$data/temp_reg.dta", clear

local outcomes1 share_primary share_juniorhigh share_seniorhigh share_bachelor ///
share_primary_prod share_juniorhigh_prod share_seniorhigh_prod share_bachelor_prod ///
share_primary_male share_juniorhigh_male share_seniorhigh_male share_bachelor_male

local outcomes2 tfp_wrdg_va_m tfp_acf_va_m1 tfp_acf_va_m2 ///
ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ///
ln_value_added ln_value_added_pw ///
ln_total_est_val ln_total_est_val_pw // 

local outcomes3 ln_exports ln_exports_pw ///
ln_inv_total ln_inv_total_pw ln_inv_private ln_inv_private_pw ln_inv_gov ln_inv_gov_pw ///
ln_tot_mach ln_tot_mach_pw // 

local outcomes4 ln_tot_wage ln_tot_wage_pw ///
ln_tot_wage_prod ln_tot_wage_prod_pw ln_tot_wage_nonprod ln_tot_wage_nonprod_pw ///
ln_tot_workers ln_tot_paid_workers ln_tot_paid_prod ln_tot_paid_other

local outcomes5 ln_num_shifts ln_num_shifts_pw ///
ln_exp_rd_eng_000 ln_exp_rd_eng_pw ///
ln_exp_hr_training_000 ln_exp_hr_training_pw

bys year: egen med_nin = median(nin)
bys year: egen mean_nin = mean(nin)
gen abv_med_nin = (nin > med_nin)
gen abv_mean_nin = (nin > mean_nin)
summ med_nin mean_nin
tab abv_med_nin
tab abv_mean_nin

foreach y in `outcomes1' {
preserve
	collapse (mean) `y', by(year abv_med_nin)
	twoway (connected `y' year if abv_med_nin==1) || ///
		(connected `y' year if abv_med_nin==0), ///
		title("`y'", size(medium)) ///
		yla(,labs(small)) xla(,labs(small)) ///
		ytitle("", size(small)) xtitle("") ///
		legend(order(1 "Above median nin" 2 "Below median nin") ///
		size(small) rows(1) pos(6))
		graph export "$graphs/`y'_nin.png", replace
restore
}

foreach y in `outcomes2' {
preserve
	collapse (mean) `y', by(year abv_med_nin)
	twoway (connected `y' year if abv_med_nin==1) || ///
		(connected `y' year if abv_med_nin==0), ///
		title("`y'", size(medium)) ///
		yla(,labs(small)) xla(,labs(small)) ///
		ytitle("", size(small)) xtitle("") ///
		legend(order(1 "Above median nin" 2 "Below median nin") ///
		size(small) rows(1) pos(6))
		graph export "$graphs/`y'_nin.png", replace
restore
}

foreach y in `outcomes3' {
preserve
	collapse (mean) `y', by(year abv_med_nin)
	twoway (connected `y' year if abv_med_nin==1) || ///
		(connected `y' year if abv_med_nin==0), ///
		title("`y'", size(medium)) ///
		yla(,labs(small)) xla(,labs(small)) ///
		ytitle("", size(small)) xtitle("") ///
		legend(order(1 "Above median nin" 2 "Below median nin") ///
		size(small) rows(1) pos(6))
		graph export "$graphs/`y'_nin.png", replace
restore
}

foreach y in `outcomes4' {
preserve
	collapse (mean) `y', by(year abv_med_nin)
	twoway (connected `y' year if abv_med_nin==1) || ///
		(connected `y' year if abv_med_nin==0), ///
		title("`y'", size(medium)) ///
		yla(,labs(small)) xla(,labs(small)) ///
		ytitle("", size(small)) xtitle("") ///
		legend(order(1 "Above median nin" 2 "Below median nin") ///
		size(small) rows(1) pos(6))
		graph export "$graphs/`y'_nin.png", replace
restore
}

foreach y in `outcomes5' {
preserve
	collapse (mean) `y', by(year abv_med_nin)
	twoway (connected `y' year if abv_med_nin==1) || ///
		(connected `y' year if abv_med_nin==0), ///
		title("`y'", size(medium)) ///
		yla(,labs(small)) xla(,labs(small)) ///
		ytitle("", size(small)) xtitle("") ///
		legend(order(1 "Above median nin" 2 "Below median nin") ///
		size(small) rows(1) pos(6))
		graph export "$graphs/`y'_nin.png", replace
restore
}
