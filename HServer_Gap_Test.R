siteChoice = "Air Quality at Taihape"
startDate = "28-03-2019 00:00:00"
endDate = "28-03-2019 12:00:00"


library(Hilltop)

htsServer <- HilltopData("http://hilltopdev.horizons.govt.nz/boo.hts")
hilltop <- GetData(htsServer, siteChoice, "PM10 [BAM PM10]", startDate, endDate)
disconnect(htsServer)

plot(hilltop, main = "Hilltop Package")
head(hilltop, 15)


library(HilltopServer)

htsServer <- HilltopServer("http://hilltopdev.horizons.govt.nz/boo.hts")
hilltopserver <- GetData(htsServer, siteChoice, "PM10 [BAM PM10]", startDate, endDate)
disconnect(htsServer)

plot(hilltopserver, main = "HilltopServer Package")
head(hilltopserver, 15)



library(XML)
url <-  paste("http://hilltopdev.horizons.govt.nz/boo.hts?service=Hilltop&request=GetData&Site=",
              siteChoice,
              "&Measurement=PM10 [BAM PM10]&From=",
              startDate,
              "&To=",
              endDate,sep="")

getData.xml <- xmlInternalTreeParse(paste(url))

ts_value <- sapply(getNodeSet(getData.xml, paste("//Hilltop/Measurement[@SiteName='",siteChoice,"']/Data/E/../E/I1",sep="")), xmlValue)
ts_date <- sapply(getNodeSet(getData.xml, paste("//Hilltop/Measurement[@SiteName='",siteChoice,"']/Data/E/../E/T",sep="")), xmlValue)

ts_date <- gsub(x = ts_date, pattern = "T", replacement = " ")
ts_date_2 <- as.POSIXct(ts_date, tz = "UTC")

ts_value <-as.numeric(ts_value)

xml <- zoo(ts_value, order.by = ts_date_2)

plot(xml, main = "XML Parse")
head(xml, 15)


data <- merge(hilltop, hilltopserver, xml)
