## Project Background
The following is taken directly from the README file associated with the dataset:

"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

Credits:
 Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
 Smartlab - Non Linear Complex Systems Laboratory
 DITEN - Università degli Studi di Genova.
 Via Opera Pia 11A, I-16145, Genoa, Italy.
 activityrecognition@smartlab.ws
 www.smartlab.ws

## Generating a Tidy File from the Samsung Accelerometer Data
### Running the Script
To generate the tidy dataset (and resulting tidy.txt file):

* Ensure that the UCI_HAR_Dataset folder containing all downloaded files is in your working directory
* Source the following code: run_analysis.R

It is assumed that the user has already downloaded the datasets from the internet prior to invoking run_analysis.R.  Also, note that there is no need to install any packages to successfully run this script.

### How Does the Script Work?
The script works by first loading all train and test datasets using read.table().  Once the datasets have been loaded, the train and test datasets are then merged using rbind() to include all observations.  Both train and test datasets include three separate files related to:

* Measurement data
* Activity data
* Subject data

Once merging is complete, the dataset contains 10299 observations and 561 measurement variables.  The script then extracts only the measurement columns related to either "mean" or "std," per the course assignment.  This significantly reduces the number of columns to 86. 

The merged activity and subject datasets are then bound to the measurement data using cbind() to create a single dataset containing 88 columns.  The script then creates descriptive names for each activity.  In other words, the integer factor categories associated with each activity are now transformed to more descriptive factor categories (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).  

At this point, the script computes the mean of each measurement for each activity, and for each subject.  Because there are 30 unique subjects in the experiment and 6 unique activities, the final tidy dataset contains 180 observations.  The dimensionality of the original merged data frame was reduced from 10299 observations x 561 columns to 180 observations x 88 columns in the final tidy dataset.

Finally, each measurement variable is renamed to include "meanOf" to indicate that each observation is the mean of each measurement for each activity, and each subject.

The final tidy dataset is then written to file (tidy.txt) using write.table()
