#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.





##setwd("C:/Users/Joseph/Desktop/MOOC/coursera/data_science/c3_getting_cleaning_data/week2/courseproject")


        # Read features dataset
        print("Reading features...")
        features <- read.table("./UCI_HAR_Dataset/features.txt")
        features <- as.character(features$V2)
        features <- gsub(",","",features,fixed=TRUE)
        features <- gsub("(","",features,fixed=TRUE)
        features <- gsub(")","",features,fixed=TRUE)
        features <- gsub("-","_",features,fixed=TRUE)        
        
        # Read train and test datasets
        print("Reading train...")
        train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
        trainsubject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
        
        print("Reading test...")
        test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
        testsubject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")
        
        # Merge train and test datasets
        full <- rbind(train,test)
        fullsubject <- rbind(trainsubject,testsubject)
        names(full) <- features
        
        # Extract only the mean and std for each measurement
        idx <- numeric(length(features))
        for (i in 1:length(features)) {
                check1 <- length(grep("mean",tolower(features[i])))>0
                check2 <- length(grep("std",tolower(features[i])))>0
                
                if (check1||check2) {
                        idx[i]=1
                } 
                else {
                        idx[i]=0
                }
        }
        good <- (idx==1)
        full_subset <- full[,good]
        
        subj <- factor(fullsubject$V1)
        nm<-names(full_subset)
        
        # Create tidy dataset
        tidy<-data.frame(y=1:30)
        
        for (i in 1:length(nm)) {
                tidy0<-tapply(full_subset[,i],subj,mean)
                tidy<-cbind(tidy0,tidy)
        }
        dd=dim(tidy)
        tidy<-tidy[,1:dd[2]-1]
        names(tidy)<-nm