#
# Coursera Data Science Specialization
# Getting and Cleaning Data Course Project
# author: ckkhan
# date: 19th May 2016
#
# for project submission, prepare:
# A. a tidy data set.
# B. a link to a Github repository where this script ("run_analysis.R")
#    can be found. This script is to perform the following:
#       1. Merge the training and test data sets to create one data set.
#       2. Extract only the measurements on the mean and standard
#          deviation for each measurement.
#       3. Use descriptive activity names to name the activities in
#          the data set.
#       4. Label the data set appropriately with descriptive variable
#          names.
#       5. Create an independent tidy data set with the average of each
#          variable per activity and per subject.
# C. a code book that describes the variables, the data, and any
#    transformations or work that was performed to clean up the
#    data. This code book is to be named "CodeBook.md".
# D. a README.md to explain how the scripts work and are connected.
#

# main procedure to house the script. takes an optional parameter which tells
# it if it should insist of redownloading the source data and overwriting the
# existing copy, if any.
run_analysis_main <- function(overwrite=FALSE) {

    # load required R packages
    library(data.table)
    library(dplyr)
    library(tidyr)

    # retrieve a fresh copy of the data sets, if missing or required
    url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    fn<-"getdata_projectfiles_UCI_HAR_Dataset.zip"
    if(!file.exists(fn) || !dir.exists("UCI HAR Dataset") || overwrite) {
        download.file(url, fn, mode="wb")
        unzip(fn, overwrite=TRUE, exdir=getwd())
    }

    # load features.txt and activity_labels.txt into R tables
    ra_features<-ra_myfileload(filename="features.txt", columnnames=c("featureid", "featurename"))
    ra_activities<-ra_myfileload(filename="activity_labels.txt", columnnames=c("activityid", "activityname"))

    # training data set is located in "train" subdirectory
    # load subject_train.txt, X_train.txt and y_train.txt into R tables
    ra_subject_train<-ra_myfileload(filename="train/subject_train.txt", columnnames=c("subjectid"))
    ra_x_train<-ra_myfileload(filename="train/X_train.txt", columnnames=ra_features$featurename)
    ra_y_train<-ra_myfileload(filename="train/y_train.txt", columnnames=c("activityid"))

    # combine the various training data tables into 1 training data set table
    # & remove the source tables to release system resources.
    ra_train_data<-cbind(ra_subject_train, ra_y_train, ra_x_train)
    rm(list=c("ra_subject_train", "ra_y_train", "ra_x_train"))    
    
    # test data set is located in "test" subdirectory
    # load subject_train.txt, X_train.txt and y_train.txt into R tables
    ra_subject_test<-ra_myfileload(filename="test/subject_test.txt", columnnames=c("subjectid"))
    ra_x_test<-ra_myfileload(filename="test/X_test.txt", columnnames=ra_features$featurename)
    ra_y_test<-ra_myfileload(filename="test/y_test.txt", columnnames=c("activityid"))

    # combine the various test data tables into 1 test data set table
    # & remove the source tables to release system resources.
    ra_test_data<-cbind(ra_subject_test, ra_y_test, ra_x_test)
    rm(list=c("ra_subject_test", "ra_y_test", "ra_x_test"))

##### combine the training and test data set rows and remove the source
# 1 # tables to release system resources. Resulting table is made visible
##### at the global environment level.
    ra_data<<-tbl_df(rbind(ra_train_data, ra_test_data))
    rm(list=c("ra_train_data", "ra_test_data"))

##### sub select only subjectid, activityid, mean and std dev measurement
# 2 # columns; and store the resulting table back into the same object.
#####
    ra_data<<-ra_data[,c(1,2,grep("mean|std",names(ra_data)))]

##### supplement the data set with activityname, joining by and dropping the
# 3 # activityid column. Reposition activityname column to the front immediately
##### after subjectid, for readibility.
    ra_data<<-left_join(ra_data, ra_activities, by=c("activityid"))
    ra_data<<-select(ra_data, subjectid, activityname, c(3:81))

##### clean up the column names to remove unwanted characters (keeping '-' as)
# 4 # a separator of the variable name segments. Fixed capitalizations to
##### match code book.
    n<-names(ra_data)
    n<-gsub("^t","Time-",gsub("^f","Freq-",n))
    n<-gsub("\\()","",n)
    n<-gsub("mean","Mean",gsub("std","Std",n))
    names(ra_data)<<-n

##### create a tidy version of the data set, with the average of each
# 5 # variable for each activity and subject.
#####
    tidy_data<<-gather(ra_data, variable, value, 3:81)
    tidy_data<<-summarize(group_by(tidy_data, subjectid, activityname, variable), averagevalue=mean(value))

##### export the tidy data table into 'tidy_data.txt' for submission
    write.table(tidy_data, paste(getwd(), "UCI HAR Dataset", "tidy_data.txt", sep="/"))

}

# this function assists the main script with loading data files into a table.
# It returns the populated table with column names set, if supplied. Having
# this function greatly reduces the amount of unecessary typing in the main
# script.
#
# Parameters:
# path (optional) - the base directory containing the training data files
# filename - the relative path and filename of the data file to be loaded
# columnnames (optional) - a character vector with the column names
#
ra_myfileload <- function(path=paste(getwd(), "UCI HAR Dataset", sep="/"), filename, columnnames=NULL) {
    tmp<-fread(paste(path, filename, sep="/"))
    if(length(columnnames)>0) names(tmp)<-columnnames
    return(tmp)
}

# lines after this are meant for kick starting the script
run_analysis_main()
