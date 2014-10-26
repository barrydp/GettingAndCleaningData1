#  Set the variable "path" to the path where everything is, then use that to set the wd
path <- "G:\\Coursera\\DataScientist\\Getting and Cleaning Data\\Week 3\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset"
setwd(path)

# Set up the names of the files to read
TestInFilenameData <- paste(path,"\\test\\X_test.txt", sep="")
TestInFilenameActivity <- paste(path,"\\test\\y_test.txt", sep="")
TrainInFilenameData <- paste(path,"\\train\\X_train.txt", sep="")
TrainInFilenameActivity <- paste(path,"\\train\\y_train.txt", sep="")
TestSubjectInFilename <- paste(path,"\\test\\subject_test.txt", sep="")
TrainSubjectInFilename <- paste(path,"\\train\\subject_train.txt", sep="")

ActivityInFilename <- paste(path,"\\activity_labels.txt", sep="")
Names <- paste(path,"\\features.txt", sep="")
OutFilename <- paste(path, "\\CleanData.txt", sep="")

# Read the data
trainData <- read.table(TrainInFilenameData, header=FALSE)
trainActivity <- read.table(TrainInFilenameActivity, header=FALSE)
trainSubjects <- read.table(TrainSubjectInFilename, header=FALSE)
colnames(trainActivity) <- "Activity"
colnames(trainSubjects) <- "Subject"


testData <- read.table(TestInFilenameData, header=FALSE)
testActivity <- read.table(TestInFilenameActivity, header=FALSE)
testSubjects <- read.table(TestSubjectInFilename, header=FALSE)
colnames(testActivity) <- "Activity"
colnames(testSubjects) <- "Subject"

mActivity <- read.table(ActivityInFilename, header=FALSE)

mmNames <- read.csv(Names, sep=" ", header=FALSE)
mNames <- mmNames[,"V2"]
rm(mmNames)

#merge the two datasets using cbind and rbind, then remove the superflouous datasets to free up memory
#  First add the activity column with cbind
mTrain <- cbind(trainActivity, trainData)
mTrain <- cbind(trainSubjects, mTrain)
mTest <- cbind(testActivity, testData)
mTest <- cbind(testSubjects, mTest)

# Then Add the two datasets together
mData <- rbind(mTrain, mTest)
rm(trainData)
rm(testData)
rm(mTrain)
rm(mTest)

#Set the column names
colnames(mData) <- c("Subject", "Activity", as.vector(mNames))

#Get the mean and std cols only
wantedCols <- c("Subject","Activity","tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", "tBodyAcc-mean()-Z", "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y", "tGravityAcc-mean()-Z","tBodyAccJerk-mean()-X","tBodyAccJerk-mean()-Y","tBodyAccJerk-mean()-Z","tBodyGyro-mean()-X","tBodyGyro-mean()-Y","tBodyGyro-mean()-Z","tBodyGyroJerk-mean()-X","tBodyGyroJerk-mean()-Y","tBodyGyroJerk-mean()-Z","tBodyAccMag-mean()","tGravityAccMag-mean()","tBodyAccJerkMag-mean()","tBodyGyroMag-mean()","tBodyGyroJerkMag-mean()","fBodyAcc-mean()-X","fBodyAcc-mean()-Y","fBodyAcc-mean()-Z","fBodyAcc-meanFreq()-X","fBodyAcc-meanFreq()-Y","fBodyAcc-meanFreq()-Z","fBodyAccJerk-mean()-X","fBodyAccJerk-mean()-Y","fBodyAccJerk-mean()-Z","fBodyAccJerk-meanFreq()-X","fBodyAccJerk-meanFreq()-Y","fBodyAccJerk-meanFreq()-Z","fBodyGyro-mean()-X","fBodyGyro-mean()-Y","fBodyGyro-mean()-Z","fBodyGyro-meanFreq()-X","fBodyGyro-meanFreq()-Y","fBodyGyro-meanFreq()-Z","fBodyAccMag-mean()","fBodyAccMag-meanFreq()","fBodyBodyAccJerkMag-mean()","fBodyBodyAccJerkMag-meanFreq()","fBodyBodyGyroMag-mean()","fBodyBodyGyroMag-meanFreq()","fBodyBodyGyroJerkMag-mean()","fBodyBodyGyroJerkMag-meanFreq()","angle(tBodyAccMean,gravity)","angle(tBodyAccJerkMean),gravityMean)","angle(tBodyGyroMean,gravityMean)","angle(tBodyGyroJerkMean,gravityMean)","angle(X,gravityMean)","angle(Y,gravityMean)","angle(Z,gravityMean)","tBodyAcc-std()-X","tBodyAcc-std()-Y","tBodyAcc-std()-Z","tGravityAcc-std()-X","tGravityAcc-std()-Y","tGravityAcc-std()-Z","tBodyAccJerk-std()-X","tBodyAccJerk-std()-Y","tBodyAccJerk-std()-Z","tBodyGyro-std()-X","tBodyGyro-std()-Y","tBodyGyro-std()-Z","tBodyGyroJerk-std()-X","tBodyGyroJerk-std()-Y","tBodyGyroJerk-std()-Z","tBodyAccMag-std()","tGravityAccMag-std()","tBodyAccJerkMag-std()","tBodyGyroMag-std()","tBodyGyroJerkMag-std()","fBodyAcc-std()-X","fBodyAcc-std()-Y","fBodyAcc-std()-Z","fBodyAccJerk-std()-X","fBodyAccJerk-std()-Y","fBodyAccJerk-std()-Z","fBodyGyro-std()-X","fBodyGyro-std()-Y","fBodyGyro-std()-Z","fBodyAccMag-std()","fBodyBodyAccJerkMag-std()","fBodyBodyGyroMag-std()","fBodyBodyGyroJerkMag-std()")
newData <- mData[wantedCols]

# Set the activity names
newData <- merge(newData, mActivity, by.x = "Activity", by.y = "V1")
colnames(newData)[colnames(newData)=="V2"] <- "ActivityName"
newData <- as.data.frame(newData)

# Get the avg per subject per activity
subjects <- split(newData, paste(newData$Subject,newData$Activity))
newData1 <- lapply(subjects, function(x) colMeans(x[,wantedCols]))

# write the clean dataset
write.table(newData1, file = OutFilename, append = FALSE, sep = ",",
            eol = "\n", dec = ".", row.names = FALSE, col.names = TRUE)
#save(newData1, file = OutFilename)
