library(tidyverse)
library(lubridate)
library(fuzzyjoin)
library(caret)
library(doParallel)

base_model <- base[, c('Global_Sales','n_platforms','Genre','publisher_top','Critic_Score','User_Score','Mean_Score','Continuacao')]

base_model_scale <- base_model %>% mutate_at(c("Critic_Score", "User_Score", "Mean_Score"), scale2)

## All subsequent models are then run in parallel
train_control<- trainControl(method="repeatedcv", number=10, savePredictions = TRUE,repeats = 10)
#train_control_scale<- trainControl(method="repeatedcv", number=10, savePredictions = TRUE,repeats = 10, 
#preProc = c("scale"))

cl <- makePSOCKcluster(11)
registerDoParallel(cl)

model_rf <- train(log(Global_Sales) ~ ., data = base_model, trControl = train_control , method = "rf",
                  tuneGrid = data.frame(mtry = seq(2,7,1)))
#scale2 <- function(x, na.rm=FALSE) (as.numeric(scale(x)))
#%>% mutate_at(c("Critic_Score", "User_Score",'n_platforms'), scale2)

model_svmLinear <- train(log(Global_Sales) ~ ., 
                         data = base_model, trControl = train_control , method = "svmLinear3",
                         tuneGrid = data.frame(Loss = c(rep('L1',6),rep('L2',6)),
                                               cost = rep(seq(.01,.06,.01),2)))

model_svmLinear_scale <- train(log(Global_Sales) ~ ., 
                               data = base_model_scale , trControl = train_control , method = "svmLinear3",
                               tuneGrid = data.frame(Loss = c(rep('L1',11),rep('L2',11)),
                                                     cost = rep(seq(.15,.25,.01),2)))

model_svmPoly_scale <- train(log(Global_Sales) ~ ., 
                             data = base_model_scale , trControl = train_control , method = "svmPoly")

model_svmRadial_scale <- train(log(Global_Sales) ~ ., 
                               data = base_model_scale , trControl = train_control , method = "svmRadial",
                               tuneGrid = expand.grid(sigma = c(0.03024655),
                                                      C = c(1.9,2,2.1,2.2,2.3,2.4,2.5,2.6,2.7)))

model_nn <- train(log(Global_Sales) ~ ., data = base_model , method = "brnn")

model_boost <- train(log(Global_Sales) ~ ., data = base_model , method = "xgbTree",
                     tuneGrid = expand.grid(eta = c(0.3),
                                            max_depth = c(1),
                                            colsample_bytree = c(0.2,0.4,0.6),
                                            subsample = c(0.8),
                                            nrounds =  c(90,100,110),
                                            gamma = c(0),
                                            min_child_weight = c(0.3,0.4,0.5)))

model_lasso <- train(log(Global_Sales) ~ ., data = base_model , method = "lasso",
                     tuneGrid = expand.grid(fraction = c(0.5,0.6,0.7,0.8,0.9)))

model_linear <- train(log(Global_Sales) ~ ., data = base_model , method = "lm")

stopCluster(cl)

cl <- makePSOCKcluster(11)
registerDoParallel(cl)
modelos_comparacao = data.frame()
train_control<- trainControl(method="cv", number=10, savePredictions = TRUE)
for(i in 1:30){
  set.seed(0 + i)
  
  model_rf <- train(log(Global_Sales) ~ ., data = base_model, trControl = train_control , method = "rf",
                    tuneGrid = data.frame(mtry = 5))

  
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'RF',RMSE = model_rf$results[,c('RMSE')]))
  
  model_svmLinear <- train(log(Global_Sales) ~ ., 
                           data = base_model, trControl = train_control , method = "svmLinear3",
                           tuneGrid = data.frame(Loss = 'L2',
                                                 cost = 0.02))
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'svmLinear',RMSE = model_svmLinear$results[,c('RMSE')]))
  
  model_svmLinear_scale <- train(log(Global_Sales) ~ ., 
                                 data = base_model_scale , trControl = train_control , method = "svmLinear3",
                                 tuneGrid = data.frame(Loss = 'L2',
                                                       cost = 0.18))
  
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'svmLinear_scale',RMSE = model_svmLinear_scale$results[,c('RMSE')]))
  
  model_svmPoly_scale <- train(log(Global_Sales) ~ ., 
                               data = base_model_scale , trControl = train_control , method = "svmPoly",
                               tuneGrid = expand.grid(degree = c(3),
                                                      scale = c(0.1),
                                                      C = c(1)))
  
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'svmPoly_scale',RMSE = model_svmPoly_scale$results[,c('RMSE')]))
  
  model_svmRadial_scale <- train(log(Global_Sales) ~ ., 
                                 data = base_model_scale , trControl = train_control , method = "svmRadial",
                                 tuneGrid = expand.grid(sigma = c(0.03024655),
                                                        C = c(2.6)))
  
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'svmRadial_scale',RMSE = model_svmRadial_scale$results[,c('RMSE')]))
  
  model_nn <- train(log(Global_Sales) ~ ., data = base_model , method = "brnn",
                    tuneGrid = data.frame(neurons = 1))
  
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'nn',RMSE = model_nn$results[,c('RMSE')]))
  
  model_boost <- train(log(Global_Sales) ~ ., data = base_model , method = "xgbTree",
                       tuneGrid = expand.grid(eta = c(0.2),
                                              max_depth = c(1),
                                              colsample_bytree = c(0.4),
                                              subsample = c(0.8),
                                              nrounds =  c(110),
                                              gamma = c(0),
                                              min_child_weight = c(0.4)))
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'boost',RMSE = model_boost$results[,c('RMSE')]))
  
  model_lasso <- train(log(Global_Sales) ~ ., data = base_model , method = "lasso",
                       tuneGrid = expand.grid(fraction = c(0.7)))
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'lasso',RMSE = model_lasso$results[,c('RMSE')]))
  
  model_linear <- train(log(Global_Sales) ~ ., data = base_model , method = "lm")
  modelos_comparacao = rbind(modelos_comparacao, data.frame(seed = i,modelo = 'linear',RMSE = model_linear$results[,c('RMSE')]))
  
}
stopCluster(cl)


library(rstatix)
library(ggpubr)

modelos_comparacao = modelos_comparacao %>% mutate(seed = factor(seed), modelo = factor(modelo))

res.fried <- friedman_test(data=modelos_comparacao,RMSE ~ modelo | seed)
res.fried

pwc <- modelos_comparacao %>%
  wilcox_test(RMSE ~ modelo, p.adjust.method = "bonferroni",paired = FALSE)
pwc

pwc <- pwc %>% add_xy_position(x = "modelo")

ggboxplot(modelos_comparacao, x = "modelo", y = "RMSE", add = "point") +
  stat_pvalue_manual(pwc, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.fried,  detailed = TRUE),
    caption = get_pwc_label(pwc)
  )


modelos_comparacao_top_real = modelos_comparacao %>% 
  reshape2::dcast(seed ~ modelo, value.var = 'RMSE')

tsutils::nemenyi(as.matrix(modelos_comparacao_top_real[,-1]), conf.level = .95,plottype = 'vline')

friedman.test(as.matrix(modelos_comparacao_top_real[,-1]))


#ggplot(model_rf$results) + geom_line(aes(x = mtry, y = RMSE), size = 1.5)+  theme_minimal()
#ggsave("plots/model_rf.png", width = 8, height = 4, dpi=600)

#ggplot(model_svmLinear$results) + geom_line(aes(x = cost, y = RMSE, color = Loss), size = 1.5)+  theme_minimal()
#ggsave("plots/model_svmLinear.png", width = 8, height = 4, dpi=600)

#ggplot(model_svmLinear_scale$results) + geom_line(aes(x = cost, y = RMSE, color = Loss), size = 1.5)+  theme_minimal()
#ggsave("plots/model_svmLinear_scale.png", width = 8, height = 4, dpi=600)

#ggplot(model_nn$results) + geom_line(aes(x = neurons, y = RMSE), size = 1.5)+  theme_minimal()
#ggsave("plots/model_nn.png", width = 8, height = 4, dpi=600)

#ggplot(model_boost$results %>% mutate(min_child_weight = factor(min_child_weight),
#                                      colsample_bytree = factor(colsample_bytree))) + geom_line(aes(x = nrounds, y = RMSE, color = min_child_weight,linetype = colsample_bytree),size = 1.5) +  
#  theme_minimal() + theme(legend.position = 'top')+
#  scale_linetype_manual(values=c("solid","dashed", "dotted"))
#ggsave("plots/model_boost.png", width = 8, height = 4, dpi=600)


saveRDS(model_svmLinear_scale, 'modelo')
saveRDS(base_model, 'dados')

svmLinear_ex = DALEX::explain(model_svmLinear_scale, label = "svmLinear", data = base_model_scale, y = log(base_model_scale$Global_Sales))
library(auditor)
mr = model_residual(svmLinear_ex)
plot( mr, type = "prediction", abline = TRUE)
plot( mr, variable = "Critic_Score", type = "prediction", abline = TRUE)
plot( mr, variable = "User_Score", type = "prediction", abline = TRUE)
plot(mr, type = "residual")
plot(mr, type = "residual_density")
plot(mr, type = "residual_boxplot")
cook = model_cooksdistance(svmLinear_ex)
plot_cooksdistance(cook)
plot_correlation(mr)
mean(mr$`_residuals_`)
sd(mr$`_residuals_`)
shapiro.test(mr$`_residuals_`)
