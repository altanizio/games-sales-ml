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
O presente trabalho tem o objetivo de desenvolver modelos de machine lerning (ML) com os dados de vendas de jogos eletrônicos de 2013 a 2017. 
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
global_sales bruto
<img src="plots/global_sales.jpg?raw=true" alt="drawing" width="50%"/>
global_sales aplicado um logarítimo natural
<img src="plots/global_sales_ln.jpg?raw=true" alt="drawing" width="50%"/>

Criação dos modelos
====================


Escolha do modelo final
========================


Pre Requisitos
---------------