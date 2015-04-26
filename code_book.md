## Code Book

I've written a lot more valuable information in my README document, which I encourage you to review. This document will attempt to "describe[s] the variables, the data, and any transformations or work that you performed to clean up the data".

### Variables
The original dataset has 561 variables, measuring a whole load of different points for a subject when they do one of the six actions. I pared down these variables to those that are either a mean or a standard deviation, which left me with 78 variables. I also added three variables to the data: subject, which was from the corresponding subject\_test data; action, which was from the corresponding y-values data; and action\_description, which was mapped by action variable and the activity\_labels data.

### Data
Besides filling in the data I describe in the variables section, I also condense the data in the final data set by each unique combination of action and subject. I simply took the average of all values in each variable that had the same action and subject and set that as the sole value of that variable for that action-subject pair.

### Transformations and work
Besides the transformations above, I made no additional changes to the data. I ignored any other raw data that was included in the zip file for this project. 
