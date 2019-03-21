library(data.table)
library(ggenealogy)
library(igraph)
library(ggplot2)
#library(network)
#library(GGally)

printNodes <- function(i){
  print(nodes[NUMFA==NUMF,.(id=ID,PRENOM,AGE,SEXE)])
}

printLinks <- function(i){
  print(links[NUMFA==NUMF,.(LIENCLAIR)])
}

printAllDetail <- function(i){
  printNodes(i)
  printLinks(i)
  print(sbGeneal[numfa==NUMF])
}

getNUMFAbyTaillMenage <- function(tailleMenage) {
  sample(nodes[,.N,NUMFA][N==tailleMenage, NUMFA],1)  
}



plotFamily <- function(i){
  nodes <- nodes[NUMFA==i,.(id=ID,PRENOM,AGE,SEXE)]
  links <- links[NUMFA==i,.(from=IDFROM,to=IDTO, LIEN)]
  #links <- linksAll[NUMFA==i & IDTO!=1 & IDFROM<IDTO,.(from=IDFROM,to=IDTO, LIEN)]
  g <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 
  V(g)$name <- V(g)$PRENOM
  plot(g, vertex.color=ifelse(V(g)$SEXE==1,"blue","red"))
}

plotGenealogy <- function(NUMF, i){
  plotAncDes(sbGeneal[numfa==NUMF][order(id)][i,child], sbGeneal, vColor = "blue") +
    ggplot2::labs(x="Generation index",y="")
}

plotFamilyPath <- function(NUMF, i, j){
  ig <- dfToIG(sbGeneal[numfa==NUMF], isDirected = TRUE)
  plotPath(getPath(V(ig)[i]$name,
                   V(ig)[j]$name,
                   ig,
                   sbGeneal[numfa==NUMF,.(child, year, parent)],
                   "year", isDirected=FALSE),
           sbGeneal[numfa==NUMF,.(child, year, parent)],
           "year") + xlab("Year")
}