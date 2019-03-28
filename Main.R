source("src/Functions.R")

#attention à déziper le fichier files.zip dans /input

nodes <- fread("input/nodesRP.csv")
links <- fread("input/linksRP.csv")
sbGeneal <- fread("input/sbGenealRP.csv")

#save.image("copy.Rdata")

#NUMF <- getNUMFAbyTaillMenage(14)
NUMF <- 32347
printNodes(NUMF)
printLinks(NUMF)
plotPedigree(NUMF)
#plotFamily(NUMF)
#plotGenealogy(NUMF, 6)
#plotFamilyPath(NUMF, 1,5)