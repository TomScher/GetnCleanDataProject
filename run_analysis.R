################################################
###Coursera Getting & Cleaning Data ############
#########Programming Assignment ################
## created by TomScher - on 2014-04-20     ####
## last modified by TomScher on 2014-04-27  ####
################################################
# Tasks:
# 1.  Merges the training and the test sets to create one data set.
# 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.  Uses descriptive activity names to name the activities in the data set
# 4.  Appropriately labels the data set with descriptive activity names. 
# 5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# clean up workspace
rm(list=ls())

# 0 download if ZIP file is not already downloaded
zipname <- "UCI HAR Dataset.zip"

if (!file.exists(paste(getwd(),"data",zipname, sep="/"))){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  print("File download in progress - please wait.")
  download.file(url=fileURL, destfile=paste(getwd(),"data",zipname, sep="/"))
} else {print("File Exists - no need to download!")}

# 1. Merge datasets - first load data! But do that only, if the data has not already 
# been saved in the working directory - in the latter case, just load the R-Data-File. 
if (!file.exists("data.all.RData")){
  data.test<-read.table("data/UCI HAR Dataset/test/X_test.txt",header=FALSE) #reads test data
  data.train<-read.table("data/UCI HAR Dataset/train/X_train.txt",header=FALSE) #reads training data
  
  data.test.subject <- scan("data/UCI HAR Dataset/test/subject_test.txt")
  data.train.subject <- scan("data/UCI HAR Dataset/train/subject_train.txt")
  str(data.test.subject)
  
  data.test.activity <- read.table("data/UCI HAR Dataset/test/y_test.txt",header=FALSE)
  data.train.activity <- read.table("data/UCI HAR Dataset/train/y_train.txt",header=FALSE)
  
  data.values <- read.table("data/UCI HAR Dataset/features.txt",header=FALSE,stringsAsFactors=FALSE) #reads the names of the variables
  data.labels.activities <- read.table("data/UCI HAR Dataset/activity_labels.txt",header=FALSE) #reads the names of the activities
  # save all basic data to avoid the need of reading it again, if you run the script a second time  
  save(list=ls(all=TRUE), file="data.all.RData")
} else {
  load("data.all.RData") # load existing data file
}

# merge files to one
data.all <- rbind(data.test, data.train)

#give meaningful variable names to this file
names(data.all)<- data.values$V2

####################################################################################################
# 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
####################################################################################################

# use only variables that are means or standard deviations and make a new data frame. 
toMatchString <- c("-mean()", "-std()") # indicate what strings have to be part of the variable names
variablestouse <- data.values$V2[grep(x=data.values$V2, pattern=paste(toMatchString, collapse="|"), perl=FALSE,fixed=FALSE)]

# I assume that variables labelled "FreqMean" should not be included -
# thus I explicitly rule them out in the next line of code. Comment it out, if they should be used.
variablestouse <- variablestouse[-grep(variablestouse, pattern="Freq")] # do not use variables that are named "FreqMean"

# use only Means (+SD) variables in the next data frame
data.onlyMeans <- data.all[,variablestouse]

####################################################################################################
# 3.  Uses descriptive activity names to name the activities in the data set #######################
####################################################################################################
#adds subject + activity from training + test together
subjects <- rbind(data.test.subject, data.train.subject)
activity <- rbind(data.test.activity, data.train.activity)

# data now with subjects and activities 
data.full <- data.frame(cbind(subjects, activity, data.onlyMeans))
head(data.full)[1:3]
# make factors and give meaningful labels to subjects and activities
data.full$V1.1 <- factor(data.full$V1.1, labels = data.labels.activities$V2)
data.full$V1 <- factor(data.full$V1, labels = 1:30)

# check if everything is alright
# head(data.full)[1:15, 1:3]
# table(data.full$subject) # check how many subjects / measurement points there are. 

###################################################################################################
# 4.  Appropriately labels the data set with descriptive activity names. ##########################
#     I am not completely sure about this part of the instrtuction. I interpret it as 'label  #####
#     all variables in a clear and simple way' i.e. all lowercase and no special cases etc.    #####
###################################################################################################
# give meaningful variable names
variablestouse <- gsub("\\( | \\) | \\-", "", variablestouse) # delete all (,), and -
variablestouse <- tolower(variablestouse)   # all lower case as suggested by lecture week 4

names(data.full)<-c("subject", "activity", variablestouse)
# names(data.full)

#export this file as cleaned_nonaggregated_data.txt
write.table(data.full, "cleaned_nonaggregated_data.txt")

###################################################################################################
# 5.  Creates a second, independent tidy data set with the average of each variable for each 
#     activity and each subject. 
###################################################################################################

# To solve this part, I use the plyr package  (alternative: data.table)
# first check if it is installed - if not, install and activate it. if yes, skip installation and just activate.
list.of.packages <- c("plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=TRUE)

# compute means for subjects and activities.
data.final <- ddply(data.full,.(subject, activity), colwise(mean))

#export this file too
write.table(data.final, "cleaned_aggregated_data.txt")

#remove all no longer necessary variables + data frames - clean up time :-)
rm(list=c("var.names", "data.test.subject", "data.train.subject", "data.test.activity","data.train.activity",
          "data.test", "data.values", "data.train", "data.test.full", "data.train.full", "data.labels.activities",
          "activity", "data.all", "data.full", "data.onlyMeans", "subjects", "fileURL", "list.of.packages", "new.packages", toMatchString,
          "variablestouse", "zipname","toMatchString"))
