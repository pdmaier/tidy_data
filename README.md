# Course Project for Getting and Cleaning Data
## Submission by Paul Maier

### How the files are organized
Each step required by the project's specification has its own separate R script. The run_analysis function serves as a controller for these five scripts, running them in sequence and returning the final tidy dataset to the user.

Here is the run_analysis script in its entirety, which will help describe what is to come. After reviewing that, you should be able to follow through the five following sections that detail each individual script.

```r 
run_analysis <- function()
{
	# This is the controller that calls all the functions described in the project.
	# Each step has its own function for your ease of grading and evaluating.

	source("merge_data.R")
	source("mean_std.R")
	source("describe.R")
	source("re_label.R")
	source("tidy.R")

	# 1. Merges the training and the test sets to create one data set.
	full_data <- merge_data()

	# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
	extracted <- mean_std(full_data)

	# 3. Uses descriptive activity names to name the activities in the data set
	described <- describe(extracted)

	# 4. Appropriately labels the data set with descriptive variable names.
	labeled <- re_label(described)

	# 5. From the data set in step 4, creates a second, independent tidy data set 
	#    with the average of each variable for each activity and each subject.
	tidy_data <- tidy(labeled)

	tidy_data

}
```
