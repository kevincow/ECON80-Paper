clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Data/"
cd "`dir'"

local logfile analysis.log
cap log close
cap erase `logfile'
log using `logfile', replace

use "cleaned_data.dta", clear

// Add the annual CPI inflation data
gen inflation = .
replace inflation = 2.1 if year == 2017
replace inflation = 1.9 if year == 2018
replace inflation = 2.3 if year == 2019
replace inflation = 1.4 if year == 2020
replace inflation = 7.0 if year == 2021
replace inflation = 6.5 if year == 2022
replace inflation = 3.4 if year == 2023 


// Get real wage change (histogram + summary statistics by year)
gen log_real_wage_change = log(earnhre / lag_earnhre) - (inflation / 100)

gen neg_inflation = -inflation
levelsof year, local(years)
foreach y of local years {
	
	su neg_inflation if year == `y'
	local neg_inflation_value = r(mean)
	
	histogram log_real_wage_change if year == `y', width(0.025) percent ///
		title("Distribution of Log Real Wage Change - Year `y'") ///
		xtitle("Log Real Wage Change") ytitle("Percentage") ///
		xline(`neg_inflation_value', lpattern(dash)) // ask prof staiger cuz this isn't working 
		
	
	graph export "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Plots/histogram`y'.png", replace
	
}

/*
histogram log_real_wage_change if year != 2017, by(year) width(0.05) percent
*/
	

/*
levelsof year, local(years)
foreach y of local years {
	kdensity log_real_wage_change if year == `y', title("Year `y'")
	pause "press enter"
}
*/

// Could we first perhaps evaluate whether DNWR holds in the Card paper due to globalization and shift to services?

// Generate important controls
gen male = (sex == 1)
gen white = (race == 1 & missing(ethnic))
gen union = (unionmme == 1 | unioncov == 1)
gen private_sector = (class94 >= 4)
gen fulltime = (uhours >= 35)
gen supporting_child = (ownchild > 0)

gen tradable = inlist(ind, 170, 180, 190, 270, 280, 290, ///
                             370, 380, 390, 470, 480, 490, ///
                             1070, 1080, 1090, 1170, 1180, 1190, ///
                             1270, 1280, 1290, 1370, 1390, ///
                             1470, 1480, 1490, 1570, 1590, 1670, ///
                             1680, 1690, 1770, 1790, 1870, 1880, ///
                             1890, 1990, 2070, 2090, 2170, 2180, ///
                             2190, 2270, 2280, 2290, 2370, 2380, ///
                             2390, 2470, 2480, 2490, 2570, 2590, ///
                             2670, 2680, 2690, 2770, 2780, 2790, ///
                             2870, 2880, 2890, 2970, 2980, 2990, ///
                             3070, 3080, 3090, 3170, 3180, 3190, ///
                             3290, 3360, 3370, 3380, 3390, ///
                             3470, 3490, 3570, 3580, 3590, ///
                             3670, 3680, 3690, 3770, 3780, 3790, ///
                             3870, 3890, 3960, 3970, 3980, 3990, ///
                             4070, 4080, 4090, 4170, 4180, 4190, ///
                             4260, 4270, 4280, 4290, ///
                             4370, 4380, 4390, 4470, 4480, 4490, ///
                             4560, 4570, 4580, 4585, 4590, ///
                             6070, 6080, 6090)
							 
		

// Revisit this definition...
gen gvc_integrated = inlist(ind, 3360, 3370, 3380, 3390, ///
                                   3570, 3580, 3590, ///
                                   3670, 3680, 3690, ///
                                   1470, 1480, 1490, ///
                                   1670, 1680, 1690, ///
                                   2180, 2190, 2370, 2380, ///
                                   2670, 2680, 2690, 2770, ///
                                   2870, 2880, 2890, 2970,  ///
                                   3090, 3170, 3180, 3190, ///
                                   2070, 2090, 2290)



// Missing an education variable





local controls male white union private_sector fulltime supporting_child tradable gvc_integrated


// Assign a RTW dummy
local rtw_states "1 2 4 6 10 12 13 15 17 18 24 27 29 33 34 36 40 41 42 44 45 47 48 49"
gen rtw = 0
foreach state in `rtw_states' {
	
	replace rtw = 1 if stfips == `state'
	
}



/*
// Define wages being rigid
gen rigid = (abs(log_wage_change) <= 0.01)

// Simple regression regarding being in a union

gen inflation_union = inflation * union

logit rigid inflation_union union `controls' i.stfips i.year, robust

preserve

keep if rtw == 1
logit rigid inflation_union union `controls' i.stfips i.year, robust

restore
preserve

keep if rtw == 0
logit rigid inflation_union union `controls' i.stfips i.year, robust

restore

gen inflation_rtw = inflation * rtw
logit rigid inflation_rtw `controls' i.stfips i.year, robust
*/


// hourslw could be an important thing to look at

gen inflation_union = inflation * union

reg log_wage_change inflation_union union `controls' i.stfips i.year, robust

preserve

keep if rtw == 1
reg log_wage_change inflation_union union `controls' i.stfips i.year, robust

restore
preserve

keep if rtw == 0
reg log_wage_change inflation_union union `controls' i.stfips i.year, robust

restore

gen inflation_rtw = inflation * rtw
reg log_wage_change inflation_rtw `controls' i.stfips i.year, robust



log close




