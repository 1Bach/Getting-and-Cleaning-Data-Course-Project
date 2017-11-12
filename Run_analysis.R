if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

path_rf <- file.path("./data" , "UCI HAR Dataset")
files <- list.files(path_rf, bold=TRUE)
files

#1)
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

#2)
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]


# 3)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

data.mean.std$label <- labels[data.mean.std$label, 2]


# 4)
good.colnames <- c("subject", "label", features.mean.std$V2)

good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))

colnames(data.mean.std) <- good.colnames


# 5)
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

#tidy dataset
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)
