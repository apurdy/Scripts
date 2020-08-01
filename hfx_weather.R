library(ggridges)
library(ggplot2)
library(viridis)
library(gganimate)
library(hrbrthemes)
library(gifski)
library(readr)
library(RCurl)

# Import data
urlfile="https://raw.githubusercontent.com/apurdy/Datasets/master/csv/weatherstats_halifax_daily.csv"
hfx_weather<-read_csv(url(urlfile))
#hfx_weather <- read.csv('/Users/purdya/OneDrive - GrantThorntonCA/Projects/weatherstats_halifax_daily.csv', row.names=1)
hfx_weather$month <- factor(hfx_weather$month, levels = c("December","November","October", "September", "August", "July", "June", 
                                              "May", "April", "March", "February", "January"))

# Plot
my_plot<- ggplot(hfx_weather, aes(x = `avg_temperature`, y = `month`, fill = ..x..)) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  scale_fill_viridis(name = "Temp. [F]", option = "plasma") +
  labs(title = 'Temperatures in Halifax, NS', subtitle = '{closest_state}',
       x = "Daily Temperature (C)", y = NULL, caption = 'Data: halifax.weatherstats.ca | Viz: @aarpurd') +
  theme_ipsum_pub() +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  )   +
  #enter_appear() +
  transition_states(year, transition_length = 1, state_length = 2) +
  #shadow_mark(past = TRUE, future = FALSE, color= "grey") +
  ease_aes('linear')


# Save animation
animate(my_plot, nframes = 250, renderer = gifski_renderer(), end_pause = 30)
anim_save("hfx_weather.gif")
