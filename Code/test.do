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
	global root "/Users/parthchawla1/Desktop/INPRES_TFP"
	global data "$root/Data"
	global graphs "$root/Graphs"
	global results "$root/Results"
}

use "$data/ind_data_EAP_update_firms.dta", clear

gen bps_1995 = state_str + district_str
destring bps_1995, replace

rename bps_1995 birthpl

merge m:1 birthpl using "$data/Regency-level vars/Regency-level vars.dta"
distinct birthpl
keep if _merge == 3
distinct birthpl

gen launch_yr = year - age
summ launch_yr

// Anyone born between 1968 and 1972 were fully exposed to the program.
// These people turned 20 in 1988 and 1992, and jointed the workforce.

gen post_1988 = (launch_yr>1988)
forval y = 1996/2000 {

	preserve
	keep if year == `y'
	tab post_1988 year

	foreach outcome in tfp_vwm lp_va wage exports lnroutput lnrva lnrk lnroutput {

		cap noisily reghdfe `outcome' c.nin##i.post_1988 foreign soe lbr, ///
		absorb(district ind2d launch_yr) vce(cl district)

	}
	restore
}
