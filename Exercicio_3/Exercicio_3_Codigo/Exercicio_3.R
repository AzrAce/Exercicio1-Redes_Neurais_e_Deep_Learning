#1. 

# Carrega o arquivo train.csv para um data.frame.
titanic_df <- read.csv("train.csv", na.strings = "")

head(titanic_df) # Exibe as primeiras linhas para uma inspeção inicial.

#2. 

# A função str() fornece um resumo da estrutura do data.frame, mostrando os tipos de dados de cada coluna e os primeiros valores.
str(titanic_df)

# Calculo da soma de valores ausentes para cada coluna.
missing_values <- colSums(is.na(titanic_df))

# Exibe apenas as colunas que contêm valores ausentes e suas contagens.
print("Colunas com valores ausentes e suas contagens:")
print(missing_values[missing_values > 0])

#3. 

# Cria uma cópia do data.frame original para realizar as modificações.
processed_df <- titanic_df

#3. 

#3.a)

num_cols <- c("Age", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck")

for (col in num_cols) {
  median_val <- median(processed_df[[col]], na.rm = TRUE) # Calcula a mediana ignorando os NAs.
  processed_df[[col]][is.na(processed_df[[col]])] <- median_val # Substitui os NAs pela mediana.
}

#3.b)
#Função para calcular a moda.
get_mode <- function(v) {
  uniqv <- unique(v[!is.na(v)])
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

cat_cols_impute <- c("HomePlanet", "CryoSleep", "Destination", "VIP")

for (col in cat_cols_impute) {
  mode_val <- get_mode(processed_df[[col]]) # Calculo da moda da coluna.
  processed_df[[col]][is.na(processed_df[[col]])] <- mode_val # Substituição dos NAs pela moda.
}

# Verificação do tratamento.
print("Valores ausentes após a imputação:")
print(colSums(is.na(processed_df)))

#3.c)

# Remoção das colunas que não são úteis para a predição.
processed_df$PassengerId <- NULL
processed_df$Name <- NULL
processed_df$Cabin <- NULL

#3.d)
# Transformação de categorias de texto em colunas numéricas binárias.
cat_cols_encode <- c("HomePlanet", "Destination")

for (col in cat_cols_encode) {
  unique_levels <- unique(processed_df[[col]])
  for (level in unique_levels) {
    new_col_name <- paste(col, level, sep = "_") # Criação de um novo nome de coluna (ex: "HomePlanet_Earth").
    # Criação da nova coluna binária: 1 se a linha pertencer à categoria, 0 caso contrário.
    processed_df[[new_col_name]] <- ifelse(processed_df[[col]] == level, 1, 0)
  }
  processed_df[[col]] <- NULL # Remoção da coluna de texto original.
}

# Conversão de colunas com TRUE/FALSE para o formato numérico 1/0.
processed_df$CryoSleep <- as.integer(processed_df$CryoSleep)
processed_df$VIP <- as.integer(processed_df$VIP)
processed_df$Transported <- as.integer(processed_df$Transported) # Converção da variável alvo.

#3.e)
numerical_features <- c("Age", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck")

# Aplicação da normalização Min-Max para o intervalo [-1, 1].
for (col in numerical_features) {
  min_val <- min(processed_df[[col]])
  max_val <- max(processed_df[[col]])
  #Ajuste dos valores para que fiquem proporcionalmente dentro do novo intervalo.
  processed_df[[col]] <- -1 + 2 * (processed_df[[col]] - min_val) / (max_val - min_val)
}

#4. 


par(mfrow = c(2, 2)) 

hist(titanic_df$Age, 
     main = "Idade (Escala Original)", 
     xlab = "Idade (Intervalo: 0 a 79)", 
     col = "skyblue",
     breaks = 20)

hist(processed_df$Age, 
     main = "Idade (Normalizada)", 
     xlab = "Idade em Escala (Intervalo: -1 a 1)", 
     col = "lightgreen",
     breaks = 20)

hist(titanic_df$FoodCourt, 
     main = "FoodCourt (Escala Original)", 
     xlab = "Gasto (Intervalo: 0 a ~30.000)", 
     col = "salmon",
     breaks = 50)

hist(processed_df$FoodCourt, 
     main = "FoodCourt (Normalizada)", 
     xlab = "Gasto em Escala (Intervalo: -1 a 1)", 
     col = "plum",
     breaks = 50)

par(mfrow = c(1, 1))