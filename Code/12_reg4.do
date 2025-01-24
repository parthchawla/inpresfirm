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
*** Run regressions (Duflo)
********************************************************************************

use "$data/temp_reg.dta", clear

********************************************************************************
//keep if year>=1986
drop if year>1999
********************************************************************************

local outcomes3 ln_exports ln_exports_pw ///
ln_inv_total ln_inv_total_pw ln_inv_private ln_inv_private_pw ln_inv_gov ln_inv_gov_pw ///
ln_tot_mach ln_tot_mach_pw

local outcomes5 ln_num_shifts ln_num_shifts_pw ///
ln_exp_rd_eng_000 ln_exp_rd_eng_pw ///
ln_exp_hr_training_000 ln_exp_hr_training_pw

bys year: egen med_nin = median(nin)
bys year: egen mean_nin = mean(nin)
gen abv_med_nin = (nin > med_nin)
gen abv_mean_nin = (nin > mean_nin)
summ med_nin mean_nin

xtset PSID year

label var abv_med_nin "Above median"
label var nin "INPRES"
label var tfp_wrdg_va_m "WTFP"

foreach y in `outcomes3' {
	
	eststo: qui reghdfe `y' i.year##c.nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) kblir2) vce(cl regency_code)
	
	eststo: qui reghdfe `y' i.year##c.nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) regency_code kblir2) vce(cl regency_code)
	
	esttab using "$results/Regressions/dufreg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
	
}

foreach y in `outcomes3' {
	
	eststo: qui reghdfe `y' i.year##i.abv_med_nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) kblir2) vce(cl regency_code)
	
	eststo: qui reghdfe `y' i.year##i.abv_med_nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) regency_code kblir2) vce(cl regency_code)
	
	esttab using "$results/Regressions/dufreg2`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
	
}

foreach y in `outcomes5' {
	
	eststo: qui reghdfe `y' nin ch71 en71, allbase noomit ///
	absorb(year kblir2) vce(cl regency_code)
	
	eststo: qui reghdfe `y' nin ch71 en71, allbase noomit ///
	absorb(year kblir2 regency_code) vce(cl regency_code)
	
	esttab using "$results/Regressions/dufreg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
	
}

foreach y in `outcomes5' {
	
	eststo: qui reghdfe `y' abv_med_nin ch71 en71, allbase noomit ///
	absorb(year kblir2) vce(cl regency_code)
	
	eststo: qui reghdfe `y' abv_med_nin ch71 en71, allbase noomit ///
	absorb(year kblir2 regency_code) vce(cl regency_code)
	
	esttab using "$results/Regressions/dufreg2`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
	
}

/* Duflo:
xtreg yeduc  1.young#c.nin birthyr##c.ch71                     , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71)              , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71 wsppc)        , fe
*/
