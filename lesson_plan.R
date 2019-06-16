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
flights %>%
  select(carrier, dest) %>%
  group_by(carrier, dest) %>%
  summarize(count = n()) %>%
  spread(dest, count)



top_carriers <- flights %>%
  select(carrier) %>%
  group_by(carrier) %>%
  summarize(count = n()) %>%
  arrange(-count)
top_carriers <- top_carriers$carrier[1:5]
top_carriers

top_dest <- flights %>%
  filter(carrier %in% top_carriers) %>%
  select(dest) %>%
  group_by(dest) %>%
  summarize(count = n()) %>%
  arrange(-count)
top_dest <- top_dest$dest[1:6]
top_dest

wrangled_dest <- flights %>%
  select(carrier, dest) %>%
  filter(
    carrier %in% top_carriers,
    dest %in% top_dest
  )

%>%
  group_by(dest, carrier) %>%
  summarize(count = n())

## Plot
wrangled_dest %>%
  ggplot() +
  geom_tile(aes(dest, carrier, fill = count))

wrangled_dest %>%
  ggplot() +
  geom_bar(aes(dest)) +
  facet_wrap(~ carrier)

## Prettify plot
flights %>%
  select(dest, carrier) %>%
  filter(carrier %in% c("UA", "EV", "9E")) %>%
  left_join(airlines) %>%
  select(-carrier) %>%
  group_by(dest, name) %>%
  summarize(n = n()) %>%
  spread(name, n) %>%
  filter_all(~!is.na(.x)) %>%
  gather(name, n, 2:4) %>%
  mutate(n = log(n)) %>%
  ggplot() +
  geom_tile(aes(dest, name, fill = n))

flights %>%
  select(dest, carrier) %>%
  filter(carrier %in% c("UA", "EV", "9E"))
