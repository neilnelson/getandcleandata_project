### Scripts

**run_analysis.R** - This is the only script. See the script for detailed processing notes.

 * WARNING: All objects are removed from the R context using *rm(list=ls())* when the script is run to avoid conflicts and minimize resource usage. Comment this line at the top of the script if this is not desired.

 * The class project page implies that the script will be tested in the directory immediately above the unzipped *UCI HAR Dataset* directory containing the already downloaded and unzipped data. Alternatively *work_dir* can be set and *create_work_dir_and_download_data* set to TRUE at the top of the script to have the work directory created and the data downloaded.

 * The **data.table** and **tidyr** packages are required.

 * A **tidy_data_set.txt** file is written to the work directory containing the required project script result.

