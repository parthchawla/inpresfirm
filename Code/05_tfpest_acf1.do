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
*** ACF using acfest (proxy: materials)
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

xtset PSID year
levelsof kblir2, local(sectors)

gen tfp_acf_va_m1 = .
foreach x of local sectors {
	quietly count if kblir2 == `x'
	di "Observations for sector `x': " r(N)
	if r(N) < 10 { // Skip with fewer than 10 observations
		display "Skipping `x' due to insufficient observations."
		continue
	}
	** Setup 2 (see Table 1 in the Manjon et al acf paper):
	*** Y: Value-added
	*** State variable: Capital
	*** Proxy: Materials
	cap acfest lnVA if kblir2 == `x', state(lnK) free(lnL) proxy(lnM) ///
	va robust nbs(50)
	cap predict temp, omega
	cap replace tfp_acf_va_m1 = temp if kblir2 == `x'
	cap drop temp
}

la var tfp_acf_va_m1 "log(TFP), proxy: mat, va, acf (acfest)"
save "$data/firms_86_99_TFP.dta", replace

********************************************************************************
*** Distributions
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

// Drop outliers:
summ tfp_acf_va_m1, detail
scalar tfp_acf_va_m1_p1 = r(p1)
scalar tfp_acf_va_m1_p99 = r(p99)
drop if tfp_acf_va_m1 < tfp_acf_va_m1_p1 | tfp_acf_va_m1 > tfp_acf_va_m1_p99

collapse (mean) tfp_acf_va_m1, by(PSID)

hist tfp_acf_va_m1, freq name(g1) ///
title("Avg. firm TFP (1986-99) estimated using the ACF method with materials as proxy", size(small)) ///
xtitle("log(TFP) (va)", size(small)) ytitle("Freq.", size(small)) ///
xla(,labsize(small)) ylab(,labsize(small)) ///
note("Note: TFP is estimated separately for each KBLI sector with at least 10 observations using the acfest command.", size(vsmall))
graph export "$graphs/tfp_acf_va_m1.png", replace

********************************************************************************
*** Time series
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

// Drop outliers:
summ tfp_acf_va_m1, detail
scalar tfp_acf_va_m1_p1 = r(p1)
scalar tfp_acf_va_m1_p99 = r(p99)
drop if tfp_acf_va_m1 < tfp_acf_va_m1_p1 | tfp_acf_va_m1 > tfp_acf_va_m1_p99

collapse (mean) tfp_acf_va_m1, by(year)
tsset year

tsline tfp_acf_va_m1, name(g2) ///
title("Avg. firm TFP estimated using the ACF method with materials as proxy", size(small)) ///
ytitle("log(TFP) (va)", size(small)) xtitle("") ///
xla(,labsize(small)) ylab(,labsize(small)) ///
note("Note: TFP is estimated separately for each KBLI sector with at least 10 observations using the acfest command.", size(vsmall))
graph export "$graphs/tfp_acf_va_m1_ts.png", replace

