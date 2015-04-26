merge_data <- function()
{

	# This function merges the test and training data.
	# Along the way, it also adds column names and data on the subject for usefulness down the line.

	# Upload and format the features, which will be the column names

	features <- read.table("UCI HAR Dataset/features.txt")

	# Organize the test data

	test_data <- read.table("UCI HAR Dataset/test/X_test.txt")

	colnames(test_data) <- features[,2]

	subject_test <- scan("UCI HAR Dataset/test/subject_test.txt")

	test_data$subject <- subject_test

	action_test <- scan("UCI HAR Dataset/test/y_test.txt")

	test_data$action <- action_test

	# Organize the train data in exactly the same way

	train_data <- read.table("UCI HAR Dataset/train/X_train.txt")

	colnames(train_data) <- features[,2]

	subject_train <- scan("UCI HAR Dataset/train/subject_train.txt")

	train_data$subject <- subject_train

	action_train <- scan("UCI HAR Dataset/train/y_train.txt")

	train_data$action <- action_train

	# Use rbind to put the train and test data together.

	full_data <- rbind(test_data, train_data)

	save(full_data, file="merge_data.RData")

	full_data

}
