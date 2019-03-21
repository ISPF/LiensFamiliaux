library(RODBC)
myconn <-odbcConnect("INED")
Liens <- sqlFetch(myconn, "EE.NKL_Liens")
nodesEE <- sqlFetch(myconn, "EE.vNodes")
nodesRP <- sqlFetch(myconn, "RP.BI")
linksEE <- sqlFetch(myconn, "EE.vLinks")
linksRP <- sqlFetch(myconn, "RP.Liens")
sbGenealEE <- sqlFetch(myconn, "EE.vGenealogy")
sbGenealRP <- sqlFetch(myconn, "RP.vGenealogy")
close(myconn)
rm(myconn)

#max(nodes$ID)

nodesRP$ID <- 10000+nodesRP$ID
linksRP$IDFROM <- 10000+linksRP$IDFROM
linksRP$IDTO <- 10000+linksRP$IDTO
sbGenealRP$id <- 10000+sbGenealRP$id

write.csv2(Liens, "input/Liens.csv", row.names = F)
write.csv2(nodesEE, "input/nodesEE.csv", row.names = F)
write.csv2(linksEE, "input/linksEE.csv", row.names = F)
write.csv2(sbGenealEE, "input/sbGenealEE.csv", row.names = F)
write.csv2(nodesRP, "input/nodesRP.csv", row.names = F)
write.csv2(linksRP, "input/linksRP.csv", row.names = F)
write.csv2(sbGenealRP, "input/sbGenealRP.csv", row.names = F)