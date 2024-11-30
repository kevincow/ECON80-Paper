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

// Make sure to turn the flags on
global histograms 1
global summary_statistics 1
global baseline_analysis 1
global union_analysis 1
global globalization_analysis 1

/* Variable generation */

// Merge the macro variables on
merge m:1 year stfips using "./Data/macro_variables.dta"
keep if _m == 3
drop _m 

// De-mean inflation
quietly summ inflation
scalar mean_inflation = r(mean) 
replace inflation = inflation - mean_inflation

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
	
	// Figure 1
	histogram log_wage_change if year == 2010, by(year) width(0.01)
	graph export "./Plots/figure_1.png", replace
	
	// Figure 2
	histogram log_wage_change if year == 1980 | year == 2010, by(year) width(0.01)
	graph export "./Plots/figure_2.png", replace
	
}

// Too much missing union data from before 1983, so we just drop all of those observations 
cap drop if year <= 1982

if $summary_statistics == 1 {
	
	// Table 1
	outsum rigid inflation productivity_growth unemployment educ experience female white married union using "./Tables/table_1.doc" if year < 2000, replace ctitle("Pre 2000")
	outsum rigid inflation productivity_growth unemployment educ experience female white married union using "./Tables/table_1.doc" if year >= 2000, append ctitle("Post 2000")
		
}

if $baseline_analysis == 1 {

	// Table 2
	logit rigid inflation productivity_growth `individual_controls' i.stfips if year < 2000, cluster(stfips)
	outreg2 using "./Tables/table_2.doc", replace ctitle("Year < 2000, No Macro Controls")
	logit rigid inflation productivity_growth unemployment `individual_controls' i.stfips if year < 2000, cluster(stfips)
	outreg2 using "./Tables/table_2.doc", append ctitle("Year < 2000, Macro Controls")
	
	logit rigid inflation productivity_growth `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "./Tables/table_2.doc", append ctitle("Year >= 2000, No Macro Controls")
	logit rigid inflation productivity_growth unemployment `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "./Tables/table_2.doc", append ctitle("Year >= 2000, Macro Controls")

	
	// Table 3
	sort year lag_earnhre
	egen bottom_quartile_threshold = pctile(lag_earnhre), p(25) by(year)
	gen low_income = (lag_earnhre <= bottom_quartile_threshold)
	
	gen inflation_low_income = inflation * low_income
	
	logit rigid inflation_low_income low_income `individual_controls' i.stfips i.year if year <= 2000, cluster(stfips)
	outreg2 using "./Tables/table_3.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_low_income low_income unemployment `individual_controls' i.stfips i.year if year <= 2000, cluster(stfips)
	outreg2 using "./Tables/table_3.doc", append ctitle("Macro Controls")
	logit rigid inflation_low_income low_income inflation productivity_growth unemployment `individual_controls' i.stfips if year <= 2000, cluster(stfips)
	outreg2 using "./Tables/table_3.doc", append ctitle("No Year FE")
	
	logit rigid inflation_low_income low_income `individual_controls' i.stfips i.year if year >= 2000, cluster(stfips)
	outreg2 using "./Tables/table_3.doc", append ctitle("No Macro Controls")
	logit rigid inflation_low_income low_income unemployment `individual_controls' i.stfips i.year if year >= 2000, cluster(stfips)
	outreg2 using "./Tables/table_3.doc", append ctitle("Macro Controls")
	logit rigid inflation_low_income low_income inflation productivity_growth unemployment `individual_controls' i.stfips if year >= 2000, cluster(stfips)
	outreg2 using "./Tables/table_3.doc", append ctitle("No Year FE")
	
	
	
}


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
	
	// Table 4
	local temp_individual_controls educ experience experience2 female white married i.ind i.occ
	
	replace unionmme = (unionmme == 1)
	logit unionmme rtw `temp_individual_controls' unemployment i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_4.doc", replace ctitle("Union Membership")
	logit union rtw `temp_individual_controls' unemployment i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_4.doc", append ctitle("Union Contract Coverage")
	
	
	// Table 5
	local balance_test_controls unemployment educ experience female white married union
	foreach var in `balance_test_controls' {
		
		if "`var'" == "unemployment" | "`var'" == "educ" | "`var'" == "experience" {
			
			areg `var' rtw i.stfips, absorb(year) cluster(stfips)
			
		}
		else {
			
			logit `var' rtw i.year i.stfips, cluster(stfips)
			
		}
		
		if "`var'" == "unemployment" {
			
			outreg2 using "./Tables/table_5.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "./Tables/table_5.doc", append ctitle("`var'")
			
		}
	} 
	
	// Table 6
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_6.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_6.doc", append ctitle("Macro Controls")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips, cluster(stfips)
	outreg2 using "./Tables/table_6.doc", append ctitle("No Year FE")
	
	// Table 7
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year if union == 0, cluster(stfips)
	outreg2 using "./Tables/table_7.doc", replace ctitle("Not Covered By Union Contract")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year if union == 0, cluster(stfips)
	outreg2 using "./Tables/table_7.doc", append ctitle("Not Covered By Union Contract")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips if union == 0, cluster(stfips)
	outreg2 using "./Tables/table_7.doc", append ctitle("Not Covered By Union Contract")
	
	logit rigid inflation_rtw rtw `individual_controls' i.stfips i.year if union == 1, cluster(stfips)
	outreg2 using "./Tables/table_7.doc", append ctitle("Covered By Union Contract")
	logit rigid inflation_rtw rtw unemployment `individual_controls' i.stfips i.year if union == 1, cluster(stfips)
	outreg2 using "./Tables/table_7.doc", append ctitle("Covered By Union Contract")
	logit rigid inflation_rtw rtw inflation productivity_growth unemployment `individual_controls' i.stfips if union == 1, cluster(stfips)
	outreg2 using "./Tables/table_7.doc", append ctitle("Covered By Union Contract")
	
	
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
	
	// Figure 6
	eventdd wage_decrease rtw unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("rtw and wage_decrease") xlabel(-5(1)10)) leads(5) lags(10) accum
	graph export "./Plots/figure_6.png", replace
	
	// Figure 7
	eventdd rigid rtw unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("rtw and rigid") xlabel(-5(1)10)) leads(5) lags(10) accum
	graph export "./Plots/figure_7.png", replace
	
	restore
	

}

if $globalization_analysis == 1 {
	
	drop if year >= 2006
	gen post = (year >= 1994)
	gen treat = (ind == 1 | ind == 2 | ind == 4) // Treated population is anyone in agriculture, raw materials, and manufacturing
	gen post_treat = post * treat
	gen inflation_post_treat = inflation * post_treat
	gen inflation_post = inflation * post
	gen inflation_treat = inflation * treat
	
	preserve
	
	
	// Table 8
	local balance_test_controls unemployment educ experience female white married union
	foreach var in `balance_test_controls' {
		
		if "`var'" == "unemployment" | "`var'" == "educ" | "`var'" == "experience" {
			
			areg `var' post_treat i.ind, absorb(year) cluster(stfips)
			
		}
		else {
			
			logit `var' post_treat i.ind i.year, cluster(stfips)
			
		}
		
		if "`var'" == "unemployment" {
			
			outreg2 using "./Tables/table_8.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "./Tables/table_8.doc", append ctitle("`var'")
			
		}
	} 

	
	// Table 9
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_9.doc", replace ctitle("No Macro Controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_9.doc", append ctitle("No Year FE")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat inflation productivity_growth unemployment `individual_controls' i.stfips, cluster(stfips)
	outreg2 using "./Tables/table_9.doc", append ctitle("No Year FE")
	
	
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
	// graph export "../Plots/nafta_propensity_score_histogram.png", replace

	kdensity phat if treat==1, gen(x_1 d_1)
	label var d_1 "treat group"
	kdensity phat if treat == 0, gen(x_0 d_0)
	label var d_0 "control group, unweighted"
	kdensity phat if treat == 0 [aw=wt], gen(x_0w d_0w)
	label var d_0w "control group, weighted"
	twoway (line d_1 x_1, sort) (line d_0 x_0, sort) (line d_0w x_0w, sort)
	// Figure 8
	graph export "./Plots/figure_8.png", replace

	// Look at the distribution of weights -- sometimes end up putting tons of weight on a few observations 
	summ wt if treat == 0, d
	summ wt_un if treat == 1, d
	summ wt_avg, d

	// Run regressions with & without controls, with & without weighting
	
	
	// Appendix Table 3
	foreach var in `balance_test_controls' {
		
		if "`var'" == "unemployment" | "`var'" == "educ" | "`var'" == "experience" {
			
			areg `var' post_treat post treat i.stfips [pw=wt], absorb(year) cluster(stfips)
			
		}
		else {
			
			logit `var' post_treat post treat i.year i.stfips [pw=wt], cluster(stfips)
			
		}
		
		if "`var'" == "unemployment" {
			
			outreg2 using "./Tables/appendix_table_3.doc", replace ctitle("`var'")
			
		}
		else {
			
			outreg2 using "./Tables/appendix_table_3.doc", append ctitle("`var'")
			
		}
	}
	
	
	// Table 10
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat i.year, cluster(stfips)
	outreg2 using "./Tables/table_10.doc", replace ctitle("No Controls/No Weighting")
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat i.year [pw=wt], cluster(stfips)
	outreg2 using "./Tables/table_10.doc", append ctitle("No Controls/Weighting")
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat unemployment `individual_controls' i.stfips i.year, cluster(stfips)
	outreg2 using "./Tables/table_10.doc", append ctitle("Controls/No Weighting")
	logit rigid inflation_post_treat inflation_post inflation_treat post_treat post treat unemployment `individual_controls' i.stfips i.year [pw=wt], cluster(stfips)
	outreg2 using "./Tables/table_10.doc", append ctitle("Controls/Weighting")

	// Appendix Table 4
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year [pw=wt_un], cluster(stfips)
	outreg2 using "./Tables/appendix_table_4.doc", replace ctitle("No controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat unemployment `individual_controls' i.stfips i.year [pw=wt_un], cluster(stfips)
	outreg2 using "./Tables/appendix_table_4.doc", append ctitle("Controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat i.year [pw=wt_avg], cluster(stfips)
	outreg2 using "./Tables/appendix_table_4.doc", append ctitle("No controls")
	logit rigid inflation_post_treat post_treat inflation_post inflation_treat post treat unemployment `individual_controls' i.stfips i.year [pw=wt_avg], cluster(stfips)
	outreg2 using "./Tables/appendix_table_4.doc", append ctitle("Controls")

	// Run regressions breaking sample into quintiles of propensity
	/*
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
	*/
	

	// Event study
	gen event_time = .
	replace event_time = year - 1994 if treat == 1
	
	gen wage_decrease = (log_wage_change < 0)
	
	// Figure 9
	eventdd wage_decrease unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("nafta and wage_decrease") xlabel(-5(1)11)) leads(5) lags(11) accum
	graph export "./Plots/figure_9.png", replace
	
	// Figure 10
	eventdd rigid unemployment `individual_controls' i.stfips i.year, timevar(event_time) method(ols, cluster(stfips)) graph_op(ytitle("nafta and wage_freeze") xlabel(-5(1)11)) leads(5) lags(11) accum
	
	graph export "./Plots/figure_10.png", replace

	
	// Appendix Figure 1
	collapse (mean) rigid, by(year treat post)
	
	twoway (line rigid year if treat == 1, lcolor(blue) lwidth(medium) lpattern(dash)) ///
			(line rigid year if treat == 0, lcolor(orange) lwidth(medium) lpattern(solid)) ///
			, title("Wage Freezes by Treatment Group") ///
			legend(label(1 "Treated") label(2 "Control")) ///
			ytitle("Proportion of Observations with Wage Freezes") xtitle("Year") ///
			ylabel(, grid) ///
			xline(1994, lcolor(black) lwidth(medium) lpattern(dash))
	graph export "./Plots/appendix_figure_1.png", replace
	
	twoway (lowess rigid year if treat == 1, lcolor(blue) lwidth(medium) lpattern(dash)) ///
			(lowess rigid year if treat == 0, lcolor(orange) lwidth(medium) lpattern(solid)) ///
			, title("Wage Freezes by Treatment Group") ///
			legend(label(1 "Treated") label(2 "Control")) ///
			ytitle("Proportion of Observations with Wage Freezes") xtitle("Year") ///
			ylabel(, grid) ///
			xline(1994, lcolor(black) lwidth(medium) lpattern(dash))
	graph export "./Plots/appendix_figure_1.png", replace
			
	restore

	
}


log close
