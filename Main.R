source("src/Functions.R")

nodes <- fread("input/nodesRP.csv")
links <- fread("input/linksRP.csv")
sbGeneal <- fread("input/sbGenealRP.csv")

save.image("copy.Rdata")

#listFamillesAObserver <- c(2,5,8,9,51,86,87,127,130,149,150,151)
#listFamilles<-c(141702,141705,141715,141716,150185,150461,150463,150761,150772,150933,150951,150971)
#NUMF <- 161592
#EE NUMF <- 150185

NUMF <- getNUMFAbyTaillMenage(14)
printNodes(NUMF)
printLinks(NUMF)
plotFamily(NUMF)

plotFamily(getNUMFAbyTaillMenage(5))

printNodes(NUMF)
printLinks(NUMF)
printAllDetail(NUMF)
plotFamily(NUMF)
plotGenealogy(NUMF, 7)
plotGenealogy(NUMF, 5)
plotFamilyPath(NUMF, 1,4)
plotFamilyPath(NUMF, 1,5)