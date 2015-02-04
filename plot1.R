library(dplyr)
library(lubridate)
library(data.table)

# read the data if it exists
if(!file.exists("household_power_consumption.txt")) stop("data file not found")
dt <- fread(input = "household_power_consumption.txt", header = T, sep = ';', na.strings = c("?"), nrow=2075259,
            colClasses = "character")

dt <- dt %>%
        filter(Date %in% c("1/2/2007", "2/2/2007"), !is.na(suppressWarnings(as.numeric(Global_active_power)))) %>%
        mutate(datetime = dmy_hms(paste(Date, Time, sep=" ")), Global_active_power = as.numeric(Global_active_power))

# create plot1.png
png("plot1.png", height=480, width=480)
with(dt, hist(Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main = "Global Active Power"))
dev.off()