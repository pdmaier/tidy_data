tidy <- function(labeled)
{

	subjects <- unique(labeled$subject)

	actions <- unique(labeled$action)

	activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

	action_descriptions <- activity_labels$V2

	columns <- length(labeled)

	rows <- length(subjects) * length(actions)

	tidy_data <- matrix(data = NA, nrow = rows, ncol = columns)

	colnames(tidy_data) <- colnames(labeled)

	tidy_data <- data.frame(tidy_data)

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

	tidy_data$action <- NULL

	tidy_data
}
