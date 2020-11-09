library(rvest)
library(purrr)
library(stringr)
library(tibble)

scrape_friends <- function(season_number){
  
  url <- "https://www.imdb.com/title/tt0108778/episodes?season="
  
  page <- str_c(url, season_number, sep = "") %>% 
    read_html()
  
  description <-
    page %>% 
    html_nodes(".item_description") %>% 
    html_text() %>% 
    str_remove_all("\n")
  
  rating <- 
    page %>% 
    html_nodes(".ipl-rating-widget > .ipl-rating-star .ipl-rating-star__rating") %>% 
    html_text() %>% 
    as.numeric()
  
  title <- page %>% 
    html_nodes("#episodes_content strong a") %>% 
    html_text() 
  
  tibble(season = season_number,
         episode = 1:length(description),
         title = title,
         description = description,
         rating = rating,
         
  )           
}


all_friends <- map_df(1:10, scrape_friends)

write_csv(all_friends, here::here("slides/data/friends.csv"))




