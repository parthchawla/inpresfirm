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
*** nin x post on educ (mechanism)
********************************************************************************

use "$data/temp_reg.dta", clear
//replace kblir2 = kblir3 if year>=2000 & year<2010

********************************************************************************
keep if year>=1986
drop if year>1999
********************************************************************************

local outcomes1 share_primary share_juniorhigh share_seniorhigh share_bachelor ///
share_primary_prod share_juniorhigh_prod share_seniorhigh_prod share_bachelor_prod ///
share_primary_male share_juniorhigh_male share_seniorhigh_male share_bachelor_male

bys year: egen med_nin = median(nin)
bys year: egen mean_nin = mean(nin)
gen abv_med_nin = (nin > med_nin)
gen abv_mean_nin = (nin > mean_nin)
summ med_nin mean_nin

xtset PSID year
gen Post = (launch_yr>=86)
tab Post

label var abv_med_nin "Above median"
label var nin "INPRES"

*******************************************************************************

foreach y in `outcomes1' {
	eststo: qui reghdfe `y' nin ch71 en71 if year==1996, ///
	allbase noomit noabsorb vce(cl regency_code)
	
	eststo: qui reghdfe `y' abv_med_nin ch71 en71 if year==1996, ///
	allbase noomit noabsorb vce(cl regency_code)
	
	esttab using "$results/mreg1`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}
** high nin firms have lower educ in 96

foreach y in `outcomes1' {
// 	eststo: qui reghdfe `y' en71 if year==1996, ///
// 	allbase noomit noabsorb vce(cl regency_code)
	
	eststo: qui reghdfe `y' en71 if year==1996, ///
	allbase noomit absorb(kblir2) vce(cl regency_code)
	
	esttab using "$results/mreg2`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}
** high enrollment in 71 means high firm educ in 96

// foreach y in `outcomes1' {
// 	eststo: qui reghdfe `y' i.Post##c.nin ch71 en71 ///
// 	if year==1996 & (launch_yr>=84 & launch_yr<=88), ///
// 	allbase noomit absorb(regency_code kblir2) vce(cl regency_code)
//	
// 	eststo: qui reghdfe `y' i.Post##i.abv_med_nin ch71 en71 ///
// 	if year==1996 & (launch_yr>=84 & launch_yr<=88), ///
// 	allbase noomit absorb(regency_code kblir2) vce(cl regency_code)
//	
// 	esttab using "$results/mreg3`y'.tex", ///
// 	star(* .10 ** .05 *** .01) not se noomit label replace compress
// 	eststo clear
// }

********************************************************************************
