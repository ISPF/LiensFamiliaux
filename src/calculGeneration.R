#calcul des générations
source("src/functions.R")
load("copy.Rdata")


getIdConcubin<-function(numeroIndividu)
{
  x <- unique(liens[IDTO %in% numeroIndividu & idLien %in% c(19,20), IDFROM])
  if(length(x)>0)
    x[[1]]
  else
    NA
}

getIdParent<-function(numeroIndividu)
{
  x <- unique(liens[IDTO %in% numeroIndividu & idLien %in% c(15,16), IDFROM])
  if(length(x)>0)
    x[[1]]
  else
    NA
}

getGenerationParent<-function(numeroIndividu)
{
  if (!is.na(getIdParent(numeroIndividu)))
    famille[ID==getIdParent(numeroIndividu),GEN]
  else 
    NA
}

getGenerationConcubin<-function(numeroIndividu)
{
  if (!is.na(getIdConcubin(numeroIndividu)))
    famille[ID==getIdConcubin(numeroIndividu),GEN]
  else
    NA
}

calculeGenerations<-function(verbose=FALSE)
{
  
  #A ordonner pour le parcours de l'arbre
  
  famille[1,GEN:=1]
  for (i in 2:famille[, .N]) {
    #i <- 5
    id <- famille[i,ID]
    GENC <- getGenerationConcubin(id)
    GENP  <- getGenerationParent(id)
    if (verbose==TRUE)
      cat(sprintf("Individus : %s\tGénération du concubin : %s et du parent : %s\n", id, GENC, GENP))
    if (!is.na(GENP)){
      famille[i, GEN:=GENP+1]
    } else{
      if (!is.na(GENC))
        famille[i,GEN:=GENC]
      else
        famille[i, GEN:=0]
    }
  }
}


#32098, 70981
NUMF <- getNUMFAbyTaillMenage(7)

famille <- nodes[NUMFA==NUMF, ]
liens <- links[NUMFA==NUMF]
famille[1,GEN:=1]
calculeGenerations(verbose = T)
plotFamily(NUMF)
famille
