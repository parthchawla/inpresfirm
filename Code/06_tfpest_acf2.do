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
*** ACF using prodest (proxy: materials)
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

xtset PSID year
levelsof kblir2, local(sectors)

gen tfp_acf_va_m2 = .
foreach x of local sectors {
	quietly count if kblir2 == `x'
	di "Observations for sector `x': " r(N)
	if r(N) < 10 { // Skip with fewer than 10 observations
		display "Skipping `x' due to insufficient observations."
		continue
	}
	*** Y: Value-added
	*** State variable: Capital
	*** Proxy: Materials
    cap prodest lnVA if kblir2 == `x', state(lnK) free(lnL) proxy(lnM) ///
	va met(lp) acf reps(50)
    cap predict temp, residual
    cap replace tfp_acf_va_m2 = temp if kblir2 == `x'
    cap drop temp
}

la var tfp_acf_va_m2 "log(TFP), proxy: mat, va, acf (prodest)"
save "$data/firms_86_99_TFP.dta", replace

********************************************************************************
*** Distributions
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

// Drop outliers:
summ tfp_acf_va_m2, detail
scalar tfp_acf_va_m2_p1 = r(p1)
scalar tfp_acf_va_m2_p99 = r(p99)
drop if tfp_acf_va_m2 < tfp_acf_va_m2_p1 | tfp_acf_va_m2 > tfp_acf_va_m2_p99

collapse (mean) tfp_acf_va_m2, by(PSID)

hist tfp_acf_va_m2, freq name(g1) ///
title("Avg. firm TFP (1986-99) estimated using the ACF method with materials as proxy", size(small)) ///
xtitle("log(TFP) (va)", size(small)) ytitle("Freq.", size(small)) ///
xla(,labsize(small)) ylab(,labsize(small)) ///
note("Note: TFP is estimated separately for each KBLI sector with at least 10 observations using the prodest command.", size(vsmall))
graph export "$graphs/tfp_acf_va_m2.png", replace

********************************************************************************
*** Time series
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

// Drop outliers:
summ tfp_acf_va_m2, detail
scalar tfp_acf_va_m2_p1 = r(p1)
scalar tfp_acf_va_m2_p99 = r(p99)
drop if tfp_acf_va_m2 < tfp_acf_va_m2_p1 | tfp_acf_va_m2 > tfp_acf_va_m2_p99

collapse (mean) tfp_acf_va_m2, by(year)
tsset year

tsline tfp_acf_va_m2, name(g2) ///
title("Avg. firm TFP estimated using the ACF method with materials as proxy", size(small)) ///
ytitle("log(TFP) (va)", size(small)) xtitle("") ///
xla(,labsize(small)) ylab(,labsize(small)) ///
note("Note: TFP is estimated separately for each KBLI sector with at least 10 observations using the prodest command.", size(vsmall))
graph export "$graphs/tfp_acf_va_m2_ts.png", replace
