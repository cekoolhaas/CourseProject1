##Make sure everything we need is in library
library(ggplot2)
library(scales)
library(chron)
library(cowplot)
library(tidyr)
library(data.table)
##Read data
my_data <- read.delim(file.choose())
##Subset rows we need
my_data <- my_data[66638:72398,1]
##Turn it back into data frame
newdata <- as.data.frame(my_data)
##Separate variables into columns
newdata2 <- separate(newdata, 1, into = c("Date", "Time", "globalActivepower", "globalReactivepower", "Voltage", "GlobalIntensity", "Sub-metering1", "Sub-metering2", "Sub-metering3"), sep = ";")
as.numeric(newdata2$globalActivepower)

##I needed to do lots of stuff to get the times and dates right
newdata2$Date <- as.Date(newdata2$Date, "%d/%m/%Y")
##ourdates and trial are just the names I gave the variables as I was working through it
##ourdates has the bulk data we need
ourdates <- setDT(newdata2)[Date %between% c('2007-02-01', '2007-02-02')]
##trial has the specific data for this plot
trial <- as.numeric(ourdates$globalActivepower)
ourdates$Time <- chron(times=ourdates$Time)
##perhaps is another bad variable name (I wasn't sure this would work, so I called it "perhaps")
##It did work, so I kept it. It stores the datetime information for the plot
perhaps <- as.POSIXct(paste(ourdates$Date, ourdates$Time), format="%Y-%m-%d %H:%M:%S")

##another bad variable name. This is subsetting the datetime info
tryit <- subset(perhaps,
                perhaps >= as.POSIXct('2007-02-01 00:00') &
                  perhaps <= as.POSIXct('2007-02-02 23:59'))
##plot and save finally
plot2 <- ggplot(ourdates, aes(x=tryit, y=trial)) +
         scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%A")) +
         scale_y_continuous(breaks = seq(0, 7)) +
         xlab("") +
         ylab("Global Active Power (kilowatts)") +
         geom_line()

plot2
ggsave("plot2.png", width = 480, height = 480, units = c("px"))
