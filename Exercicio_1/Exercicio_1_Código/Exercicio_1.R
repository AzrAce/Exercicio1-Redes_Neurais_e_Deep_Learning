#1. 
set.seed(42) # Define uma "semente" para que os números aleatórios gerados sejam sempre os mesmos.

n_samples <- 100 # Define o número de amostras (pontos) para cada uma das quatro classes.


# A função rnorm() é usada para gerar números aleatórios a partir de uma distribuição normal Gaussiana,
# seguindo a média (mean) e o desvio padrão (sd) especificados para cada classe.
class0_x <- rnorm(n = n_samples, mean = 2, sd = 0.8)
class0_y <- rnorm(n = n_samples, mean = 3, sd = 2.5)

class1_x <- rnorm(n = n_samples, mean = 5, sd = 1.2)
class1_y <- rnorm(n = n_samples, mean = 6, sd = 1.9)

class2_x <- rnorm(n = n_samples, mean = 8, sd = 0.9)
class2_y <- rnorm(n = n_samples, mean = 1, sd = 0.9)

class3_x <- rnorm(n = n_samples, mean = 15, sd = 0.5)
class3_y <- rnorm(n = n_samples, mean = 4, sd = 2.0)


df <- data.frame( # A função data.frame() é usada para criar uma tabela organizada.
  # A função c() combina todos os valores de X e Y em uma única coluna para cada.
  x = c(class0_x, class1_x, class2_x, class3_x), 
  y = c(class0_y, class1_y, class2_y, class3_y),
  # A coluna 'class' é criada para identificar a qual classe cada ponto pertence.
  # factor() indica que 'class' é uma variável categórica.
  # rep() repete o nome de cada classe 100 vezes.
  class = factor(rep(c("Class 0", "Class 1", "Class 2", "Class 3"), each = n_samples))
)

#2. 

# Definição de um vetor de cores para cada classe, facilitando a visualização no gráfico.
colors <- c("Class 0" = "blue", "Class 1" = "orange", "Class 2" = "forestgreen", "Class 3" = "red")

# A função plot() é usada para configurar a área de plotagem, eixos e títulos.
plot(
  x = df$x, y = df$y, # Define os dados que serão usados para os eixos X e Y.
  type = "n", # O tipo "n" cria o gráfico vazio, sem desenhar os pontos ainda.
  main = "Dados Gaussianos 2D com Fronteiras de Decisão Lineares", # Título principal do gráfico.
  xlab = "Característica 1 (Eixo X)", # Rótulo do eixo X.
  ylab = "Característica 2 (Eixo Y)", # Rótulo do eixo Y.
  xlim = c(-2, 18), # Define os limites do eixo X para um melhor enquadramento.
  ylim = c(-5, 12), # Define os limites do eixo Y.
  asp = 1 # Garante que a proporção dos eixos seja 1:1, evitando distorções visuais.
)

# A função grid() desenha linhas de grade para facilitar a leitura.
grid(lty = "dashed", col = "lightgray") # 'lty' define o estilo da linha como tracejada.

# A função points() é usada para desenhar os pontos sobre a área do gráfico já criada.
# pch=21 define o símbolo como um círculo que pode ter cor de borda e de preenchimento.
# 'col' define a cor da borda (preta) e 'bg' a cor do preenchimento.
points(df$x[df$class == "Class 0"], df$y[df$class == "Class 0"], pch = 21, col = "black", bg = colors["Class 0"])
points(df$x[df$class == "Class 1"], df$y[df$class == "Class 1"], pch = 21, col = "black", bg = colors["Class 1"])
points(df$x[df$class == "Class 2"], df$y[df$class == "Class 2"], pch = 21, col = "black", bg = colors["Class 2"])
points(df$x[df$class == "Class 3"], df$y[df$class == "Class 3"], pch = 21, col = "black", bg = colors["Class 3"])

# O ponto central escolhido é a média das médias das classes que se sobrepõem (0, 1 e 2).
center_point <- c(5, 3.33)


# As linhas são desenhadas a partir do ponto central para separar as classes.
segments(x0 = center_point[1], y0 = center_point[2], x1 = 2, y1 = 8, col = "black", lty = "dashed", lwd = 2.5)
segments(x0 = center_point[1], y0 = center_point[2], x1 = 3, y1 = -1, col = "black", lty = "dashed", lwd = 2.5)
segments(x0 = center_point[1], y0 = center_point[2], x1 = 11.5, y1 = center_point[2], col = "black", lty = "dashed", lwd = 2.5)
# A linha vertical (em x=11.5) separa a Classe 3 das demais.
segments(x0 = 11.5, y0 = -2, x1 = 11.5, y1 = 10, col = "black", lty = "dashed", lwd = 2.5)

# Criação da legenda.
legend(
  "bottomright", # Posição da legenda no canto inferior direito.
  legend = c(names(colors), "Fronteiras Lineares"), # Textos que aparecerão na legenda.
  col = c("black", "black", "black", "black", "black"), # Cor da borda dos pontos e da linha.
  pt.bg = c(colors["Class 0"], colors["Class 1"], colors["Class 2"], colors["Class 3"], NA), # Cor de preenchimento dos pontos.
  pch = c(21, 21, 21, 21, NA), # Símbolos para cada item (círculo para as classes, nenhum para a fronteira).
  lty = c(NA, NA, NA, NA, "dashed"), # Estilo de linha (nenhum para as classes, tracejado para a fronteira).
  lwd = c(NA, NA, NA, NA, 2.5), # Espessura da linha.
  bty = "o" # Desenha uma caixa ao redor da legenda.
)