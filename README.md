getting-and-cleaning-data
=========================

Peer assessment submission for the Getting and Cleaning Data course. https://class.coursera.org/getdata-002

Instructions
------------------------

1. Clone the repo

        git clone https://github.com/pramodliv1/getting-and-cleaning-data 
        



2. [Download](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) the dataset into the root directory of the repository, i.e. in the same level as this run_analysis.R.

3. Unzip the download file. You should see a directory called `UCI HAR Dataset`

4. Open RStudio and set the working directory to the root directory of the repository.

5. Run the script which creates the tidy datasets in the `tidy` directory. 

        source("run_analysis.R")


Output Datasets
-----------------
The run_analysis.R script produces two files in the `tidy` directory. 

1. `merged_tidy_all.txt` - Contains merged test and training datasets. The first column is the subject, the second column is the activityLabel. The rest of the columns(86) contain mean and standard deviation measurements.

2. `subject_activity_average_data.txt` - Contains average of each variable grouped by subject and activity extracted from `merged_tidy_all.txt`

See CodeBook.md for more details on column names.
