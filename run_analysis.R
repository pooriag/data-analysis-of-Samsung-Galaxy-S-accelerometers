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
train_data <- train_data %>% select( c( subject, activity, contains(c(".mean..", ".std..")) ) )


############


## loading test data

### loading test features
test_data <- read.table("data/UCI HAR Dataset/test/X_test.txt", col.names = features)
test_data <- tbl_df(test_data)

### adding train activity class to train data
test_activity_file <- file("data/UCI HAR Dataset/test/y_test.txt", "r")
test_activities <- as.numeric(readLines(test_activity_file))
close(test_activity_file, "r")
rm("test_activity_file")

test_activities <- sapply(test_activities, function(activity){
      activities[activity]
})

test_data <- test_data %>% mutate(activity = test_activities, .before = tBodyAcc.mean...X)

### adding subjects of observations to train_data
test_obs_sub_file <- file("data/UCI HAR Dataset/test/subject_test.txt", "r")
test_obs_sub <- as.character(readLines(test_obs_sub_file))
close(test_obs_sub_file, "r")
rm("test_obs_sub_file")

test_data <- test_data %>% mutate(subject = test_obs_sub, .before = activity)

### removing columns other than columns containing means and stds
test_data <- test_data %>% select( c( subject, activity, contains(c(".mean..", ".std..")) ) )

############################################################################

# combinint test and train data
data_total <- rbind(train_data, test_data)

#grouping dataset by activity and subjects
grouped_data <- data_total %>% group_by(subject, activity)

# averaging(summarizing) grouped data for each group(for different activities of each subject)
summarized_data <- grouped_data %>% summarize_at(vars(tBodyAcc.mean...X:fBodyBodyGyroJerkMag.std..), mean, na.rm=T)

# cleaning final data variable names
names(summarized_data) <- gsub("\\.\\.", "\\(\\)", names(summarized_data))
names(summarized_data) <- gsub("\\.", "\\_", names(summarized_data))
#names(summarized_data) <- gsub("\\.$", "", names(summarized_data))

# replacing names of final data with more discriptive names
names(summarized_data) <- c(names(summarized_data)[1:2], paste0("mean_of_" , names(summarized_data)[3:length(names(summarized_data))]))

# separating average of means and stds into to table and saving them
summarized_of_mean <- summarized_data %>% select( c( subject, activity, contains("_mean") ) )
summarized_of_std <- summarized_data %>% select( c( subject, activity, contains("_std")))

# writing tidy datsets to a file
if(!dir.exists("./data/tidy_data/")) dir.create("./data/tidy_data/")

file.create("./data/tidy_data/mean_of_means")
write.table(summarized_of_mean, file("./data/tidy_data/mean_of_means" , "w"))
close("./data/tidy_data/mean_of_means" , "w")

file.create("./data/tidy_data/mean_of_stds")
write.table(summarized_of_std, file("./data/tidy_data/mean_of_stds" , "w"))
close("./data/tidy_data/mean_of_stds" , "w")


