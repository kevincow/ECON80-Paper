clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Data/"
cd "`dir'"

local logfile construct.log
cap log close
cap erase `logfile'
log using `logfile', replace


*************************** Compile the data **********************************


use "morg16.dta", clear

// Concatenate all years of data into one dataset
foreach year in 17 18 19 20 21 22 23 {
	
	append using morg`year' 
	
}

// Find number of observations for each household 
egen nobs = count(hhid), by(hhid hrhhid2 lineno)

// Drop if there aren't 2 different observations (might need to investigate if certain types of households dropped out so no bias from attrition) *just use nobs == 1 for this*
drop if nobs == 1
drop nobs

/*
tab nobs minsamp if nobs == 2

tab nobs minsamp

tab year minsamp if nobs == 2
*/

// Create a unique identifier
egen id = group(hhid hrhhid2 lineno)

tsset id year

// Drop anyone who may have changed jobs
/*
by id (year): gen job_change = (class94 != class94[_n-1]) | (ind02 != ind02[_n-1]) | (ind17 != ind17[_n-1]) | (dind02 != dind02[_n-1]) | (occ2012 != occ2012[_n-1]) | (occ18 != occ18[_n-1])

drop if job_change == 1
drop job_change
*/

// Drop anyone who isn't paid by the hour
drop if paidhre == 2

// Drop anyone whose paid by hour status is questionable or may have changed
keep if I25b == 0

// Remove anyone who is reported to have made $9999 per hour or missing
drop if earnhre == 9999
drop if missing(earnhre)

// Remove anyone without two observations
egen id_count = count(id), by(id)
keep if id_count == 2
drop id_count

// Convert salaries to dollar unit
replace earnhre = round(earnhre / 100, 0.01)

// Get wage change
gen lag_earnhre = L.earnhre
drop if missing(lag_earnhre)
gen log_wage_change = ln(earnhre) - ln(lag_earnhre)

// For now... just drop anyone with a large change in wages
drop if abs(log_wage_change) > 0.25

// Merge industry variables
gen ind = .
replace ind = ind02 if !missing(ind02)
replace ind = ind17 if missing(ind) & !missing(ind17)
// be careful in case there is a reworking of how these things are coded

// Save and export
save "cleaned_data.dta", replace


log close 
