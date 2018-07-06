# DEMO ALGORITMO - APRESENTACAO TCC 05/07/2018


## definicao do diretorio:
# library(tcltk)
# wd.loc<-tk_choose.dir()
wd.loc <- "/home/allan/Documents/1S2018/TCC2/scripts/fase_final/completo_com_MST_boruvka/"
setwd(wd.loc)


## carregamento dos códigos fonte Rcpp e funcoes API

# pacotes
library(Rcpp) 
library(RcppMLPACK)
#library(RcppArmadillo) # utilizado no mst prim para op. com matrizes

# codigo C++
# MST
sourceCpp("mst_mlpack_v4.cpp", verbose=TRUE) # jah adicionando 1 às linhas e sem precisar passar matriz transposta

# distance matrix
sourceCpp("dist_matrix_OK.cpp", verbose=TRUE) # necessaria para calculo das estatisticas de teste


## carregamento das funcoes R
funs <- c('1-FUN_select_link_v6.R', 
          '2-FUN_cluster_assign_v10_novo.R', 
          '3-FUN_stat_calc_conn_ss_v6.R', 
          '4-FUN-MST_cluster_v1.R',
          '5-FUN-CCC_sim_v1.R',
          '6-FUN-K_det_v3.R',
          '7-FUN-MST_cluster_solution.R',
          'FUN-gen_data_v3.R')

sapply(funs, source)


# ----------------------------------------

# result 4
n=100
set.seed(1984)
d1<-matrix(rnorm(n,mean=2,sd=1), n/2, 2)
d2<-matrix(rnorm(n,mean=-2,sd=.5), n/2, 2)
d<-rbind(d1,d2)

plot(d)

k_best <- K_det(as.matrix(d), kmax=5, n_neig=8, n_sim=100)


par(mfrow=c(1,2))
plot(d)

MST_cluster_sol(d, k=2, n_neig=8) #ok!

par(mfrow=c(1,1))


# result 1
n=66
set.seed(1984)
d1<-matrix(rnorm(n,mean=3,sd=1), n/3, 2)
d2<-matrix(rnorm(n,mean=-3,sd=.5), n/3, 2)
d3<-matrix(rnorm(n,mean=-0,sd=.5), n/3, 2)
d<-rbind(d1,d2,d3) # 3 clusters mas em 2d

k_best <- K_det(as.matrix(d), kmax=5, n_neig=25, n_sim=100)

MST_cluster_sol(d, k=3, n_neig=8) #ok!