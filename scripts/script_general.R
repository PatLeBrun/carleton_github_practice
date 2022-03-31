
# Packages ----------------------------------------------------------------

install.packages('remotes') # for installing packages from sources that aren't CRAN
library(remotes) # load the package

install_github("allisonhorst/palmerpenguins") #installing development version of dataset
library(palmerpenguins) # loading the package which contains dataset we will use

install.packages('tidyverse')
library(tidyverse) # loading tidyverse package for ggplot etc.

# Session info ------------------------------------------------------------

sessionInfo()

# R version 4.1.2 (2021-11-01)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 22000)
# 
# Matrix products: default
# 
# locale:
#   [1] LC_COLLATE=English_Canada.1252  LC_CTYPE=English_Canada.1252    LC_MONETARY=English_Canada.1252
# [4] LC_NUMERIC=C                    LC_TIME=English_Canada.1252    
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] forcats_0.5.1        stringr_1.4.0        dplyr_1.0.7          purrr_0.3.4         
# [5] readr_2.1.2          tidyr_1.1.4          tibble_3.1.5         ggplot2_3.3.5       
# [9] tidyverse_1.3.1      palmerpenguins_0.1.0 remotes_2.4.2       
# 
# loaded via a namespace (and not attached):
#   [1] tidyselect_1.1.1  haven_2.4.3       colorspace_2.0-2  vctrs_0.3.8       generics_0.1.1   
# [6] utf8_1.2.2        rlang_0.4.11      pkgbuild_1.3.1    pillar_1.6.4      glue_1.4.2       
# [11] withr_2.4.2       DBI_1.1.1         dbplyr_2.1.1      modelr_0.1.8      readxl_1.3.1     
# [16] lifecycle_1.0.1   munsell_0.5.0     gtable_0.3.0      cellranger_1.1.0  rvest_1.0.2      
# [21] callr_3.7.0       tzdb_0.2.0        ps_1.6.0          curl_4.3.2        fansi_0.5.0      
# [26] broom_0.7.12      Rcpp_1.0.7        backports_1.4.1   scales_1.1.1      jsonlite_1.7.2   
# [31] fs_1.5.0          hms_1.1.1         stringi_1.7.5     processx_3.5.2    rprojroot_2.0.2  
# [36] grid_4.1.2        cli_3.1.1         tools_4.1.2       magrittr_2.0.1    crayon_1.4.1     
# [41] pkgconfig_2.0.3   ellipsis_0.3.2    xml2_1.3.2        prettyunits_1.1.1 reprex_2.0.1     
# [46] lubridate_1.8.0   assertthat_0.2.1  httr_1.4.2        rstudioapi_0.13   R6_2.5.1         
# [51] compiler_4.1.2 

# Create data ---------------------------------------------------------------

data(penguins, package = "palmerpenguins")

write.csv(penguins_raw, "rawdata/penguins_raw.csv", row.names = FALSE)

write.csv(penguins,"data/penguins.csv",row.names = FALSE)

# Load Data ---------------------------------------------------------------

pen.data <- read.csv("Data/penguins.csv")

str(pen.data) # look at data types (e.g., factor, character)
colnames(pen.data) # look at the column names

# check for bullshit
head(pen.data) # first few rows of the start of the data
tail(pen.data) # last few rows at the end

# [row, column] and we want columns 3:6 and 8 which are the numeric variables
?pairs # will give you information about the function

pairs(pen.data[,c(3:6,8)]) # pairwise correlation plot of numeric columns

hist(pen.data$body_mass_g)  # make a histogram    
?hist

boxplot(pen.data$body_mass_g ~ pen.data$species) # boxplot of body mass x species
?boxplot


# Save boxplot as pdf -----------------------------------------------------

pdf("output/wt_by_spp.pdf",
    width = 7,
    height = 5) # open a graphics device (everything you print to the screen while this is open will be saved to the file name that you give here), there are analogous functions for png and other image types


boxplot(pen.data$body_mass_g ~ pen.data$species,
        xlab="Species", ylab="Body Mass (g)") # print the boxplot to the pdf file


dev.off() #close the graphics device (very important to run this line or the pdf won’t save and will continue to add new plots that you run afterwards)


# ggplot figure -----------------------------------------------------------

pen_fig <- pen.data %>% # calling on the data
  drop_na() %>%  # dropping "NAs" from the plot
  ggplot(aes(y = body_mass_g, x = sex, # aesthetic: y = body mass, x = sex
             colour = sex)) + # colour violin plots by sex
  facet_wrap(~species) + # each species will have it's own plot
  geom_violin(trim = FALSE, # violin plot, turn off trim the edges
              lwd = 1) + # make the lines thick
  theme_bw() + # black and white background theme
  theme(text = element_text(size = 12), # change the text size
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size=12),
        legend.position = "none") + # remove the legend
  labs(y = "Body Mass (g)", # specify labels on axes
       x = " ") +
  scale_colour_manual(values = c("black", "darkgrey"))

pen_fig

ggsave("output/pen_fig.jpeg", pen_fig, # save figure to output
       width = 7,
       height = 5)
