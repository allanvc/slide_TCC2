# FIGURA PARA APRESENTACAO TCC2

## 1) Grafo, MST e links interessantes
wd.loc <- "/home/allan/Documents/1S2018/TCC2/scripts/fase_final/completo_com_MST_boruvka/"
setwd(wd.loc)

library(Rcpp) 
library(RcppMLPACK)

sourceCpp("mst_mlpack_v4.cpp", verbose=TRUE)
sourceCpp("dist_matrix_OK.cpp", verbose=TRUE)

funs <- c('1-FUN_select_link_v6.R', 
          '2-FUN_cluster_assign_v10_novo.R', 
          '3-FUN_stat_calc_conn_ss_v6.R', 
          '4-FUN-MST_cluster_v1.R',
          '5-FUN-CCC_sim_v1.R',
          '6-FUN-K_det_v3.R',
          '7-FUN-MST_cluster_solution.R',
          'FUN-gen_data_v3.R')

sapply(funs, source)

# figura 10 nova - links interessantes
library(dplyr)
set.seed(1984)
n <- 15
c1 <- data_frame(x = rnorm(n,-0.2, sd=0.2), y = rnorm(n,-2,sd=0.2), c="c1")
c2 <- data_frame(x = rnorm(n,-1.1,sd=0.15), y = rnorm(n,-2,sd=0.3), c= "c2")
c3 <- data_frame(x=0.55, y=-2.4, c="c1")
d <- rbind(c1, c2, c3)
d <- as.data.frame(d)

# plot(c1, xlim=c(-2,1), ylim=c(-2.5,-1.5), cex=3)
# points(c2, pch=16, cex=3)
# points(c3[1], c3[2], cex=3)
# identify(d) # para idt quais eram os ptos
out <- mlpack_mst(as.matrix(d[,-3])) 

from <- out[1,]
to <- out[2,]

intlink_from <- 22
intlink_to <- 4

nolink_from<-c(5, 18)
nolink_to<-c(31, 30)



# fig com ggplot2
# de matriz para dataframe:
df<-as.data.frame(d)
library(ggplot2)
# criar um ponto a mais nos vetores from e to para o ggplot não dar erro de comprimento
fromgg <- c(from, 1)
togg <- c(to,1)
# https://stackoverflow.com/questions/48148373/how-to-plot-line-segments-in-ggplot2-when-aesthetics-do-not-have-length-1-or-sam

nolink_fromgg <-c(5, 18, rep(1, nrow(d)-2)) # para completar e ggplot nao reclamar
nolink_togg <-c(31, 30, rep(1, nrow(d)-2))

# a saida eh fazer um data_frame usando o tamanho maximo - liga cada numero a todos os outros
# ...  se passar a menos nos links nao tem problema

# arvore
# from_tree <- c( c(17, 29, 28, 23, 24, 26, 25, 27, 19, 22, 30, 4, 8, 3, 5, 31, 14, 2, 11, 12, 10, 7, 9, 13, 15, 6, 1, 20, 18, 21), 1)
# to_tree <- c( c(29, 28, 23, 24, 26, 25, 27, 19, 22, 30, 4, 8, 3, 5, 31, 14, 2, 11, 12, 10, 7, 9, 13, 15, 6, 1, 20, 18, 21, 16), 1)

from_tree <- c( c(17, 29, 28, 23, 24, 26, 25, 27, 19, 22, 30, 4, 8, 3, 8, 8, 14, 2, 11, 12, 10, 7, 9, 13, 15, 6, 1, 20, 18, 21), 1)
to_tree <- c( c(29, 28, 23, 24, 26, 25, 27, 19, 22, 30, 4, 8, 3, 5, 31, 14, 2, 11, 12, 10, 7, 9, 13, 15, 6, 1, 20, 18, 21, 16), 1)

# grafo
from_total <- rep(1:nrow(d), each= nrow(d))
to_total <- rep(1:nrow(d), nrow(d))

df_total <- df[rep(seq_len(nrow(df)), nrow(d)),]


# from_mst <- rep(fromgg, nrow(d))
# to_mst <- rep(togg, nrow(d))

plotly_palette <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9575D2", "#8C564B", "#E377C0", "#7F7F7F",
                    "#BCBD22", "#17BECF")

library(dplyr)
# b <- df_total %>%
  # grafo total:
b <- ggplot()+
  geom_point(data = df_total, aes(x, y, colour = factor(c), shape = factor(c)), size=3)+
  geom_segment(aes(x = df_total[from_total,1], y = df_total[from_total,2],
                   xend = df_total[to_total,1], yend = df_total[to_total,2], colour = "grafo"),
               data = df_total, linetype="dotted", size = 0.4, alpha = 0.4)+
  # geom_point(aes(x, y, colour = factor(c), shape = factor(c)), size=3)+
  # Spanning Tree qualquer:
  geom_segment(aes(x = df[from_tree,1], y = df[from_tree,2],
                   xend = df[to_tree,1], yend = df[to_tree,2], colour="tree"),
               data = df, linetype="dotted", size=1.2)+
  # plotagem regular MST:
  # geom_point(aes(df[,1], df[,2], colour = factor(c), shape = factor(c)))+
  geom_segment(aes(x = df[fromgg,1], y = df[fromgg,2],
                     xend = df[togg,1], yend = df[togg,2], colour="MST"),
                 data = df, linetype="dotted", size=1.2)+
  # outliers:
  geom_segment(aes(x = df[nolink_fromgg,1], y = df[nolink_fromgg,2],
                   xend = df[nolink_togg,1], yend = df[nolink_togg,2], colour="outlink"),
               data = df, size=1.4)+ #linetype="dotted", size=1.4)+
  
  # link interessante:
  geom_segment(aes(x = df[intlink_from,1], y = df[intlink_from,2],
                   xend = df[intlink_to,1], yend = df[intlink_to,2], colour="intlink"),
               data = df, size=1.4)+# linetype="dotted", size=1.4)+
  # formatacao:
  theme_bw()+
  theme(panel.border = element_blank())+ # para ficar igual o plotly
  guides(color=guide_legend(title=NULL), shape=guide_legend(title=NULL))+
  scale_shape_manual(values=c(1, 16))+
  # scale_color_manual(values=c("black", "black", "orange", "red", "blue", "green", "purple"))
  # scale_color_manual(values=c("black", "black", "grey", plotly_palette[4], plotly_palette[1], 
  #                             plotly_palette[3], plotly_palette[2]))
  # scale_color_manual(values=c(plotly_palette[5], plotly_palette[10], "grey", plotly_palette[4], plotly_palette[1], 
  #                           plotly_palette[3], plotly_palette[2]))
  scale_color_manual(values=c(plotly_palette[1], plotly_palette[2], plotly_palette[10], plotly_palette[4], plotly_palette[5], 
                            plotly_palette[3], plotly_palette[7]))

b

plotly::style(plotly::ggplotly(b),visible="legendonly", traces = 1)

bp <- plotly::style(plotly::ggplotly(b),visible="legendonly", traces = c(3,4,5,6,7))
# https://github.com/ropensci/plotly/issues/1177 -- como esconder legendas mas deixa-las ativas

library(htmlwidgets)
library(plotly)
saveWidget(as_widget(bp), file = "/home/allan/Documents/1S2018/TCC2/apres_TCC2/assets/widgets/MST_intlink_plotly.html")


# plotly::style(plotly::ggplotly(b) %>%
#                 plotly::layout(legend = list(orientation = "h", x = -2, y =-0.1))
#                 ,visible="legendonly", traces = 1)

# -------------

## 2) CCC - pca

# figura 11 - CCC
n=336
set.seed(1984)
d1<-matrix(rnorm(n,mean=3,sd=.7), n/3, 2)
d2<-matrix(rnorm(n,mean=-3,sd=.5), n/3, 2)
d3<-matrix(rnorm(n,mean=0,sd=.4), n/3, 2)
d<-rbind(d1,d2,d3) # 3 clusters mas em 2d

simd <- CCC_sim(d)

#par(pty="s")
plot(d, cex=0.5, xlab="x", ylab="y", ylim=c(-5.5,5.5), xlim=c(-5.5,5.5))
# points(d1, col="navyblue", cex=0.5)
# points(d3, col="green", cex=0.5)
points(simd, col="darkorange", pch="+", cex=1)
legend(-5.4, 5, legend=c("dados originais", "dados simulados"),
       col=c("black", "darkorange"), pch=c("o","+"), cex=1,
       bty="n")

# plot1
plot(d)

pca<-princomp(d)

#plot2
plot(pca$scores[,1], pca$scores[,2], ylim=c(-5.5, 5.5), xlim=c(-5.5, 5.5) )

mx<-min(pca$scores[,1]) # menor valor de x no espaço transformado
Mx<-max(pca$scores[,1]) # maior valor de x no espaço transformado

my<-min(pca$scores[,2]) # menor valor de y no espaço transformado
My<-max(pca$scores[,2]) # maior valor de y no espaço transformado

simx<-runif(n,mx,Mx) # uniforme entre mx e Mx # aqui eh n
simy<-runif(n,my,My) # uniforme entre my e My

simd_pre<-t(rbind(simx,simy))

# plot3
plot(simd_pre, ylim=c(-5.5, 5.5), xlim=c(-5.5, 5.5) )

# simd<-simd %*% t(pca$loadings) + pca$center # transformando para o espaço original

# v9
simd<-simd_pre %*% t(pca$loadings)
simd[,1]<-simd[,1]+pca$center[1]
simd[,2]<-simd[,2]+pca$center[2]

plot(simd, ylim=c(-5.5, 5.5), xlim=c(-5.5, 5.5) )

df <- data.frame(x=d[,1], y=d[,2])
pca_df <- data.frame(x = pca$scores[,1], y = pca$scores[,2])
simd_pre_df <- data.frame(x = simd_pre[,1], y = simd_pre[,2])
simd_df <- data.frame(x = simd[,1], y = simd[,2])


plotly_palette <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9575D2", "#8C564B", "#E377C0", "#7F7F7F",
                    "#BCBD22", "#17BECF")
library(ggplot2)

c <- ggplot()+
  geom_point(data=df, aes(x, y, colour="1.dados"))+
  geom_point(data=pca_df, aes(x, y, colour="2.pca"))+
  geom_point(data=simd_pre_df, aes(x, y, colour="3.hipercubo1"))+
  geom_point(data=simd_df, aes(x, y, colour="4.hipercubo2"))+
  theme_bw()+
  theme(panel.border = element_blank())+ # para ficar igual o plotly
  guides(color=guide_legend(title=NULL))+
  # scale_color_manual(values=c("black", "black", "orange", "red", "blue", "green", "purple"))
  scale_color_manual(values=c(plotly_palette[c(1,1,2,2)]))

c

bc <- plotly::style(plotly::ggplotly(c),visible="legendonly", traces = c(2,3,4))

library(htmlwidgets)
library(plotly)
saveWidget(as_widget(bc), file = "/home/allan/Documents/1S2018/TCC2/apres_TCC2/assets/widgets/ccc_pca_plotly.html")


## ---------------------

## 3) Pareto

# figura 12 - Pareto
# urlfile<-'https://raw.githubusercontent.com/allanvc/pareto_non_dominated_points-test/master/data_example.txt'
# dt<-read.table(urlfile, header=TRUE)
# library(emoa)
# nondom_emoa <- nondominated_points(t(as.matrix(dt)))
# require( tikzDevice )
# tikz( 'fig11.tex' , width = 6.5, height = 4.5)
# plot(dt, cex=0.8)
# points(t(nondom_emoa), col='green', cex=0.8)
# dev.off()

# outra versao da fig 12 (menos pontos)
n = 42
# n = 52
# set.seed(1984)
set.seed(123)
d<-matrix(rnorm(n,mean=-2,sd=.5), n/2, 2) # 3d

library(emoa)
nondom_emoa <- nondominated_points(t(as.matrix(d)))

plot(d, pch=4, xlab="x", ylab="y", cex=0.8)
points(t(nondom_emoa), pch=15, col="green")
legend(-1.61, -0.7, legend=c("n\\~ao-dominados", "dominados"), # escrevemos assim para aceitar o acento no latex
       col=c("green", "black"), pch=c(15,4), cex=1,
       bty="n")

df <- data.frame(x=d[,1], y=d[,2])
nondom_df <- data.frame(x=t(nondom_emoa)[,1], y= t(nondom_emoa)[,2])


plotly_palette <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9575D2", "#8C564B", "#E377C0", "#7F7F7F",
                    "#BCBD22", "#17BECF")

library(ggplot2)

d <-
  ggplot()+
  geom_point(data=df, aes(x, y, shape="dom", colour="dom"))+
  geom_point(data=nondom_df, aes(x, y, shape="nondom", colour="nondom"), size=1.9)+
  theme_bw()+
  theme(panel.border = element_blank())+ # para ficar igual o plotly
  guides(color=guide_legend(title=NULL), shape=guide_legend(title=NULL))+
  scale_shape_manual(values=c(4, 15))+
  # scale_fill_manual(plotly_palette[3])+
  # scale_color_manual(values=c("black", "black", "orange", "red", "blue", "green", "purple"))
  # scale_color_manual(values=c("black", plotly_palette[3]))
  scale_color_manual(values=c(plotly_palette[5], plotly_palette[3]))+
  labs(x="conn", y="SSwt")

d


# bd <-plotly::style(plotly::ggplotly(d) %>%
#                 plotly::layout(legend = list(orientation = "h", x = 0.3, y = -0.2)))

bd <-plotly::style(plotly::ggplotly(d), visible="legendonly", traces = 2)

library(htmlwidgets)
library(plotly)
saveWidget(as_widget(bd), file = "/home/allan/Documents/1S2018/TCC2/apres_TCC2/assets/widgets/pareto_plotly.html")


##--------------------


## 4) Algoritmo

# dados
n = 99
set.seed(1984)
# set.seed(123)
d1<-matrix(rnorm(n,mean=-2,sd=.5), n/3, 3) # 3d
d2<-matrix(rnorm(n,mean=0,sd=.3), n/3, 3)
d3<-matrix(rnorm(n,mean=3,sd=.4), n/3, 3)
d<-rbind(d1,d2,d3)


# MST
simd <- CCC_sim(d)

out <- mlpack_mst(as.matrix(d)) 
from <- out[1,]
to <- out[2,]
from_to.m <- t(cbind(from,to))

# criar um novo vetor com o from_to.m adicionando uma linha de NA na matrix inteira no final
# ideia dos NA's: https://community.plot.ly/t/droplines-from-points-in-3d-scatterplot/4113/4
# ideia de usar line: https://plot.ly/r/3d-line-plots/ (penultimo grafico)
m <- rbind(from_to.m, NA) # o NA servirá para separarmos os segmentos
ordem_linhas <- Reduce(rbind, m) # ok!
novo_d <- d[ordem_linhas,] # ok! parece que funciona!! o R recicla!!!
novo_d <- as.data.frame(novo_d)

# MST clustering
x <- scale(d)
M <- as.matrix(x)
dist.m<-dist_cpp(M)
diag(dist.m) <- max(dist.m) +1
ord.m <- apply(dist.m, 2, order)
n_neig=7
ord.m <- ord.m[1:n_neig,]

cut <- select_link(k=3, n_neig=7, dist.m, from, to, from_to.m, ord.m)
from_wcut <- from[-which(cut == 0)]
to_wcut <- to[-which(cut == 0)]

m <- rbind(from_wcut, to_wcut, NA) # utilizando os vetores _wcut na versão final
ordem_linhas <- Reduce(rbind, m) # ok!

novo_d2 <- d[ordem_linhas,] # ok! parece que funciona!! o R recicla!!!
novo_d2 <- as.data.frame(novo_d2)

# CCC
simd <- CCC_sim(d)

plotly_palette <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9575D2", "#8C564B", "#E377C0", "#7F7F7F",
                    "#BCBD22", "#17BECF")

# MST na simulação

out2 <- mlpack_mst(as.matrix(simd))
from <- out2[1,]
to <- out2[2,]
from_to.m <- t(cbind(from,to))
m <- rbind(from_to.m, NA) # o NA servirá para separarmos os segmentos
ordem_linhas <- Reduce(rbind, m) # ok!
novo_d3 <- simd[ordem_linhas,] # ok! parece que funciona!! o R recicla!!!
novo_d3 <- as.data.frame(novo_d3)

# MST clustering
x <- scale(simd)
M <- as.matrix(x)
dist.m<-dist_cpp(M)
diag(dist.m) <- max(dist.m) +1
ord.m <- apply(dist.m, 2, order)
n_neig=7
ord.m <- ord.m[1:n_neig,]

cut <- select_link(k=3, n_neig=7, dist.m, from, to, from_to.m, ord.m)
from_wcut <- from[-which(cut == 0)]
to_wcut <- to[-which(cut == 0)]

m <- rbind(from_wcut, to_wcut, NA) # utilizando os vetores _wcut na versão final
ordem_linhas <- Reduce(rbind, m) # ok!

novo_d4 <- simd[ordem_linhas,] # ok! parece que funciona!! o R recicla!!!
novo_d4 <- as.data.frame(novo_d4)



library(plotly)
#plot_ly(color = I("blue"), showlegend = T) %>%
e <- plot_ly(showlegend = T) %>%
  add_markers(data=novo_d, x = ~V1, y = ~V2, z = ~V3, marker=list(opacity=0.5), size = I(3.5), name="dados") %>%
  add_paths(data = novo_d, x = ~V1, y = ~V2, z = ~V3, color = I("red"), visible="legendonly", name="MST_dados") %>%
  add_paths(data = novo_d2, x = ~V1, y = ~V2, z = ~V3, color = I("red"), visible="legendonly", name="clust_dados") %>%
  add_trace(x = simd[,1], y = simd[,2], z = simd[,3], marker=list(opacity=0.5), size = I(3.5),  
            visible="legendonly", name="hipercubo", color=I(plotly_palette[2])) %>%
  add_paths(data = novo_d3, x = ~V1, y = ~V2, z = ~V3, color = I(plotly_palette[5]), visible="legendonly", name="MST_cubo") %>%
  add_paths(data = novo_d4, x = ~V1, y = ~V2, z = ~V3, color = I(plotly_palette[5]), visible="legendonly", name="clust_cubo")


# be <-plotly::style(plotly::ggplotly(e), visible="legendonly", traces = c(2))

library(htmlwidgets)
library(plotly)
saveWidget(as_widget(e), file = "/home/allan/Documents/1S2018/TCC2/apres_TCC2/assets/widgets/algorit_plotly.html")


##---------------------------


## 5) - best k
pca <- princomp(d)
# teste grafico inicial
simd <- CCC_sim(d)
# MST Boruvka based clustering nos dados originais
contg <<- 1 # variavel de contagem apenas para identificar possiveis erros
n_neig=7
kmax=5
d_clust<-MST_cluster(d, kmax=kmax, n_neig=n_neig)

# pontos nao dominados nas estatisticas de teste - dados originais
library(ecr)
d_nond <- d_clust[which.nondominated(t(d_clust)),] # precisamos deste tb v3 14.06.2018

# alteracao v3 14.06.2018 - vamos apenas modificar as linhas dominadas
d_clust2 <- d_clust
d_clust2[-which.nondominated(t(d_clust)),1] <- max(d_clust[,2])

# simulacoes CCC
# lista de hipercubos
n_sim=100
sim_data_l<-lapply(1:n_sim, function(i){
  sim_data <- CCC_sim(d)
  return(sim_data)
} )

# MST Boruvka based clustering nos dados simulados
sim_clusters_l <- lapply(1:length(sim_data_l), function(i) {
  MST_cluster(sim_data_l[[i]], kmax=kmax, n_neig=n_neig)
} )

# pontos nao dominados nas estatisticas de teste - dados simulados (hipercubos)
sim_nond_l <- lapply(1:length(sim_clusters_l), function(i) {
  # nond <- which.nondominated(t(sim_clusters_l[[i]]))
  sim_clusters_l[[i]][which.nondominated(t(sim_clusters_l[[i]])),] # eh implementada em C
} )


# separando nuvens por k
# antes juntar tudo num unico dataframe
res_sim <- Reduce(rbind, sim_nond_l)
#table(rownames(res_sim)) # trouxe todos
rownames_vec <- rownames(res_sim)
res_sim <- as.data.frame(res_sim, row.names = FALSE)
res_sim <- cbind(res_sim, "k"=rownames_vec)

# separando nuvens
library(magrittr)
library(dplyr)
# detach(package:plyr) # cuidado para nao carregar plyr depois de dplyr

# centroides das nuvens
clouds_centroids <- res_sim %>%
  group_by(k) %>%
  summarise(conn = mean(conn, na.rm=TRUE), SSwt = mean(SSwt, na.rm=TRUE))

clouds_centroids <- as.data.frame(clouds_centroids)
rownames(clouds_centroids) <- clouds_centroids[,1]
clouds_centroids <- as.matrix(clouds_centroids[,-1])

# descontando a variancia de cada nuvem
# obtendo matriz de cov
cov_df <- res_sim %>% 
  group_by(k) %>%
  do(data.frame(Cov=t(cov(.[,1:2])))) # de k ateh k+1

distances <- sapply(2:kmax, function(i){
  # testando se houve pontos dominados nos dados
  if(nrow(d_nond) == (kmax-1)){
    x <- d_nond %>%
      .[rownames(.)==paste0("k=", i),] # qdo tiver um k dos dados dominados ai temos que usar o d_clust
  } else {
    x <- d_clust %>%
      .[rownames(.)==paste0("k=", i),]
  }
  
  x <- as.matrix(x)
  
  m <- clouds_centroids %>%
    .[rownames(.)==paste0("k=", i),]
  
  m <- as.matrix(m)
  
  cov <- cov_df %>%
    filter(k == paste0("k=", i))
  
  cov <- as.matrix(cov[,-1])
  
  sqrt(t(x-m)%*%solve(cov)%*%(x-m))
}); distances


if(nrow(d_nond) != (kmax-1)){
  best_k <- d_clust2[which.max(distances), , drop=FALSE] # 14.06.2018 alteracao para trazer qual o k
} else {
  best_k <- d_clust[which.max(distances), , drop=FALSE] # para trazer qual o k
}

library(ggplot2)
## plotar tudo:
p1 <- res_sim %>%
  ggplot(aes(conn, SSwt, alpha=0.7), size=1)+
  geom_point()+
  geom_point(aes(d_clust[1,1], d_clust[1,2]), colour="red", shape="2", size=2.5)+
  geom_point(aes(d_clust[2,1], d_clust[2,2]), colour="orange", shape="3", size=2.5)+
  geom_point(aes(d_clust[3,1], d_clust[3,2]), colour="blue", shape="4", size=2.5)+
  geom_point(aes(d_clust[4,1], d_clust[4,2]), colour="purple", shape="5", size=2.5)+
  geom_point(aes(best_k[1,1], best_k[1,2]), colour="red", shape=5, size=5)+
  # geom_point(aes(d_clust[which.max(distances), 1], d_clust[which.max(distances), 2], colour="yellow"),
  #           shape=5, size=3)+
  facet_wrap(~k, nrow=2)+
  # formatacao:
  theme_bw()+
  theme(panel.border = element_blank())+ # para ficar igual o plotly
  theme(legend.position = "none")

x11()
p1  

# plotly::ggplotly(p1)

## ------------------------------

# 6) RESULTADOS

