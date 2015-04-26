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
### merge_data

The merge_data function completes the first step of the project. It "merges the training and the test sets to create one data set". 

First, we read in the features information, as they'll be our column names. Notice that I add the column names right away from features for easy matching. Also note that I'm adding in the subject and action data into additional columns.
```r
features <- read.table("UCI HAR Dataset/features.txt")
```
Then we'll read in all the information we need for the test data.
```r
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")

colnames(test_data) <- features[,2]

subject_test <- scan("UCI HAR Dataset/test/subject_test.txt")

test_data$subject <- subject_test

action_test <- scan("UCI HAR Dataset/test/y_test.txt")

test_data$action <- action_test
```

We'll do the exact same thing for the training data.
```r
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")

colnames(train_data) <- features[,2]

subject_train <- scan("UCI HAR Dataset/train/subject_train.txt")

train_data$subject <- subject_train

action_train <- scan("UCI HAR Dataset/train/y_train.txt")

train_data$action <- action_train
```

Finally, we'll do a simple rbind to put all this together, save, and submit the data as output.
```r
full_data <- rbind(test_data, train_data)

save(full_data, file="merge_data.RData")

full_data
```

### mean_std

Although this function seems like something you may get after an ill-advised night out, it's actually the second step of the spec. This function "extracts only the measurements on the mean and standard deviation for each measurement".

The first thing we do is utilize the grep function to find the indexes of all the column names that include the string "mean" or "std". Then we'll just concatenate these indexes into one vector.
```r
std_index <- grep("std", colnames(full_data))

mean_index <- grep("mean", colnames(full_data))

index <- c(std_index, mean_index)
```

Then we get the columns with those column indexes, and add on the action and subject columns.
```r
extracted <- full_data[, index]

extracted$subject <- full_data$subject

extracted$action <- full_data$action
```

That's it! Save this and submit.
```r
save(extracted, file="mean_std.RData")

extracted
```

### describe

Describe is the third of the five helper functions. It "uses descriptive activity names to name the activities in the data set".

I simply took the features_info file and used those terms as descriptive activity names. To do this, I uploaded the file, gave it column names to easily match with the data we have, and then used merge to put it together.
```r
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

colnames(activity_labels) <- list("action", "action_description")

merged_data <- merge(x = extracted, y = activity_labels, all.x = TRUE)
```

Theoretically I'm done here, but I needed to do some switching around of columns to make things look pretty and easy to work with. This section shows me subsetting the data oddly (just removing the subject, action and action_description variables), renaming those three vectors for easy matching, and then using cbind to put them in the order that I want.

```r
re_ordered <- merged_data[,2:(length(merged_data) - 2)]

subject <- merged_data$subject

action <- merged_data$action

action_description <- merged_data$action_description

re_ordered <- cbind(subject, action, action_description, re_ordered)
```

Now just save and return the new data.
```r
save(re_ordered, file="describe.RData")

re_ordered
```

### re_label
Re_label is the fourth of the five functions in run_analysis. It "appropriately labels the data set with descriptive variable names".

I found this task tricky, because I thought the column names were pretty good as they were. They were descriptive and relatively easy to read. Because of this, and my lack of further knowledge about the data, I essentially kept them as-is. The only modifications I made were to remove and replace illegal characters from the column names so they can be easily used with the $ operator. I also fixed the "BodyBody" typo that our community TA, David Hood, noticed on the forums.

To remove and replace the illegal characters, I used gsub. Notice in the code snippet that I had to use double backslashes to made sure the illegal characters ("(", ")", and "-") would be recognized within my quotations.
```r
new_labels <- gsub("\\(", "", colnames(described))

new_labels <- gsub("\\)", "", new_labels)

new_labels <- gsub("\\-", "_", new_labels)

new_labels <- gsub("BodyBody", "Body", new_labels)
```

After that, all that's left is to set new_labels as the new colnames, save, and return. Before that, though, I change the variable name so that this script has a different variable name output from the other scripts for easy debugging.
```r
colnames(described) <- new_labels

re_labeled <- described

save(re_labeled, file="re_label.RData")

re_labeled
```

### tidy

Tidy is the final and most complex of all the scripts in run_analysis. "From the data set in step 4," it "creates a second, independent tidy data set with the average of each variable for each activity and each subject".

The first thing I do is confirm the count of unique actions and subjects from the data.
```r
subjects <- unique(labeled$subject)

actions <- unique(labeled$action)
```

Next I re-upload and put the activity descriptions into a list. I do this to ensure that the list is in the right order, which will become imporant later on.
```r
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

action_descriptions <- activity_labels$V2
```

Now I'm going to create that "second, independent tidy data set" from scratch by calculating the number of rows I'll need (number of subjects * number of actions) and number of columns I'll need (same as the other data set). I initialize the table as a matrix for control over the size, set the column names, and then switch it to a data.frame because it was easy for me to do.
```r
columns <- length(labeled)

rows <- length(subjects) * length(actions)

tidy_data <- matrix(data = NA, nrow = rows, ncol = columns)

colnames(tidy_data) <- colnames(labeled)

tidy_data <- data.frame(tidy_data)
```

Now, here's the beast of this function: a triple-nested for loop. I know Roger, our instructor for R Programming, would be mad at me for ignoring his advice of not doing too much nesting. However, I thought this was the best way to make the code easy to read, write and debug. I'm sure there's a more efficient way, but I didn't mind waiting a couple of seconds longer for that easiness.
```r
row <- 1

for (s in 1:length(subjects))
{
	for (a in 1:length(actions))
	{
		for (c in 4:columns)
		{
			entries <- labeled[which(labeled$subject == s & labeled$action == a), c]

			tidy_data[row, c] <- mean(entries)
		}

		tidy_data$action[row] <- a

		tidy_data$subject[row] <- s

		tidy_data$action_description[row] <- as.character(action_descriptions[a])

		row <- row + 1
	}
}
```

I take advantage of the fact that both subject and action are consecutive vectors. I cycle through them in every combination with the first two loops.

I start at 4 instead of 1 in the columns loop because I don't want to overwrite the first three columns, which are subject, action, and action\_descrption. Essentially, I figure out what combination of action and subject I'm on, and then I go across every variable. For each variable, I gather all the measurements in the other dataset for that variable, action, and subject. Then I get the mean of all those measurements and put that value in the cell for that variable-action-subject combination in my tidy\_dataset.

After I go through all the variables, I just insert the appropriate values for action and subject. I also use that untouched and ordered version of action_description by pulling the appropriate description by using action as a vector for the value. 

The loop finishes, and we have two more lines. The pentultimate is to drop action: we don't need the numerical value if we have the description now. The ultimate is to return our final, tidy, perfect data to the user.
```r
tidy_data$action <- NULL

tidy_data
```

### Conclusion
I hope you enjoyed reading this README. If you have feedback, please let me know in your evaluation, or if you're just a GitHubber who is reading this on their own (bless you), email me. Thank you!
