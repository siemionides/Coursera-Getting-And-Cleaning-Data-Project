# R script for course project on Getting and Cleaning Data.

#--MERGING--
#-----------
   TrainingSet <- read.table("UCI HAR Dataset/train/X_train.txt")
   TestSet <- read.table("UCI HAR Dataset/test/X_test.txt")
   SubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
   SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
   TrainingLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
   Testlabels <- read.table("UCI HAR Dataset/test/y_test.txt")
 
   Set <- rbind(TrainingSet, TestSet)
   Subjects <- rbind(SubjectTrain, SubjectTest)
   Labels <- rbind(TrainingLabels, Testlabels)
   rm(TrainingSet, TestSet, SubjectTrain, SubjectTest, TrainingLabels, Testlabels)

#--EXTRACTION--
#--------------
   AllFeatures <- read.table("UCI HAR Dataset/features.txt")
   IndexDesiredFeatures <- grep("mean\\(\\)|std\\(\\)", AllFeatures[, 2])
   SetDesiredFeatures <- Set[,IndexDesiredFeatures]

#--NAMING--
#----------
   AllActivities <- read.table("UCI HAR Dataset/activity_labels.txt")
   #----------For the activities
   AllActivities[,2] <- gsub("_", " ", AllActivities[,2])
   AllActivities[,2] <- tolower(AllActivities[,2])
   AllActivities[,2] <- gsub("wa", "Wa", AllActivities[,2])
   AllActivities[,2] <- gsub("up", "Up", AllActivities[,2])
   AllActivities[,2] <- gsub("do", "Do", AllActivities[,2])
   AllActivities[,2] <- gsub("si", "Si", AllActivities[,2])
   AllActivities[,2] <- gsub("stan", "Stan", AllActivities[,2])
   AllActivities[,2] <- gsub("la", "La", AllActivities[,2])
   Labels[,1] = AllActivities[Labels[,1], 2]
   #----------For subjects and labels columns
   names(Subjects) <- "Subject"
   names(Labels) <- "Activity"
   #----------For the desired features data
   names(SetDesiredFeatures) <- AllFeatures[IndexDesiredFeatures, 2]
   names(SetDesiredFeatures) <- gsub("\\(\\)", "", names(SetDesiredFeatures))
   
   ProcessedData <- cbind(Subjects, Labels, SetDesiredFeatures)
   write.table(ProcessedData, "ProcessedData.txt")

   #----------For the features of tidy data of averages
   names(SetDesiredFeatures) <- gsub("m", "M", names(SetDesiredFeatures))
   names(SetDesiredFeatures) <- gsub("std", "StD", names(SetDesiredFeatures))
   names(SetDesiredFeatures) <- gsub("-", "", names(SetDesiredFeatures))

#--CREATINGTIDYAVERAGESDATA--
#----------------------------
   TidyAveragesData <- data.table(cbind(Subjects, Labels, SetDesiredFeatures))[, lapply(.SD, mean), by=c("Subject","Activity")]
   write.table(TidyAveragesData, "TidyAveragesData.txt")
   