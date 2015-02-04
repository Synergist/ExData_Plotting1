library(dplyr)
library(lubridate)
library(tidyr)
library(data.table)

# read the data if it exists
if(!file.exists("household_power_consumption.txt")) stop("data file not found")
dt <- fread(input = "household_power_consumption.txt", header = T, sep = ';', na.strings = c("?"), nrow=2075259,
            colClasses = "character")
dt <- dt %>%
    filter(Date %in% c("1/2/2007", "2/2/2007")
           , !is.na(suppressWarnings(as.numeric(Sub_metering_1)))
           , !is.na(suppressWarnings(as.numeric(Sub_metering_2)))
           , !is.na(suppressWarnings(as.numeric(Sub_metering_3)))) %>%
    mutate(datetime = dmy_hms(paste(Date, Time, sep=" "))
           , Sub_metering_1 = as.numeric(Sub_metering_1)
           , Sub_metering_2 = as.numeric(Sub_metering_2)
           , Sub_metering_3 = as.numeric(Sub_metering_3))

# create plot3.png
png("plot3.png", height=480, width=480)
with(dt, {
    plot(Sub_metering_1 ~ datetime, type="l", col="black", xlab="", ylab="Energy sub metering")
    lines(Sub_metering_2 ~ datetime, col="red")
    lines(Sub_metering_3 ~ datetime, col="blue")
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()
