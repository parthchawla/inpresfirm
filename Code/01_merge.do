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

use "$data/Regency-level vars/Regency-level vars.dta"
rename birthpl bps_1995
distinct bps_1995
tempfile schools
save `schools'

********************************************************************************

use "$data/crosswalk_frame514_mar18_final.dta", clear
keep province bps_1993-name_2015 Region_Code Region_Name region_level

forval i = 1993/2009 {
	order bps_`i' name_`i'
}
order bps_2014 name_2014 bps_2015 name_2015

merge m:1 bps_1995 using `schools'
drop if _merge == 1
drop _merge
order province bps_1995 name_1995 nin-nen71newish

forval yr = 1993/1999 {
	preserve
	duplicates drop bps_`yr', force
	tempfile cw`yr'
	save `cw`yr''
	restore
}

********************************************************************************

forval yr = 1986/1993 {
	use "$data/Waves/si`yr'.dta", clear
	di "`yr'"
	quietly destring, replace
	
	gen bps_1993 = _DPROVI * 100 + real(string(_DKABUP, "%02.0f"))
	merge m:1 bps_1993 using `cw1993'
	keep if _merge == 3
	drop _merge
	
	cap drop YEAR _DFYRST _DFYEND
	gen year = `yr'
	
	rename bps_1993 regency_code
	order year regency_code
	distinct regency_code
	tempfile y`yr'
	save `y`yr''
}

forval yr = 1994/1999 {
	use "$data/Waves/si`yr'.dta", clear
	di "`yr'"
	quietly destring, replace
	
	gen bps_`yr' = _DPROVI * 100 + real(string(_DKABUP, "%02.0f"))
	merge m:1 bps_`yr' using `cw`yr''
	keep if _merge == 3
	drop _merge
	
	cap drop YEAR _DFYRST _DFYEND
	gen year = `yr'
	
	rename bps_`yr' regency_code
	order year regency_code
	distinct regency_code
	tempfile y`yr'
	save `y`yr''
}

use `y1986', clear
forval yr = 1987/1999 {
	di "`yr'"
	append using `y`yr''
}

tab year
distinct regency_code
save "$data/firms_86_99_merged.dta", replace
