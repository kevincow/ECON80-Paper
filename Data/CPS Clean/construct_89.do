clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Data/"
cd "`dir'"

use "morg89.dta", clear

// Concatenate all years of data into one dataset
foreach year in 90 91 92 93 {
	
	append using morg`year' 
	
}


gen occ = .
gen ind = .

replace ind = 1 if (year >= 1983 & year <= 1999) & ind80 <= 32
replace ind = 2 if (year >= 1983 & year <= 1999) & ind80 >= 40 & ind80 <= 50
replace ind = 3 if (year >= 1983 & year <= 1999) & ind80 == 60
replace ind = 4 if (year >= 1983 & year <= 1999) & ind80 >= 100 & ind80 <= 392
replace ind = 5 if (year >= 1983 & year <= 1999) & ind80 >= 500 & ind80 <= 571
replace ind = 6 if (year >= 1983 & year <= 1999) & ind80 >= 580 & ind80 <= 691
replace ind = 7 if (year >= 1983 & year <= 1999) & ind80 >= 400 & ind80 <= 432
replace ind = 8 if (year >= 1983 & year <= 1999) & ind80 >= 450 & ind80 <= 472
replace ind = 9 if (year >= 1983 & year <= 1999) & ind80 >= 440 & ind80 <= 442
replace ind = 10 if (year >= 1983 & year <= 1999) & ind80 >= 700 & ind80 <= 711
replace ind = 11 if (year >= 1983 & year <= 1999) & ind80 == 712
replace ind = 12 if (year >= 1983 & year <= 1999) & ind80 >= 882 & ind80 <= 891 | ind80 == 893 | ind80 == 841
replace ind = 13 if (year >= 1983 & year <= 1999) & ind80 == 892
replace ind = 14 if (year >= 1983 & year <= 1999) & ind80 >= 721 & ind80 <= 760
replace ind = 15 if (year >= 1983 & year <= 1999) & ind80 >= 842 & ind80 <= 860
replace ind = 16 if (year >= 1983 & year <= 1999) & ((ind80 >= 812 & ind80 <= 840) | (ind80 >= 861 & ind80 <= 871))
replace ind = 17 if (year >= 1983 & year <= 1999) & ind80 >= 800 & ind80 <= 810 | ind80 == 872
replace ind = 18 if (year >= 1983 & year <= 1999) & ind80 >= 762 & ind80 <= 770
replace ind = 19 if (year >= 1983 & year <= 1999) & ind80 >= 771 & ind80 <= 791 | ind80 == 761 
replace ind = 20 if (year >= 1983 & year <= 1999) & ind80 >= 900 & ind80 <= 932
replace ind = 21 if (year >= 1983 & year <= 1999) & ind80 >= 940 & ind80 <= 960

replace occ = 1 if (year >= 1983 & year <= 1999) & occ80 <= 19
replace occ = 2 if (year >= 1983 & year <= 1999) & occ80 >= 23 & occ80 <= 37
replace occ = 3 if (year >= 1983 & year <= 1999) & ((occ80 >= 64 & occ80 <= 68) | occ80 >= 229 | occ80 == 235)
replace occ = 4 if (year >= 1983 & year <= 1999) & (occ80 >= 43 & occ80 <= 59) | (occ80 >= 213 & occ80 <= 218)
replace occ = 5 if (year >= 1983 & year <= 1999) & (occ80 >= 69 & occ80 <= 83) | (occ80 >= 166 & occ80 <= 173) | (occ80 >= 223 & occ80 <= 225)
replace occ = 6 if (year >= 1983 & year <= 1999) & occ80 >= 174 & occ80 <= 177
replace occ = 7 if (year >= 1983 & year <= 1999) & (occ80 >= 178 & occ80 <= 179 | occ80 == 234)
replace occ = 8 if (year >= 1983 & year <= 1999) & occ80 >= 113 & occ80 <= 165
replace occ = 9 if (year >= 1983 & year <= 1999) & (occ80 >= 183 & occ80 <= 199 | occ80 == 228)
replace occ = 10 if (year >= 1983 & year <= 1999) & (occ80 >= 84 & occ80 <= 89) | (occ80 >= 96 & occ80 <= 105) | (occ80 >= 203 & occ80 <= 208) 
replace occ = 11 if (year >= 1983 & year <= 1999) & ((occ80 >= 445 & occ80 <= 447) | occ80 == 95 | occ80 == 106)
replace occ = 12 if (year >= 1983 & year <= 1999) & occ80 >= 413 & occ80 <= 427
replace occ = 13 if (year >= 1983 & year <= 1999) & occ80 >= 433 & occ80 <= 444
replace occ = 14 if (year >= 1983 & year <= 1999) & occ80 >= 448 & occ80 <= 455
replace occ = 15 if (year >= 1983 & year <= 1999) & (occ80 >= 456 & occ80 <= 469) | (occ80 >= 403 & occ80 <= 407)
replace occ = 16 if (year >= 1983 & year <= 1999) & occ80 >= 243 & occ80 <= 285
replace occ = 17 if (year >= 1983 & year <= 1999) & occ80 >= 303 & occ80 <= 389
replace occ = 18 if (year >= 1983 & year <= 1999) & occ80 >= 473 & occ80 <= 499
replace occ = 19 if (year >= 1983 & year <= 1999) & (occ80 >= 553 & occ80 <= 699) & (occ80 >= 865 & occ80 <= 869)
replace occ = 20 if (year >= 1983 & year <= 1999) & (occ80 >= 503 & occ80 <= 549 | occ80 == 864)
replace occ = 21 if (year >= 1983 & year <= 1999) & (occ80 >= 703 & occ80 <= 799 | occ80 == 233 | occ80 == 869)
replace occ = 22 if (year >= 1983 & year <= 1999) & ((occ80 >= 803 & occ80 <= 834) | (occ80 >= 226 & occ80 <= 227))
replace occ = 23 if (year >= 1983 & year <= 1999) & ((occ80 >= 843 & occ80 <= 859) & (occ80 >= 875 & occ80 <= 889) | occ80 == 863)
replace occ = 24 if (year >= 1983 & year <= 1999) & occ80 == 905


drop if missing(hurespli)

egen nobs = count(hhid) if hhnum == 1, by(hhid lineno hurespli intmonth famnum race sex hrhtype relaref marital chldpres ind occ)
keep if nobs == 2

egen id = group(hhid lineno hurespli intmonth famnum race sex hrhtype relaref marital chldpres)

sort id minsamp

gen is_mis4 = (minsamp == 4)
gen is_mis8 = (minsamp == 8)

bysort id: egen mis4 = total(is_mis4)
bysort id: egen mis8 = total(is_mis8)

keep if (mis4 == 1 & mis8 == 1)

// There must be some error recording years...
gen delete_flag = 1 
foreach year in 1989 1990 1991 1992 {
	
	gen flag_minsamp4_`year' = (minsamp == 4 & year == `year')
	gen flag_minsamp8_`year' = (minsamp == 8 & year == `year' + 1)
	
	bysort id: egen has_minsamp4_`year' = max(flag_minsamp4_`year')
	bysort id: egen has_minsamp8_`year' = max(flag_minsamp8_`year')
	
	replace delete_flag = 0 if has_minsamp4_`year' == 1 & has_minsamp8_`year' == 1
	
	drop flag_minsamp4_`year'
	drop flag_minsamp8_`year'
	drop has_minsamp4_`year'
	drop has_minsamp8_`year'
	
}

drop if delete_flag == 1

tsset id year 

// Drop anyone who isn't paid by the hour
drop if paidhre == 2
keep if I25b == 0

drop if earnhre == 9999
drop if missing(earnhre)

rename classer class94

drop if missing(ind80)

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

// Make sure there are no overlapping IDs when we need to concatenate
tostring id, replace
replace id = id + "_C"

save "cleaned_data_89to93.dta", replace





