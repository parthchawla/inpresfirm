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

gen abv_med_nin = (nin > 2.09441)

********************************************************************************
* Count how many distinct years each district has, find the max, then keep only
* districts that match that maximum.
********************************************************************************

distinct regency_code if abv_med_nin==1
distinct regency_code if abv_med_nin==0
bys regency_code: egen nyrs = nvals(year)
quietly summarize nyrs
local maxnyrs = r(max)
keep if nyrs == `maxnyrs'
drop nyrs
distinct regency_code if abv_med_nin==1
distinct regency_code if abv_med_nin==0

collapse (count) firm_count=PSID (mean) tfp_wrdg_va_m ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ln_tot_workers ///
ln_value_added ln_value_added_pw, by(year regency_code abv_med_nin)

collapse (mean) tfp_wrdg_va_m ln_output ln_output_pw ///
ln_tot_goods_produced ln_tot_goods_pw ln_tot_workers ///
ln_value_added ln_value_added_pw [aw=firm_count], by(year abv_med_nin)

twoway (connected ln_output year if abv_med_nin==1) || ///
	(connected ln_output year if abv_med_nin==0), ///
	name(g1) title("Total Output", size(medium)) ///
	yla(12.4(0.2)13.8,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(output)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)

twoway (connected ln_output_pw year if abv_med_nin==1) || ///
	(connected ln_output_pw year if abv_med_nin==0), ///
	name(g1) title("Labor Productivity", size(medium)) ///
	yla(8.4(0.2)9.6,labs(small)) xla(1987(2)1999,labs(small)) ///
	ytitle("log(output per worker)", size(small)) xtitle("") ///
	legend(order(1 "Above median INPRES intensity" 2 "Below median INPRES intensity") ///
	size(small) rows(1) pos(6)) xline(1997)
