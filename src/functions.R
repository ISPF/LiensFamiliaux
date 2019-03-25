library(data.table)
library(ggenealogy)
library(igraph)
library(ggplot2)
library(kinship2)
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


getPedigree <- function(NUMF){
  famille <- nodes[NUMFA==NUMF, ]
  liens <- links[NUMFA==NUMF]
  
  df <- cbind(rbind(famille[,.(id=ID)]),
              merge(famille, liens[idLien==15], by.x="ID", by.y="IDTO", all.x = T)[,.(dadid=IDFROM)],
              merge(famille, liens[idLien==16], by.x="ID", by.y="IDTO", all.x = T)[,.(momid=IDFROM)],
              famille[,.(sex=SEXE)])
  df[xor(is.na(dadid), is.na(momid)),c("dadid", "momid"):=NA]
  
  # relationsConjoints <- liens[idLien %in% c(20), .(id1=IDTO, id2=IDFROM, code=4)]
  # for (j in names(df))
  #   set(df,which(is.na(df[[j]])),j,0)
  
  with(df, pedigree(id, dadid, momid, sex))
}

plotPedigree <- function(NUMF){
  famille <- nodes[NUMFA==NUMF, ]
  pedigr <- getPedigree(NUMF)
  pedigr$id <- famille$PRENOM
  plot.pedigree(pedigr, col=ifelse(famille$SEXE==1,"blue","red"))
}
