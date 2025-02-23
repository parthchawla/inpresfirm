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

local outcomes1 share_primary share_juniorhigh /*share_seniorhigh share_bachelor*/ ///
share_primary_prod share_juniorhigh_prod /*share_seniorhigh_prod share_bachelor_prod*/
/*share_primary_male share_juniorhigh_male share_seniorhigh_male share_bachelor_male*/

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

// foreach y in `outcomes1' {
// 	eststo: qui reghdfe `y' nin if year==1996, ///
// 	allbase noomit noabsorb vce(cl regency_code)
//	
// 	eststo: qui reghdfe `y' abv_med_nin if year==1996, ///
// 	allbase noomit noabsorb vce(cl regency_code)
//	
// 	esttab using "$results/mreg1`y'.tex", ///
// 	star(* .10 ** .05 *** .01) not se noomit label replace compress
// 	eststo clear
// }
** high nin firms have lower educ in 96

// foreach y in `outcomes1' {
// 	eststo: qui reghdfe `y' en71 if year==1996, ///
// 	allbase noomit noabsorb vce(cl regency_code)
//	
// 	eststo: qui reghdfe `y' en71 if year==1996, ///
// 	allbase noomit absorb(kblir2) vce(cl regency_code)
//	
// 	esttab using "$results/mreg2`y'.tex", ///
// 	star(* .10 ** .05 *** .01) not se noomit label replace compress
// 	eststo clear
// }
** high enrollment in 71 means high firm educ in 96

foreach y in `outcomes1' {
	eststo: qui reghdfe `y' nin en71 if year==1996, ///
	allbase noomit noabsorb vce(cl regency_code)
	
	eststo: qui reghdfe `y' abv_med_nin en71 if year==1996, ///
	allbase noomit noabsorb vce(cl regency_code)
	
	esttab using "$results/mreg3`y'.tex", ///
	star(* .10 ** .05 *** .01) not se noomit label replace compress
	eststo clear
}

// foreach y in `outcomes1' {
// 	eststo: qui reghdfe `y' c.nin##c.en71 if year==1996, ///
// 	allbase noomit noabsorb vce(cl regency_code)
//	
// 	eststo: qui reghdfe `y' i.abv_med_nin##c.en71 if year==1996, ///
// 	allbase noomit noabsorb vce(cl regency_code)
//	
// 	esttab using "$results/mreg4`y'.tex", ///
// 	star(* .10 ** .05 *** .01) not se noomit label replace compress
// 	eststo clear
// }

/*
Districts that got more schools under INPRES were initially the worst off (lowest enrollment in 1971) and possibly had other disadvantages not fully captured by one baseline measure (e.g., remoteness, poverty, infrastructure deficits). Even after controlling for 1971 enrollment, there could be unobserved aspects of those low-baseline districts that still depress 1996 workforce education, leaving the coefficient on nin negative.

A positive coefficient on 1971 enrollment suggests persistence: places with higher starting enrollment rates remained better educated by 1996. At the same time, it does not fully eliminate all differences between high- and low-enrollment districts. Some low-enrollment districts may have been so far behind that adding schools (i.e., higher nin) did not bring them fully on par with the historically advantaged ones by 1996.

INPRES helped these disadvantaged districts improve—but not enough to surpass or match the already-advanced districts by 1996. This partial catch-up could still leave a residual negative correlation on nin.
*/

********************************************************************************

// foreach y in `outcomes1' {
// 	eststo: qui reghdfe `y' i.Post##c.nin ch71 en71 ///
// 	if year==1996 & (launch_yr>=84 & launch_yr<=88), ///
// 	allbase noomit absorb(regency_code kblir2) vce(cl regency_code)
//	
// 	eststo: qui reghdfe `y' i.Post##i.abv_med_nin ch71 en71 ///
// 	if year==1996 & (launch_yr>=84 & launch_yr<=88), ///
// 	allbase noomit absorb(regency_code kblir2) vce(cl regency_code)
//	
// 	esttab using "$results/.tex", ///
// 	star(* .10 ** .05 *** .01) not se noomit label replace compress
// 	eststo clear
// }

********************************************************************************
