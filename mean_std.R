mean_std <- function(full_data)
{
	std_index <- grep("std", colnames(full_data))

	mean_index <- grep("mean", colnames(full_data))

	index <- c(std_index, mean_index)

	extracted <- full_data[, index]

	extracted$subject <- full_data$subject

	extracted$action <- full_data$action

	save(extracted, file="mean_std.RData")

	extracted
}
