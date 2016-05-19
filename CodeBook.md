## Code Book for tidy_data.txt
by ckkhan


### Data Set Background & Origin
One of the most exciting areas in all of data science right now is wearable computing - see for example this [article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained.

description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Feature Selection
The features selected for this data set come from the accelerometer and gyroscope 3-axial raw signals Time-Acc-XYZ and Time-Gyro-XYZ. These time domain signals were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (Time-BodyAcc-XYZ and Time-GravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (Time-BodyAccJerk-XYZ and Time-BodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (Time-BodyAccMag, Time-GravityAccMag, Time-BodyAccJerkMag, Time-BodyGyroMag, Time-BodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing Freq-BodyAcc-XYZ, Freq-BodyAccJerk-XYZ, Freq-BodyGyro-XYZ, Freq-BodyAccJerkMag, Freq-BodyGyroMag, Freq-BodyGyroJerkMag. (Note that these are frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* Time-BodyAcc-XYZ
* Time-GravityAcc-XYZ
* Time-BodyAccJerk-XYZ
* Time-BodyGyro-XYZ
* Time-BodyGyroJerk-XYZ
* Time-BodyAccMag
* Time-GravityAccMag
* Time-BodyAccJerkMag
* Time-BodyGyroMag
* Time-BodyGyroJerkMag
* Freq-BodyAcc-XYZ
* Freq-BodyAccJerk-XYZ
* Freq-BodyGyro-XYZ
* Freq-BodyAccMag
* Freq-BodyAccJerkMag
* Freq-BodyGyroMag
* Freq-BodyGyroJerkMag

The set of variables that were estimated and retained from these signals are: 

* Mean: Mean value
* Std: Standard deviation

Note: Features are normalized and bounded within [-1,1] prior to its average calculated for each combination of subject, activity and variable resulting in the values found in tidy_data.txt.


### Transformations
tidy_data.txt contains average values for measurements for each combination of subject, activity and variable. From the source data, the following transformations were performed:

R version: "R version 3.2.5 (2016-04-14)" on Windows 7
Packages used: data.table (version 1.9.6), dplyr (version 0.4.3), tidyr (version 0.4.1)

Script performs the following:
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
