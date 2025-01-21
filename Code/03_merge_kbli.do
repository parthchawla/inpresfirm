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
// import excel using "$data/KBLI 2015 2009 2005.xlsx", clear firstrow
// keep Dig5_05 Dig5_09
// rename (Dig5_05 Dig5_09) (kblir2_m kblir3)
// destring, replace
// duplicates drop
// sort kblir3 kblir2_m
// by kblir3: gen seq = _n
// reshape wide kblir2_m, i(kblir3) j(seq)
// tempfile cw_kbli
// save `cw_kbli'
********************************************************************************

use "$data/firms_80_04_merged.dta", clear
rename (_KKI5D _PROD5D _PSID) (KKI5D PROD5D PSID)

merge 1:1 PSID year using "$data/kbli_out.dta"
drop if _merge == 2
drop _merge

destring kblir2 kblir2_2 kblir3 kblir3_2 kblir4, replace
ren dup dupkbli
order dupkbli kblir2 kblir2_2 kblir3 kblir3_2 kblir4 PROD5D KKI5D,after(year)

** Duplicates identification in the KBLI
list PSID year kblir2 kblir2_2 kblir3 kblir3_2 kblir4 PROD5D KKI5D if dupkbli==2,clean
replace kblir2=kblir2_2 if kblir2_2==PROD5D & dupkbli==2
replace kblir3=kblir3_2 if kblir3_2==KKI5D  & dupkbli==2
list PSID year kblir2 kblir2_2 kblir3 kblir3_2 kblir4 PROD5D KKI5D if dupkbli==2,clean
drop dupkbli kblir2_2 kblir3_2

** Replace blank KBLI
replace kblir2=PROD5D if strlen(string(PROD5D))==5 & kblir2==. & year<2000
replace kblir3=KKI5D  if strlen(string(KKI5D))==5 & kblir3==. & year>=2000 & year<2010

mdesc kblir2 if year<2000 // Till 1999
mdesc kblir3 if year<2000 // Till 1999
mdesc kblir2 if year>=2000 & year<2010 // 2000-2009
mdesc kblir3 if year>=2000 & year<2010 // 2000-2009
drop PROD5D KKI5D

replace kblir3=. if year<2000
replace kblir2=. if year>=2000 & year<2010

// merge m:1 kblir3 using `cw_kbli'
// drop if _merge==2
// drop _merge
// forval i=1/32 {
// 	replace kblir2=kblir2_m`i' if kblir2==. & year>=2000 & year<2010
// 	drop kblir2_m`i'
// }
// mdesc kblir2 if year<2000 // Till 1999
// mdesc kblir2 if year>=2000 & year<2010 // 2000-2009

** Just add kblir2 and kblir3 FE separately

order PSID year regency_code kblir2 kblir3 _DKABUP _DPROVI
drop if PSID==96.59375
save "$data/firms_80_04_merged.dta", replace
