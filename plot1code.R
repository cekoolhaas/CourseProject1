##Make sure everything is in library
library(ggplot2)
library(scales)
library(chron)
library(cowplot)
library(tidyr)
library(data.table)

##Read the data 
my_data <- read.delim(file.choose())
##Subset the rows we need
my_data <- my_data[66638:72398,1]
##Turn it back into a data frame
newdata <- as.data.frame(my_data)
##Separate the variables into columns
newdata2 <- separate(newdata, 1, into = c("Date", "Time", "globalActivepower", "globalReactivepower", "Voltage", "GlobalIntensity", "Sub-metering1", "Sub-metering2", "Sub-metering3"), sep = ";")
##Change data from character to numeric
as.numeric(newdata2$globalActivepower)
##Plot and save
plot1 <- hist(as.numeric(newdata2$globalActivepower), main = "Global Active Power", col = "red")

png(filename="plot1.png", width = 480, height = 480, units = "px")
hist(as.numeric(newdata2$globalActivepower), main = "Global Active Power", col = "red")
dev.off()

