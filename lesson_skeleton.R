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
str(flights)
summary(flights)


# You can directly read in directly from files online
crime <- read_csv("https://vincentarelbundock.github.io/Rdatasets/csv/Ecdat/Crime.csv")
browseURL("https://vincentarelbundock.github.io/Rdatasets/doc/Ecdat/Crime.html")



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

## Which airlines experience the most delays?

## Wrangle data

## Plot

## Prettify plot

############################################
##                Plot 4                  ##
############################################

## How does time of year affect flight delay?




############################################
##                Plot 5                  ##
############################################

## Which destinations are serviced by the top x airlines?

