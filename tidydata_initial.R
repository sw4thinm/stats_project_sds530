library(dplyr)
library(doBy)
library(readr)
library(ggplot2)
library(geosphere)

# read in csv containing divvy bike data. This is the raw data file obtained from Kaggle

divy_chicago <- read.csv("data.csv")

# filter to only include ridership data in 2017 and omit any NA

divy_2017 <- divy_chicago |>
  filter(year == "2017") |>
  na.omit()

# number of rides by usertype
divy_2017$usertype <- as.factor(divy_2017$usertype)
summary(divy_2017$usertype)

## out of 2957690 rides, 832 were by customers, 4 were by dependents and the rest were subscribers. 
## Therefore, we will only look at Subscribers bike rides and remove the usertype column from our cleaned dataset

# modify types of variables

divy_2017$month <- as.factor(divy_2017$month)
divy_2017$day <- as.factor(divy_2017$day)
divy_2017$hour <- as.factor(divy_2017$hour)
divy_2017$from_station_name <- as.factor(divy_2017$from_station_name)
divy_2017$to_station_name <- as.factor(divy_2017$to_station_name)
divy_2017$gender <- as.factor(divy_2017$gender)
divy_2017$events <- as.factor(divy_2017$events)

# final version of data used for analyses
# create column to get distance of bike rides - uses Haversine formula function from geosphere package

start_list <- cbind(c(divy_2017$longitude_start), c(divy_2017$latitude_start))
end_list <- cbind(c(divy_2017$longitude_end), c(divy_2017$latitude_end))


divy_2017 <- divy_2017 |>
  mutate(tripdistance = distHaversine(end_list, start_list)) |>
  filter(usertype == "Subscriber") |>
  select(-year, -usertype, -from_station_id, -to_station_id -starttime, -stoptime)
  
write.csv(divy_2017, "divvy_main_2017.csv")
