re_label <- function(described)
{
	new_labels <- gsub("\\(", "", colnames(described))

	new_labels <- gsub("\\)", "", new_labels)

	new_labels <- gsub("\\-", "_", new_labels)

	new_labels <- gsub("BodyBody", "Body", new_labels)

	colnames(described) <- new_labels

	re_labeled <- described

	save(re_labeled, file="re_label.RData")

	re_labeled
}
