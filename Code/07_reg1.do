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

use "$data/firms_86_99_TFP.dta", clear
merge 1:1 PSID year regency_code kblir2 using "$data/firms_86_99_merged.dta", nogen

** Other outcomes
foreach outcome in _OUTPUT {
	lnVA
}

exit
rename _DYRSTR launch_yr
summ launch_yr

// Anyone born between 1968 and 1972 were fully exposed to the program.
// These people turned 20 in 1988 and 1992, and jointed the workforce.

xtset PSID year

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
