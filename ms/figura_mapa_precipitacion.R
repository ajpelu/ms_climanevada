# Raster precipitation 

library(sf)
library(here)
library(tidyverse)
library(raster)
library(rasterVis)
library(latticeExtra)
library(ggspatial)

# Read raster 
r <- raster(here::here("ms/figures/raster_precipita.tif"))

# Read limit of SN 
sn <- st_read("/Users/ajpelu/Google Drive/_phd/_geoinfo/aux/sn_enp.shp")
sn <- st_transform(sn, projection(r))

# Read sen station
sen <- st_read(here::here("ms/figures/info_figura_eric/sen_stations.shp"))
sen <- st_transform(sen, projection(r))

precip <- as.data.frame(r, xy=TRUE) %>% 
  rename(prec = raster_precipita)

mapa <- ggplot() +
  geom_raster(data = precip, 
              aes(x = x, y = y, fill = prec)) +
   scale_fill_gradientn(colours = brewer.pal(9, "GnBu"), 
                        na.value = "transparent", 
                       name = "Precipitación (mm)") +
  geom_sf(data = sn, fill= NA, size = .5) + 
  geom_point(data = sen, aes(x=longitud, y =latitud, shape=clasifica_,
                             color=clasifica_)) +
  coord_sf() + 
  theme_bw() +
  xlab("Longitud") + ylab("Latitud") + 
  theme(panel.grid = element_blank(),
        legend.position = "bottom") +
  annotation_scale(location = "tl", width_hint = 0.2) +
  annotation_north_arrow(location = "tl", which_north = "true", 
                         height = unit(0.3, "in"), width = unit(0.3, "in"), 
                         pad_x = unit(0.25, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  scale_shape_manual(values=c("red_triangle"=25,
                              "red_circle" =10,
                              "blue_circle" =10), 
                     guide="none") +
  scale_color_manual(values=c("red_triangle"="red",
                              "red_circle" ="red",
                              "blue_circle" = "darkgreen"), 
                     guide="none") 

ggsave(here::here("ms/figures/precipita.png"), 
       plot = mapa, device = "png",
       width = 19, height = 10, units = "cm", 
       dpi = 300)
