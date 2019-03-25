source("src/functions.R")
load("copy.Rdata")

#NUMF <- 70981
#NUMF <- 72300
NUMF <- 7448
#NUMF <- getNUMFAbyTaillMenage(5)
famille <- nodes[NUMFA==NUMF, ]
liens <- links[NUMFA==NUMF]
plotPedigree(NUMF)
ped <- getPedigree(NUMF)
ped$id <- famille$PRENOM

kinship(ped)
round(8*kinship(ped))
