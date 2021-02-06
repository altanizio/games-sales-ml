# Games sales - ML
## Análise da venda global de jogos com uso de Machine Learning

<img src="https://img.shields.io/badge/R-markdown-blue?style=flat-square&logo=appveyor"/> <img src="https://img.shields.io/badge/license-MIT-yellow?style=flat-square&logo=appveyor"/>

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
   * [Dados para a aprendizagem](#criação-dos-modelos)
   * [Escolha do modelo final](#escolha-do-modelo-final)
      * [Pre Requisitos](#pre-requisitos)
      * [Local files](#local-files)
      * [Remote files](#remote-files)
      * [Multiple files](#multiple-files)
      * [Combo](#combo)
   * [Resultados](#testes)
   * [Fontes e referências](#tecnologias)
<!--te-->

Sobre
======
O presente trabalho tem o objetivo de desenvolver modelos de machine lerning (ML) com os dados de vendas de jogos eletrônicos de 2013 a 2017 (oitava geração de consoles). 
Este trabalho é fundamentalmente para a prática de ML do autor, como forma de portfólio.

- Este README.md é um resumo, para ver todos os passos acessar o Relatório criado no Rmarkdown: 


Análise exploratória
=====================
O primeiro passo foi a consolidação do banco. Primeiramente arrumando variáveis e criando outras. Foi realizado um agrupamento dos jogos de diferentes plataformas, somando as vendas e tirando a média das notas da crítica e usuários.

Variáveis criadas:
- Número de plataformas
- Média das notas da crítica e usuários
- Verificar se o jogo é uma continuação (Fazendo uma verificação das strings, jogos com nomes iniciais repetidos e terminando com números (1-9,IVXLCM))
- Plataformas lançadas (PS4, XOne, PC, Wiiu, 3DS|PSV)
- Melhores publicadora (as 10 publicadoras com a maior vendas por número de jogos)

Global_Sales
-------------
Vendas Globais (Shipped)

global_sales bruto            |  global_sales aplicado um logarítimo natural
:-------------------------:|:-------------------------:
![](plots/global_sales.jpg?raw=true)  |  ![](plots/global_sales_ln.jpg?raw=true)
Shapiro-test: p-value < 2.2e-16  |  Shapiro-test: p-value = 6.071e-06

Ao aplicar a função log() no Global_Sales observa-se uma maior aproximação para uma distribuição normal, apesar de não ter evidências (p-value < 0,05). Observa-se diversos outliers pelo boxplot representando jogos que vendem fora do comum, em especial o outlier do segundo gráfico, o qual é o GTA V com 57.75 milhoes de cópias enviadas (shipped).

Critic_Score
-------------
Nota média da crítica (metracritic)

Relação da nota da crítica com o ln(Global_Sales)
![](plots/scarter_critic_sales.png?raw=true)  
Corr: 0.4 (p-value < 2.2e-16); tendência: Local Polynomial Regression Fitting (loess)

Observa-se que quando ocorre um aumento da nota média da crítica as vendas tendem a aumentar em média.

User_Score
-------------
Nota média dos usuários (metracritic)

Relação da nota média dos usuários com o ln(Global_Sales)
![](plots/scarter_user_sales.png?raw=true)  
Corr: 0.01 (p-value = 0.7349); tendência: Local Polynomial Regression Fitting (loess)

Não há evidências que existe uma relação entre a nota média dos usuários e o número de vendas.

Genre
-------------
Gênero do jogo

Gráfico - 1
![](plots/bar_genero_sales.png?raw=true)  

Gráfico - 2
![](plots/bar_genero_critic.png?raw=true)

O gráfico 1 não é o total de vendas. É o total de vendas dividido pelo total de jogos daquele gênero.

O gráfico 1 demonstra que jogos de tiro (shooter) são mais eficientes na venda em média, ou seja, esse gênero tem uma maior probabilidade de vender melhor.

O gráfico 2 demonstra não existir uma diferença significativa entre a nota média dos gêneros.

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

Logicamente observa-se que quanto mais plataformas maior vai ser o número de vendas.

Criação dos modelos
====================

Os modelos escolhidos para o treinamento foram quatro descritos a seguir. Os processos foram realizados utilizando cros-validation, testando com k = 5 e k = 10. Os resultados com k = 10 foram mais promissores utilizando de 10 repetições, ou seja, 100 testes por modelo para a otimização dos parâmetros.

A métrica alvo escolhida foi o RMSE (root mean squared error), representando a raiz quadrática média:

![equation](https://latex.codecogs.com/png.latex?RMSEA%20%3D%20%5Csqrt%7B%5Cfrac%7B1%7D%7Bn%7D%5Csum_%7Bn%7D%5E%7Bj%20%3D%201%7D%28y_%7Bj%7D%20-%20%5Chat%7By%7D_%7Bj%7D%29%5E2%7D)

<!--  RMSEA = \sqrt{\frac{1}{n}\sum_{n}^{j = 1}(y_{j} - \hat{y}_{j})^2} -->

Random Florest
-------------

O parâmetro ajudato desse modelo é:

- mtry: Número de variáveis escolhidas randomicamente para compor a amostra em cada divisão.

![](plots/model_rf.png?raw=true) 

mtry = 5 foi o melhor resultado


Escolha do modelo final
========================


Pre Requisitos
---------------