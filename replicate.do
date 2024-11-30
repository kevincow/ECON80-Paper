clear all
set memory 600m
set more off

local dir "/Users/kevincao/Desktop/ECON80/ECON80-Paper/"
cd "`dir'"

local logfile master_log.log
cap log close
cap erase `logfile'
log using `logfile', replace

// Clean and link the raw CPS datasets
do "./Data/CPS Clean/construct_01.do"
cd "`dir'"
do "./Data/CPS Clean/construct_04.do"
cd "`dir'"
do "./Data/CPS Clean/construct_79.do"
cd "`dir'"
do "./Data/CPS Clean/construct_84.do"
cd "`dir'"
do "./Data/CPS Clean/construct_85.do"
cd "`dir'"
do "./Data/CPS Clean/construct_86.do"
cd "`dir'"
do "./Data/CPS Clean/construct_88.do"
cd "`dir'"
do "./Data/CPS Clean/construct_89.do"
cd "`dir'"
do "./Data/CPS Clean/construct_93.do"
cd "`dir'"
do "./Data/CPS Clean/construct_94.do"
cd "`dir'"
do "./Data/CPS Clean/construct_96.do"
cd "`dir'"

do "./Data/compile.do"
cd "`dir'"

// Perform the analysis
do "analysis.do"

// Close the log
cap log close 
