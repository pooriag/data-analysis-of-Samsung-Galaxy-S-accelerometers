# data-analysis-of-Samsung-Galaxy-S-accelerometers

raw data has been downloaded if you are interested you can check "run_analysis.R" for link

datsets from unzipped folder has been loaded into data frames "test_data" and "train_data" ; unwanted variables has been removed; these two data frames has been merged into "total_data" and it was summarized with mean function and for each subject and activity.

for more detailed workflow see "run_analysis.R"

"run_analysis.R" : script for obtaining wanted dataset
"./data/tidy_data" : directory for tidy dataset
"./data/zip_data" : zipped file of raw data
"./data/UCI HAR Dataset" : unzipped of "./data/zip_data"
