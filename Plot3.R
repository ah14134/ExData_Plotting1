
## check if ./data folder exists 

if(!file.exists("data")){dir.create("data")}

##  if data file is not here  
##  downlord and unzip (using CRAN package "downloader")

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
fulldata.df <- read.csv(file.name, header=T, sep=';', na.strings="?", quote='\"')
fulldata.df$Date <- as.Date(fulldata.df$Date,format="%d/%m/%Y")

consumption.df <- subset(fulldata.df, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(fulldata.df)

## Converting dates
datetime <- paste(as.Date(consumption.df$Date), consumption.df$Time)
consumption.df$Datetime <- as.POSIXct(datetime)


## Plot 3
par(mar=c(2,2,1,1), oma=c(0,0,0,0))
with(consumption.df, {
        plot(Sub_metering_1~Datetime, type="l",
             ylab="Global Active Power (kilowatts)", xlab="")
        lines(Sub_metering_2~Datetime,col='Red')
        lines(Sub_metering_3~Datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
