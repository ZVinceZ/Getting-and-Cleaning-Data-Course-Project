library(dplyr)
library(reshape2)

#Reads the test column names into a character vector and changes the label to
#be more descriptive
cln <- read.table("./UCI HAR Dataset/features.txt")
cln <- cln[, 2]
cln <- sub("^t", "Time", cln)
cln <- sub("^f", "Freq", cln)
cln <- gsub("BodyBody", "Body", cln)

#Reads tables for "test" group (subjects, tests, activities) 
#and adds the column names
subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                       col.names = "Subject")
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                       col.names = cln)
test_label <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                         col.names = "Activity")

#Column binds the "test" group data
ts <- cbind(subjtest, test_label, test_set)

#Reads tables for "train" group (subjects, tests, activities) 
#and adds the column names
subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                        col.names = "Subject")
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                        col.names = cln)
train_label <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                          col.names = "Activity")

#Column binds the "train" group data
tr <- cbind(subjtrain, train_label, train_set)

#Merges "test" and "train" group data to all common column names
tt <- merge(ts, tr, all = TRUE)

#Extracts only the measurements on the mean and standard deviation for each 
#measurement. 
ext <- select(tt, Subject:Activity, matches(c("mean", "std")))

#Converts the activity number to the description of the activity
ext$Activity <- gsub("1", "Walking", ext$Activity)
ext$Activity <- gsub("2", "Walking Upstairs", ext$Activity)
ext$Activity <- gsub("3", "Walking Downstairs", ext$Activity)
ext$Activity <- gsub("4", "Sitting", ext$Activity)
ext$Activity <- gsub("5", "Standing", ext$Activity)
ext$Activity <- gsub("6", "Laying", ext$Activity)


#creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.
meltext <- melt(ext, id = c("Subject", "Activity")) 
tidyext <- dcast(meltext, Subject + Activity ~ variable, mean)
write.table(tidyext, file = "./tidydata.txt")


