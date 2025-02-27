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

forval yr = 1993/2004 {
	preserve
	duplicates drop bps_`yr', force
	tempfile cw`yr'
	save `cw`yr''
	restore
}

********************************************************************************

forval yr = 1980/1993 {
	use "$data/Waves/si`yr'.dta", clear
	di "`yr'"
	quietly destring, replace
	
	* No cw before 1993 so use 1993 before that
	gen bps_1993 = _DPROVI * 100 + real(string(_DKABUP, "%02.0f"))
	merge m:1 bps_1993 using `cw1993', keepusing(bps_1995 ///
	nin recp ch71 en71 wsppc dens71 moldyed birthlat birthlong ///
	Schools73new Schools74new Schools75new Schools76new Schools77new ///
	Schools78new pop71new ch71new totinnew ninnew nch71new atsc71new ///
	en71newish en71new nen71new nen71newish)
	keep if _merge == 3
	drop _merge
	
	capture confirm variable _FLAG
    if _rc == 0 drop _FLAG
    cap drop YEAR _DFYRST _DFYEND
	gen year = `yr'
	
	* Harmonize to 1995
	rename bps_1995 regency_code
	order year regency_code
	distinct regency_code
	drop bps_1993
	
	tempfile y`yr'
	save `y`yr''
}

forval yr = 1994/2004 {
	use "$data/Waves/si`yr'.dta", clear
	di "`yr'"
	quietly destring, replace
	
	gen bps_`yr' = _DPROVI * 100 + real(string(_DKABUP, "%02.0f"))
	merge m:1 bps_`yr' using `cw`yr'', keepusing(bps_1995 ///
	nin recp ch71 en71 wsppc dens71 moldyed birthlat birthlong ///
	Schools73new Schools74new Schools75new Schools76new Schools77new ///
	Schools78new pop71new ch71new totinnew ninnew nch71new atsc71new ///
	en71newish en71new nen71new nen71newish)
	keep if _merge == 3
	drop _merge
	
	capture confirm variable _FLAG
    if _rc == 0 drop _FLAG
    cap drop YEAR _DFYRST _DFYEND
	gen year = `yr'
	
	* Harmonize to 1995
	rename bps_1995 regency_code
	order year regency_code
	distinct regency_code
	if `yr' != 1995 {
		drop bps_`yr'
	}
	
	tempfile y`yr'
	save `y`yr''
}

use `y1980', clear
forval yr = 1981/2004 {
	di "`yr'"
	append using `y`yr''
}

tab year
distinct regency_code // 295
save "$data/firms_80_04_merged.dta", replace
