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
*** Run regressions (Cali)
********************************************************************************
/*
use "$data/temp_reg.dta", clear

* Did INPRES affect firm worker education levels?
// reghdfe share_primary nin en71, allbaselevels noomitted ///
// absorb(PSID kblir2 year) vce(cl kblir2)

local outcomes2 tfp_wrdg_va_m tfp_acf_va_m1 tfp_acf_va_m2 ///
ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ///
ln_value_added ln_value_added_pw ///
ln_total_est_val ln_total_est_val_pw

foreach y in `outcomes2' {
	eststo: qui reghdfe `y' c.share_primary_pre##c.nin ch71 if year>=1997, allbaselevels noomitted ///
	absorb(kblir2 year) vce(cl kblir2)

	eststo: qui reghdfe `y' c.share_primary_pre##c.nin ch71 if year>=1997, allbaselevels noomitted ///
	absorb(kblir2 year) vce(cl regency_code)
	
	eststo: qui reghdfe `y' c.share_primary_pre##c.nin ch71 if year>=1997, allbaselevels noomitted ///
	absorb(regency_code kblir2 year) vce(cl kblir2)
	
	eststo: qui reghdfe `y' c.share_primary_pre##c.nin ch71 if year>=1997, allbaselevels noomitted ///
	absorb(regency_code kblir2 year) vce(cl regency_code)
	
	esttab, star(* .10 ** .05 *** .01) not se noomitted
	eststo clear
}
*/

********************************************************************************
*** Run regressions (Duflo)
********************************************************************************

use "$data/temp_reg.dta", clear

local outcomes1 tot_edatt_pw tot_edatt_prod_pw tot_edatt_nonprod_pw

// stop overcomplicating, run Halim spec exploiting only geographic variation

** First stage, weird edatt values for 1996 and 1997; 1995 ok

// foreach y in `outcomes1' {
// 	reghdfe `y' i.year##c.nin, ///
// 	absorb(i.year##c.ch71 kblir2 regency_code) vce(cl kblir2) allbaselevels
//	
// 	reghdfe `y' nin if year==1995, ///
// 	absorb(kblir2) vce(cl kblir2)
// }

// tot_edatt_pw tot_edatt_prod_pw cl kblir2: + (incorrect)

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
// ln_tot_paid_workers ln_tot_paid_prod ln_tot_paid_other

local outcomes5 ln_num_shifts ln_num_shifts_pw ///
ln_exp_rd_eng_000 ln_exp_rd_eng_pw ///
ln_exp_hr_training_000 ln_exp_hr_training_pw

foreach y in `outcomes4' {
	
	eststo: qui reghdfe `y' i.year##c.nin, allbaselevels noomitted ///
	absorb(i.year##c.(ch71 en71) kblir2) vce(cl kblir2)
	
	eststo: qui reghdfe `y' i.year##c.nin, allbaselevels noomitted ///
	absorb(i.year##c.(ch71 en71) regency_code kblir2) vce(cl kblir2)
	
	eststo: qui reghdfe `y' i.year##c.nin, allbaselevels noomitted ///
	absorb(i.year##c.(ch71 en71) regency_code kblir2) vce(cl regency_code)
	
	esttab, star(* .10 ** .05 *** .01) not se noomitted
	eststo clear
	
}

// sig: 

/* Duflo:
xtreg yeduc  1.young#c.nin birthyr##c.ch71                     , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71)              , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71 wsppc)        , fe
*/
