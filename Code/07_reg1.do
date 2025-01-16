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

** Ed attainment
egen tot_edatt = rowtotal(edatt_prod_male_tot edatt_prod_female_tot ///
edatt_nonprod_male_tot edatt_nonprod_female_tot), missing
egen tot_edatt_prod = rowtotal(edatt_prod_male_tot edatt_prod_female_tot), missing
egen tot_edatt_nonprod = rowtotal(edatt_nonprod_male_tot edatt_nonprod_female_tot), missing

gen tot_edatt_pw = tot_edatt/tot_workers
gen tot_edatt_prod_pw = tot_edatt_prod/tot_paid_prod
gen tot_edatt_nonprod_pw = tot_edatt_nonprod/tot_paid_other

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
exp_hr_training_000 exp_hr_training_pw ///
tot_edatt tot_edatt_pw ///
tot_edatt_prod tot_edatt_prod_pw tot_edatt_nonprod tot_edatt_nonprod_pw {
	gen ln_`var' = ln(`var')
}

rename _DYRSTR launch_yr

// Anyone born between 1968 and 1972 were fully exposed to the program.
// These people turned 20 in 1988 and 1992, and jointed the workforce.

xtset PSID year
save "$data/temp_reg.dta", replace
*/

********************************************************************************
*** Run regressions
********************************************************************************

use "$data/temp_reg.dta", clear

local outcomes1 tot_edatt_pw tot_edatt_prod_pw tot_edatt_nonprod_pw

** First stage, weird edatt values for 1996 and 1997; 1995 ok

// foreach y in `outcomes1' {
// 	reghdfe `y' i.year##c.nin, ///
// 	absorb(i.year##c.ch71 kblir2 regency_code) vce(cl kblir2) allbaselevels
//	
// 	reghdfe `y' nin if year==1995, ///
// 	absorb(kblir2) vce(cl kblir2)
// }

// tot_edatt_pw tot_edatt_prod_pw cl kblir2: + (incorrect)

// EXTRAPOLATE 95 TO ALL YEARS, THEN USE IT AS INTERACTION WITH NIN <- DO THIS NEXT

local outcomes2 tfp_wrdg_va_m tfp_acf_va_m1 tfp_acf_va_m2 ///
ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ///
ln_value_added ln_value_added_pw ///
ln_total_est_val ln_total_est_val_pw

local outcomes3 ln_exports ln_exports_pw ///
ln_inv_total ln_inv_total_pw ln_inv_private ln_inv_private_pw ln_inv_gov ln_inv_gov_pw ///
ln_tot_mach ln_tot_mach_pw // sig: inv (almost all yrs)

local outcomes4 ln_tot_wage ln_tot_wage_pw ///
ln_tot_wage_prod ln_tot_wage_prod_pw ln_tot_wage_nonprod ln_tot_wage_nonprod_pw ///
ln_tot_workers ln_tot_paid_workers ln_tot_paid_prod ln_tot_paid_other

local outcomes5 ln_num_shifts ln_num_shifts_pw ///
ln_exp_rd_eng_000 ln_exp_rd_eng_pw ///
ln_exp_hr_training_000 ln_exp_hr_training_pw

foreach y in `outcomes3' {
	
	eststo: qui reghdfe `y' i.year##c.nin, allbaselevels noomitted ///
	absorb(i.year##c.ch71 kblir2) vce(cl kblir2)
	
	eststo: qui reghdfe `y' i.year##c.nin, allbaselevels noomitted ///
	absorb(i.year##c.ch71 regency_code kblir2) vce(cl kblir2)
	
	eststo: qui reghdfe `y' i.year##c.nin, allbaselevels noomitted ///
	absorb(i.year##c.ch71 regency_code kblir2) vce(cl regency_code)

	esttab, star(* .10 ** .05 *** .01) not se noomitted
	eststo clear
	
}

// For the above to work, you need to do before 1987 too, show that [year x intensity]
// coefs only start to become positive and significant after 1986


// sig: 

/* Duflo:
xtreg yeduc  1.young#c.nin birthyr##c.ch71                     , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71)              , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71 wsppc)        , fe
*/
