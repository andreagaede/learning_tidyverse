### Welcom to Shree and Dre's tidyverse overview

library(tidyverse)
library(nycflights13)

## cheat sheets: https://www.rstudio.com/resources/cheatsheets/

## Import data

# explain read.csv() vs read_csv() (use url -- put dataset on github and read it)
# mention write_csv()

## Clean dataset

# inspect data: head(), tail(), summary(), names(), unique(), briefly mention tibble vs df
# remove spaces
# change case
# rename columns
# reorder columns

## Wrangles
# filter() -select
# -mutate
# group_by()/summarise
# gather/spread
# join / bind_cols / bind_rows

## plots
## talk about grammar of graphics
## talk about aesthetics within each plot
## in prettify: talk about facet, smooth, reordering
# histogram: color vs fill, alpha,
# bar: factor level reorder
# geom_boxplot + geom_violin(): overlaying points with alpha
# scatter + geom_smooth(): point size, line type, size inside vs outside aes(), scale_x_log10()

############################################
##                Import                  ##
############################################

# You can read in directly from files online
crime <- read_csv("https://vincentarelbundock.github.io/Rdatasets/csv/Ecdat/Crime.csv")

# Datasets need documentation too
browseURL("https://vincentarelbundock.github.io/Rdatasets/doc/Ecdat/Crime.html")

############################################
##                Clean                   ##
############################################

# inspect data: head(), tail(), summary(), names(), unique(), briefly mention tibble vs df
# remove spaces
# change case
# rename columns
# reorder columns

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
wrangled_hr <- flights %>%
  select(hour, minute)

wrangled_hr

## Plot
wrangled_hr %>%
  ggplot() +
  geom_histogram(aes(hour))

## Prettify plot
wrangled_hr %>%
  ggplot() +
  geom_histogram(aes(hour), binwidth = 1) +
  theme_minimal()

############################################
##                Plot 2                  ##
############################################

## What times are busiest?

## Wrangle data
wrangled_min <- wrangled_hr %>%
  mutate(
    time_min = 60 * hour + minute,
    time = time_min / 60
    )

wrangled_min

## Plot
wrangled_min %>%
  ggplot() +
  geom_histogram(aes(time), binwidth = 1)

## Prettify plot
wrangled_min %>%
  ggplot() +
  geom_histogram(aes(time), binwidth = 1/4) +
  labs(x = "Time (hour)", y = "Number of Flights", title = "Busiest departure times at New York airports") +
  theme_minimal()

############################################
##                Plot 3                  ##
############################################

## Wrangle data
top_carriers <- flights %>%
  count(carrier) %>%
  arrange(-n) %>%
  head(5) %>%
  pull(carrier)

top_dest <- flights %>%
  select(carrier, dest) %>%
  filter(carrier %in% top_carriers) %>%
  count(carrier, dest) %>%
  spread(carrier, n) %>%
  drop_na %>%
  pull(dest)

wrangled_dest <- flights %>%
  select(carrier, dest) %>%
  filter(
    carrier %in% top_carriers,
    dest %in% top_dest
  ) %>%
  inner_join(airlines)

wrangled_dest

## Plot
wrangled_dest %>%
  ggplot() +
  geom_bin2d(aes(dest, name))

## Prettify plot

############################################
##                Plot 4                  ##
############################################

## Which airlines experience the most delays?

## Wrangle data
flights %>%
  select(tailnum, arr_delay) %>%
## Plot
  ggplot(aes(tailnum, arr_delay)) +
  geom_boxplot()

## Prettify plot
flights %>%
  select(carrier, distance) %>%
  ggplot(aes(carrier, distance)) +
  geom_boxplot()
