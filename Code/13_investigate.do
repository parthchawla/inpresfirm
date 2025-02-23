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

local outcomes tfp_wrdg_va_m ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ln_tot_workers ///
ln_value_added ln_value_added_pw

bys year: egen med_nin = median(nin)
gen abv_med_nin = (nin > med_nin)

/*
foreach y in `outcomes' {
	forval t = 1994/1996 {
		di " "
		di "`y' `t' Above Median"
		summ `y' if year==`t' & abv_med_nin==1, detail
		hist `y' if year==`t' & abv_med_nin==1, freq ///
		title("`y' `t' abv med") xla(,labsize(small)) ylab(,labsize(small)) ///
		xtitle("", size(small)) ytitle("Freq.", size(small)) legend(off)
		graph export "$graphs/`y'_`t'_am_dist.png", replace
// 		di "`y' `t' Below Median"
// 		summ `y' if year==`t' & abv_med_nin==0, detail
// 		hist `y' if year==`t' & abv_med_nin==0, freq ///
// 		title("`y' `t' bel med") xla(,labsize(small)) ylab(,labsize(small)) ///
// 		xtitle("", size(small)) ytitle("Freq.", size(small)) legend(off)
// 		graph export "$graphs/`y'_`t'_bm_dist.png", replace
	}
}
*/

// foreach y in `outcomes' {
// 	winsor2 `y', cuts(1 99) replace
// }

// foreach y in `outcomes' {
// 	summ `y', detail
// 	scalar `y'_p1 = r(p1)
// 	scalar `y'_p99 = r(p99)
// 	replace `y' = . if `y' < `y'_p1 | `y' > `y'_p99
// }

collapse (count) firm_count=PSID (mean) tfp_wrdg_va_m ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ln_tot_workers ///
ln_value_added ln_value_added_pw, by(year regency_code abv_med_nin)

collapse (mean) tfp_wrdg_va_m ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ln_tot_workers ///
ln_value_added ln_value_added_pw [aw=firm_count], by(year abv_med_nin)

twoway (connected tfp_wrdg_va_m year if abv_med_nin==1) || ///
	(connected tfp_wrdg_va_m year if abv_med_nin==0), ///
	title("TFP", size(medium)) ///
	yla(,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(TFP)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/tfp_wrdg_va_m_winz_nin.png", replace

twoway (connected ln_output year if abv_med_nin==1) || ///
	(connected ln_output year if abv_med_nin==0), ///
	title("Total Output", size(medium)) ///
	yla(12.4(0.2)13.8,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(output)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_output_winz_nin.png", replace

twoway (connected ln_output_pw year if abv_med_nin==1) || ///
	(connected ln_output_pw year if abv_med_nin==0), ///
	title("Labor Productivity", size(medium)) ///
	yla(8.4(0.2)9.6,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(output per worker)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_output_pw_winz_nin.png", replace

twoway (connected ln_tot_goods_produced year if abv_med_nin==1) || ///
	(connected ln_tot_goods_produced year if abv_med_nin==0), ///
	title("Total Goods Produced", size(medium)) ///
	yla(12.4(0.2)13.8,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_tot_goods_produced_winz_nin.png", replace

twoway (connected ln_tot_goods_pw year if abv_med_nin==1) || ///
	(connected ln_tot_goods_pw year if abv_med_nin==0), ///
	title("Labor Productivity", size(medium)) ///
	yla(8.4(0.2)9.6,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(goods produced per worker)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_tot_goods_pw_winz_nin.png", replace

twoway (connected ln_value_added year if abv_med_nin==1) || ///
	(connected ln_value_added year if abv_med_nin==0), ///
	title("Value Added", size(medium)) ///
	yla(,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(va)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_value_added_winz_nin.png", replace

twoway (connected ln_value_added_pw year if abv_med_nin==1) || ///
	(connected ln_value_added_pw year if abv_med_nin==0), ///
	title("Value Added Per Worker", size(medium)) ///
	yla(,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(va per worker)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_value_added_pw_winz_nin.png", replace

twoway (connected ln_tot_workers year if abv_med_nin==1) || ///
	(connected ln_tot_workers year if abv_med_nin==0), ///
	title("No. of Workers", size(medium)) ///
	yla(,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(employees)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
	graph export "$graphs/ln_tot_workers_winz_nin.png", replace
