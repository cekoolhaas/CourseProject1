##Make sure everything is in library
library(ggplot2)
library(scales)
library(chron)
library(cowplot)
library(tidyr)
library(data.table)
##Read the data, subset it, separate variables into columns
my_data <- read.delim(file.choose())
my_data <- my_data[66638:72398,1]
newdata <- as.data.frame(my_data)
newdata2 <- separate(newdata, 1, into = c("Date", "Time", "globalActivepower", "globalReactivepower", "Voltage", "GlobalIntensity", "Sub-metering1", "Sub-metering2", "Sub-metering3"), sep = ";")
as.numeric(newdata2$globalActivepower)

##This is all the code I used to get the datetime stuff correct
newdata2$Date <- as.Date(newdata2$Date, "%d/%m/%Y")
ourdates <- setDT(newdata2)[Date %between% c('2007-02-01', '2007-02-02')]
ourdates$Time <- chron(times=ourdates$Time)
perhaps <- as.POSIXct(paste(ourdates$Date, ourdates$Time), format="%Y-%m-%d %H:%M:%S")
tryit <- subset(perhaps,
                perhaps >= as.POSIXct('2007-02-01 00:00') &
                  perhaps <= as.POSIXct('2007-02-02 23:59'))

myvoltage <- as.numeric(ourdates$Voltage)

##Plot and save!
voltplot <- ggplot(ourdates, aes(x=tryit, y=myvoltage)) +
            scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%A")) +
            scale_y_continuous(breaks = seq(233, 246)) +
            xlab("datetime") +
            ylab("Voltage") +
            geom_line()

mygrp <- as.numeric(ourdates$globalReactivepower)

grpplot <- ggplot(ourdates, aes(x=tryit, y=mygrp)) +
           scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%A")) +
           scale_y_continuous(breaks = seq(0, 0.5, by = 0.1)) +
           xlab("datetime") +
           ylab("Global_reactive_power") +
           geom_line()

submet1 <- as.numeric(ourdates$`Sub-metering1`)
submet2 <- as.numeric(ourdates$`Sub-metering2`)
submet3 <- as.numeric(ourdates$`Sub-metering3`)

submetplot <- ggplot(ourdates, aes(x=tryit, y=submet1, color = "sub_metering_1")) +
              scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%A")) +
              scale_y_continuous(breaks = seq(0, 35, by = 10)) +
              xlab("") +
              ylab("Energy Sub metering") +
              theme(
              legend.position = c(1, 1), legend.justification = c("right", "top"),
              legend.key.height = unit(0.1, "cm"),
              legend.key.size = unit(0.2, "cm")) +
              geom_line(aes(y = submet2, color = "sub_metering_2")) +
              geom_line(aes(y = submet3, color = "sub_metering_3")) +
              scale_color_manual(name = "", values = c("sub_metering_1" = "black", "sub_metering_2" = "red", "sub_metering_3" = "blue")) +
              geom_line()

trial <- as.numeric(ourdates$globalActivepower)

gapplot <- ggplot(ourdates, aes(x=tryit, y=trial)) +
           scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%A")) +
           scale_y_continuous(breaks = seq(0, 7)) +
           xlab("") +
           ylab("Global Active Power (kilowatts)") +
           geom_line()

##This is the code that puts all the plots into a 2x2 alignment
plot4 <- plot_grid(gapplot, voltplot, submetplot, grpplot, labels=c("", "", "", ""), ncol = 2, nrow = 2)
plot4

ggsave("plot4.png", width = 480, height = 480, units = c("px"))



