# The Downward Nominal Wage Rigidity Gap for Lower-Income Workers

## Kevin Cao
## Dartmouth College, ECON80 24F
## Taught by Professor Douglas Staiger

Welcome to my data and code repository for my ECON80 (Advanced Topics in Econometrics) term paper for the 24F term! 

### Instructions for Replication
I have made it pretty easy to replicate the entire study, including the cleaning process and the production of the graph/table outputs. All you have to do is to clone/download the entire repository, and then hit do in the master `replicate.do` file, which should run all of the code from the very beginning to the very end.

The only technical requirements are Stata 17.0, Jupyter Notebook, and Python 3 (especially the Pandas library).

### Overview
Just some notes and brief overview of this organization of this repository:

* `Data` - All of the raw and cleaned data, including the code used for cleaning
   * `CPS Clean`
       * Cleaned linked chunks of CPS data.
       * The code files that created these cleaned linked chunks from the raw annual CPS data
    * `CPS Raw`
       * The raw annual CPS data for the merged outgoing rotation groups, as obtained from the NBER website
    * `Macro Raw`
       * The raw data for annual macroeconomic data found from the FRED website (which obtained these from BLS)
       * A Python Jupyter Notebook that cleaned these separate data files and compiled them into one consistent dataset
    * `compile.do` is the .do file that combines and makes consistent the chunks of cleaned CPS data files into one single data file. The output for this datafile is called `cleaned_data.dta`, but it is too large (>100 MB) to be put in a github repository. However, this can be created via `compile.do` or the master `replicate.do` file.
    * `macro_variables.dta` is cleaned dataset with all of the annual macroeconomic variables that we use in our analysis.
* `Plots` - Any image output that will be used for the paper
    * `rtw_map_plot.ipynb` is a jupyter notebook file which uses python to generate Figure 3 from the paper.
* `Tables` - Any table output that will be used for the paper
* `analysis.do` - Creates any plots and tables for the paper, utilizes the `cleaned_data.dta` that is created by `compile.do`
* `replicate.do` - A master do file that replicates the entire study, from dataset creation and cleaning to the actual analysis and creation of plot/table outputs. 



