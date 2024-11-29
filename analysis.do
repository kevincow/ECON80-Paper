clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/"
cd "`dir'"

local logfile analysis.log
cap log close
cap erase `logfile'
log using `logfile', replace

use "./Data/cleaned_data.dta", clear

global histograms 0
global summary_statistics 0
global baseline_analysis 1
global union_analysis 0
global globalization_analysis 0

/* Variable generation */

// Add the annual CPI inflation data
gen inflation = .
replace inflation = 13.5 if year == 1980
replace inflation = 10.3 if year == 1981
replace inflation = 6.1 if year == 1982
replace inflation = 3.2 if year == 1983
replace inflation = 4.3 if year == 1984
replace inflation = 3.5 if year == 1985
replace inflation = 1.9 if year == 1986
replace inflation = 3.7 if year == 1987
replace inflation = 4.1 if year == 1988
replace inflation = 4.8 if year == 1989
replace inflation = 5.4 if year == 1990
replace inflation = 4.2 if year == 1991
replace inflation = 3.0 if year == 1992
replace inflation = 2.7 if year == 1993
replace inflation = 2.7 if year == 1994
replace inflation = 2.5 if year == 1995
replace inflation = 3.3 if year == 1996
replace inflation = 1.7 if year == 1997
replace inflation = 1.6 if year == 1998
replace inflation = 2.2 if year == 1999
replace inflation = 3.4 if year == 2000
replace inflation = 2.8 if year == 2001
replace inflation = 1.6 if year == 2002
replace inflation = 2.3 if year == 2003
replace inflation = 2.7 if year == 2004
replace inflation = 3.4 if year == 2005
replace inflation = 2.5 if year == 2006
replace inflation = 4.1 if year == 2007
replace inflation = 0.1 if year == 2008
replace inflation = 2.7 if year == 2009
replace inflation = 1.5 if year == 2010
replace inflation = 3.0 if year == 2011
replace inflation = 1.7 if year == 2012
replace inflation = 1.5 if year == 2013
replace inflation = 0.8 if year == 2014
replace inflation = 0.7 if year == 2015
replace inflation = 2.1 if year == 2016
replace inflation = 2.1 if year == 2017
replace inflation = 1.9 if year == 2018
replace inflation = 2.3 if year == 2019
replace inflation = 1.4 if year == 2020
replace inflation = 7.0 if year == 2021
replace inflation = 6.5 if year == 2022
replace inflation = 3.4 if year == 2023 

// De-mean inflation
quietly summ inflation
scalar mean_inflation = r(mean) 
replace inflation = inflation - mean_inflation

// Merge the macro variables on
merge m:1 year stfips using "./Data/macro_variables.dta"
keep if _m == 3
drop _m 

// Generate important variables
gen experience = age - educ - 6
gen experience2 = experience^2
gen female = (sex == 2)
gen white = (race == 1 & missing(ethnic) & year > 2002) | (race == 1 & ethnic == 8 & year <= 2002)
gen married = (marital == 1 | marital == 2)
gen union = (unionmme == 1 | unioncov == 1)
						   
gen rigid = (abs(log_wage_change) <= 0.01)  
local individual_controls educ experience experience2 female white married union i.ind i.occ

if $histograms == 1 {
	
	// Just 2010
	histogram log_wage_change if year == 2010, by(year) width(0.01)
	graph export "../Plots/histogram_2010.png", replace
	
	// Compare 1980 vs 2010
	histogram log_wage_change if year == 1980 | year == 2010, by(year) width(0.01)
	graph export "../Plots/histogram_comparison.png", replace
	
	// Although not really a histogram, I think Staiger wanted a plot of % rigid over time (and maybe compare that with inflation over time in general)
	
}

// Too much missing union data from before 1983, so we just drop all of those observations 
// 9147 + 10591 + 10633
cap drop if year <= 1982

if $summary_statistics == 1 {
	
	
	
	// what to put for summary statistics
	outsum rigid inflation productivity_growth unemployment educ experience female white married union using "../Tables/sum_stats.doc" if year < 2000, replace ctitle("Pre 2000")
	outsum rigid inflation productivity_growth unemployment educ experience female white married union using "../Tables/sum_stats.doc" if year >= 2000, append ctitle("Post 2000")
	
	/*
	// Put summary statistics for industry and occupation in appendix
	outsum i.ind using "../Tables/industry_sum_stats.doc" if year < 2000, replace ctitle("Pre 2000")
	outsum i.ind using "../Tables/industry_sum_stats.doc" if year >= 2000, append ctitle("Post 2000")
	*/
		
}

if $baseline_analysis == 1 {
	/*
	
	// All pre vs post 2000
	logit rigid inflation productivity_growth `individual_controls' i.stfips if year < 2000, cluster(stfips)
	outreg2 using "../Tables/baseline_table_1.doc", replace ctitle("Year < 2000, No Macro Controls")
	logit rigid inflation productivity_growth unemployment `individual_controls' i.stfips if year < 2000, cluster(stfips)
	outreg2 using "../Tables/baseline_table_1.doc", append ctitle("Year < 2000, Macro Controls")
	
	logit rigid inflation productivity_growth `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/baseline_table_1.doc", append ctitle("Year >= 2000, No Macro Controls")
	logit rigid inflation productivity_growth unemployment `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/baseline_table_1.doc", append ctitle("Year >= 2000, Macro Controls")

	
	// Low vs High Income
	sort year lag_earnhre
	egen bottom_quartile_threshold = pctile(lag_earnhre), p(25) by(year)
	gen low_income = (lag_earnhre <= bottom_quartile_threshold)
	
	gen inflation_low_income = inflation * low_income
	
	logit rigid inflation_low_income low_income `individual_controls' i.stfips i.year if year <= 2000, cluster(stfips)
	outreg2 using "../Tables/low_income_table_1.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_low_income low_income unemployment `individual_controls' i.stfips i.year if year <= 2000, cluster(stfips)
	outreg2 using "../Tables/low_income_table_1.doc", append ctitle("Macro Controls")
	logit rigid inflation_low_income low_income inflation productivity_growth unemployment `individual_controls' i.stfips if year <= 2000, cluster(stfips)
	outreg2 using "../Tables/low_income_table_1.doc", append ctitle("No Year FE")
	
	logit rigid inflation_low_income low_income `individual_controls' i.stfips i.year if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/low_income_table_1.doc", append ctitle("No Macro Controls")
	logit rigid inflation_low_income low_income unemployment `individual_controls' i.stfips i.year if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/low_income_table_1.doc", append ctitle("Macro Controls")
	logit rigid inflation_low_income low_income inflation productivity_growth unemployment `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/low_income_table_1.doc", append ctitle("No Year FE")
	*/
	
	// Education level
	
	
	cap gen college = educ >= 9
	cap gen inflation_college = inflation * college
	logit rigid inflation_college college `individual_controls' i.stfips i.year if year <= 2000, cluster(stfips)
	outreg2 using "../Tables/educ_table_1.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_college college `individual_controls' i.stfips i.year if year <= 2000, cluster(stfips)
	outreg2 using "../Tables/educ_table_1.doc", append ctitle("Macro Controls")
	logit rigid inflation_college college inflation productivity_growth unemployment `individual_controls' i.stfips if year <= 2000, cluster(stfips)
	outreg2 using "../Tables/educ_table_1.doc", append ctitle("No Year FE")
	
	logit rigid inflation_college college `individual_controls' i.stfips i.year if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/educ_table_1.doc", append ctitle("No Macro Controls")
	logit rigid inflation_college college unemployment `individual_controls' i.stfips i.year if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/educ_table_1.doc", append ctitle("Macro Controls")
	logit rigid inflation_college college inflation productivity_growth unemployment `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "../Tables/educ_table_1.doc", append ctitle("No Year FE")
	
	
}

// bring back baseline analysis as it shows that in general, for everyone, there is less DNWR (and then we show it's not true for vulnerable sectors of population)

if $union_analysis == 1 {
	
	preserve 
	
	// Assign a RTW dummy
	gen rtw = 0
	replace rtw = 1 if stfips == 1
	replace rtw = 1 if stfips == 4
	replace rtw = 1 if stfips == 5
	replace rtw = 1 if stfips == 12
	replace rtw = 1 if stfips == 13
	replace rtw = 1 if stfips == 16
	replace rtw = 1 if (stfips == 18 & year > 2012)
	replace rtw = 1 if stfips == 19
	replace rtw = 1 if stfips == 20
	replace rtw = 1 if (stfips == 21 & year > 2017)
	replace rtw = 1 if stfips == 22
	replace rtw = 1 if (stfips == 26 & year > 2012)
	replace rtw = 1 if stfips == 28
	replace rtw = 1 if (stfips == 29 & year == 2018)
	replace rtw = 1 if stfips == 31
	replace rtw = 1 if stfips == 32
	replace rtw = 1 if stfips == 37
	replace rtw = 1 if stfips == 38
	replace rtw = 1 if (stfips == 40 & year > 2001)
	replace rtw = 1 if stfips == 45
	replace rtw = 1 if stfips == 46
	replace rtw = 1 if stfips == 47
	replace rtw = 1 if (stfips == 48 & year > 1993)
	replace rtw = 1 if stfips == 49
	replace rtw = 1 if stfips == 51
	replace rtw = 1 if (stfips == 55 & year > 2015)
	replace rtw = 1 if stfips == 56
	
	gen inflation_rtw = inflation * rtw
	
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year if year >= 1983, cluster(stfips)
	outreg2 using "../Tables/rtw_table_1.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year if year >= 1983, cluster(stfips)
	outreg2 using "../Tables/rtw_table_1.doc", append ctitle("Macro Controls")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips if year >= 1983, cluster(stfips)
	outreg2 using "../Tables/rtw_table_1.doc", append ctitle("No Year FE")
	
	// Balance tables
	local balance_test_controls unemployment educ experience female white married union
	foreach var in `balance_test_controls' {
		
		if "`var'" == "unemployment" | "`var'" == "educ" | "`var'" == "experience" {
			
			areg `var' rtw i.stfips, absorb(year) cluster(stfips)
			
		}
		else {
			
			logit `var' rtw i.year i.stfips, cluster(stfips)
			
		}
		
		if "`var'" == "unemployment" {
			
			outreg2 using "../Tables/balance_test_rtw.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "../Tables/balance_test_rtw.doc", append ctitle("`var'")
			
		}
	} 
	
	
	// Put industry and occupation balance tests in appendix for space reasons
	/*
	local ind_occ i.ind i.occ
	local counter = 1
	foreach var in `ind_occ' {
		
		
		logit `var' rtw i.year i.stfips, cluster(stfips)
			
		if `counter' == 1 {
			
			outreg2 using "../Tables/balance_test_rtw_appendix.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "../Tables/balance_test_rtw_appendix.doc", append ctitle("`var'")
			
		}
		
		local counter = `counter' + 1
		
	}
	*/

	// Regressions that demonstrates that RTW laws decreased the number of people who are in a union and covered by a union contract
	local temp_individual_controls educ experience experience2 female white married i.ind i.occ
	
	replace unionmme = (unionmme == 1)
	logit unionmme rtw `temp_individual_controls' unemployment i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/rtw_actually_doing_something.doc", replace ctitle("Union Membership")
	logit union rtw `temp_individual_controls' unemployment i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/rtw_actually_doing_something.doc", append ctitle("Union Contract Coverage")
	
	
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/rtw_table_1.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/rtw_table_1.doc", append ctitle("Macro Controls")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips, cluster(stfips)
	outreg2 using "../Tables/rtw_table_1.doc", append ctitle("No Year FE")
	
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year if union == 0, cluster(stfips)
	outreg2 using "../Tables/rtw_table_2.doc", replace ctitle("Not Covered By Union Contract")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year if union == 0, cluster(stfips)
	outreg2 using "../Tables/rtw_table_2.doc", append ctitle("Not Covered By Union Contract")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips if union == 0, cluster(stfips)
	outreg2 using "../Tables/rtw_table_2.doc", append ctitle("Not Covered By Union Contract")
	
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year if union == 1, cluster(stfips)
	outreg2 using "../Tables/rtw_table_2.doc", append ctitle("Covered By Union Contract")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year if union == 1, cluster(stfips)
	outreg2 using "../Tables/rtw_table_2.doc", append ctitle("Covered By Union Contract")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips if union == 1, cluster(stfips)
	outreg2 using "../Tables/rtw_table_2.doc", append ctitle("Covered By Union Contract")
	
	
	
	// Propensity Score Matching
	local psm_controls educ experience female white married i.ind i.occ

	gen inflation_union = inflation * union
	
	logit union `psm_controls' `macro_controls' i.stfips i.year
	predict phat

	gen wt = 1 if union == 1
	replace wt = phat/(1-phat) if union == 0

	gen wt_un = 1 if union == 0
	replace wt_un = (1-phat)/phat if union == 1

	gen wt_avg = 1/(1-phat) if union == 0
	replace wt_avg = 1/phat if union == 1

	// Graph the propensity scores
	histogram phat, by(union) kdensity
	graph export "../Plots/propensity_score_histogram.png", replace

	kdensity phat if union==1, gen(x_1 d_1)
	label var d_1 "union group"
	kdensity phat if union == 0, gen(x_0 d_0)
	label var d_0 "control group, unweighted"
	kdensity phat if union == 0 [aw=wt], gen(x_0w d_0w)
	label var d_0w "control group, weighted"
	twoway (line d_1 x_1, sort) (line d_0 x_0, sort) (line d_0w x_0w, sort)
	graph export "../Plots/PSM_kernel_density_plot.png", replace

	// Look at the distribution of weights -- sometimes end up putting tons of weight on a few observations 
	summ wt if union == 0, d
	summ wt_un if union == 1, d
	summ wt_avg, d

	// Run regressions with & without controls, with & without weighting
	
	// ATE on Treated
	logit rigid inflation_union inflation union i.year, cluster(stfips)
	outreg2 using "../Tables/psm_union_table_1.doc", replace ctitle("No Controls/No Weighting")
	logit rigid inflation_union inflation union i.year [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_1.doc", append ctitle("No Controls/Weighting")
	logit rigid inflation_union inflation unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/psm_union_table_1.doc", append ctitle("Controls/No Weighting")
	logit rigid inflation_union inflation productivity_growth unemployment `individual_controls' i.stfips i.year [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_1.doc", append ctitle("Controls/Weighting")

	// ATE on Untreated
	logit rigid inflation_union inflation union i.year [pw=wt_un], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_2.doc", replace ctitle("No controls")
	logit rigid inflation_union inflation unemployment `individual_controls' i.stfips i.year [pw=wt_un], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_2.doc", append ctitle("Controls")

	// ATE on Average
	logit rigid inflation_union inflation union i.year [pw=wt_avg], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_3.doc", replace ctitle("No controls")
	logit rigid inflation_union inflation unemployment `individual_controls' i.stfips i.year [pw=wt_avg], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_3.doc", append ctitle("Controls")

	// Run regressions breaking sample into quintiles of propensity
	logit rigid inflation_union inflation union i.year if phat>=0 & phat<0.2 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_4.doc", replace ctitle("First quintile")
	logit rigid inflation_union inflation union i.year if phat>=0.2 & phat<0.4 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_4.doc", append ctitle("Second quintile")
	logit rigid inflation_union inflation union i.year if phat>=0.4 & phat<0.6 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_4.doc", append ctitle("Third quintile")
	logit rigid inflation_union inflation union i.year if phat>=0.6 & phat<0.8 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_4.doc", append ctitle("Fourth quintile")
	logit rigid inflation_union inflation union i.year if phat>=0.8 & phat<1 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_union_table_4.doc", append ctitle("Fifth quintile")

	// include interaction with propensity in full sample
	gen inflation_union_phat = inflation_union*phat
	logit rigid inflation_union_phat inflation_union phat [pw=wt], cluster(stfips)
	
	gen wage_decrease = (log_wage_change < 0)
	
	// Drop anyone who has always had a RTW law
	drop if stfips == 1
	drop if stfips == 4
	drop if stfips == 5
	drop if stfips == 12
	drop if stfips == 13
	drop if stfips == 16
	drop if stfips == 19
	drop if stfips == 20
	drop if stfips == 22
	drop if stfips == 28
	drop if stfips == 31
	drop if stfips == 32
	drop if stfips == 37
	drop if stfips == 38
	drop if stfips == 45
	drop if stfips == 46
	drop if stfips == 47
	drop if stfips == 49
	drop if stfips == 51
	drop if stfips == 56
	
	gen event_time = .
	replace event_time = year - 2013 if stfips == 18
	replace event_time = year - 2017 if stfips == 21
	replace event_time = year - 2013 if stfips == 26
	replace event_time = year - 2019 if stfips == 29
	replace event_time = year - 2002 if stfips == 40
	replace event_time = year - 1994 if stfips == 48
	replace event_time = year - 2016 if stfips == 55
	
	eventdd wage_decrease rtw unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("rtw and wage_decrease") xlabel(-5(1)10)) leads(5) lags(10) accum
	graph export "../Plots/event_study_rtw_decrease.png", replace
	
	eventdd rigid rtw unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("rtw and rigid") xlabel(-5(1)10)) leads(5) lags(10) accum
	graph export "../Plots/event_study_rtw_rigid.png", replace
	
	restore
	

}

if $globalization_analysis == 1 {
	
	drop if year >= 2006
	gen post = (year >= 1994)
	gen treat = (ind == 1 | ind == 2 | ind == 4) // Treated population is anyone in agriculture, raw materials, and manufacturing
	// gen treat = (occ == 18 | occ == 21)
	gen post_treat = post * treat
	gen inflation_post_treat = inflation * post_treat
	gen inflation_post = inflation * post
	gen inflation_treat = inflation * treat
	
	preserve
	
	/*
	
	// Balance test 
	local balance_test_controls unemployment educ experience female white married union
	foreach var in `balance_test_controls' {
		
		if "`var'" == "unemployment" | "`var'" == "educ" | "`var'" == "experience" {
			
			areg `var' post_treat i.ind /* i.stfips */, absorb(year) cluster(stfips)
			
		}
		else {
			
			logit `var' post_treat i.ind i.year /* i.stfips */, cluster(stfips)
			
		}
		
		if "`var'" == "unemployment" {
			
			outreg2 using "../Tables/balance_test_nafta.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "../Tables/balance_test_nafta.doc", append ctitle("`var'")
			
		}
	} 

	 
	local individual_controls2 educ experience experience2 female white married union i.ind i.occ
	
	// Regressions (adding post and treat improves convergence; can't cluster on ind because < 30)
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/nafta_table_1.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/nafta_table_1.doc", append ctitle("No Year FE")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat inflation productivity_growth unemployment `individual_controls' i.stfips, cluster(stfips)
	outreg2 using "../Tables/nafta_table_1.doc", append ctitle("No Year FE")
	
	// PSM
	
	*/
	
	local psm_controls educ experience female white married i.occ
	
	logit treat `psm_controls' `macro_controls' i.stfips i.year
	predict phat

	gen wt = 1 if treat == 1
	replace wt = phat/(1-phat) if treat == 0

	gen wt_un = 1 if treat == 0
	replace wt_un = (1-phat)/phat if treat == 1

	gen wt_avg = 1/(1-phat) if treat == 0
	replace wt_avg = 1/phat if treat == 1

	// Graph the propensity scores
	histogram phat, by(treat) kdensity
	graph export "../Plots/nafta_propensity_score_histogram.png", replace

	kdensity phat if treat==1, gen(x_1 d_1)
	label var d_1 "treat group"
	kdensity phat if treat == 0, gen(x_0 d_0)
	label var d_0 "control group, unweighted"
	kdensity phat if treat == 0 [aw=wt], gen(x_0w d_0w)
	label var d_0w "control group, weighted"
	twoway (line d_1 x_1, sort) (line d_0 x_0, sort) (line d_0w x_0w, sort)
	graph export "../Plots/nafta_PSM_kernel_density_plot.png", replace

	// Look at the distribution of weights -- sometimes end up putting tons of weight on a few observations 
	summ wt if treat == 0, d
	summ wt_un if treat == 1, d
	summ wt_avg, d

	// Run regressions with & without controls, with & without weighting
	
	foreach var in `balance_test_controls' {
		
		if "`var'" == "unemployment" | "`var'" == "educ" | "`var'" == "experience" {
			
			areg `var' post_treat post treat i.stfips [pw=wt], absorb(year) cluster(stfips)
			
		}
		else {
			
			logit `var' post_treat post treat i.year i.stfips [pw=wt], cluster(stfips)
			
		}
		
		if "`var'" == "unemployment" {
			
			outreg2 using "../Tables/balance_test_nafta_2.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "../Tables/balance_test_nafta_2.doc", append ctitle("`var'")
			
		}
	}
	
	// Balance tests
	outsum unemployment educ experience female white married union using "../Tables/balance_nafta_psm.doc" if post == 0 & treat == 1, replace ctitle("Treatment")
	
	outsum rigid inflation productivity_growth unemployment educ experience female white married union using "../Tables/balance_nafta_psm.doc" if post == 0 & treat == 0, append ctitle("Control")
	
	outsum rigid inflation productivity_growth unemployment educ experience female white married union using "../Tables/balance_nafta_psm.doc" if post == 0 & treat == 0 [wt=wt], append ctitle("Weighted Control")
	
	
	// ATE on Treated
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat i.year, cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_1.doc", replace ctitle("No Controls/No Weighting")
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat i.year [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_1.doc", append ctitle("No Controls/Weighting")
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_1.doc", append ctitle("Controls/No Weighting")
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat unemployment `individual_controls' i.stfips i.year [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_1.doc", append ctitle("Controls/Weighting")

	// ATE on Untreated
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year [pw=wt_un], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_2.doc", replace ctitle("No controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat unemployment `individual_controls' i.stfips i.year [pw=wt_un], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_2.doc", append ctitle("Controls")

	// ATE on Average
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year [pw=wt_avg], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_2.doc", append ctitle("No controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat unemployment `individual_controls' i.stfips i.year [pw=wt_avg], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_2.doc", append ctitle("Controls")

	// Run regressions breaking sample into quintiles of propensity
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year if phat>=0 & phat<0.2 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_3.doc", replace ctitle("First quintile")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year if phat>=0.2 & phat<0.4 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_3.doc", append ctitle("Second quintile")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year if phat>=0.4 & phat<0.6 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_3.doc", append ctitle("Third quintile")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year if phat>=0.6 & phat<0.8 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_3.doc", append ctitle("Fourth quintile")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year if phat>=0.8 & phat<1 [pw=wt], cluster(stfips)
	outreg2 using "../Tables/psm_nafta_table_3.doc", append ctitle("Fifth quintile")
	

	// Event study
	gen event_time = .
	replace event_time = year - 1994 if treat == 1
	
	gen wage_decrease = (log_wage_change < 0)
	
	eventdd wage_decrease unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("nafta and wage_decrease") xlabel(-5(1)11)) leads(5) lags(11) accum
	graph export "../Plots/event_study_nafta_decrease.png", replace
	
	eventdd rigid unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("nafta and wage_freeze") xlabel(-5(1)11)) leads(5) lags(11) accum
	
	graph export "../Plots/event_study_nafta_rigid.png", replace

	// DiD plots
	
	/*
	collapse (mean) rigid [pw=wt], by(year treat post)
	
	twoway (line rigid year if treat == 1, lcolor(blue) lwidth(medium) lpattern(dash)) ///
			(line rigid year if treat == 0, lcolor(orange) lwidth(medium) lpattern(solid)) ///
			, title("Wage Freezes by Treatment Group") ///
			legend(label(1 "Treated") label(2 "Control")) ///
			ytitle("Proportion of Observations with Wage Freezes") xtitle("Year") ///
			ylabel(, grid) ///
			xline(1994, lcolor(black) lwidth(medium) lpattern(dash))
	graph export "../Plots/DiD_nafta_plot_3.png", replace
			
	twoway (lowess rigid year if treat == 1, lcolor(blue) lwidth(medium) lpattern(dash)) ///
			(lowess rigid year if treat == 0, lcolor(orange) lwidth(medium) lpattern(solid)) ///
			, title("Wage Freezes by Treatment Group") ///
			legend(label(1 "Treated") label(2 "Control")) ///
			ytitle("Proportion of Observations with Wage Freezes") xtitle("Year") ///
			ylabel(, grid) ///
			xline(1994, lcolor(black) lwidth(medium) lpattern(dash))
	graph export "../Plots/DiD_nafta_plot_4.png", replace
	
	restore
	preserve
	
	*/
	
	collapse (mean) rigid, by(year treat post)
	
	twoway (line rigid year if treat == 1, lcolor(blue) lwidth(medium) lpattern(dash)) ///
			(line rigid year if treat == 0, lcolor(orange) lwidth(medium) lpattern(solid)) ///
			, title("Wage Freezes by Treatment Group") ///
			legend(label(1 "Treated") label(2 "Control")) ///
			ytitle("Proportion of Observations with Wage Freezes") xtitle("Year") ///
			ylabel(, grid) ///
			xline(1994, lcolor(black) lwidth(medium) lpattern(dash))
	graph export "../Plots/DiD_nafta_plot_1.png", replace
	
	twoway (lowess rigid year if treat == 1, lcolor(blue) lwidth(medium) lpattern(dash)) ///
			(lowess rigid year if treat == 0, lcolor(orange) lwidth(medium) lpattern(solid)) ///
			, title("Wage Freezes by Treatment Group") ///
			legend(label(1 "Treated") label(2 "Control")) ///
			ytitle("Proportion of Observations with Wage Freezes") xtitle("Year") ///
			ylabel(, grid) ///
			xline(1994, lcolor(black) lwidth(medium) lpattern(dash))
	graph export "../Plots/DiD_nafta_plot_2.png", replace
			
	restore

	
}


log close
