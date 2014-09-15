# run_analysis.R

# Remove any prior objects to minimize resource use and avoid possible
# contamination.
rm(list=ls())

# work_dir and downloading should not be required according to the testing
# instructions.
create_work_dir_and_download_data <- FALSE

# *** Replace the following work directory with your own.
if (create_work_dir_and_download_data)
  work_dir <- "/home/nnelson/Documents/classes/coursera/data_specialization/getdata/project"

HAR_dir <- "UCI HAR Dataset"

# Requirement
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

library(data.table)
library(tidyr)

if (create_work_dir_and_download_data) {
  # Create work directory if needed.
  if (!file.exists(work_dir)) {
    dir.create(work_dir, recursive=TRUE)
    if (!file.exists(work_dir)) # should exist but making sure
      stop("ERROR: Unable to create work directory ")
  }
  setwd(work_dir)

  # Download and unzip dataset if needed.
  if (!file.exists(HAR_dir)) {
    fileDest <- "HAR_Dataset.zip"
    if (!file.exists(fileDest)) {
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile=fileDest, method="curl")
      dateDownloaded <- date()
      dput(dateDownloaded,file="HAR_Dataset.zip_download_date")
      rm(dateDownloaded)
    }
    unzip(fileDest)
  }
}

# Load X_train and X_test tables efficiently. These files were observed to have
# a consistent fixed line length throughout and so the number of lines (rows) in
# the file would be greater than or equal to the file size divided by the length
# of the first line. The 'greater than' possiblity results from having a line
# length available after reading that does not include the line termination and
# spaces from trimming. The ratio of reduction in observed line length over the
# actual line length is quite small, and having a small excess of nrows provided
# to the read.table syntax is noted in the documentation as acceptable.

# The resulting load time and memory usage for the following method as against
# using, for example, the read.fwf method was considerable.

X_train_info <- file.info(paste0("./",HAR_dir,"/train/X_train.txt"))
con <- file(paste0("./",HAR_dir,"/train/X_train.txt"), "r", blocking=FALSE)
first_line <- readLines(con, n=1)
close(con)
X_train_rows <- as.integer(X_train_info$size/nchar(first_line))
X_train <- read.table(paste0("./",HAR_dir,"/train/X_train.txt"), comment.char="",
  colClasses = "numeric", nrows=X_train_rows)

X_test_info <- file.info(paste0("./",HAR_dir,"/test/X_test.txt"))
con <- file(paste0("./",HAR_dir,"/test/X_test.txt"), "r", blocking=FALSE)
first_line <- readLines(con, n=1)
close(con)
X_test_rows <- as.integer(X_test_info$size/nchar(first_line))
X_test <- read.table(paste0("./",HAR_dir,"/test/X_test.txt"), comment.char = "",
  colClasses = "numeric", nrows=X_test_rows)

# rbind X_train and X_test tables and remove objects no longer needed.
X <- rbind(X_train,X_test)
rm(con,first_line,X_train_info,X_test_info,X_train_rows,X_test_rows,X_train,X_test)

# Load the features names and apply them to the X table.
features <- read.table(paste0("./",HAR_dir,"/features.txt"))
names(X) <- features[,2]
rm(features)

# Get the features that will be used. Create a table of only those features.
ids <- sort(c(grep("-mean",names(X)), grep("-std",names(X))))
X_sub <- X[,names(X)[ids]]
rm(X,ids)

# Make the feature names tidy.
names(X_sub) <- tolower(gsub("\\(\\)","",gsub("-","",names(X_sub))))

# Load the y (target) train and test tables and rbind them.
y_train <- read.table(paste0("./",HAR_dir,"/train/y_train.txt"))
y_test <- read.table(paste0("./",HAR_dir,"/test/y_test.txt"))
y <- rbind(y_train,y_test)
rm(y_train,y_test)
names(y) <- "id"

# Load the activity labels, tidy the labels, and replace the activity code in
# the y table with its corresponding activity label.
activity_labels <- read.table(paste0("./",HAR_dir,"/activity_labels.txt"))
names(activity_labels) <- c("id","activity")
activity_labels$activity <- tolower(gsub("\\(\\)","",
  gsub("_","",activity_labels$activity)))
y[,"activity"] <- as.factor(activity_labels[y[,"id"],"activity"])
rm(activity_labels)

# Load and rbind the subject tables and create a subject factor vector.
subject_train <- read.table(paste0("./",HAR_dir,"/train/subject_train.txt"))
subject_test <- read.table(paste0("./",HAR_dir,"/test/subject_test.txt"))
subject <- as.factor(rbind(subject_train,subject_test)[,1])
rm(subject_train,subject_test)

# Combine the subject vector, activity_lables, and selected features.
X_final <- cbind(subject,y[,2],X_sub)
rm(subject,y,X_sub)
names(X_final)[1:2] <- c("subjectid","activity")

# Use data.table methods in the following.
setattr(X_final,"class",c("data.table","data.frame"))

# Get the column names of the features to be averaged and average them.
cols <- names(X_final)[3:length(names(X_final))]
X_means <- X_final[,lapply(.SD, function(x) list(mean=mean(x))),
  by=c("subjectid","activity"), .SDcols=cols ]
rm(X_final,cols)

# Gather the averages to measurement (key) and average (value) columns.
tidy_data_set <- gather(X_means, measurement, average, -(c(subjectid,activity)))
rm(X_means)

# Sort and write the tidy_data_set to a txt file.
tidy_data_set$average <- unlist(tidy_data_set$average) # unlist for write.
tidy_data_set <- tidy_data_set[order(subjectid,activity,measurement)]
write.table(tidy_data_set, file="tidy_data_set.txt", row.names=FALSE)

