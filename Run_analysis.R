##Instructions:

#Here are the data for the project:

#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



#Downloading file and puts it in working directory
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#Unpacking the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#List of the files in the "UCI HAR Dataset" folder, wich shows an equal amount of test - and training files.
path_rf <- file.path("./data" , "UCI HAR Dataset")
files <- list.files(path_rf, bold=TRUE)
files

## 1
# reads all the separate files
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")


##2
# Reading the features 
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# Exctracting measurement on mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# select only the means and standard deviations from data
# increment by 2 because data has subjects and labels
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]


## 3
# read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]


## 4
# first make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)

# then tidy that list by removing every non-alphabetic character and converting to lowercase
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))

# then use the list as column names for data
colnames(data.mean.std) <- good.colnames


## 5
# Finding the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)


# presenting the data
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)