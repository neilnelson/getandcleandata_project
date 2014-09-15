### Scripts

**run_analysis.R** - This is the only script. See the script for detailed processing notes.

 * WARNING: All objects are removed from the R context using *rm(list=ls())* when the script is run to avoid conflicts and minimize resource usage. Comment this line at the top of the script if this is not desired.

 * The script needs to be run in the directory immediately above the unzipped *UCI HAR Dataset* directory containing the downloaded data. The class project page implies this testing context. Alternatively the working directory will be created and data download by setting create_work_dir_and_download_data to TRUE at the top of the script.

 * The **data.table** and **tidyr** packages are required.

 * A **tidy_data_set.txt** file is written to the work directory containing the required project script result.

