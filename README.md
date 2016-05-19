## Assignment: Getting and Cleaning Data Course Project
by ckkhan

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
I am required to prepare and submit:

1. a tidy data set as described below
2. a link to a Github repository with your script for performing the analysis. The script is to perform the following:
  1. Merge the training and the test sets to create one data set.
  2. Extract only the measurements on the mean and standard deviation for each measurement.
  3. Use descriptive activity names to name the activities in the data set
  4. Appropriately label the data set with descriptive variable names. 
  5. From the data set in prior step, create a second, independent tidy data set with the average of each variable for each activity and each subject.
3. a code book that describes the variables, the data, and any transformations or work that I performed to clean up the data called CodeBook.md.
4. a README.md in the repo with my scripts to explain how all of the scripts work and how they are connected.


### Data Set Background & Origin
One of the most exciting areas in all of data science right now is wearable computing - see for example this [article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained.

description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### Files in this repository
* README.md - this file explains the assignment and contents of the repository.
* CodeBook.md - this file explains how all of the scripts work and how they are connected.
* run_analysis.R - an R script containing the main analysis script as well as functions to assist with repetitive tasks (such as file loading). The script performs the following in order:
  * downloads the data set files (zipped) from source and unzips it into work directory
  * loads features.txt and activity_labels.txt into R tables. This and other file loads are assisted by the ra_myfileload function defined in the script.
  * loads subject_train.txt, X_train.txt and y_train.txt into R tables and combines them into 1 training data set table via cbind
  * loads subject_train.txt, X_train.txt and y_train.txt into R tables and combines them into 1 test data set table via cbind
  * combines the training and test data sets, row wise via rbind
  * omits measurements which are not of mean or std deviation types
  * populates the data set with activity name (data set left join activity lookup table) and clean up the column names
  * creates a tidy data set by transforming the wide table into a narrow one, using the gather {tidyr} function
  * summarizes the tidy data by applying mean function to the values grouped by subjectid, activityname and variable.
  * exports the tidy data set into 'tidy_data.txt' for submission using the write.table {utils} function, default parameters.
* tidy_data.txt - the tidy data set result stored in a text file 
