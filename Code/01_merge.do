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

// use "$data/crosswalk_frame514_mar18_final.dta", clear
// keep bps_1995
// sort bps_1995
// duplicates tag bps_1995, gen(dup)
// duplicates drop
// tempfile cw1
// save `cw1'
// use "$data/ind_data_EAP_update_firms.dta", clear
// merge m:1 bps_1995 using `cw1'
