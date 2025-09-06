#1.

set.seed(42) # Define uma semente para garantir que os resultados sejam reprodutíveis.

n_samples <- 500 # Define o número de amostras para cada classe.

mu_A <- c(0, 0, 0, 0, 0) # Vetor de médias para as 5 dimensões.

# Matriz de covariância para a Classe A, que define a correlação entre as dimensões.
Sigma_A <- matrix(c(
  1.0, 0.8, 0.1, 0.0, 0.0,
  0.8, 1.0, 0.3, 0.0, 0.0,
  0.1, 0.3, 1.0, 0.5, 0.0,
  0.0, 0.0, 0.5, 1.0, 0.2,
  0.0, 0.0, 0.0, 0.2, 1.0
), nrow = 5, byrow = TRUE)

mu_B <- c(1.5, 1.5, 1.5, 1.5, 1.5) # Vetor de médias para as 5 dimensões.

# Matriz de covariância para a Classe B.
Sigma_B <- matrix(c(
  1.5, -0.7,  0.2, 0.0, 0.0,
  -0.7,  1.5,  0.4, 0.0, 0.0,
  0.2,  0.4,  1.5, 0.6, 0.0,
  0.0,  0.0,  0.6, 1.5, 0.3,
  0.0,  0.0,  0.0, 0.3, 1.5
), nrow = 5, byrow = TRUE)


# a) Geração de uma matriz de dados aleatórios de uma distribuição normal padrão (média 0, desvio padrão 1).
Z_A <- matrix(rnorm(n_samples * 5), nrow = n_samples, ncol = 5)
# b)Geração de uma matriz 'U' que, quando multiplicada, garante a correlação desejada nos dados.
U_A <- chol(Sigma_A)
# c) Transformação os dados aleatórios para que tenham a covariância correta e inserção da média.
#O operador %*% realiza a multiplicação de matrizes.
#A função sweep() soma o vetor de médias a cada linha da matriz de dados.
class_A_data <- sweep(Z_A %*% U_A, 2, mu_A, "+")


Z_B <- matrix(rnorm(n_samples * 5), nrow = n_samples, ncol = 5)
U_B <- chol(Sigma_B)
class_B_data <- sweep(Z_B %*% U_B, 2, mu_B, "+")

# rbind() empilha as duas matrizes de dados.
full_data <- as.data.frame(rbind(class_A_data, class_B_data))
# Inserção de uma coluna 'class' para identificar a qual classe cada linha pertence.
full_data$class <- factor(rep(c("Class A", "Class B"), each = n_samples))


2. 
# Isolamento apenas dos dados numéricos (colunas 1 a 5) para o PCA.
numeric_data <- full_data[, 1:5]

# a) Centralização os dados subtraindo a média de cada coluna.
#A função scale() realiza essa operação.
centered_data <- scale(numeric_data, center = TRUE, scale = FALSE)

# b) Calculo da matriz de covariância dos dados centralizados.
cov_matrix <- cov(centered_data)

# c) Calculo dos autovetores e autovalores da matriz de covariância.
#Os autovetores são os Componentes Principais (direções de maior variância).
eigen_decomp <- eigen(cov_matrix)
eigenvectors <- eigen_decomp$vectors

# d) Projeção  dos dados nos dois primeiros autovetores (PC1 e PC2).
#Feito a partir da multiplicação da matriz de dados pela matriz de autovetores.
pca_scores <- centered_data %*% eigenvectors[, 1:2]

# e) Criação de um novo data.frame com os dados projetados em 2D para a plotagem.
pca_data <- data.frame(
  PC1 = pca_scores[, 1],
  PC2 = pca_scores[, 2],
  class = full_data$class
)


# Definição das cores com um canal "alpha" (transparência).
colors_alpha <- c("Class A" = "#0000FF80", "Class B" = "#FF000080")

# Criação do gráfico.
plot(
  x = pca_data$PC1, y = pca_data$PC2,
  type = "n",
  main = "Projeção PCA 2D com Transparência",
  xlab = "Componente Principal 1",
  ylab = "Componente Principal 2",
  asp = 1
  )

grid(lty = "dotted", col = "lightgray") # Adiciona uma grade pontilhada.

# Inserção dos pontos de dados ao gráfico.
points(pca_data$PC1[pca_data$class == "Class A"], pca_data$PC2[pca_data$class == "Class A"], 
       pch = 21, col = "black", bg = colors_alpha["Class A"])
points(pca_data$PC1[pca_data$class == "Class B"], pca_data$PC2[pca_data$class == "Class B"], 
       pch = 21, col = "black", bg = colors_alpha["Class B"])

# Criação da Legenda
legend(
  "topright",
  legend = names(colors_alpha),
  col = "black",
  pt.bg = colors_alpha, 
  pch = 21,
  title = "Classe"
)