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

############################################
##                Plot 4                  ##
############################################


flights
airlines
airports

## which airlines are on time most frequently
## does distance traveled affect this?
## does dest affect this?


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

#install.packages("ggpubr")  
#library(ggpubr)
left_join(flights, airlines, by = "carrier") %>% 
  filter(is.na(flights$arr_delay) == FALSE) %>% 
  sample_frac(0.1) %>% 
  ggplot(aes(name, arr_delay, color = name, fill = name)) +
  geom_violin(aes(alpha = 1/5)) +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  scale_y_log10() + 
  #coord_flip() +
  ggpubr::rotate_x_text() +
  theme(legend.position = "none") 


flights %>% 
  filter(is.na(flights$arr_delay) == FALSE) %>% 
  sample_frac(0.1) %>% 
  ggplot() +
  geom_point(aes(arr_delay, distance)) + 
  geom_smooth(aes(arr_delay, distance))

inner_join(flights, weather) %>% 
  select(arr_delay, wind_speed, origin, dest, carrier) %>% 
  sample_frac(0.1) %>% 
  ggplot() +
  facet_grid(.~origin) +
  geom_point(aes(wind_speed, arr_delay)) +
  geom_smooth(aes(wind_speed, arr_delay), method = "lm")

inner_join(flights, weather) %>% 
  select(arr_delay, wind_speed, origin, dest, carrier) %>% 
  sample_frac(0.1) %>% 
  group_by(origin) %>% 
  ggplot(aes(wind_speed, arr_delay, color = origin)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme(legend.position = "none") 

## look at all weather factors

flights_hr <- flights
flights_hr$hour <- ifelse(flights_hr$hour == 24, 0, flights_hr$hour)

weather_flights <- left_join(flights_hr, weather) %>% 
  filter(arr_delay >= 0) %>% 
  filter(dep_delay >= 0) %>% 
  mutate(tot_delay = arr_delay + dep_delay) %>% 
  select(tot_delay, temp, dewp, humid, wind_dir, wind_speed, wind_gust, precip, pressure, visib)

cor(na.omit(weather_flights))

## look at time of year effect

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
    
