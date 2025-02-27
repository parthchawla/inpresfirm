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

use "$data/firms_80_04_merged.dta", clear

rename _DDMSTK p_own_priv
rename _DPUSAT p_own_cgov
rename _DASING p_own_for
rename _DPEMDA p_own_lgov
rename _LFANOU unpaid_workers
rename _MPMNOU prime_movers_prod
rename _MGDNOU prime_movers_elec
rename _MEMNOU electric_motors
rename _MGENOU generators
rename _CBNTCU bldg_constr_tot
rename _CLNTCU land_tot
rename _CMNTCU mach_equip_tot
rename _CTNTCU chg_fixassets
rename _CXNTCU veh_capgoods_tot

rename _MTLNOU prime_movers_num
rename _LPRNOU tot_paid_prod
rename _LNPNOU tot_paid_other
rename _LPDNOU tot_paid_workers
rename _LTLNOU tot_workers
rename _ZPSCCU w_sal_prod_cash
rename _ZPSKCU w_sal_prod_inkind
rename _ZNSCCU w_sal_nonprod_cash
rename _ZNSKCU w_sal_nonprod_inkind
rename _ZPOCCU1 ot_prod_cash
rename _ZPOKCU1 ot_prod_inkind
rename _ZNOCCU1 ot_nonprod_cash
rename _ZNOKCU1 ot_nonprod_inkind
rename _ZPICCU1 gift_prod_cash
rename _ZPIKCU1 gift_prod_inkind
rename _ZNICCU1 gift_nonprod_cash
rename _ZNIKCU1 gift_nonprod_inkind
rename _ZPECCU oth_pay_prod_cash
rename _ZPEKCU oth_pay_prod_inkind
rename _ZNECCU oth_pay_nonprod_cash
rename _ZNEKCU oth_pay_nonprod_inkind
rename _ZPDCCU tot_ws_prod_cash
rename _ZPDKCU tot_ws_prod_inkind
rename _ZNDCCU tot_ws_nonprod_cash
rename _ZNDKCU tot_ws_nonprod_inkind
rename _ZPPCCU1 pen_soc_prod_cash
rename _ZPPKCU1 pen_soc_prod_inkind
rename _ZNPCCU1 pen_soc_oth_cash
rename _ZNPKCU1 pen_soc_oth_inkind
rename _ZPACCU acc_allow_prod_cash
rename _ZPAKCU acc_allow_prod_inkind
rename _ZNACCU acc_allow_nonprod_cash
rename _ZNAKCU acc_allow_nonprod_inkind
rename _ZPTCCU tot_pay_prod_cash
rename _ZPTKCU tot_pay_prod_inkind
rename _ZNTCCU tot_pay_nonprod_cash
rename _ZNTKCU tot_pay_nonprod_inkind
rename _CLUSCU land_acq_used
rename _CLROCU land_maint_oth
rename _CLRSCU land_maint_biz
rename _CLSACU land_sale_reduct
rename _CBNECU bldg_acq_new
rename _CBUSCU bldg_acq_used
rename _CBROCU bldg_maint_oth
rename _CBRSCU bldg_maint_biz
rename _CBSACU bldg_sale_reduct
rename _CMNECU mach_acq_new
rename _CMUSCU mach_acq_used
rename _CMROCU mach_maint_oth
rename _CMRSCU mach_maint_biz
rename _CMSACU mach_sale_reduct

rename _CVNECU veh_acq_new
rename _CVUSCU veh_acq_used
rename _CVROCU veh_maint_oth
rename _CVRSCU veh_maint_biz
rename _CVSACU veh_sale_reduct
rename _CONECU othercap_acq_new
rename _COUSCU othercap_acq_used
rename _COROCU othercap_maint_oth
rename _CORSCU othercap_maint_biz
rename _COSACU othercap_sale_reduct
rename _CTNECU chgfix_new
rename _CTUSCU chgfix_used
rename _CTROCU chgfix_maint_oth
rename _CTRSCU chgfix_maint_biz
rename _CTSACU chgfix_sale_reduct
rename _MGDHPU prime_movers_elec_cap
rename _MEMHPU electric_motors_cap
rename _MGEKWU generators_cap
rename _MTLQUU prime_movers_cap
rename _EPLVCU pln_elec
rename _ENPVCU nonpln_elec
rename _OELKHU elec_sold_q
rename _YELVCU elec_sold_000
rename _EPEVCU fuel_gasoline
rename _ESOVCU fuel_diesel
rename _EDIVCU fuel_diesel_oil
rename _EOIVCU fuel_kerosene
rename _ECLVCU fuel_coal
rename _ECKVCU fuel_coke
rename _EGAVCU fuel_pub_gas
rename _ENCVCU fuel_other
rename _ELUVCU lub_total
rename _EFUVCU fuel_total
rename _IPKVCU exp_pack
rename _ISPVCU exp_spare
rename _IOFVCU exp_stationery
rename _IISVCU exp_manuf_serv
rename _IMNVCU exp_cap_maint
rename _IBRVCU rent_bldg_mach
rename _ILRVCU rent_land
rename _ITXVCU indirect_tax
rename _IINVCU exp_loan_int
rename _ICOVCU exp_charity
rename _INCVCU exp_others
rename _YISVCU inc_manuf_serv
rename _YRSVCU inc_raw_resold
rename _YRNVCU inc_leasing_oth
rename _SRMVCU stock_raw
rename _SHFVCU stock_semifin
rename _SFNVCU stock_finished

rename _MPMHPU prod_prime_movers_cap
rename _ESGKHU elec_prod_est_kwh
rename _EPLKHU elec_pln_kwh
rename _ENPKHU elec_nonpln_kwh
rename _RDNVCU raw_mat_dom
rename _RIMVCU raw_mat_imp
rename _RTLVCU raw_mat_tot
rename _EPELIU fuel_gasoline_q
rename _ESOLIU fuel_diesel_q
rename _EDILIU fuel_diesel_oil_q
rename _EOILIU fuel_kerosene_q
rename _ECLKGU fuel_coal_q
rename _ECKKGU fuel_coke_q
rename _EGAM3U fuel_pub_gas_q
rename _ELULIU lub_total_q
rename _IT1VCU other_exp_tot
rename _YPRVCU tot_goods_produced
rename _YT1VCU other_inc_tot
rename _STLVCU stock_tot
rename _VTLVCU value_added
rename _FDOMCU inv_private
rename _FRETCU inv_reinvest_earn
rename _FSHRCU inv_stock_bonds
rename _FLDOCU inv_dom_loan
rename _FLFOCU inv_for_loan
rename _FDFICU inv_for_invest
rename _FGOVCU inv_gov
rename _FNKTCU inv_cap_market
rename _FTTLCU inv_total

rename _DSRVYR survey_year
rename _F6B09 tot_elec_q_000
rename _EELKHU elec_prod_purch_sold_000
rename _ETLQUU tot_fuel_lub_000
rename _SXXXXX sum_stock_chg
rename _V1001 latex_kg
rename _V1002 sheet_rubber_kg
rename _V1003 lumb_kg
rename _V1004 crepe_kg
rename _V1005 crumb_rubber_kg
rename _V1006 tot_rubber_kg
rename _V1101 est_land_cap
rename _V1102 book_land_cap
rename _V1103 est_bldg_cap
rename _V1104 book_bldg_cap
rename _V1105 dep_bldg_cap
rename _V1106 est_mach_cap
rename _V1107 book_mach_cap
rename _V1108 dep_mach_cap
rename _V1109 est_vehic_cap
rename _V1110 book_vehic_cap
rename _V1111 dep_vehic_cap
rename _V1112 est_other_cap
rename _V1113 book_other_cap
rename _V1114 dep_other_cap
rename _V1115 total_est_val
rename _V1116 total_book_val
rename _V1117 dep_total
rename _EELVCU elec_prod_purch_sold_kw
rename _PRPRCA pct_cap_real
rename _PRPREX pct_prod_exp
rename _SHIFTL num_shifts

rename _EPEVCE fuel_gasoline_elecgen_000
rename _ESOVCE fuel_diesel_elecgen_000
rename _EDIVCE fuel_diesel_oil_elecgen_000
rename _ECLVCE fuel_coal_elecgen_000
rename _ECKVCE fuel_coke_elecgen_000
rename _ELUVCE fuel_lub_elecgen_000
rename _EFUVCE fuel_total_elecgen_000
rename _EPELIE fuel_gasoline_elecgen_q
rename _ESOLIE fuel_diesel_elecgen_q
rename _EDILIE fuel_diesel_oil_elecgen_q
rename _ECLKGE fuel_coal_elecgen_q
rename _ECKKGE fuel_coke_elecgen_q
rename _ELULIE fuel_lub_elecgen_q
rename _IREVCU oth_exp_repr_allow
rename _IROVCU oth_exp_royalty
rename _IMGVCU oth_exp_mgmt_fee
rename _IADVCU oth_exp_promo_ad
rename _IWRVCU oth_exp_water
rename _IPHVCU oth_exp_telecom
rename _ITRVCU oth_exp_travel
rename _IOTVCU oth_exp_others
rename _YRBVCU inc_rm_purch_val
rename _YRLVCU inc_rm_sale_val
rename _SRJVCU stock_rm_beg
rename _SRDVCU stock_rm_end
rename _SHJVCU stock_semi_beg
rename _SHDVCU stock_semi_end
rename _SFJVCU stock_fin_beg
rename _SFDVCU stock_fin_end
rename _STJVCU stock_all_beg
rename _STDVCU stock_all_end
rename _CEKSUM pct_own_check
rename _LPMNOU paid_prod_male
rename _LPWNOU paid_prod_female
rename _LNMNOU paid_other_male
rename _LNWNOU paid_other_female
rename _LDMNOU tot_paid_male
rename _LDWNOU tot_paid_female
rename _LTMNOU tot_male
rename _LTWNOU tot_female
rename _LFMNOU unpaid_male
rename _LFWNOU unpaid_female
rename _IPDVCU exp_pack_dom
rename _ISDVCU exp_spare_dom
rename _IOIVCU exp_stationery_imp
rename _IPIVCU exp_pack_imp
rename _ISIVCU exp_spare_imp
rename _IODVCU exp_stationery_dom
rename _CEKESO elec_forprod

rename _EFOLIU fuel_bunker_q
rename _EFOVCU fuel_bunker_000
rename _EFOLIE fuel_bunker_elecgen_q
rename _EFOVCE fuel_bunker_elecgen_000
rename _EOILIE fuel_kerosene_elecgen_q
rename _EOIVCE fuel_kerosene_elecgen_000
rename _EGAM3E fuel_pub_gas_elecgen_q
rename _EGAVCE fuel_pub_gas_elecgen_000
rename _ELPKGU fuel_lpg_q
rename _ELPVCU fuel_lpg_000
rename _ELPKGE fuel_lpg_elecgen_q
rename _ELPVCE fuel_lpg_elecgen_000
rename _ECAKGU fuel_charcoal_q
rename _ECAVCU fuel_charcoal_000
rename _ECAKGE fuel_charcoal_elecgen_q
rename _ECAVCE fuel_charcoal_elecgen_000
rename _EWOKGU fuel_firewood_q
rename _EWOVCU fuel_firewood_000
rename _EWOKGE fuel_firewood_elecgen_q
rename _EWOVCE fuel_firewood_elecgen_000
rename _ENCVCE fuel_other_elecgen_000
rename _ETLQUE tot_fuel_lub_elecgen_000
rename _DKECAM kecamatan_id
rename _DESA village_id
rename _LTL avg_workers_prev_year
rename _IENVCU exp_env_prevent_000
rename _IRDVCU exp_rd_eng_000
rename _ITDVCU exp_oth_goods_dom_000
rename _ITIVCU exp_oth_goods_imp_000
rename _ITSVCU exp_mfg_serv_000
rename _IRTVCU exp_rent_tot_000
rename _DHOIND head_office_ind
rename _ITTVCU exp_oth_goods_all_000
rename _DCONTR main_foreign_inv_country
rename _IRHVCU exp_hr_training_000

rename _YTPREX part_prod_export
rename _YSWVCU inc_remain_sales_000
rename _A6V3501 cur_assets_endprev
rename _A6V3502 cur_assets_endcurr
rename _A6V3503 fix_assets_endprev
rename _A6V3504 fix_assets_endcurr
rename _A6V3505 oth_assets_endprev
rename _A6V3506 oth_assets_endcurr
rename _A6V3507 tot_assets_endprev
rename _A6V3508 tot_assets_endcurr
rename _A6V3601 cur_liab_endprev
rename _A6V3602 cur_liab_endcurr
rename _A6V3603 lt_liab_endprev
rename _A6V3604 lt_liab_endcurr
rename _A6V3605 eq_initial_endprev
rename _A6V3606 eq_initial_endcurr
rename _A6V3607 eq_add_endprev
rename _A6V3608 eq_add_endcurr
rename _A6V3609 tot_liab_eq_endprev
rename _A6V3610 tot_liab_eq_endcurr
rename _A6V3701 training_some_workers
rename _A6V3702 training_organizer
rename _A6V3703 training_type
rename _A6V3801 foster_parent_co
rename _A6V3802 foster_parent_services
rename _A6V3901 has_foster_parent
rename _A6V3902 foster_parent_prov_svc
rename _A6V4001 constraint_unovercome
rename _A6V4002 constraint_type
rename _A6V4101 cap_constr_efforts
rename _A6V4201 profit_cmp_prev
rename _A6V4301 future_prospect
rename _A6V4401 future_expansion
rename _A6V4402 no_futureexp_reason
rename _A6V4501 member_group_co
rename _A6V4601 rnd_unit
rename _A6V4602 mathnsci_rsch_lt3
rename _A6V4603 mathnsci_rsch_d3
rename _A6V4604 mathnsci_rsch_bach
rename _A6V4605 mathnsci_rsch_post
rename _A6V4606 mathnsci_rsch_tot
rename _A6V4607 eng_rsch_lt3
rename _A6V4608 eng_rsch_d3
rename _A6V4609 eng_rsch_bach
rename _A6V4610 eng_rsch_post
rename _A6V4611 eng_rsch_tot
rename _A6V4612 econ_rsch_lt3
rename _A6V4613 econ_rsch_d3
rename _A6V4614 econ_rsch_bach
rename _A6V4615 econ_rsch_post
rename _A6V4616 econ_rsch_tot

rename _A6V4617 law_rsch_lt3
rename _A6V4618 law_rsch_d3
rename _A6V4619 law_rsch_bach
rename _A6V4620 law_rsch_post
rename _A6V4621 law_rsch_tot
rename _A6V4622 ag_rsch_lt3
rename _A6V4623 ag_rsch_d3
rename _A6V4624 ag_rsch_bach
rename _A6V4625 ag_rsch_post
rename _A6V4626 ag_rsch_tot
rename _A6V4627 tourism_rsch_lt3
rename _A6V4628 tourism_rsch_d3
rename _A6V4629 tourism_rsch_bach
rename _A6V4630 tourism_rsch_post
rename _A6V4631 tourism_rsch_tot
rename _A6V4632 other_rsch_lt3
rename _A6V4633 other_rsch_d3
rename _A6V4634 other_rsch_bach
rename _A6V4635 other_rsch_post
rename _A6V4636 other_rsch_tot
rename _A6V4637 all_rsch_lt3
rename _A6V4638 all_rsch_d3
rename _A6V4639 all_rsch_bach
rename _A6V4640 all_rsch_post
rename _A6V4641 all_rsch_tot

rename _IMRVCU rent_mach_tools_000
rename _IBRVCU1 rent_bldg_000
rename _LPMNOU1 unpaid_prod_male
rename _LPWNOU1 unpaid_prod_female
rename _LNMNOU1 unpaid_other_male
rename _LNWNOU1 unpaid_other_female
rename _LPMLTL tot_male_prod
rename _LPWLTL tot_female_prod
rename _LNMLTL tot_male_other
rename _LNWLTL tot_female_other
rename ESGANS esgans
rename _CLTTCU land_asset_tot
rename _CBTTCU bldg_acq_rep_tot
rename _CMTTCU mach_acq_rep_tot
rename _CVTTCU veh_acq_rep_tot
rename _COTTCU othercap_acq_rep_tot
rename _CTTTCU tot_acq_rep

rename _LPMSNF edatt_prod_male_1
rename _LPWSNF edatt_prod_female_1
rename _LNMSNF edatt_nonprod_male_1
rename _LNWSNF edatt_nonprod_female_1
rename _LPMSEL edatt_prod_male_2
rename _LPWSEL edatt_prod_female_2
rename _LNMSEL edatt_nonprod_male_2
rename _LNWSEL edatt_nonprod_female_2
rename _LPMSHF edatt_prod_male_3
rename _LPWSHF edatt_prod_female_3
rename _LNMSHF edatt_nonprod_male_3
rename _LNWSHF edatt_nonprod_female_3
rename _LPMSHS edatt_prod_male_4
rename _LPWSHS edatt_prod_female_4
rename _LNMSHS edatt_nonprod_male_4
rename _LNWSHS edatt_nonprod_female_4
rename _LPMSD3 edatt_prod_male_5
rename _LPWSD3 edatt_prod_female_5
rename _LNMSD3 edatt_nonprod_male_5
rename _LNWSD3 edatt_nonprod_female_5
rename _LPMSS1 edatt_prod_male_6
rename _LPWSS1 edatt_prod_female_6
rename _LNMSS1 edatt_nonprod_male_6
rename _LNWSS1 edatt_nonprod_female_6
rename _LPMSS2 edatt_prod_male_7
rename _LPWSS2 edatt_prod_female_7
rename _LNMSS2 edatt_nonprod_male_7
rename _LNWSS2 edatt_nonprod_female_7
rename _LPMSS3 edatt_prod_male_8
rename _LPWSS3 edatt_prod_female_8
rename _LNMSS3 edatt_nonprod_male_8
rename _LNWSS3 edatt_nonprod_female_8
rename _LPMSTL edatt_prod_male_tot
rename _LPWSTL edatt_prod_female_tot
rename _LNMSTL edatt_nonprod_male_tot
rename _LNWSTL edatt_nonprod_female_tot

rename edatt_prod_male_1 edatt_prod_male_noprimary
rename edatt_prod_female_1 edatt_prod_female_noprimary
rename edatt_nonprod_male_1 edatt_nonprod_male_noprimary
rename edatt_nonprod_female_1 edatt_nonprod_female_noprimary

rename edatt_prod_male_2 edatt_prod_male_primary
rename edatt_prod_female_2 edatt_prod_female_primary
rename edatt_nonprod_male_2 edatt_nonprod_male_primary
rename edatt_nonprod_female_2 edatt_nonprod_female_primary

rename edatt_prod_male_3 edatt_prod_male_juniorhigh
rename edatt_prod_female_3 edatt_prod_female_juniorhigh
rename edatt_nonprod_male_3 edatt_nonprod_male_juniorhigh
rename edatt_nonprod_female_3 edatt_nonprod_female_juniorhigh

rename edatt_prod_male_4 edatt_prod_male_seniorhigh
rename edatt_prod_female_4 edatt_prod_female_seniorhigh
rename edatt_nonprod_male_4 edatt_nonprod_male_seniorhigh
rename edatt_nonprod_female_4 edatt_nonprod_female_seniorhigh

rename edatt_prod_male_5 edatt_prod_male_diploma3
rename edatt_prod_female_5 edatt_prod_female_diploma3
rename edatt_nonprod_male_5 edatt_nonprod_male_diploma3
rename edatt_nonprod_female_5 edatt_nonprod_female_diploma3

rename edatt_prod_male_6 edatt_prod_male_bachelor
rename edatt_prod_female_6 edatt_prod_female_bachelor
rename edatt_nonprod_male_6 edatt_nonprod_male_bachelor
rename edatt_nonprod_female_6 edatt_nonprod_female_bachelor

rename edatt_prod_male_7 edatt_prod_male_master
rename edatt_prod_female_7 edatt_prod_female_master
rename edatt_nonprod_male_7 edatt_nonprod_male_master
rename edatt_nonprod_female_7 edatt_nonprod_female_master

rename edatt_prod_male_8 edatt_prod_male_phd
rename edatt_prod_female_8 edatt_prod_female_phd
rename edatt_nonprod_male_8 edatt_nonprod_male_phd
rename edatt_nonprod_female_8 edatt_nonprod_female_phd

save "$data/firms_80_04_merged.dta", replace
