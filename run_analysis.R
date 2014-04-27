
#Extracted dataset directory path. All other file paths are derived from 
#this path

BASE_PATH <- "UCI HAR Dataset"



#Read file from disk into a dataframe using read.table.

txtFileToTable <- function(relativePath) {
    path <- paste(BASE_PATH, relativePath, sep="/")
    read.table(path, stringsAsFactors=F)
}



#Get names of all activities

getActivityLabels <- function() {
    activities <- txtFileToTable("activity_labels.txt")
    as.character(activities[, 2])
}

getFeatureNames <- function() {
    featuresTable <- txtFileToTable("features.txt")
    featuresTable[, 2]
}



#Loads feature data (i.e. X_test.txt or X_train.txt) into a dataframe. 
#Column names are set to corresponding feature name

loadXIntoTable <- function(relativePath) {
    x <- txtFileToTable(relativePath)
    featureNames <- getFeatureNames()
    colnames(x) <- featureNames
    x
}



#Filter only mean and standard deviation variables from the loaded dataset.

filterXColumns <- function(x) {
    message("Filtering columns")

    featureNames <- getFeatureNames()
    #Convert to Lower Case to include both "Mean" and "mean"
    lowerFeatureNames <- tolower(featureNames)
    meanCols <- grep("mean", lowerFeatureNames)
    stdCols <- grep("std", lowerFeatureNames)
    filterCols <- c(meanCols, stdCols)

    x[, filterCols]
}


#Loads subject data. Category is either "test" or "train"

loadSubjectData <- function(category) {
    subjectFileName <- paste("subject_", category, ".txt", sep="")
    subjectRelativePath <- paste(category, subjectFileName, sep="/")
    subjectData <- txtFileToTable(subjectRelativePath)
    
    colnames(subjectData) <- "subject"
    subjectData
}

#Loads activity data. Similar to loading subject data. Category is either 
#"test" or "train"

loadActivityLabelData <- function(category) {
    yFileName <- paste("y_", category, ".txt", sep="")
    yRelativePath <- paste(category, yFileName, sep="/")
    y <- txtFileToTable(yRelativePath)

    activities <- getActivityLabels()
    labeledY <- sapply(y, function(a) {activities[a]})
    colnames(labeledY) <- c("activityLabel")
    labeledY
}

#Loads Subject and Activity data for given category. Also loads feature data.
#Finally all columns are merged to form a single data frame 

loadCategoryData <- function(category) {
    message(paste("Loading", category, "data"))

    subjectData <- loadSubjectData(category)
    activityLabelData <- loadActivityLabelData(category)
    
    xFileName <- paste("X_", category, ".txt", sep="")
    xRelativePath <- paste(category, xFileName, sep="/")
    x <- loadXIntoTable(xRelativePath)
    filteredX <- filterXColumns(x)

    subjectAndActivity <- cbind(subjectData,activityLabelData)
    allData <- cbind(subjectAndActivity, filteredX)


    allData

}

#1. Loads test dataset 
#2. Loads training dataset
#3. Merges them using rbind. rbind is slow( todo -> Find an alternative)

loadAndMergeCategoryData <- function() {

    testData <- loadCategoryData("test")
    trainData <- loadCategoryData("train")

    message("Merging training and test data")
    rbind(testData, trainData)

}


#Calculates average of each parameter by Subject And activity.
#A new column, subjectAndActivity, which is a concatenation of 
#subject and activityLabel is used for aggregation
#http://stackoverflow.com/a/7029834/817277

averageBySubjectAndActivity <- function(df) {
    
    message("Calculating average for each subject and activity")

    subjectAndActivity <- paste(df[, 1], df[, 2])
    df$subjectAndActivity <- subjectAndActivity
    
    lastFeatureIndex <- ( dim(df)[2] - 1 )
    agg <- aggregate(df[, 3:lastFeatureIndex], list(df$subjectAndActivity), mean)
    
    colnames(agg)[1] <- "subjectAndActivity"

    agg
    
}

#Calls methods that perform the neccessary merging and filtering
#Writes results into the "tidy" directory

tidyData <- function() {

    startingTime <- Sys.time()
    if(!file.exists("tidy")) {
        dir.create("tidy")
    }
    mergedData <- loadAndMergeCategoryData()
    write.table(mergedData, "tidy/merged_tidy_all.txt")
    
    subjectAverageData <- averageBySubjectAndActivity(mergedData)
    write.table(subjectAverageData, "tidy/subject_activity_average_data.txt")

    message("Done! Find tidy datasets in the \"tidy\" directory")
    endingTime <- Sys.time()

    print(endingTime - startingTime)

}


tidyData()

