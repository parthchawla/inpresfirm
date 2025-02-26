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

********************************************************************************
*** nin x post
********************************************************************************

use "$data/temp_reg.dta", clear

********************************************************************************
keep if year>=1986
drop if year>1999
********************************************************************************

local outcomes2 tfp_wrdg_va_m /*tfp_acf_va_m1 tfp_acf_va_m2*/ ///
ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ///
ln_value_added ln_value_added_pw ///
ln_total_est_val ln_total_est_val_pw // 

local outcomes3 ln_exports ln_exports_pw ///
ln_inv_total ln_inv_total_pw ln_inv_private ln_inv_private_pw ln_inv_gov ln_inv_gov_pw ///
ln_tot_mach ln_tot_mach_pw

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

xtset PSID year
gen post_97 = (year>=1997)
tab post_97

label var post_97 "Post 1997"
label var abv_med_nin "Above median"
label var nin "INPRES"
label var tfp_wrdg_va_m "WTFP"

********************************************************************************

foreach y in `outcomes2' {
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(regency_code kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(PSID regency_code kblir2 year) vce(cl regency_code)
	
	esttab using "$results/creg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}

********************************************************************************

foreach y in `outcomes3' {
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(kblir2 year) vce(cl regency_code)	
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(regency_code kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(PSID regency_code kblir2 year) vce(cl regency_code)
	
	esttab using "$results/creg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}

********************************************************************************

foreach y in `outcomes4' {
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(regency_code kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(PSID regency_code kblir2 year) vce(cl regency_code)
	
	esttab using "$results/creg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}

********************************************************************************

foreach y in `outcomes5' {
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(regency_code kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe D.`y' i.post_97##c.nin ch71 en71, ///
	allbase noomit absorb(PSID regency_code kblir2 year) vce(cl regency_code)
	
	esttab using "$results/creg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}
