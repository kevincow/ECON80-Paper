clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Data/"
cd "`dir'"

*************************** Compile the data **********************************


use "morg04.dta", clear

// Concatenate all years of data into one dataset
foreach year in 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 {
	
	append using morg`year' 
	
}

// Need to first convert first or else we don't know who switched between certain years (since no more overlap)

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

cap drop ind
gen ind = .

replace ind = 1 if (year >= 2020) & ind17 <= 290
replace ind = 2 if (year >= 2020) & ind17 >= 370 & ind17 <= 490
replace ind = 3 if (year >= 2020) & ind17 == 770
replace ind = 4 if (year >= 2020) & ind17 >= 1070 & ind17 <= 3990
replace ind = 5 if (year >= 2020) & ind17 >= 4070 & ind17 <= 4590
replace ind = 6 if (year >= 2020) & ind17 >= 4670 & ind17 <= 5790
replace ind = 7 if (year >= 2020) & ind17 >= 6070 & ind17 <= 6390
replace ind = 8 if (year >= 2020) & ind17 >= 570 & ind17 <= 690
replace ind = 9 if (year >= 2020) & ind17 >= 6470 & ind17 <= 6780
replace ind = 10 if (year >= 2020) & ind17 >= 6870 & ind17 <= 6992
replace ind = 11 if (year >= 2020) & ind17 >= 7071 & ind17 <= 7190
replace ind = 12 if (year >= 2020) & ind17 >= 7270 & ind17 <= 7490
replace ind = 13 if (year >= 2020) & ind17 == 7570
replace ind = 14 if (year >= 2020) & ind17 >= 7580 & ind17 <= 7790
replace ind = 15 if (year >= 2020) & ind17 >= 7860 & ind17 <= 7890
replace ind = 16 if (year >= 2020) & ind17 >= 7970 & ind17 <= 8470
replace ind = 17 if (year >= 2020) & ind17 >= 8561 & ind17 <= 8590
replace ind = 18 if (year >= 2020) & ind17 >= 8660 & ind17 <= 8690
replace ind = 19 if (year >= 2020) & ind17 >= 8770 & ind17 <= 9290
replace ind = 20 if (year >= 2020) & ind17 >= 9370 & ind17 <= 9590
replace ind = 21 if (year >= 2020) & ind17 >= 9670 & ind17 <= 9870

	
replace ind = 1 if (year >= 2000 & year <= 2019) & ind02 <= 290
replace ind = 2 if (year >= 2000 & year <= 2019) & ind02 >= 370 & ind02 <= 490
replace ind = 3 if (year >= 2000 & year <= 2019) & ind02 == 770
replace ind = 4 if (year >= 2000 & year <= 2019) & ind02 >= 1070 & ind02 <= 3990
replace ind = 5 if (year >= 2000 & year <= 2019) & ind02 >= 4070 & ind02 <= 4590
replace ind = 6 if (year >= 2000 & year <= 2019) & ind02 >= 4690 & ind02 <= 5790
replace ind = 7 if (year >= 2000 & year <= 2019) & ind02 >= 6070 & ind02 <= 6390
replace ind = 8 if (year >= 2000 & year <= 2019) & ind02 >= 570 & ind02 <= 690
replace ind = 9 if (year >= 2000 & year <= 2019) & ind02 >= 6470 & ind02 <= 6780
replace ind = 10 if (year >= 2000 & year <= 2019) & ind02 >= 6870 & ind02 <= 6990
replace ind = 11 if (year >= 2000 & year <= 2019) & ind02 >= 7070 & ind02 <= 7190
replace ind = 12 if (year >= 2000 & year <= 2019) & ind02 >= 7270 & ind02 <= 7490
replace ind = 13 if (year >= 2000 & year <= 2019) & ind02 == 7570
replace ind = 14 if (year >= 2000 & year <= 2019) & ind02 >= 7580 & ind02 <= 7790
replace ind = 15 if (year >= 2000 & year <= 2019) & ind02 >= 7860 & ind02 <= 7890
replace ind = 16 if (year >= 2000 & year <= 2019) & ind02 >= 7970 & ind02 <= 8470
replace ind = 17 if (year >= 2000 & year <= 2019) & ind02 >= 8560 & ind02 <= 8590
replace ind = 18 if (year >= 2000 & year <= 2019) & ind02 >= 8660 & ind02 <= 8690 
replace ind = 19 if (year >= 2000 & year <= 2019) & ind02 >= 8770 & ind02 <= 9290
replace ind = 20 if (year >= 2000 & year <= 2019) & ind02 >= 9370 & ind02 <= 9590
replace ind = 21 if (year >= 2000 & year <= 2019) & ind02 >= 9670 & ind02 <= 9870
	

// replace ind = 21 if ...

// Reintroduce the labels for the new ind variable
label define ind_labels 1 "Agriculture/Forestry/Fishing/Hunting" ///
                       2 "Mining/Oil" ///
                       3 "Construction" ///
                       4 "Manufacturing" ///
                       5 "Wholesale Trade" ///
                       6 "Retail Trade" ///
                       7 "Transportation/Warehousing" ///
                       8 "Utilities" ///
                       9 "Communications" ///
                       10 "Finance/Insurance" ///
                       11 "Real Estate" ///
                       12 "Professional/Scientific/Technical Services" ///
                       13 "Consulting" ///
                       14 "Business Administrative/Support Services" ///
                       15 "Education" ///
                       16 "Healthcare/Social Assistance" ///
                       17 "Arts/Entertainment/Recreation" ///
                       18 "Accommodation/Food Services" ///
                       19 "Other Services" ///
                       20 "Public Administration" ///
                       21 "Military"

label values ind ind_labels

drop if missing(ind)		// Drops 298 observations, all from older datasets



// Make a consistent new occupation variable

cap drop occ
gen occ = .

replace occ = 1 if (year >= 2020) & occ18 <= 440 
replace occ = 2 if (year >= 2020) & occ18 >= 500 & occ18 <= 960
replace occ = 3 if (year >= 2020) & occ18 >= 1005 & occ18 <= 1240
replace occ = 4 if (year >= 2020) & occ18 >= 1305 & occ18 <= 1560
replace occ = 5 if (year >= 2020) & occ18 >= 1600 & occ18 <= 1980
replace occ = 6 if (year >= 2020) & occ18 >= 2001 & occ18 <= 2060
replace occ = 7 if (year >= 2020) & occ18 >= 2100 & occ18 <= 2180
replace occ = 8 if (year >= 2020) & occ18 >= 2205 & occ18 <= 2255
replace occ = 9 if (year >= 2020) & occ18 >= 2600 & occ18 <= 2970
replace occ = 10 if (year >= 2020) & occ18 >= 3000 & occ18 <= 3550
replace occ = 11 if (year >= 2020) & occ18 >= 3601 & occ18 <= 4655
replace occ = 12 if (year >= 2020) & occ18 >= 3700 & occ18 <= 3960
replace occ = 13 if (year >= 2020) & occ18 >= 4000 & occ18 <= 4160
replace occ = 14 if (year >= 2020) & occ18 >= 4200 & occ18 <= 4255
replace occ = 15 if (year >= 2020) & occ18 >= 4300 & occ18 <= 4655
replace occ = 16 if (year >= 2020) & occ18 >= 4700 & occ18 <= 4965
replace occ = 17 if (year >= 2020) & occ18 >= 5000 & occ18 <= 5940
replace occ = 18 if (year >= 2020) & occ18 >= 6005 & occ18 <= 6130
replace occ = 19 if (year >= 2020) & occ18 >= 6200 & occ18 <= 6950
replace occ = 20 if (year >= 2020) & occ18 >= 7000 & occ18 <= 7640
replace occ = 21 if (year >= 2020) & occ18 >= 7700 & occ18 <= 8990
replace occ = 22 if (year >= 2020) & occ18 >= 9005 & occ18 <= 9430
replace occ = 23 if (year >= 2020) & occ18 >= 9510 & occ18 <= 9760
replace occ = 24 if (year >= 2020) & occ18 >= 9800

// For some reason occ2012 and occ2011 are split; they are the same
replace occ = 1 if (year >= 2012 & year <= 2019) & occ2012 <= 430
replace occ = 2 if (year >= 2012 & year <= 2019) & occ2012 >= 500 & occ2012 <= 950
replace occ = 3 if (year >= 2012 & year <= 2019) & occ2012 >= 1000 & occ2012 <= 1240
replace occ = 4 if (year >= 2012 & year <= 2019) & occ2012 >= 1300 & occ2012 <= 1560
replace occ = 5 if (year >= 2012 & year <= 2019) & occ2012 >= 1600 & occ2012 <= 1965
replace occ = 6 if (year >= 2012 & year <= 2019) & occ2012 >= 2000 & occ2012 <= 2060
replace occ = 7 if (year >= 2012 & year <= 2019) & occ2012 >= 2100 & occ2012 <= 2160
replace occ = 8 if (year >= 2012 & year <= 2019) & occ2012 >= 2200 & occ2012 <= 2550
replace occ = 9 if (year >= 2012 & year <= 2019) & occ2012 >= 2600 & occ2012 <= 2960
replace occ = 10 if (year >= 2012 & year <= 2019) & occ2012 >= 3000 & occ2012 <= 3540
replace occ = 11 if (year >= 2012 & year <= 2019) & occ2012 >= 3600 & occ2012 <= 3655
replace occ = 12 if (year >= 2012 & year <= 2019) & occ2012 >= 3700 & occ2012 <= 3955
replace occ = 13 if (year >= 2012 & year <= 2019) & occ2012 >= 4000 & occ2012 <= 4160
replace occ = 14 if (year >= 2012 & year <= 2019) & occ2012 >= 4200 & occ2012 <= 4250
replace occ = 15 if (year >= 2012 & year <= 2019) & occ2012 >= 4300 & occ2012 <= 4650
replace occ = 16 if (year >= 2012 & year <= 2019) & occ2012 >= 4700 & occ2012 <= 4965
replace occ = 17 if (year >= 2012 & year <= 2019) & occ2012 >= 5000 & occ2012 <= 5940
replace occ = 18 if (year >= 2012 & year <= 2019) & occ2012 >= 6005 & occ2012 <= 6130
replace occ = 19 if (year >= 2012 & year <= 2019) & occ2012 >= 6200 & occ2012 <= 6940
replace occ = 20 if (year >= 2012 & year <= 2019) & occ2012 >= 7000 & occ2012 <= 7630
replace occ = 21 if (year >= 2012 & year <= 2019) & occ2012 >= 7700 & occ2012 <= 8965
replace occ = 22 if (year >= 2012 & year <= 2019) & occ2012 >= 9000 & occ2012 <= 9420
replace occ = 23 if (year >= 2012 & year <= 2019) & occ2012 >= 9500 & occ2012 <= 9750
replace occ = 24 if (year >= 2012 & year <= 2019) & occ2012 >= 9800 & occ2012 <= 9830

replace occ = 1 if (year >= 2011 & year <= 2012) & occ2011 <= 430
replace occ = 2 if (year >= 2011 & year <= 2012) & occ2011 >= 500 & occ2011 <= 950
replace occ = 3 if (year >= 2011 & year <= 2012) & occ2011 >= 1000 & occ2011 <= 1240
replace occ = 4 if (year >= 2011 & year <= 2012) & occ2011 >= 1300 & occ2011 <= 1560
replace occ = 5 if (year >= 2011 & year <= 2012) & occ2011 >= 1600 & occ2011 <= 1965
replace occ = 6 if (year >= 2011 & year <= 2012) & occ2011 >= 2000 & occ2011 <= 2060
replace occ = 7 if (year >= 2011 & year <= 2012) & occ2011 >= 2100 & occ2011 <= 2160
replace occ = 8 if (year >= 2011 & year <= 2012) & occ2011 >= 2200 & occ2011 <= 2550
replace occ = 9 if (year >= 2011 & year <= 2012) & occ2011 >= 2600 & occ2011 <= 2960
replace occ = 10 if (year >= 2011 & year <= 2012) & occ2011 >= 3000 & occ2011 <= 3540
replace occ = 11 if (year >= 2011 & year <= 2012) & occ2011 >= 3600 & occ2011 <= 3655
replace occ = 12 if (year >= 2011 & year <= 2012) & occ2011 >= 3700 & occ2011 <= 3955
replace occ = 13 if (year >= 2011 & year <= 2012) & occ2011 >= 4000 & occ2011 <= 4160
replace occ = 14 if (year >= 2011 & year <= 2012) & occ2011 >= 4200 & occ2011 <= 4250
replace occ = 15 if (year >= 2011 & year <= 2012) & occ2011 >= 4300 & occ2011 <= 4650
replace occ = 16 if (year >= 2011 & year <= 2012) & occ2011 >= 4700 & occ2011 <= 4965
replace occ = 17 if (year >= 2011 & year <= 2012) & occ2011 >= 5000 & occ2011 <= 5940
replace occ = 18 if (year >= 2011 & year <= 2012) & occ2011 >= 6005 & occ2011 <= 6130
replace occ = 19 if (year >= 2011 & year <= 2012) & occ2011 >= 6200 & occ2011 <= 6940
replace occ = 20 if (year >= 2011 & year <= 2012) & occ2011 >= 7000 & occ2011 <= 7630
replace occ = 21 if (year >= 2011 & year <= 2012) & occ2011 >= 7700 & occ2011 <= 8965
replace occ = 22 if (year >= 2011 & year <= 2012) & occ2011 >= 9000 & occ2011 <= 9420
replace occ = 23 if (year >= 2011 & year <= 2012) & occ2011 >= 9500 & occ2011 <= 9750
replace occ = 24 if (year >= 2011 & year <= 2012) & occ2011 >= 9800 & occ2011 <= 9830

replace occ = 1 if (year >= 2000 & year <= 2010) & occ00 <= 430
replace occ = 2 if (year >= 2000 & year <= 2010) & occ00 >= 500 & occ00 <= 950
replace occ = 3 if (year >= 2000 & year <= 2010) & occ00 >= 1000 & occ00 <= 1240
replace occ = 4 if (year >= 2000 & year <= 2010) & occ00 >= 1300 & occ00 <= 1560
replace occ = 5 if (year >= 2000 & year <= 2010) & occ00 >= 1600 & occ00 <= 1960
replace occ = 6 if (year >= 2000 & year <= 2010) & occ00 >= 2000 & occ00 <= 2060
replace occ = 7 if (year >= 2000 & year <= 2010) & occ00 >= 2100 & occ00 <= 2150
replace occ = 8 if (year >= 2000 & year <= 2010) & occ00 >= 2200 & occ00 <= 2550
replace occ = 9 if (year >= 2000 & year <= 2010) & occ00 >= 2600 & occ00 <= 2960
replace occ = 10 if (year >= 2000 & year <= 2010) & occ00 >= 3000 & occ00 <= 3540
replace occ = 11 if (year >= 2000 & year <= 2010) & occ00 >= 3600 & occ00 <= 3650
replace occ = 12 if (year >= 2000 & year <= 2010) & occ00 >= 3700 & occ00 <= 3950
replace occ = 13 if (year >= 2000 & year <= 2010) & occ00 >= 4000 & occ00 <= 4160
replace occ = 14 if (year >= 2000 & year <= 2010) & occ00 >= 4200 & occ00 <= 4250
replace occ = 15 if (year >= 2000 & year <= 2010) & occ00 >= 4300 & occ00 <= 4650
replace occ = 16 if (year >= 2000 & year <= 2010) & occ00 >= 4700 & occ00 <= 4960
replace occ = 17 if (year >= 2000 & year <= 2010) & occ00 >= 5000 & occ00 <= 5930
replace occ = 18 if (year >= 2000 & year <= 2010) & occ00 >= 6000 & occ00 <= 6130
replace occ = 19 if (year >= 2000 & year <= 2010) & occ00 >= 6200 & occ00 <= 6940
replace occ = 20 if (year >= 2000 & year <= 2010) & occ00 >= 7000 & occ00 <= 7620
replace occ = 21 if (year >= 2000 & year <= 2010) & occ00 >= 7700 & occ00 <= 8960
replace occ = 22 if (year >= 2000 & year <= 2010) & occ00 >= 9000 & occ00 <= 9420
replace occ = 23 if (year >= 2000 & year <= 2010) & occ00 >= 9500 & occ00 <= 9750
replace occ = 24 if (year >= 2000 & year <= 2010) & occ00 >= 9800

drop if missing(occ) 	

// Find number of observations for each household 
keep if hhnum == 1
egen nobs = count(hhid), by(hhid hrhhid2 lineno ind occ)

// Drop if there aren't 2 different observations (might need to investigate if certain types of households dropped out so no bias from attrition) *just use nobs == 1 for this*
keep if nobs == 2
drop nobs

/*
tab nobs minsamp if nobs == 2

tab nobs minsamp

tab year minsamp if nobs == 2
*/

// Create a unique identifier
egen id = group(hhid hrhhid2 lineno)

sort id minsamp

gen is_mis4 = (minsamp == 4)
gen is_mis8 = (minsamp == 8)

bysort id: egen mis4 = total(is_mis4)
bysort id: egen mis8 = total(is_mis8)

keep if (mis4 == 1 & mis8 == 1)

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

// Remove anyone who is reported to have made $9999 per hour or missing (also people making like nothing?)
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
/*
gen ind = .
replace ind = ind02 if !missing(ind02)
replace ind = ind17 if missing(ind) & !missing(ind17)
*/
// be careful in case there is a reworking of how these things are coded

// Merge occupation variables (need to merge the occs but they are coded differently)
/*
gen occ = .
replace occ = occ002 if !missing(occ002)
replace occ = occ18 if missing(occ) & !missing(occ18)
*/

// Make sure there are no overlapping IDs when we need to concatenate
tostring id, replace
replace id = id + "_A"

// Save and export
save "cleaned_data_04to23.dta", replace
