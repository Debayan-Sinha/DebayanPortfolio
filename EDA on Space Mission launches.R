#-----------------------------Space Mission Analysis---------------------------------------#
#-------------------------------------------------------------------------------------------#

data <- read.csv("C:/Users/Suhita Sinha/Desktop/R Coding/R/Revision/dataset/mission_launches.csv", 
                 header = TRUE, as.is = TRUE, stringsAsFactors = FALSE)

df <- data #making a copy of the dataset

library(sqldf)  # for data wrangling
library(dplyr)   # for data wrangling
library(ggplot2) # for data visualization
library(pastecs) # for detailed statistics
library(lubridate) # for date wrangling

dim(df) #showing rows and columns
str(df)
#view(head(df,5))
summary(df) #showing summary statistics

colnames(df)

# converting strings into factors
df["Rocket_Status"] <- as.factor(df$Rocket_Status)
df["Mission_Status"] <- as.factor(df$Mission_Status)
#df["Organisation"] <- as.factor(df$Organisation)
df$Price <- as.integer(df$Price) # changing the data type into integer
class(df$Date)
df$Date <- as.Date(df$Date) # not working

#removing duplicate rows.
 df1 <- unique(df) # no duplicate rows
 sqldf("select count(distinct(x))
       from df")
 

#checking null values
colSums(is.na(df)) # checking count of null values for each column
sum(is.na(df$Price))

df1 <- subset(df, select = -c(Price,Unnamed..0))# delete column price for having excessive null values
#df1 <- subset(df, select = -Unnamed..0) #deleting unnecessary column
?rename
df1<- rename(df1, Sl.no. = X) #renaming the first col as sl.no


# ________________organisation having the highest no. of rockets____________________________________

plot1<-sqldf("select Organisation, count(*) as no_of_rockets
      from df1
      group by Organisation
      order by count(*) desc
             limit 15")

# Visualising the data with bar plot
colnames(plot1)
ggplot(plot1,aes(reorder(Organisation,+no_of_rockets), no_of_rockets))+
  geom_bar(stat = 'identity', colour = "green")+ coord_flip()+
  geom_text(aes(label = no_of_rockets), size = 3, hjust=1)+ 
  labs(title = "Top 15 organisations",
       x = "Name of Organisations")

#Bar plot showing mission status
ggplot(df1, aes(Mission_Status))+ geom_bar(fill="steelblue")

# Bar plot showing rocket status
plot2 <- sqldf("select Rocket_Status, count(*) as count
               from df1
               group by Rocket_Status")
plot2
 #visuialising the data with bar plot

ggplot(plot2,aes(Rocket_Status,count))+
  geom_bar(stat = "identity", fill= "steelblue") +
  geom_text(aes(label=count), vjust = 1, colour = "white")



df1$Date <- substring(df1$Date,1,16)
df1$day_of_launch <- substring(df1$Date,1,3)
df1$Date <- substring(df1$Date,4,16)
df1$year_of_launch <- substring(df1$Date,9,13)

# year wise count of launch

plot3 <- df1%>%group_by(year_of_launch)%>%tally()

#visualize with bar plot
ggplot(plot3, aes(year_of_launch,n)) + 
  geom_bar(stat = "identity", fill = "yellow", colour = "red") + 
  geom_text(aes(label = n))

#day wise count of rocket launch

plot4 <- df1%>%group_by(day_of_launch)%>%tally()
plot4
#visualize with bar plot
ggplot(plot4, aes(day_of_launch,n)) + 
  geom_bar(stat = "identity", fill = "yellow", colour = "red") + 
  geom_text(aes(label = n))


  







