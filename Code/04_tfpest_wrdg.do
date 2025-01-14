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
*** GDP deflator to adjust for inflation
********************************************************************************

import excel using "$data/GDP deflator.xls", clear case(lower) firstrow ///
sheet("Data")
keep if countrycode == "IDN"
drop countryname indicatorname indicatorcode

local y 1960
foreach var of varlist e-bp {
	rename `var' y_`y'
	local y = `y' + 1
}

* GDP deflator by country
reshape long y_, i(countrycode) j(year)
keep year y_
rename y_ gdp_deflator // default base year is 2010

* Create new variable for rebased deflator (1995=100)
gen gdp_deflator_1995 = gdp_deflator if year == 1995
egen base_1995 = mean(gdp_deflator_1995)
gen gdp_deflator_base1995 = (gdp_deflator/base_1995) * 100
keep year gdp_deflator_base1995

tempfile deflator
save `deflator'

********************************************************************************

use "$data/firms_86_99_merged.dta", clear

* Create vars for tfp estimation
gen L = tot_workers
gen K = total_est_val
gen M = raw_mat_tot
gen VA = value_added

* Deflate
merge m:1 year using `deflator'
drop if _merge == 2
drop _merge

summ L K M VA
foreach var of varlist K M VA {
	replace `var' = `var' * (100/gdp_deflator_base1995)
}
summ L K M VA

gen lnL = ln(L)
gen lnK = ln(1+K)
gen lnM = ln(1+M)
gen lnVA = ln(1+VA)
summ lnL lnK lnM lnVA

keep PSID year regency_code kblir2 lnL lnK lnM lnVA

********************************************************************************
*** WRDG using prodest
********************************************************************************

xtset PSID year
levelsof kblir2, local(sectors)

gen tfp_wrdg_va_m = .
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
	va met(wrdg) reps(50)
    cap predict temp, residual
    cap replace tfp_wrdg_va_m = temp if kblir2 == `x'
    cap drop temp
}

la var tfp_wrdg_va_m "log(TFP), proxy: mat, va, wrdg (prodest)"
save "$data/firms_86_99_TFP.dta", replace

********************************************************************************
*** Distributions
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

// Drop outliers:
summ tfp_wrdg_va_m, detail
scalar tfp_wrdg_va_m_p1 = r(p1)
scalar tfp_wrdg_va_m_p99 = r(p99)
drop if tfp_wrdg_va_m < tfp_wrdg_va_m_p1 | tfp_wrdg_va_m > tfp_wrdg_va_m_p99

collapse (mean) tfp_wrdg_va_m, by(PSID)

hist tfp_wrdg_va_m, freq name(g1) ///
title("Avg. firm TFP (1986-99) estimated using the WRDG method with materials as proxy", size(small)) ///
xtitle("log(TFP) (va)", size(small)) ytitle("Freq.", size(small)) ///
xla(,labsize(small)) ylab(,labsize(small)) ///
note("Note: TFP is estimated separately for each KBLI sector with at least 10 observations using the prodest command.", size(vsmall))
graph export "$graphs/tfp_wrdg_va_m.png", replace

********************************************************************************
*** Time series
********************************************************************************

use "$data/firms_86_99_TFP.dta", clear

// Drop outliers:
summ tfp_wrdg_va_m, detail
scalar tfp_wrdg_va_m_p1 = r(p1)
scalar tfp_wrdg_va_m_p99 = r(p99)
drop if tfp_wrdg_va_m < tfp_wrdg_va_m_p1 | tfp_wrdg_va_m > tfp_wrdg_va_m_p99

collapse (mean) tfp_wrdg_va_m, by(year)
tsset year

tsline tfp_wrdg_va_m, name(g2) ///
title("Avg. firm TFP estimated using the WRDG method with materials as proxy", size(small)) ///
ytitle("log(TFP) (va)", size(small)) xtitle("") ///
xla(,labsize(small)) ylab(,labsize(small)) ///
note("Note: TFP is estimated separately for each KBLI sector with at least 10 observations using the prodest command.", size(vsmall))
graph export "$graphs/tfp_wrdg_va_m_ts.png", replace

