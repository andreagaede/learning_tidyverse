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

left_join(flights, airlines, by = "carrier") %>%
  filter(is.na(flights$arr_delay) == FALSE) %>%
  sample_frac(0.1) %>%
  ggplot() +
  geom_jitter(height = 0.3, size = 0.1, aes(arr_delay, name, alpha = 1/10, color = name)) +
  theme_classic() +
  theme(legend.position = "none")



left_join(flights, airlines, by = "carrier") %>%
  filter(is.na(flights$arr_delay) == FALSE) %>%
  sample_frac(0.1) %>%
  ggplot(aes(name, arr_delay, color = name, fill = name)) +
  geom_boxplot(aes(alpha = 1/5)) +
  geom_jitter(position = position_jitter(width = 0, height = 0.1), alpha = 1/4) +
  # geom_jitter(width = 0.1, aes(color = name)) +
  theme(legend.position = "none") +
  scale_y_log10() +
  coord_flip()




############################################
##                Plot 5                  ##
############################################

## How does time of year affect flight delay?

season_df <- flights %>%
  select(month, day, arr_delay, dep_delay, origin, dest, carrier) %>%
  filter(arr_delay >= 0, dep_delay >= 0) %>%
  group_by(origin, month, day) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE) + mean(dep_delay, na.rm = TRUE)) %>%
  ungroup()

season_df %>%
  group_by(origin) %>%
  summarise(max(avg_delay), min(avg_delay))

season_df$date <- with(season_df, ISOdate(year = 2013, month, day))

season_df %>%
  ggplot(aes(date, avg_delay)) +
  geom_point(aes(color = origin)) +
  scale_color_manual(values = c("springgreen", "purple", "dodgerblue")) +
  geom_smooth(color = "magenta") +
  ylab("average delay (min)") +
  theme_classic()

season_df %>%
  ggplot(aes(date, avg_delay)) +
  geom_point(aes(color = origin, alpha = 1/8)) +
  geom_smooth(aes(color = origin), se = FALSE) +
  scale_color_manual(values = c("springgreen", "purple", "dodgerblue")) +
  ylab("average delay (min)") +
  theme_classic()

season_df %>%
  ggplot(aes(date, avg_delay)) +
  geom_smooth(aes(color = origin), se = FALSE) +
  scale_color_manual(values = c("springgreen", "purple", "dodgerblue")) +
  ylab("average delay (min)") +
  theme_classic()


