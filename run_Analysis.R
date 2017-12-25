
rm(list = ls())

setwd("D:/Dashboard/R")  

#Getting the Training Data in the Memory 
dtTrainSubject <- read.table("UCIHARDataset/train/subject_train.txt")
dtTrain <- read.table("UCIHARDataset/train/X_train.txt")
dtTrainAct <- read.table("UCIHARDataset/train/y_train.txt")

#Getting the Test Data in Memory 
dtTest <- read.table("UCIHARDataset/test/X_test.txt")
dtTestSubject <- read.table("UCIHARDataset/test/subject_test.txt")
dtTestAct <- read.table("UCIHARDataset/test/y_test.txt")

#Get Training and Test Data in a Single Set 
totalActivities <- rbind(
        cbind(dtTrainSubject, dtTrain, dtTrainAct),
        cbind(dtTestSubject, dtTest, dtTestAct) 
)
#View(head(totalActivities))

#Remove the datasets, which are no longer required for resource utilisation. 
rm(dtTrainSubject, dtTrain, dtTrainAct, dtTest, dtTestSubject, dtTestAct) 

#Gett the list of all topics 
xtTopics <- read.table("UCIHARDataset/features.txt", as.is = TRUE) 
#View(head(xtTopics))

#Set the Coumn names for all Columns in the list of all activities 
colnames(totalActivities) <- c("subject", xtTopics[, 2], "activity")
#View(head(totalActivities))

#Filter teh list of Topics 
xtSelTopics <- grepl("*mean*|*std*", xtTopics[,2])

#Get the list of filtered Topics 
xtFilteredTopics <- c("subject", "activity", xtTopics[, 2][xtSelTopics])

#Check 
#View(head(totalActivities[xtFilteredTopics]))

#Get only the list of Required Selected Topics 
totalActivities <- totalActivities[xtFilteredTopics]
#View(head(totalActivities))

#Add Labels for Activity 
actLabels <- read.table("UCIHARDataset/activity_labels.txt", as.is = TRUE)
colnames(actLabels) <- c("ActivityId", "ActivityLabel")

#Set Labels for Activities. 
totalActivities$activity <- factor(totalActivities$activity, 
                                levels = actLabels[, 1], labels = actLabels[, 2])
#View(head(totalActivities))


library(dplyr)

#Set Summaries
totalActMeans <- totalActivities %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
#View(totalActMeans)

#Export the Dataset. 
write.table(totalActMeans, "tidy.txt", row.names = FALSE, quote = FALSE)
