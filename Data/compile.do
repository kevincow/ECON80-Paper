clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/Data/"
cd "`dir'"

use "./CPS Clean/cleaned_data_04to23.dta", clear
append using "./CPS Clean/cleaned_data_01to04.dta"
append using "./CPS Clean/cleaned_data_96to01.dta"
append using "./CPS Clean/cleaned_data_94to96.dta"
append using "./CPS Clean/cleaned_data_93to94.dta"
append using "./CPS Clean/cleaned_data_89to93.dta"
append using "./CPS Clean/cleaned_data_88to89.dta"
append using "./CPS Clean/cleaned_data_86to89.dta"
append using "./CPS Clean/cleaned_data_85to86.dta"
append using "./CPS Clean/cleaned_data_84to85.dta"
append using "./CPS Clean/cleaned_data_79to84.dta"

// Make the state dummies consistent
replace stfips = 1 if state == 63	 	// Alabama
replace stfips = 2 if state == 94		// Alaska
replace stfips = 4 if state == 86		// Arizona
replace stfips = 5 if state == 71		// Arkansas
replace stfips = 6 if state == 93		// California
replace stfips = 8 if state == 84		// Colorado
replace stfips = 9 if state == 16	// Connecticut
replace stfips = 10 if state == 51		// Delaware
replace stfips = 11 if state == 53		// DC
replace stfips = 12 if state == 59    	// Florida
replace stfips = 13 if state == 58		// Georgia
replace stfips = 15 if state == 95		// Hawaii
replace stfips = 16 if state == 82		// Idaho
replace stfips = 17 if state == 32	// Indiana
replace stfips = 18 if state == 33		// Illinois
replace stfips = 19 if state == 42		// Iowa
replace stfips = 20 if state == 47		// Kansas
replace stfips = 21 if state == 61		// Kentucky
replace stfips = 22 if state == 72		// Louisiana
replace stfips = 23 if state == 11		// Maine
replace stfips = 24 if state == 52	// Maryland	
replace stfips = 25 if state == 14		// Massachusetts
replace stfips = 26 if state == 34		// Michigan
replace stfips = 27 if state == 41		// Minnesota
replace stfips = 28 if state == 64		// Mississippi
replace stfips = 29 if state == 43		// Missouri
replace stfips = 30 if state == 81		// Montana
replace stfips = 31 if state == 46	// Nebraska
replace stfips = 32 if state == 88		// Nevada
replace stfips = 33 if state == 12	// New Hampshire
replace stfips = 34 if state == 22		// New Jersey
replace stfips = 35 if state == 85		// New Mexico
replace stfips = 36 if state == 21		// New York
replace stfips = 37 if state == 56		// North Carolina
replace stfips = 38 if state == 44		// North Dakota
replace stfips = 39 if state == 31		// Ohio
replace stfips = 40 if state == 73	// Oklahoma 
replace stfips = 41 if state == 92		// Oregon
replace stfips = 42 if state == 23		// Pennsylvania
replace stfips = 44 if state == 15		// Rhode Island
replace stfips = 45 if state == 57		// South Carolina
replace stfips = 46 if state == 45	// South Dakota
replace stfips = 47 if state == 62		// Tennessee
replace stfips = 48 if state == 74		// Texas
replace stfips = 49 if state == 87		// Utah
replace stfips = 50 if state == 13 		// Vermont
replace stfips = 51 if state == 54		// Virginia
replace stfips = 53 if state == 91		// Washington
replace stfips = 54 if state == 55		// West Virginia
replace stfips = 55 if state == 35		// Wisconsin
replace stfips = 56 if state == 83		// Wyoming

// Replace the highest grade completed
gen educ = gradeat
replace educ = 0 if grade92 == 31  // Less Than 1st Grade
replace educ = 2.5 if grade92 == 32  // 1st to 4th Grade
replace educ = 5.5 if grade92 == 33  // 5th to 6th Grade
replace educ = 7.5 if grade92 == 34  // 7th to 8th Grade
replace educ = 9 if grade92 == 35  // 9th Grade
replace educ = 10 if grade92 == 36 // 10th Grade
replace educ = 11 if grade92 == 37 // 11th Grade
replace educ = 12 if grade92 == 38 // 12th Grade No Diploma
replace educ = 13 if grade92 == 39 // High School Graduate
replace educ = 14 if grade92 == 40 // Some College, No Degree
replace educ = 15 if grade92 == 41 // Associate Degree (Occupational/Vocational)
replace educ = 15 if grade92 == 42 // Associate Degree (Academic)
replace educ = 16 if grade92 == 43 // Bachelor's Degree
replace educ = 17 if grade92 == 44 // Master's Degree
replace educ = 18 if grade92 == 45 // Professional Degree
replace educ = 18 if grade92 == 46 // Doctorate Degree

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
	
// Uses 1990 codes?
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

// Reintroduce the labels for the new ind variable
label define ind_label 1 "Agriculture/Forestry/Fishing/Hunting" ///
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

label values ind ind_label

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

label define occ_label 1 "Management" ///
                       2 "Financial Operations" ///
                       3 "Computer/Math Operations" ///
                       4 "Architecture/Engineering" ///
                       5 "Life/Physical/Social Sciences" ///
                       6 "Community/Social Services" ///
                       7 "Legal" ///
                       8 "Education" ///
                       9 "Arts/Entertainment/Media" ///
                       10 "Healthcare Practitioner" ///
                       11 "Healthcare Support" ///
                       12 "Protective Services" ///
                       13 "Food Services" ///
                       14 "Cleaning" ///
                       15 "Personal Services" ///
                       16 "Sales" ///
                       17 "Administrative Support" ///
                       18 "Farming/Fishing/Forestry" ///
                       19 "Construction" ///
                       20 "Installation/Maintenance" ///
                       21 "Production" ///
					   22 "Transportation" ///
					   23 "Material Moving" ///
					   24 "Military" ///

label values occ occ_label

drop if missing(occ)

// Drop allocateds
drop if I25a == 1 | I25b == 1 | I25c == 1 | I25d == 1     // 45,120 observations deleted mostly from recent years


// Encode a numeric ID variable
drop id 
gen id = _n

save "cleaned_data.dta", replace
