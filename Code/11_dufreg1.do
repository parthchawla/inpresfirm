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

local outcomes4 ln_tot_wage ln_tot_wage_pw ///
ln_tot_wage_prod ln_tot_wage_prod_pw ln_tot_wage_nonprod ln_tot_wage_nonprod_pw ///
ln_tot_workers ln_tot_paid_workers ln_tot_paid_prod ln_tot_paid_other

bys year: egen med_nin = median(nin)
bys year: egen mean_nin = mean(nin)
gen abv_med_nin = (nin > med_nin)
gen abv_mean_nin = (nin > mean_nin)
summ med_nin mean_nin

xtset PSID year

label var abv_med_nin "Above median"
label var nin "INPRES"
label var tfp_wrdg_va_m "WTFP"

foreach y in `outcomes4' {
	
	eststo: qui reghdfe `y' i.year##c.nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) kblir2) vce(cl regency_code)
	
	eststo: qui reghdfe `y' i.year##c.nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) regency_code kblir2) vce(cl regency_code)
	
	esttab using "$results/Regressions/dufreg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
	
}
* Same negative wage effect like Duflo

foreach y in `outcomes4' {
	
	eststo: qui reghdfe `y' i.year##i.abv_med_nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) kblir2) vce(cl regency_code)
	
	eststo: qui reghdfe `y' i.year##i.abv_med_nin, allbase noomit ///
	absorb(i.year##c.(ch71 en71) regency_code kblir2) vce(cl regency_code)
	
	esttab using "$results/Regressions/dufreg2`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
	
}

/* Duflo:
xtreg yeduc  1.young#c.nin birthyr##c.ch71                     , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71)              , fe
xtreg yeduc  1.young#c.nin birthyr##c.(ch71 en71 wsppc)        , fe
*/
