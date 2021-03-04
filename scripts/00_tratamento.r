library(tidyverse)
library(lubridate)

addline_format <- function(x,...){
  gsub('\\s','\n',x)
}


sales_full <-  read_csv('vgsales_full.csv') # https://raw.githubusercontent.com/810Teams/video-game-sales/master/vgsales.csv

sales_full <- sales_full %>% mutate(User_Score = User_Score*10)

sales_full <-  sales_full %>% select(Name, Platform, Year, Genre, Publisher, Global_Sales,  
                                     Critic_Score, Critic_Count, User_Score, User_Count) %>% filter_all(~!is.na(.))

base  <-  sales_full %>% group_by(Name) %>% summarise(Plataformas = paste0(Platform, collapse = "/"),
                                                      n_platforms = n(),
                                                      date = min(Year),
                                                      Genre = first(Genre),
                                                      Publisher = first(Publisher),
                                                      Global_Sales = sum(Global_Sales),
                                                      Critic_Score = mean(Critic_Score),
                                                      Critic_Count = max(Critic_Count),
                                                      User_Score = mean(User_Score),
                                                      User_Count = max(User_Count))

base  <-  base %>% filter(date >= 2013)

games_names <- c(base$Name)

games_names_split <- strsplit(games_names, " ")

repet_names <- c()
for(i in 1:length(games_names_split)){
  repet_names[i] <- paste(games_names_split[[i]][1],games_names_split[[i]][2])
  
}
repet_names <- repet_names[duplicated(repet_names)]

delete_list  <-  c('7 Days to Die', 'Code Name: S.T.E.A.M.','Mighty No. 9',"Devil May Cry",'Fairy Fencer F')

base  <-  base %>% mutate( Continuacao = case_when(Name %in% delete_list ~ '0',
                                                   str_detect(Name, '\\d') == TRUE ~ '1',
                                                   str_detect(Name, "^([0-9]+)|([IVXLCM]+)\\.?$") == TRUE ~ '1',
                                                   str_detect(Name, paste0("\\b(", paste(repet_names, collapse=" |"), ")\\b")) == TRUE ~ '1',
                                                   TRUE ~ '0'))

base  <-  base %>% mutate( PS4 = case_when(str_detect(Plataformas, 'PS4') == TRUE ~ '1', TRUE ~ '0'),
                           XOne = case_when(str_detect(Plataformas, 'XOne') == TRUE ~ '1', TRUE ~ '0'),
                           PC = case_when(str_detect(Plataformas, 'PC') == TRUE ~ '1', TRUE ~ '0'),
                           WiiU = case_when(str_detect(Plataformas, 'WiiU') == TRUE ~ '1', TRUE ~ '0'),
                           PORT = case_when(str_detect(Plataformas, '3DS|PSV') == TRUE ~ '1', TRUE ~ '0'))


publisher_top  <-  (base %>% group_by(Publisher) %>% summarise(
  Global_Sales = sum(Global_Sales) / n()
) %>%
  arrange(desc(Global_Sales)) %>%  top_n(10) %>% distinct(Publisher))$Publisher


base  <-  base %>% mutate(publisher_top = case_when(Publisher %in% publisher_top ~ as.character(Publisher),
                                                    TRUE ~ 'Outro'))


base <- base %>% mutate(n_platforms = case_when(n_platforms == 1 ~ '1',
                                               n_platforms == 2 ~ '2',
                                               n_platforms == 3 ~ '3',
                                               TRUE ~ '3>')) %>% 
  mutate(n_platforms = factor(n_platforms, levels = c('1','2','3','3>'), ordered = T))

PS4 <- (base %>% group_by(PS4) %>% summarise(
  score = mean(Critic_Score),
  Global_Sales = sum(Global_Sales) / n()
))[2,]

PS4[1,1] = 'PS4'
colnames(PS4)[1] = 'Plataforma'

XOne <- (base %>% group_by(XOne) %>% summarise(
  score = mean(Critic_Score),
  Global_Sales = sum(Global_Sales) / n()
))[2,]
XOne[1,1] = 'XOne'
colnames(XOne)[1] = 'Plataforma'

PC <- (base %>% group_by(PC) %>% summarise(
  score = mean(Critic_Score),
  Global_Sales = sum(Global_Sales) / n()
))[2,]
PC[1,1] = 'PC'
colnames(PC)[1] = 'Plataforma'

WiiU <- (base %>% group_by(WiiU) %>% summarise(
  score = mean(Critic_Score),
  Global_Sales = sum(Global_Sales) / n()
))[2,]
WiiU[1,1] = 'WiiU'
colnames(WiiU)[1] = 'Plataforma'

PORT <- (base %>% group_by(PORT) %>% summarise(
  score = mean(Critic_Score),
  Global_Sales = sum(Global_Sales) / n()
))[2,]
PORT[1,1] = 'Portátil'
colnames(PORT)[1] = 'Plataforma'

base <-  base %>% mutate(Mean_Score = (Critic_Score + User_Score)/2)