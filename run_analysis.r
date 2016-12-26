#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 
#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis, and 
#3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
#You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#Here are the data for the project:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  


#You should create one R script called run_analysis.R that does the following. 

#1.-DONE Merges the training and the test sets to create one data set.
#2.-DONE Extracts only the measurements on the mean and standard deviation for each measurement.
#3.-DONE Uses descriptive activity names to name the activities in the data set.
#4.-DONE Appropriately labels the data set with descriptive activity names.
#5.-DONE Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Prelminars
Load Package 

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

#Result
#data.table   reshape2 
#      TRUE       TRUE
      
path <- getwd()

#> path
#[1] "C:/CodigoR"


## considering zip file is downloaded and saved under working directory
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

## test data:
XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

## features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")


##Part1 - merges train and test data in one dataset (full dataset at the end)
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)

#Get information 
> dim(X)
#[1] 10299   561
> dim(Y)
#[1] 10299     1
> dim(Subject)
#[1] 10299     1

##Part2 Extracts only the measurements on the mean and standard deviation for each measurement.

##getting features indeces which contain mean() and std() in their name
index<-grep("mean\\(\\)|std\\(\\)", features[,2]) 
length(index) 
## count of features
#[1] 66

X<-X[,index] 
## getting only variables with mean/stdev
dim(X) 
## checking dim of subset 
## [1] 10299    66


##Part3
#Uses descriptive activity names to name the activities in the data set.

Y[,1]<-activity[Y[,1],2] ## replacing numeric values with lookup value from activity.txt; won't reorder Y set
head(Y)


##Part4 Appropriately labels the data set with descriptive activity names.

names<-features[index,2] ## getting names for variables
names(X)<-names ## updating colNames for new dataset
names(Subject)<-"SubjectID"
names(Y)<-"Activity"
    
CleanedData<-cbind(Subject, Y, X)
head(CleanedData[,c(1:4)]) ## first 5 columns
SubjectID Activity tBodyAcc-mean()-X
#1         2 STANDING         0.2571778
#2         2 STANDING         0.2860267
#3         2 STANDING         0.2754848
#4         2 STANDING         0.2702982
#5         2 STANDING         0.2748330
#6         2 STANDING         0.2792199

#tBodyAcc-mean()-Y
#1       -0.02328523
#2       -0.01316336
#3       -0.02605042
#4       -0.03261387
#5       -0.02784779
#6       -0.01862040

##Part5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity'] ## features average by Subject and by activity
dim(TidyData)

#[1] 180  68

write.table(TidyData, file = "Tidy.txt", row.names = FALSE)

#The first 10 Rows and the 5 columns
head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],10) 
