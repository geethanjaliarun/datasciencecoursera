## Combining Test and Train data sets and putting them in a folder
## named "combined"

if(!file.exists("./UCI HAR Dataset/combined"))
{
        dir.create("./UCI HAR Dataset/combined")
        dir.create("./UCI HAR Dataset/combined/Inertial Signals")
}

## Reading all files in "Inertial Signals" folder
files_in_test_inertial = list.files("./UCI HAR Dataset/test/Inertial Signals", pattern = "*.txt", full.names = TRUE)
files_in_train_inertial = list.files("./UCI HAR Dataset/train/Inertial Signals", pattern = "*.txt", full.names = TRUE)


## Combining and writing the data.
for(index_i in seq_along(files_in_train_inertial))
{
        train_data = read.table(files_in_train_inertial[index_i]);
        test_data = read.table(files_in_test_inertial[index_i]);
        file_name_array = strsplit(files_in_test_inertial[index_i], "/")[[1]]
        file_name = file_name_array[length(file_name_array)]
        combined_data = rbind(train_data, test_data);
        file_name = paste("./UCI HAR Dataset/combined/Inertial Signals/", file_name, sep="")
        write.table(combined_data, file = file_name, sep = " ", eol = "\n")
}

## Combining and writing 'X_train', 'subject' and 'activity label' data. 
files_in_test = list.files("./UCI HAR Dataset/test", pattern = "*.txt", full.names = TRUE)
files_in_train = list.files("./UCI HAR Dataset/train", pattern = "*.txt", full.names = TRUE)
for(index_i in seq_along(files_in_train))
{
        train_data = read.table(files_in_train[index_i]);
        test_data = read.table(files_in_test[index_i]);
        file_name_array = strsplit(files_in_train[index_i], "/")[[1]]
        file_name = file_name_array[length(file_name_array)]
        combined_data = rbind(train_data, test_data);
        file_name = paste("./UCI HAR Dataset/combined/", file_name, sep="")
        write.table(combined_data, file = file_name, sep = " ", eol = "\n", row.names = FALSE, col.names = FALSE)
}

combined_X = read.table("./UCI HAR Dataset/combined/X_train.txt");
combined_subject_label = read.table("./UCI HAR Dataset/combined/subject_train.txt")
combined_activity_label = read.table("./UCI HAR Dataset/combined/y_train.txt")

## Converting the activities to factors and renaming the activities to corresponding
## labels from the file activity_labels.txt 
activity_label = read.table("./UCI HAR Dataset/activity_labels.txt")
combined_activity_label$V1 = as.factor(combined_activity_label$V1)
levels(combined_activity_label$V1) <- activity_label$V2
names(combined_activity_label) = "activity"

## Naming the subject table
names(combined_subject_label) = "subject_id"

features = read.table("./UCI HAR Dataset/features.txt")
## Using regular expression to extract the indices of features that are either mean or standard deviation.
## f is a vector containing the indices of the featured that contain "mean" or "std"
f = grep("*mean\\(\\)*", x = features$V2)
f = c(f, grep("*std*", x = features$V2))

## Renaming the labels that conforms with the R naming standard.
## Removes hyphen, opening and closing paranthesis
## Replacing std_X to X_std and mean_X to X_mean etc, to improve readability
featureNames = features[f, "V2"]
featureNames = gsub("-", "_", featureNames)
featureNames = gsub("\\(", "", featureNames)
featureNames = gsub("\\)", "", featureNames)
featureNames = gsub("std_X", "X_std", featureNames)
featureNames = gsub("mean_X", "X_mean", featureNames)
featureNames = gsub("std_Y", "Y_std", featureNames)
featureNames = gsub("mean_Y", "Y_mean", featureNames)
featureNames = gsub("std_Z", "Z_std", featureNames)
featureNames = gsub("mean_Z", "Z_mean", featureNames)

## A data set of 66 features that contain "mean" and "std"
meanAndSdSet = select(combined_X, f)
names(meanAndSdSet) = featureNames

## Adding activity and subject columns
meanAndSdSet = cbind(meanAndSdSet, combined_activity_label)
meanAndSdSet = cbind(meanAndSdSet, combined_subject_label)

## Grouping by each subject and averaging
## The tidy data set contains 180 rows and 68 columns - 180 rows corresponding to
## 6 activities of 30 subjects. (6 * 30 = 180)
tidyData = meanAndSdSet %>% group_by(subject_id, activity) %>% summarize_each(c("mean"))
names(tidyData) = toupper(names(tidyData))
featureNames = names(tidyData)
featureNames = gsub("^T", "T_", featureNames)
featureNames = gsub("^F", "F_", featureNames)
featureNames = gsub("BODY", "BODY_", featureNames)
featureNames = gsub("ACC", "ACC_", featureNames)
featureNames = gsub("GYRO", "GYRO_", featureNames)
featureNames = gsub("JERK", "JERK_", featureNames)
featureNames = gsub("MAG", "MAG_", featureNames)
featureNames = gsub("GRAVITY", "GRAVITY_", featureNames)
featureNames = gsub("__", "_", featureNames)
names(tidyData) = featureNames
write.table(tidyData, "./UCI HAR Dataset/final_tidy_data_set.txt", sep = " ", eol = "\n", row.names = FALSE)


