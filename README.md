# Games sales - ML
## Análise da venda global de jogos com uso de Machine Learning

<img src="https://img.shields.io/badge/R-markdown-blue?style=flat-square&logo=appveyor"/>
<img src="https://img.shields.io/badge/license-MIT-yellow?style=flat-square&logo=appveyor"/>

Sumário
=================
<!--ts-->
   * [Sobre](#sobre)
   * [Análise exploratória](#análise-exploratória)
      * [Global_Sales](#Global_Sales)
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



Criação dos modelos
====================


Escolha do modelo final
========================


Pre Requisitos
---------------