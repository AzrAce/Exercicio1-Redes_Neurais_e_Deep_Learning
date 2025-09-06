# Exercicio1-Redes_Neurais_e_Deep_Learning

Este repositório contém a resolução do exercício 1.

O projeto foi desenvolvido inteiramente em **R**, sem o uso de pacotes externos para as funcionalidades principais de machine learning, como PCA ou geração de dados multivariados.

---

## Exercício 1: Dados Gaussianos Sintéticos e Fronteiras de Decisão

### 1. Abordagem

A abordagem para o exercício consistiu em:
1.  Gerar 400 pontos de dados (100 por classe) em um espaço 2D, utilizando uma distribuição Gaussiana com os parâmetros de média e desvio padrão especificados.
2.  Visualizar os dados em um gráfico de dispersão, utilizando cores distintas para cada classe.
3.  Desenhar fronteiras de decisão lineares que um modelo simples, como um Perceptron de camada única, poderia aprender para classificar esses dados.

### 2. Código e Plot(s)
O código R completo e comentado, bem como o(s) plot(s) estão disponíveís na pasta `/Exercicio_1`.

### 3. Análise e Respostas

#### Análise da Distribuição e Sobreposição das Classes
O gráfico de dispersão revela que cada classe forma uma nuvem de pontos elíptica, conforme o esperado de uma distribuição Gaussiana. A **Classe 0** e a **Classe 1** são alongadas na vertical, enquanto a **Classe 2** é aproximadamente circular. A **Classe 3** é notavelmente estreita na horizontal. Existe uma **sobreposição significativa** entre a Classe 0 e a Classe 1, e uma sobreposição menor entre a Classe 1 e a Classe 2. A Classe 3, no entanto, está bem separada das demais.

#### Análise da Separabilidade Linear
O conjunto de dados **não pode** ser separado por um único e simples limite linear. É impossível traçar uma única linha reta que separe perfeitamente todas as quatro classes sem cometer erros.

#### Justificativa das Fronteiras de Decisão (Contexto de um Perceptron)
Entretanto, foi possível desenhar fronteiras de decisão lineares que representem o que um **Perceptron** poderia aprender. Utilizando uma estratégia **(One-vs-Rest)**, o sistema treinaria um classificador linear para cada classe. A fronteira final é o resultado da "competição" entre esses classificadores. A linha vertical que isola a Classe 3 é uma fronteira ótima, pois este subproblema é linearmente separável. As linhas que se encontram no centro formam uma partição que busca minimizar os erros na região de sobreposição das Classes 0, 1 e 2, criando regiões de decisão convexas e lineares por partes.

---

## Exercício 2: Dados 5D, PCA e Separabilidade Não-Linear

### 1. Abordagem

Este exercício introduziu o desafio de trabalhar com dados de alta dimensionalidade. A abordagem foi:
1.  Gerar dois conjuntos de dados de 500 amostras cada (Classe A e Classe B) a partir de distribuições normais multivariadas de 5 dimensões. Para isso, foi implementado um método manual utilizando apenas funções do Base R.
2.  Aplicar a técnica de **PCA** para reduzir a dimensionalidade dos dados de 5D para 2D. O PCA também foi implementado manualmente, calculando a matriz de covariância e seus autovetores.
3.  Projetar os dados nos dois componentes principais de maior variância.
4.  Criar um gráfico de dispersão da projeção 2D, fazendo uso de cores semi-transparentes para melhor visualização do overlap, e analisar a relação e a separabilidade entre as duas classes.

### 2. Código e Plot(s)
O código R completo e comentado, bem como o(s) plot(s) estão disponíveís na pasta `/Exercicio_2`.

### 3. Análise e Respostas

#### Relação Entre as Classes na Projeção 2D
A projeção 2D do PCA mostra dois clusters elípticos com orientações distintas, indicando diferentes estruturas de correlação nos dados 5D originais. Embora os centros dos clusters estejam separados, há uma **região de sobreposição significativa**, onde pontos de ambas as classes estão misturados.

#### Análise da Separabilidade Linear e o Desafio para Modelos Simples
Os dados, conforme visualizados em sua projeção mais informativa, **não são linearmente separáveis**. Nenhuma linha reta pode separar perfeitamente as duas classes. Um modelo linear simples (como um Perceptron) seria incapaz de alcançar alta acurácia, pois sua fronteira de decisão linear inevitavelmente classificaria incorretamente muitos pontos na zona de sobreposição.

Para classificar esses dados com precisão, seria necessário um modelo mais complexo, como um **MLP** . Tal rede pode aprender uma **fronteira de decisão não-linear**, que se ajustaria de forma muito mais eficaz à fronteira complexa entre os dois clusters, resultando em um desempenho de classificação superior.

---

## Exercício 3: Pré-processamento do Dataset "Spaceship Titanic"

### 1. Abordagem

Este exercício focou no pré-processamento de um dataset real do Kaggle para prepará-lo para uma rede neural com função de ativação `tanh`. A abordagem foi:
1.  Carregar o dataset `train.csv` e realizar uma análise exploratória para identificar tipos de dados, variáveis preditivas e valores ausentes.
2.  Implementar uma estratégia de limpeza de dados:
    *   **Imputação de dados ausentes:** Substituir valores numéricos faltantes pela **mediana** (devido à assimetria dos dados) e valores categóricos pela **moda**.
    *   **Codificação de variáveis categóricas:** Aplicar **One-Hot Encoding** em variáveis como `HomePlanet` e `Destination` e converter variáveis booleanas (`CryoSleep`, `VIP`) para formato numérico (0/1).
3.  **Normalizar** todas as features numéricas para o intervalo `[-1, 1]` usando a normalização Min-Max, uma escolha justificada pela natureza da função de ativação `tanh`.
4.  Criar histogramas comparativos ("antes e depois") para visualizar o impacto da etapa de normalização em features com escalas drasticamente diferentes.

### 2. Código e Plot(s)
O código R completo e comentado, bem como o(s) plot(s) estão disponíveís na pasta `/Exercicio_3`.

### 3. Análise e Respostas

#### Descrição e Análise do Dataset
O objetivo do dataset é uma tarefa de **classificação binária** para prever se um passageiro foi transportado (`Transported`). As features incluem dados numéricos (`Age`, despesas) e categóricos (`HomePlanet`, `Destination`). A análise inicial revelou a presença de valores ausentes em múltiplas colunas, tanto numéricas quanto categóricas.

#### Justificativa das Etapas de Pré-processamento
*   **Tratamento de Dados Ausentes:** A imputação pela **mediana** para dados numéricos foi escolhida devido à alta assimetria das distribuições de despesas, tornando-a mais robusta que a média. A imputação pela **moda** para dados categóricos é a abordagem padrão para preencher com o valor mais provável.
*   **Normalização para `[-1, 1]` (vs. Padronização Z-score):** A função de ativação `tanh` satura (seu gradiente se aproxima de zero) para entradas com valores absolutos grandes. A padronização Z-score não garante um intervalo limitado, o que poderia levar ao problema do **desaparecimento do gradiente** e paralisar o aprendizado da rede. A **normalização Min-Max para `[-1, 1]`**, por outro lado, **garante** que todas as entradas permaneçam na região ativa da função `tanh`, assegurando um treinamento mais estável e eficiente.

#### Análise dos Histogramas
Os histogramas comparativos demonstram que a normalização **preserva a forma da distribuição original** dos dados, mas **transforma sua escala**. Isso é visível tanto para a feature `Age` (com escala original de 0-80) quanto para a `FoodCourt` (com escala original de 0 a ~30.000). Ambas, após a transformação, possuem seus valores contidos estritamente no intervalo `[-1, 1]`, confirmando que o pré-processamento foi bem-sucedido e os dados estão prontos para serem utilizados pela rede neural.