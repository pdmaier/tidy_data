describe <- function(extracted)
{
	activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

	colnames(activity_labels) <- list("action", "action_description")

	merged_data <- merge(x = extracted, y = activity_labels, all.x = TRUE)

	re_ordered <- merged_data[,2:(length(merged_data) - 2)]

	subject <- merged_data$subject

	action <- merged_data$action

	action_description <- merged_data$action_description

	re_ordered <- cbind(subject, action, action_description, re_ordered)

	save(re_ordered, file="describe.RData")

	re_ordered

}
