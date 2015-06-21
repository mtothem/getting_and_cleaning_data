location <- file.path("./data" , "UCI HAR Dataset")
data_files<-list.files(location, recursive=TRUE)
#read files
sub_test  <- read.table(file.path(location, "test" , "subject_test.txt"),header = FALSE)
sub_train <- read.table(file.path(location, "train", "subject_train.txt"),header = FALSE)
act_test  <- read.table(file.path(location, "test" , "Y_test.txt" ),header = FALSE)
act_train <- read.table(file.path(location, "train", "Y_train.txt"),header = FALSE)
feat_test <- read.table(file.path(location, "test" , "X_test.txt" ),header = FALSE)
feat_train <- read.table(file.path(location, "train", "X_train.txt"),header = FALSE)
#bind data
rbind_subj <- rbind(sub_train, sub_test)
rbind_acty<- rbind(act_train, act_test)
rbind_feat<- rbind(feat_train, feat_test)
#names
names(rbind_subj)<-c("subject")
names(rbind_acty)<- c("activity")
features_names <- read.table(file.path(location, "features.txt"),head=FALSE)
names(dataFeatures)<-  features_names$V2
#cbind
cbind_data <- cbind(rbind_subj, rbind_acty)
Data <- cbind(dataFeatures, cbind_data)
#find mean and std dev
 extract<- features_names$V2[grep("mean\\(\\)|std\\(\\)",  features_names$V2)]
selectedNames<-c(as.character( extract), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
#descriptive names
desc_labels <- read.table(file.path(location, "activity_labels.txt"),header = FALSE)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
library(dplyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
 Data2<- Data2[order( Data2$subject, Data2$activity),]
write.table( Data2, file = "data_step5.txt",row.name=FALSE)
