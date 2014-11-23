# Set directory
#setwd("~/Getting & cleaning data")

#read training info - note do not rename from download
training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

#read testing info
testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

#read ladels
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

#make feature names more readable
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

#make single data set
SDset = rbind(training, testing)

#extract mean and std
mean_and_std <- grep(".*Mean.*|.*Std.*", features[,2])

#remove data we dont want
features <- features[mean_and_std,]

#add mean_and_std
mean_and_std <- c(mean_and_std, 562, 563)

#remove rest of data we dont want
SDset <- SDset[,mean_and_std]

#put column names in
NameCol(SDset) <- c(features$V2, "Activity", "Subject")
NameCol(SDset) <- tolower(NameCol(SDset))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
    SDset$activity <- gsub(currentActivity, currentActivityLabel, SDset$activity)
    currentActivity <- currentActivity + 1
}

SDset$activity <- as.factor(SDset$activity)
SDset$subject <- as.factor(SDset$subject)

tidy = aggregate(SDset, by=list(activity = SDset$activity, subject=SDset$subject), mean)

#create final output
write.table(tidy, "tidy.txt", sep="\t")