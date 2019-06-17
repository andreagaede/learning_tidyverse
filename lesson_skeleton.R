### Welcom to Shree and Dre's tidyverse overview

library(tidyverse)
library(nycflights13)

## cheat sheets: https://www.rstudio.com/resources/cheatsheets/

############################################
##                Import                  ##
############################################

# Start with importing data

# Some data come in packages
flights

# You can directly read in directly from files online
crime <- read_csv("https://vincentarelbundock.github.io/Rdatasets/csv/Ecdat/Crime.csv")
browseURL("https://vincentarelbundock.github.io/Rdatasets/doc/Ecdat/Crime.html")

############################################
##                Clean                   ##
############################################

# Take a look at subset of rows
head(crime)
tail(crime)
sample_frac(crime, 0.01)

# Get an overview of the data
names(crime)
summary(crime)

# Subset, reorder, clean data
select(crime) # Subset columns, can also be used to rename and reorder cols
filter(crime) # Subset rows
rename(crime) # Rename
drop_na(crime) # Remove all rows with any NA's


############################################
##                Plot 1                  ##
############################################

## What times are busiest?

## Wrangle data

## Plot

## Prettify plot

############################################
##                Plot 2                  ##
############################################

## What times are busiest?

## Wrangle data

## Plot

## Prettify plot

############################################
##                Plot 3                  ##
############################################

## Wrangle data

## Plot

## Prettify plot

############################################
##                Plot 4                  ##
############################################

## Which airlines experience the most delays?

## Wrangle data

## Plot

## Prettify plot
