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
*** Plot
********************************************************************************

use "$data/temp_reg.dta", clear

********************************************************************************
keep if year>=1986
drop if year>1999
********************************************************************************

local outcomes ln_output ln_output_pw ln_tot_goods_produced ln_tot_goods_pw ///
ln_tot_workers

bys year: egen med_nin = median(nin)
gen abv_med_nin = (nin > med_nin)

collapse (mean) ln_output ln_output_pw ln_tot_goods_produced ln_tot_goods_pw ///
ln_tot_workers, by(year regency_code abv_med_nin)

foreach y in `outcomes' {
	graph box `y', over(abv_med_nin) over(year)
	graph export "$graphs/`y'_box.png", replace
}
