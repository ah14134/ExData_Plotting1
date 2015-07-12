
## check if ./data folder exists 

if(!file.exists("data")){dir.create("data")}

## check if data file exists. 
## If not, downlord and unzip (using CRAN package "downloader")

file.name <- "./data/household_power_consumption.txt"
if(!file.exists(file.name)){
        
        # check if CRAN package "downloader" is installed
        list.of.packages <- c("downloader")
        
        new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
        if(length(new.packages)) install.packages(new.packages)
        
        library("downloader")
        
        # download zip file
        file.URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        file.zip <- "./data/dataset.zip"
        
        download(file.URL, dest=file.zip, mode="wb") 
        unzip(file.zip, exdir = "./data")
        unlink(file.zip)
}

fulldata.df <- read.csv(filename, header=T, sep=';', na.strings="?", quote='\"')
fulldata.df$Date <- as.Date(fulldata.df$Date,format="%d/%m/%Y")

consumption.df <- subset(fulldata.df, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(fulldata.df)

## Converting dates
datetime <- paste(as.Date(consumption.df$Date), consumption.df$Time)
consumption.df$Datetime <- as.POSIXct(datetime)

## Plot 1
hist(consumption.df$Global_active_power, main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

## Saving to file
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()
