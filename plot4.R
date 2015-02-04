library(dplyr)
library(lubridate)
library(tidyr)
library(data.table)

# read the data if it exists
if(!file.exists("household_power_consumption.txt")) stop("data file not found")
dt <- fread(input = "household_power_consumption.txt", header = T, sep = ';', na.strings = "?", nrow=2075259, colClasses="character")
dt <- dt %>%
    filter(Date %in% c("1/2/2007", "2/2/2007")
           , !is.na(suppressWarnings(as.numeric(Voltage)))
           , !is.na(suppressWarnings(as.numeric(Global_active_power)))
           , !is.na(suppressWarnings(as.numeric(Global_reactive_power)))
           , !is.na(suppressWarnings(as.numeric(Sub_metering_1)))
           , !is.na(suppressWarnings(as.numeric(Sub_metering_2)))
           , !is.na(suppressWarnings(as.numeric(Sub_metering_3)))) %>%
    mutate(datetime = dmy_hms(paste(Date, Time, sep=" "))
           , Voltage = as.numeric(Voltage)
           , Global_active_power = as.numeric(Global_active_power)
           , Global_reactive_power = as.numeric(Global_reactive_power)
           , Sub_metering_1 = as.numeric(Sub_metering_1)
           , Sub_metering_2 = as.numeric(Sub_metering_2)
           , Sub_metering_3 = as.numeric(Sub_metering_3))

# create plot4.png
png("plot4.png", height=480, width=480)
par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(dt, {
    # topleft
    plot(Global_active_power~datetime, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

    # topright
    plot(Voltage~datetime, type = "l", xlab="", ylab="Voltage (volt)")

    # bottomleft
    plot(Sub_metering_1 ~ datetime, type="l", col="black", xlab="", ylab="Energy sub metering")
    lines(Sub_metering_2 ~ datetime, col="red")
    lines(Sub_metering_3 ~ datetime, col="blue")
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

    # bottomright
    plot(Global_reactive_power ~ datetime, type="l", xlab="", ylab="Global Reactive Power (kilowatts)")
})
dev.off()