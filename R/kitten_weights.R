library(tidyverse)
library(ggimage)
library(extrafont)
library(Rokemon)
library(palettetown)
library(gganimate)
library(gifski)
library(av)


# Get fonts
#font_import()
#loadfonts(device="win")

# Load data
urlfile="https://raw.githubusercontent.com/apurdy/Datasets/master/csv/kitten_weights.csv"
urlpokemon="https://raw.githubusercontent.com/apurdy/Datasets/master/csv/pokemon_images.csv"
kitten_weights<-read_csv(url(urlfile))
pkm_images<-read_csv(url(urlpokemon))

# Clean data
kitten_weights_2 <- kitten_weights %>%
  pivot_longer(-c(date,day), names_to = "kitten_name", values_to = "weight_grams")
  kitten_weights_2$day <- as.integer(kitten_weights_2$day)

# Match in pokemon images
kitten_weights_2$pkm_image <-pkm_images$image_url[match(kitten_weights_2$kitten_name, pkm_images$pkm_name)]

# Plot the data
my_plot <- ggplot(kitten_weights_2,aes(x=day, y=weight_grams, group = kitten_name, color=kitten_name))+
  #geom_point(aes(color=kitten_name), size =3) +
  geom_path(aes(color=kitten_name), size =1.2)+
  #geom_line(aes(color=kitten_name), size = 1.5)+
  geom_image(aes(image = pkm_image), size = 0.06) +
  theme_gba()+
  scale_colour_manual(values = c("#F85888", "#A8A878", "#F08030","#786824", "#6890F0", "#C6D16E")) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  #scale_fill_identity(guide = "pkm_image") +
  labs(title = "What? Your Kittens Are Evolving!",
       x = "Days on Earth",
       y = "Weight (grams)",
       color="Kittens"
       #caption = 'Viz: @aarpurd'
       ) +

  theme(plot.title = element_text(size = rel(1.5), margin = unit(c(6,0,6,0), "mm")),
        plot.background=element_rect(fill="#9bbc0f"),
        panel.background = element_rect(fill ="#d8d8d8"),
        axis.title.x = element_text(margin = unit(c(4,0,3,0), "mm"),colour = "black"),
        axis.text.x = element_text(colour = "black"),
        axis.title.y = element_text(margin = unit(c(0,5,0,3), "mm"),colour = "black"),
        axis.text.y = element_text(colour = "black"),
        legend.position="right",
        legend.background = element_rect(fill = "transparent"),
        legend.key = element_rect(fill = "#d8d8d8"),
        legend.text = element_text(colour = "black", size=12),
        legend.title = element_blank(),
        legend.margin = margin(c(0,18,0,0)),
        legend.justification = "top",
        panel.grid.major = element_line(colour="white", size=0.1)
        ) +
  guides(color = guide_legend(override.aes = list(size = 4))) +

#my_plot

  transition_reveal(day) +
  view_follow() +
  ease_aes('linear')


# Save animation
#animate(my_plot, duration = 30 ,nframes = 300, height = 520, width =821, renderer = gifski_renderer(), end_pause = 200)
#anim_save("kitten_weights.gif")
animate(my_plot, duration = 30 ,nframes = 600, height = 520, width =821, renderer = av_renderer())
anim_save("kitten_weights.mp4")