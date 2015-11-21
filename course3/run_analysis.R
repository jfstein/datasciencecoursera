setwd("C:/Users/Joseph/datasciencecoursera/course3")
        
# Read datasets
print("Reading train data...")
train_measurement <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
train_activity <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
train_subject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

print("Reading test data...")       
test_measurement <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
test_activity <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
test_subject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")        
        
print("Reading features...")
features <- read.table("./UCI_HAR_Dataset/features.txt")
features <- as.character(features$V2)
features <- gsub(",","",features,fixed=TRUE)
features <- gsub("(","",features,fixed=TRUE)
features <- gsub(")","",features,fixed=TRUE)
features <- gsub("-","_",features,fixed=TRUE)          
                
# Merge test and train data
print("Merging...")        
measurement <- rbind(train_measurement,test_measurement)
activity <- rbind(train_activity,test_activity)
subject <- rbind(train_subject,test_subject)
        
# Change column names for measurements
names(measurement) <- features
        
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
measurement <- measurement[,good]        
        
# Create single data frame
full <- cbind(subject,activity)
full <- cbind(full,measurement)        
colnames(full)[1] <- "subject"
        
# Create activity column
act <- data.frame(activity=1:nrow(full))
act <- transform(act,activity=as.character(activity))
        
idx <- full$V1==1
act$activity[idx]="WALKING"
idx <- full$V1==2
act$activity[idx]="WALKING_UPSTAIRS"        
idx <- full$V1==3
act$activity[idx]="WALKING_DOWNSTAIRS"
idx <- full$V1==4
act$activity[idx]="SITTING"
idx <- full$V1==5
act$activity[idx]="STANDING"
idx <- full$V1==6
act$activity[idx]="LYING"
        
full <- cbind(full$subject, act$activity,full[,3:ncol(full)])
names(full)[1] <- "subject"
names(full)[2] <- "activity"

# Create tidy dataset
subj <- factor(full$subject)
nm<-names(full)[3:ncol(full)]        
uact <- unique(full$activity)
        
for (i in 1:6) {        
                
        subtidy<-data.frame()
                
        idx <- full$activity==uact[i]
        subset <- full[idx,]
        subjsubset <- subj[idx]
        for (j in 3:ncol(subset)) {
                subtidy0<-data.frame(tapply(subset[,j],subjsubset,mean))
                names(subtidy0) <- colnames(subset)[j]
                
                if (j==3) {
                        subtidy<-data.frame(subject=1:30,activity=rep(uact[i],30))
                        
                } 
                subtidy<-cbind(subtidy,subtidy0)        
                
        }
        if (i==1) {
                tidy <- subtidy
        } else {
                tidy <- rbind(tidy,subtidy)        
        }
        
}

# Spruce up names
nm<-names(tidy)
nm <- gsub("fBody","meanOf",nm,fixed=TRUE)
nm <- gsub("tBody","meanOf",nm,fixed=TRUE)  
nm <- gsub("tGravity","meanOf",nm,fixed=TRUE)  
nm <- gsub("angle","meanOf",nm,fixed=TRUE) 
names(tidy)<-nm

# Write to file
write.table(tidy,"tidy.txt",row.name=FALSE)