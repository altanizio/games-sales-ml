# Games sales - ML
## Análise da venda global de jogos com uso de Machine Learning

<img src="https://img.shields.io/badge/R-4.0.4-blue?style=flat-square&logo=appveyor"/> <img src="https://img.shields.io/badge/license-MIT-yellow?style=flat-square&logo=appveyor"/>

Sumário
=================
<!--ts-->
   * [Sobre](#sobre)
   * [Análise exploratória](#análise-exploratória)
      * [Global_Sales](#Global_Sales)
      * [Critic_Score](#Critic_Score)
      * [User_Score](#User_Score)
      * [Genre](#Genre)
      * [Publisher](#Publisher)
      * [Continuacao](#Continuacao)
      * [n_platforms](#n_platforms)
   * [Criação dos modelos](#criação-dos-modelos)
   * [Escolha do modelo final](#escolha-do-modelo-final)
   * [Deploy do modelo](#Deploy-do-modelo)
   * [Fonte dos dados](#Fonte-dos-dados)
<!--te-->

Sobre
======
O presente trabalho tem o objetivo de desenvolver modelos de Machine Lerning (ML) com os dados de vendas de jogos eletrônicos de 2013 a 2017 (oitava geração de consoles). 
Este trabalho é fundamentalmente para a prática de ML do autor, como forma de portfólio.

- Este README.md é um resumo, para ver todos os passos acessar os <a href = 'https://github.com/altanizio/games-sales-ml/tree/main/scripts'>scripts do R</a> ou no <a href = 'https://www.kaggle.com/franciscoaltanizio/predicting-video-games-global-sales-with-r'>kaggle</a>. 


Análise exploratória
=====================
O primeiro passo foi a consolidação dos dados. Primeiramente modificando variáveis e realizando a criação de outras. Foi realizado um agrupamento dos jogos de diferentes plataformas, somando as vendas e tirando a média das notas da crítica e dos usuários.

Variáveis criadas:
- Número de plataformas
- Média das notas da crítica e usuários
- Verificar se o jogo é uma continuação (Fazendo uma verificação das strings, jogos com nomes iniciais repetidos e terminando com números (1-9,IVXLCM))
- Plataformas lançadas (PS4, XOne, PC, Wiiu, 3DS|PSV)
- Melhores publicadora (as 10 publicadoras com as maiores vendas por número de jogos publicados)

Global_Sales
-------------
Vendas Globais (Shipped)

global_sales bruto            |  global_sales aplicado um logarítimo natural
:-------------------------:|:-------------------------:
![](plots/global_sales.jpg?raw=true)  |  ![](plots/global_sales_ln.jpg?raw=true)
Shapiro-test: p-value < 2.2e-16  |  Shapiro-test: p-value = 6.071e-06

Ao aplicar a função log() no Global_Sales observa-se uma maior aproximação para uma distribuição normal, apesar de não haver evidências (p-value < 0,05). Observa-se diversos outliers pelo boxplot, representando os jogos que venderam fora do normal, em especial o outlier do segundo gráfico, sendo o GTA V com 57.75 milhões de cópias enviadas (shipped).

Critic_Score
-------------
Nota média da crítica (metracritic)

Relação da nota da crítica com o ln(Global_Sales)
![](plots/scarter_critic_sales.png?raw=true)  
Corr: 0.4 (p-value < 2.2e-16); tendência: Local Polynomial Regression Fitting (loess)

Observa-se que quando ocorre um aumento da nota média da crítica as vendas tendem a aumentar na média. Alertando que correlação não significa uma relação de causa e efeito.

User_Score
-------------
Nota média dos usuários (metracritic)

Relação da nota média dos usuários com o ln(Global_Sales)
![](plots/scarter_user_sales.png?raw=true)  
Corr: 0.01 (p-value = 0.7349); tendência: Local Polynomial Regression Fitting (loess)

Não existe evidências que existe uma relação linear entre a nota média dos usuários e o número de vendas.

Genre
-------------
Gênero do jogo

Gráfico - 1
![](plots/bar_genero_sales.png?raw=true)  

Gráfico - 2
![](plots/bar_genero_critic.png?raw=true)

O gráfico 1 não representa o total de vendas. Representa o total de vendas dividido pelo total de jogos daquele gênero.

O gráfico 1 demonstra que jogos de tiro (shooters) são mais eficientes na venda, ou seja, esse gênero tem uma maior probabilidade de vender melhor em média.

O gráfico 2 demonstra que não existe evidências de uma diferença significativa entre a nota média dos gêneros dos jogos.

Publisher
-------------
Publicadora do jogo

![](plots/bar_Publisher_sales.png?raw=true)  

O gráfico demonstra que a publicadora Take-Two Interactive é a mais eficiente, vendendo mais por jogo lançado.

Continuacao
-------------
Se o jogo é uma continuação de outro jogo

![](plots/bar_Continuacao_sales.png?raw=true)  

O gráfico demonstra que jogos que são continuação são mais eficientes nas vendas.

n_platforms
-------------
Número de plataformas que o jogo foi lançado

![](plots/bar_n_platforms_sales.png?raw=true)  

Logicamente, observa-se que quanto mais plataformas maior vai ser o número de vendas.

Criação dos modelos
====================

Os modelos escolhidos para o treinamento foram os descritos a seguir. Os processos foram realizados utilizando cros-validation, testando com k = 5 e k = 10. Os resultados com k = 10 foram mais promissores utilizando de 10 repetições, ou seja, 100 testes por modelo para a otimização dos hiperparâmetros.

A métrica alvo escolhida foi o RMSE (root mean squared error), representando a raiz quadrática média:

![equation](https://latex.codecogs.com/png.latex?%5Cdpi%7B120%7D%20%5Cbg_white%20RMSEA%20%3D%20%5Csqrt%7B%5Cfrac%7B1%7D%7Bn%7D%5Csum_%7Bn%7D%5E%7Bj%20%3D%201%7D%28y_%7Bj%7D%20-%20%5Chat%7By%7D_%7Bj%7D%29%5E2%7D)

<!--  RMSEA = \sqrt{\frac{1}{n}\sum_{n}^{j = 1}(y_{j} - \hat{y}_{j})^2} -->

Os modelos escolhidos para a regressão foram: Random Forest, Support Vector Machine (linear, polinomial e radial), Bayesian Regularized Neural Networks, eXtreme Gradient Boosting, lasso e regressão linear múltipla.

Alguns dos modelos estão descritos abaixo, para a verificação de todos checar o arquivo r.

Observou-se que os modelos utilizando o ln da variável dependente apresentaram melhores resultados, por isso optou-se a continuar com essa abordagem.

Random Florest
---------------

O parâmetro otimizado desse modelo foi:

- mtry: Número de variáveis escolhidas randomicamente para compor a amostra em cada divisão.

![](plots/model_rf.png?raw=true) 

mtry = 5 foi o melhor resultado.

SVRLinear
---------------
L2-regularized L1-loss or L2-loss support vector regression (dual)

Os parâmetros otimizados desse modelo foram:

- Loss: L1 Loss function stands for Least Absolute Deviations; L2 Loss function stands for Least Square Errors.
- cost

O modelo foi testado com as variáveis preditoras padronizadas e não padronizadas.

Não padronizado            |  Padronizado
:-------------------------:|:-------------------------:
![](plots/model_svmLinear.png?raw=true) |  ![](plots/model_svmLinear_scale.png?raw=true) 


Observa-se que o SVR com valores padronizados apresentou melhores resultados, demonstrando a importância desse processo com as variáveis para esse tipo de modelo.

Boosting 
---------------
eXtreme Gradient Boosting 

Existem diversos parâmetros de otimização: eta,max_depth, colsample_bytree, subsample, nrounds, gamma e min_child_weight.
Foram testado diversos cenários, alguns estão visíveis no gráfico abaixo.

![](plots/model_boost.png?raw=true)

Escolha do modelo final
========================

Após a calibração dos modelos foi feito a comparação com k = 5 e k = 10 com 30 repetições.

Os modelos foram comparados através de dois testes: wilcox e nemenyi

k            |  wilcox 
:-------------------------:|:-------------------------:
5 |  ![](plots/modelos_comparacao_wilcox.png?raw=true) 
10 |  ![](plots/modelos_comparacao_wilcox_10.png?raw=true)

k            |  nemenyi
:-------------------------:|:-------------------------:
5 | ![](plots/modelos_comparacao_friedman.png?raw=true) 
10 | ![](plots/modelos_comparacao_friedman_10.png?raw=true) 

Em todos os cenários o modelo svmLinear apresentou melhores resultados sendo comparado com o Lasso (k = 5) e radial (k = 10).

O modelo final portanto foi o svmLinear(Loss = 'L2', cost = 0.18) com as variáveis independentes padronizadas.

Resíduos            |  Distribuição
:-------------------------:|:-:
![](plots/Residuals.png?raw=true)  |  ![](plots/Residuals_dist.png?raw=true) 
Média = 0,009; Desvio Padrão = 1,164  |  Shapiro-Wilk, p-valor = 0,0002

A análise gráfica dos resíduos demonstra uma não homogeneidade dos resíduos. Podendo haver influências externas não medidas que explicam o valor das vendas.

Apesar da limitação esse modelo é o melhor dos testados. Pode-se ainda excluir outliers e modificar variáveis para possivelmente obter melhores resultados. 
Porém optou-se a não excluir os outliers, pois esses podem ser um importante valor para prever o número de vendas de jogos "blockbusters" e não representam algum tipo de erro dos dados.

Deploy do modelo
====================

O modelo final escolhido foi o SVMLinear adaptado para regressão (SVR), com L2 e cost 0,18. Foi criado uma aplicação para prever valores futuros apresentado abaixo.

![](plots/deploy.JPG?raw=true) 

link: https://altanizio.shinyapps.io/ML_games_sales

Nessa aplicação é possível comparar diferentes configurações de jogos para prever o valor de vendas globais. Observa-se que ao aumentar a nota da crítica as vendas sobem, o que foi observado também na análise exploratória. Já as notas dos usuários diminuem as vendas, o que pode ser algo que o modelo realiza para prever melhor as notas, visto que este é um modelo de "caixa preta" e não temos conhecimento mais profundo sobre as influências das variáveis exógenas no modelo.

Fonte dos dados
====================

Games Sales. https://raw.githubusercontent.com/810Teams/video-game-sales/master/vgsales.csv

