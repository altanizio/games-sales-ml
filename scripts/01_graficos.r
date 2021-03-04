library(tidyverse)

DescTools::Desc(base[, c('Global_Sales','n_platforms','Genre','Publisher','Critic_Score','User_Score','Continuacao','PS4','XOne','PC','WiiU','PORT')])

DescTools::Desc((base[, c('Global_Sales')]))
DescTools::Desc(log(base[, c('Global_Sales')]))
DescTools::Desc(sqrt(base[, c('Global_Sales')]))
DescTools::Desc(as.numeric(scale(base$'Global_Sales')))

shapiro.test((base$Global_Sales))
shapiro.test(log(base$Global_Sales))

base[, c('Global_Sales','n_platforms','Genre','publisher_top','Critic_Score','User_Score','Continuacao','PS4','XOne','PC','WiiU','PORT')]

ggplot(base,aes(x = Critic_Score, y = log(Global_Sales))) + geom_point() + geom_smooth(method ="loess") +
  xlab('Nota da crítica') + ylab('Vendas global ln(milhoes)') +  theme_minimal() 
#ggsave("plots/scarter_critic_sales.png", width = 8, height = 4, dpi=600)
cor.test(base$Critic_Score,base$Global_Sales)
cor.test(base$Critic_Score,log(base$Global_Sales))

ggplot(base,aes(x = User_Score, y = log(Global_Sales))) + geom_point() + geom_smooth(method ="loess") +
  xlab('Nota do usuário') + ylab('Vendas global ln(milhoes)') +  theme_minimal()
#ggsave("plots/scarter_user_sales.png", width = 8, height = 4, dpi=600)
cor.test(base$User_Score,base$Global_Sales)
cor.test(base$User_Score,log(base$Global_Sales))

ggplot(base,aes(x = Mean_Score, y = log(Global_Sales))) + geom_point() + geom_smooth(method ="loess") +
  xlab('Nota média') + ylab('Vendas global ln(milhoes)') +  theme_minimal()
#ggsave("plots/scarter_user_sales.png", width = 8, height = 4, dpi=600)
cor.test(base$Mean_Score,base$Global_Sales)
cor.test(base$Mean_Score,log(base$Global_Sales))

base %>% group_by(Genre) %>% summarise(Global_Sales = sum(Global_Sales)/n()) %>%
  ggplot(aes(x = (reorder(addline_format(Genre),-Global_Sales)), y = Global_Sales, fill = Genre)) + geom_col() +  theme_minimal() +
  xlab('Gênero do jogo') + ggtitle('Vendas global (milhões) por número total de jogos') + ylab('') + theme(legend.position = '')  +
  scale_fill_viridis_d(option = "magma",direction = 1)
#  geom_text(aes(x = (reorder(addline_format(Genre),-Global_Sales)), y = Global_Sales,label= round(Global_Sales,2)), position= position_stack(vjust=0.5), color = "steelblue")
#ggsave("plots/bar_genero_sales.png", width = 10, height = 4, dpi=600)



base %>% group_by(Genre) %>% summarise(score = mean(Critic_Score), superior = t.test(Critic_Score)$conf.int[1], inferior = t.test(Critic_Score)$conf.int[2]) %>%
  ggplot(aes(x = (reorder(addline_format(Genre),-score)), y = score, fill = Genre)) + geom_col() +  theme_minimal() +
  xlab('Gênero do jogo') + ylab('Nota média da crítica') + theme(legend.position = '')+
  scale_fill_viridis_d(option = "magma",direction = 1)+
  #geom_text(aes(x = (reorder(addline_format(Genre),-score)), y = score,label= round(score,1)), position= position_stack(vjust=0.5), color = "steelblue")+
  geom_errorbar(
    aes(x=(reorder(addline_format(Genre),-score)), 
        ymin = inferior, 
        ymax = superior), 
    color = "black", width = 0.5, alpha = 0.7
  ) 
#ggsave("plots/bar_genero_critic.png", width = 10, height = 4, dpi=600)


base %>% group_by(Publisher) %>% summarise(
  Global_Sales = sum(Global_Sales)/ n()
) %>%
  arrange(desc(Global_Sales)) %>%  top_n(15) %>%
  ggplot(aes(x = (reorder(addline_format(Publisher),-Global_Sales)), y = Global_Sales)) + geom_col(fill = 'steelblue') +  theme_minimal() +
  xlab('Publicadora do jogo') + ggtitle('Vendas global (milhões) por número total de jogos') + ylab('') + theme(legend.position = '')  +
  scale_fill_viridis_d(option = "magma",direction = 1)+
  geom_text(aes(x = (reorder(addline_format(Publisher),-Global_Sales)), y = Global_Sales,label= round(Global_Sales,2)), position= position_stack(vjust=0.5), color = "white")
#ggsave("plots/bar_Publisher_sales.png", width = 14, height = 6, dpi=600)

base %>% group_by(Continuacao) %>% summarise(
  Global_Sales = sum(Global_Sales) / n()
) %>%
  ggplot(aes(x = (reorder(addline_format(Continuacao),-Global_Sales)), y = Global_Sales)) + geom_col(fill = 'steelblue') + 
  theme_minimal() + scale_x_discrete(name = '', labels = c('Continuação','Não')) +  theme_minimal() +
  ggtitle('Vendas global (milhões) por número total de jogos') + ylab('') + theme(legend.position = '')  +
  #scale_fill_viridis_d(option = "plasma",direction = 1)+
  geom_text(aes(color = Continuacao,x = (reorder(addline_format(Continuacao),-Global_Sales)), y = Global_Sales,label= round(Global_Sales,2)),color = 'white', position= position_stack(vjust=0.5))
#scale_colour_viridis_d(option = "plasma",direction = -1)
#ggsave("plots/bar_Continuacao_sales.png", width = 6, height = 4, dpi=600)


base %>% group_by(n_platforms) %>% summarise(
  Global_Sales = sum(Global_Sales) / n()
) %>%
  ggplot(aes(x = (reorder(addline_format(n_platforms),-Global_Sales)), y = Global_Sales)) + geom_col(fill = 'steelblue') + 
  theme_minimal() +  theme_minimal() +
  ggtitle('Vendas global (milhões) por número total de jogos') + ylab('') + theme(legend.position = '')  +
  #scale_fill_viridis_d(option = "plasma",direction = 1)+
  geom_text(aes(color = n_platforms,x = (reorder(addline_format(n_platforms),-Global_Sales)), y = Global_Sales,label= round(Global_Sales,2)),color = 'white', position= position_stack(vjust=0.5))+
  #scale_colour_viridis_d(option = "plasma",direction = -1) + 
  xlab('')
#ggsave("plots/bar_n_platforms_sales.png", width = 6, height = 4, dpi=600)



bind_rows(PS4, XOne, PC, WiiU, PORT) %>%
  ggplot(aes(x = (reorder(addline_format(Plataforma),-Global_Sales)), y = Global_Sales)) + geom_col(fill = 'steelblue') +  theme_minimal() +
  xlab('Plataforma') + ggtitle('Vendas global (milhões) por número total de jogos') + ylab('') + theme(legend.position = '')  +
  geom_text(aes(x = (reorder(addline_format(Plataforma),-Global_Sales)), y = Global_Sales,label= round(Global_Sales,2)), position= position_stack(vjust=0.5), color = "white")
#ggsave("plots/bar_Plataforma_sales.png", width = 6, height = 4, dpi=600)


bind_rows(PS4, XOne, PC, WiiU, PORT) %>%
  ggplot(aes(x = (reorder(addline_format(Plataforma),-score)), y = score)) + geom_col(fill = 'steelblue') +  theme_minimal() +
  xlab('Plataforma') + ylab('Nota média da crítica') + theme(legend.position = '')+
  scale_fill_viridis_d(option = "magma",direction = 1)+
  geom_text(aes(x = (reorder(addline_format(Plataforma),-score)), y = score,label= round(score,1)), position= position_stack(vjust=0.5), color = "white")
#ggsave("plots/bar_Plataforma_critica.png", width = 6, height = 4, dpi=600)
