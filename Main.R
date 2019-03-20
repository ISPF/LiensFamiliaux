source("src/Functions.R")

nodes <- setDT(read.csv2("input/nodes.csv", stringsAsFactors = F))
links <- setDT(read.csv2("input/links.csv", stringsAsFactors = F))
sbGeneal <- setDT(read.csv2("input/sbGeneal.csv", stringsAsFactors = F))

#listFamillesAObserver <- c(2,5,8,9,51,86,87,127,130,149,150,151)
#listFamilles<-c(141702,141705,141715,141716,150185,150461,150463,150761,150772,150933,150951,150971)
#NUMF <- 161592
NUMF <- 150185

printNodes(NUMF)
printLinks(NUMF)
printAllDetail(NUMF)
plotFamily(NUMF)
plotGenealogy(NUMF, 2)
plotGenealogy(NUMF, 5)
plotFamilyPath(NUMF, 1,2)
plotFamilyPath(NUMF, 1,5)