
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
consumption.df <- subset(fulldata.df, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(fulldata.df)

## Converting dates
datetime <- paste(as.Date(consumption.df$Date), consumption.df$Time)
consumption.df$Datetime <- as.POSIXct(datetime)

## Plot 4
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(consumption.df, {
        plot(Global_active_power~Datetime, type="l", 
             ylab="Global Active Power (kilowatts)", xlab="")
        plot(Voltage~Datetime, type="l", 
             ylab="Voltage (volt)", xlab="")
        plot(Sub_metering_1~Datetime, type="l", 
             ylab="Global Active Power (kilowatts)", xlab="")
        lines(Sub_metering_2~Datetime,col='Red')
        lines(Sub_metering_3~Datetime,col='Blue')
        legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(Global_reactive_power~Datetime, type="l", 
             ylab="Global Rective Power (kilowatts)",xlab="")
})

## Saving to file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
