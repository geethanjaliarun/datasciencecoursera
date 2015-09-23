# Explanation of the Script

#####  Merging of the train and test set

1. Creates a folder named 'Combined'.
2. Merges the respective contents of 'Inertial Signals' folder and writes to the **'Combined'** folder. (Using **rbind**)
3. Merges X_train, y_train and subject_train to the **corresponding** files of the 'test' folder. (Using **rbind**)
4. The **train** data set contains **7352** observations. The **test** data contains **2947** observations. Thus the merged sets contain **10299** rows.

##### Labelling of the activities from activity_labels.txt
1. Converts the contents of the combined activity information to corresponding **activity labels** as given in the file **activity_labels.txt** and stores the values in a dataframe. (Using **as.factor** and **levels**)
2. Names the column as **activity**
3. Size of the data frame **10299** rows, 1 column.

##### Storing the subject information
1. Stores the combined subject information in a dataframe with the column name **subject_id**
2. Size of the data frame **10299** rows, 1 column.

##### Selecting the required features
1. Reads the file **features.txt** and stores in a data frame.
2. Selects the features that contain **mean()** and **std()** **only** at the end of the name. This gives rise to 66 features. The specification mentions to select only the mean and standard deviation for **each measurement**. The features that end with **meanFreq** contain a weighted average, that is representative of some other quantity. Hence they are not extracted. The mean of the measurement is given by the feature that has the substring '**mean()** ' in it. The **angle** measurements are **not extracted** as well. (Using **grep()**)
3. The feature names are stored in a vector of length **66**.

##### Renaming the feature labels so that they conform to the R standard
1. Replaces **hyphen '-'** with an **underscore '_'**. (Using **gsub**)
2. Removes the **opening and closing parenthesis ()**. (Using **gsub**)
3. Replaces feature names containing **mean_X** / **std_X** pattern with **X_mean** / **X_std** to improve **readability**. (Using **gsub**)
4. Feature names all are upper cased and sub-strings of different identifiers are separated by **under score _**. Example **F_BODY_GYRO_Y_STD** 

##### Combining the features with labelled activity and subject information
1. Selects the 66 features from the combined data set and renames them with the changed feature names from the above step. (Using **select** from **dplyr**)
2. Combines the above data set with the activity and subject information. (Using **cbind**)
3. The resulting data frame is of size (**10299**, **68**).

##### Grouping the dataset by activity and subject, finding the average and writing to a text file
1. Groups the data set by activity and subject columns. (Using **group_by** from **dplyr**)
2. Finds the average of the rest of the features. (Using **summarize_each** from **dplyr**)
3. The final tidy data set has **180** rows (6 activities * 30 subjects = 180) and **68** columns.
4. Writes to a text file named "final_tidy_data_set.txt".
