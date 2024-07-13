# importing libraries
library(dplyr)


## downloading the zip data file 
if (dir.exists("./data")){
      download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/zip_data")
      date_of_latest_download <<- Sys.Date()
}else {
      dir.create("./data")
      download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/zip_data")
      date_of_latest_download <<- Sys.Date()
}

## unzipping file (make sure that you don't want the previous unzipped files because they will be replaced)
unzip("./data/zip_data", exdir = "./data", overwrite = T)

#############################################################################

# loading test and train dataframes

## loading feature names
features_file <- file("data/UCI HAR Dataset/features.txt", "r")
features <- as.character(readLines(features_file))
close(features_file, "r")
rm("features_file")
features <- strsplit(features, "^[0-9]* ")
features <- sapply(features, function(feature){
      feature[2]
})

##assigning activities to their class number
activity_class_file <- file("data/UCI HAR Dataset/activity_labels.txt", "r")
activities <- as.character(readLines(activity_class_file))
close(activity_class_file, "r")
rm("activity_class_file")
activities <- strsplit(activities, " ")
activities <- sapply(activities, function(line){
      line[2]
})

## loading train data

### loading train features
train_data <- read.table("data/UCI HAR Dataset/train/X_train.txt", col.names = features)
train_data <- tbl_df(train_data)

### adding train activity class to train data
train_activity_file <- file("data/UCI HAR Dataset/train/y_train.txt", "r")
train_activities <- as.numeric(readLines(train_activity_file))
close(train_activity_file, "r")
rm("train_activity_file")

train_activities <- sapply(train_activities, function(activity){
      activities[activity]
})

train_data <- train_data %>% mutate(activity = train_activities, .before = tBodyAcc.mean...X)

### adding subjects of observations to train_data
train_obs_sub_file <- file("data/UCI HAR Dataset/train/subject_train.txt", "r")
train_obs_sub <- as.character(readLines(train_obs_sub_file))
close(train_obs_sub_file, "r")
rm("train_obs_sub_file")

train_data <- train_data %>% mutate(subject = train_obs_sub, .before = activity)

### removing columns other than columns containing means and stds
#train_data <- train_data %>% select(c(contains(c("std", "mean")) , ))






