clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Data/CPS Clean/"
cd "`dir'"

use "morg79.dta", clear

// Concatenate all years of data into one dataset
foreach year in 80 81 82 83 84 {
	
	append using morg`year' 
	
}


// Make industry and occupation consistent (because no overlap)
// Make consistent industry variable

/* New industry mapping
1 --> Agriculture/Forestry/Fishing/Hunting
2 --> Mining/Quarrying/OilExtraction
3 --> Construction
4 --> Manufacturing
5 --> Wholesale Trade
6 --> Retail Trade
7 --> Transportation and Warehousing
8 --> Utilities
9 --> Information/Communications
10 --> Finance/Insurance
11 --> Real Estate/Renting
12 --> Professional/Scientific/Technical Services
13 --> Management of Companies/Enterprises/Consulting
14 --> Administrative/Support/Waste Management Services
15 --> Education
16 --> Healthcare/Social Assistance
17 --> Arts/Entertainment/Recreation
18 --> Accomodation/Food Services
19 --> Other Services (e.g. car maintenance, beauty salons, religion, funeral homes)
20 --> Public Administration
21 --> Military
*/

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

// Dataset lacks a military industry but it's okay because they aren't paid hourly anyways
replace ind = 1 if (year <= 1982) & ind70 <= 28
replace ind = 2 if (year <= 1982) & ind70 >= 47 & ind70 <= 57
replace ind = 3 if (year <= 1982) & ind70 >= 67 & ind70 <= 77
replace ind = 4 if (year <= 1982) & ind70 >= 107 & ind70 <= 398
replace ind = 5 if (year <= 1982) & ind70 >= 507 & ind70 <= 588
replace ind = 6 if (year <= 1982) & ind70 >= 607 & ind70 <= 698
replace ind = 7 if (year <= 1982) & ind70 >= 407 & ind70 <= 429
replace ind = 8 if (year <= 1982) & ind70 >= 467 & ind70 <= 479
replace ind = 9 if (year <= 1982) & ind70 >= 447 & ind70 <= 449
replace ind = 10 if (year <= 1982) & ind70 >= 707 & ind70 <= 717
replace ind = 11 if (year <= 1982) & ind70 == 718
replace ind = 12 if (year <= 1982) & ind70 >= 888 & ind70 <= 897 | ind70 == 849
replace ind = 13 if (year <= 1982) & ind70 == 738
replace ind = 14 if (year <= 1982) & ind70 >= 727 & ind70 <= 759
replace ind = 15 if (year <= 1982) & ind70 >= 857 & ind70 <= 868
replace ind = 16 if (year <= 1982) & ((ind70 >= 828 & ind70 <= 848) | ind70 >= 878 | ind70 == 879)
replace ind = 17 if (year <= 1982) & (ind70 >= 807 & ind70 <= 809 | ind70 == 869)
replace ind = 18 if (year <= 1982) & (ind70 == 777 | ind70 == 778)
replace ind = 19 if (year <= 1982) & ((ind70 >= 779 & ind70 <= 798) | ind70 == 877 | ind70 == 887)
replace ind = 20 if (year <= 1982) & ind70 >= 907 & ind70 <= 937
// replace ind = 21 if ...

drop if missing(ind)		// Drops 298 observations, all from older datasets



// Make a consistent new occupation variable

cap drop occ
gen occ = .

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

replace occ = 1 if (year <= 1982) & occ70 >= 201 & occ70 <= 245
replace occ = 2 if (year <= 1982) & (occ70 >= 55 & occ70 <= 56 | occ70 == 195 | occ70 == 26 | occ70 == 1)
replace occ = 3 if (year <= 1982) & occ70 >= 3 & occ70 <= 5 | occ70 >= 34 & occ70 <= 36
replace occ = 4 if (year <= 1982) & ((occ70 >= 6 & occ70 <= 23) | (occ70 >= 150 & occ70 <= 162) | occ70 == 2)
replace occ = 5 if (year <= 1982) & occ70 >= 42 & occ70 <= 54 | occ70 >= 91 & occ70 <= 96
replace occ = 6 if (year <= 1982) & (occ70 >= 86 & occ70 <= 90 | occ70 == 100 | occ70 == 174 | occ70 == 763) 
replace occ = 7 if (year <= 1982) & occ70 >= 30 & occ70 <= 31
replace occ = 8 if (year <= 1982) & occ70 >= 32 & occ70 <= 33 | occ70 >= 102 & occ70 <= 145
replace occ = 9 if (year <= 1982) & (occ70 >= 175 & occ70 <= 195 | occ70 == 101 | occ70 == 171)
replace occ = 10 if (year <= 1982) & (occ70 >= 61 & occ70 <= 73 | occ70 >= 80 & occ70 <= 83 | occ70 == 85) 
replace occ = 11 if (year <= 1982) & ((occ70 >= 74 & occ70 <= 76) | (occ70 >= 921 & occ70 <= 926) | occ70 == 84)
replace occ = 12 if (year <= 1982) & occ70 >= 960 & occ70 <= 965
replace occ = 13 if (year <= 1982) & occ70 >= 910 & occ70 <= 916
replace occ = 14 if (year <= 1982) & occ70 >= 901 & occ70 <= 903
replace occ = 15 if (year <= 1982) & (occ70 >= 931 & occ70 <= 954 | occ70 >= 980 & occ70 <= 984 | occ70 == 165 | occ70 == 740 | occ70 == 755)
replace occ = 16 if (year <= 1982) & occ70 >= 260 & occ70 <= 300
replace occ = 17 if (year <= 1982) & occ70 >= 301 & occ70 <= 395
replace occ = 18 if (year <= 1982) & (occ70 >= 801 & occ70 <= 824 | occ70 >= 24 & occ70 <= 25 | occ70 == 752 | occ70 == 761)
replace occ = 19 if (year <= 1982) & (occ70 >= 401 & occ70 <= 462 | occ70 == 750 | occ70 == 751) 
replace occ = 20 if (year <= 1982) & occ70 >= 470 & occ70 <= 575
replace occ = 21 if (year <= 1982) & occ70 >= 601 & occ70 <= 695 | occ70 >= 172 & occ70 <= 173
replace occ = 22 if (year <= 1982) & (occ70 >= 701 & occ70 <= 705 | occ70 >= 714 & occ70 <= 715 | occ70 >= 163 & occ70 <= 164 | occ70 == 170 | occ70 == 764)
replace occ = 23 if (year <= 1982) & (occ70 >= 706 & occ70 <= 713 | occ70 == 770 | occ70 == 762 | (occ70 >= 753 & occ70 <= 754) | (occ70 >= 764 & occ70 <= 785))
replace occ = 24 if (year <= 1982) & occ70 == 580

drop if missing(occ)

//famnum, hrhtype, chldpres for 84+
egen nobs = count(hhid) if hhnum == 1, by(hhid lineno hurespli intmonth race sex marital esr gradeat ind occ)
keep if nobs == 2

egen id = group(hhid lineno hurespli intmonth race sex marital esr gradeat)

sort id minsamp

gen is_mis4 = (minsamp == 4)
gen is_mis8 = (minsamp == 8)

bysort id: egen mis4 = total(is_mis4)
bysort id: egen mis8 = total(is_mis8)

keep if (mis4 == 1 & mis8 == 1)

// There must be some error recording years...
gen delete_flag = 1
foreach year in 1979 1980 1981 1982 1983 {
	
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

/*
gen ind = ind70 if !missing(ind70)
replace ind = ind80 if missing(ind) & !missing(ind80)
drop if missing(ind)
*/

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
replace id = id + "_E"

save "cleaned_data_79to84.dta", replace

// Probably dropped too many here...



