### Data Source and Transformations

Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data unzipped to a folder 'UCI HAR Dataset' containing the following used files:

 * **activity_labels.txt** - Code-name pair table. Integer activity code were used in the y_train.txt and y_test.txt target factor files, and these converted to the activity name using this table to obtain a more descriptive result. The activity names were converted to lower case and had the underscores removed.

 * **features_info.txt** - This file provides some background on how the values in the X_train.txt and X_test.txt were obtained and some explantion of the format of the feature names in the the features.txt file. Mention was made of 'mean' type features on 'angle() variables'. Those variables were not included in that the intention appeared to be that those variable values were computed as angles from two vectors of mean measurements and hence not directly satisfying the *mean* or *std* requirement for the current project.

 * **features.txt** - Contains a list of 561 feature names whose order corresponds to the variable columns in the X_train.txt and X_test.txt files. Only the feature names having the strings *-mean* and *-std* were selected for further processing. The feature names were converted to lower case and had the dashes and paretheses removed. The feature names are somewhat cryptic and very briefly described in the features_info.txt file with additional background in README.txt. No further expanding or translation of the feature names was attempted because the resulting names were long for variable names and were concatenations of abbreviations that if expanded would result in excessively long names.

 * **README.txt** - This file provides additional background information for the researchers collecting the data, how the data was collected, file descriptions, 
test/subject_test.txt, and a license.

 * **train/X_train.txt** and **test/X_test.txt** - These files contain the feature data. The two features files were concatenated with rbind in the order shown to an *X* table with the cleaned feature names applied to the columns. The *mean* and *std* columns were extracted to an *X_sub* table for further processing.
 
 * **train/y_train.txt** and **test/y_test.txt** - These files were concatenated with rbind in the order shown to a *y* table and contain the activity code target factors or classes for each row of the feature files. The activity codes were converted to the activity names, a factor, before further processing.

 * **train/subject_train.txt** and **test/subject_test.txt** - These files were concatenated with rbind in the order shown to a *subject* table and contain the subject (person) ids for each row of the feature files. The ids were converted to a factor before further processing.

The *subject*, *y*, and *X_sub* tables were concatenated with cbind to obtain the final combined data table *X_final* before computing the mean table for all numeric variables by subject and activity. Correctly aligned rbind orders were maintained for each of the three tables. *subjectid* and *activity* variable names were applied to the resulting subject and activity variables (first two columns).

An *X_means* table for all feature variables by subject and activity was computed.

The final tidy table *tidy_data_set* was gathered from the *X_means* table. The result contained the prior *subjectid* and *activity* variables and a key variable of feature names *measurement* and a value variable of the mean, *average*, for each subject/activity/feature combination. *tidy_data_set* was sorted and the *tidy_data_set.txt* was written.

