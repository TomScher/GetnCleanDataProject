GetnCleanDataProject
====================
This code (run_analysis.R) allows to read in lots of data from some wearable computing study.

The steps are as follows:

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive activity names. 
    5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

All of these points are commented in the orginal code and should thus be simple to understand. 

For the sake of this assignment, I also included a first pre-processing point, which can be used to download the original data. This will be skipped, if data is already present in the working directory. 

This script actually gives two output files as .txt: first, a table including all the data for each variable that is a mean or standard deviation (excluding variables like Freq-mean()). Second, there will be an aggregated file where for each subject and activity only one mean will be present. Both files will be exported in your working directory. 
