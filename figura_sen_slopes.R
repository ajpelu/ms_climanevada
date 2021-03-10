library(here)
library("tidyverse")
library("ggpubr")

df <- read_delim(here::here("data/sen_slopes.txt"), delim="\t")

df %>% ggplot(aes(x=season, y=sen)) +
  geom_violin(trim = FALSE)+
  geom_dotplot(binaxis='y', stackdir='center')

p <- ggdotplot(df, x = "season", y = "sen", 
          size = .7, fill="gray", color= "transparent", 
          alpha=.9, position = position_jitter(.1)) +
  scale_x_discrete(limits = c("anual", "invierno", "primavera", "verano", "otoño"))+
  ylab("Tendencia (mm/año)") + xlab("") + 
  scale_y_continuous(limits = c(-5, 1), breaks= seq(-5,1, 1))

p <- add_summary(p, "mean_sd", color = "blue")
p 

ggsave(filename= here::here("ms/figures/figure_sen_slopes.pdf"), 
       height = 4, width = 6)

ggsave(filename = here::here("ms/figures/figure_sen_slopes.png"),
       plot = p,
       width = 7, height = 5, dpi = 300, units = "in", device='png')