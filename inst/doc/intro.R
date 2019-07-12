## ---- echo = FALSE-------------------------------------------------------
LOCAL <- identical(Sys.getenv("LOCAL"), "true")
knitr::opts_chunk$set(purl = LOCAL)

## ---- eval = FALSE-------------------------------------------------------
#  Sys.setenv(gvision_key = "Your Google Vision API key")

## ---- eval = LOCAL-------------------------------------------------------
library(imgrec)
gvision_init()

## ---- eval = LOCAL-------------------------------------------------------
sw_image <- 'https://upload.wikimedia.org/wikipedia/en/a/a2/Star_Wars_The_Force_Awakens_Theatrical_Poster.jpg'
results <- get_annotations(images = sw_image, # image character vector
                           features = 'all', # request all available features
                           max_res = 5, # maximum number of results per feature
                           mode = 'url') # determine image type

## ---- eval = FALSE-------------------------------------------------------
#  temp_file_path <- tempfile(fileext = '.json')
#  save_json(results, temp_file_path)

## ---- eval = LOCAL-------------------------------------------------------
img_data <- parse_annotations(results) # returns list of data frames
names(img_data) # all available features

## ---- eval = FALSE-------------------------------------------------------
#  img_labels <- img_data$labels
#  head(img_labels)

## ---- results = 'asis', echo = FALSE, eval = LOCAL-----------------------
img_labels <- img_data$labels
knitr::kable(head(img_labels))

## ---- fig.height=5.36, fig.width=3.66, eval = LOCAL----------------------
library(magick)
library(ggplot2)

img <- image_read(sw_image) 
image_ggplot(img) + 
   geom_rect(data = img_data$logos, 
          aes(xmin = poly_x_min, xmax = poly_x_max, 
              ymin = poly_y_min, ymax = poly_y_max),
              color = 'yellow', fill = NA, linetype = 'dashed', size = 2) +
   geom_text(data = img_data$logos, 
          aes(x =poly_x_max, y = poly_y_max, label = description),
              size = 8, color = "yellow", vjust = 1) +
  theme(legend.position="none")


