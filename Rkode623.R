#pakker
library(PxWebApiData)
library(tidyverse)

#hente data for sykefravær fra ssb api
Syk <- ApiData("https://data.ssb.no/api/v0/no/table/12441/", 
                Kjonn=list('item', c("1", "2")), 
                Tid=list('item', c("2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019")), 
                NACE2007=FALSE, 
                Sykefraver2=FALSE, 
                ContentsCode=TRUE)

Syk <- Syk[[1]] 

#hente data for ledighet fra ssb api
Ledig <- ApiData("https://data.ssb.no/api/v0/no/table/05111/", 
                 ArbStyrkStatus=list('item', c("2")), 
                 Kjonn=list('item', c("1", "2")), 
                 ContentsCode=list('item', c("Prosent")), 
                 Tid=list('item', c("2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019")), 
                 Alder=FALSE)

Ledig <- Ledig[[1]]

#kombinere data

data <- Ledig %>% 
  select(!statistikkvariabel) %>% 
  rename(statistikkvariabel = arbeidsstyrkestatus) %>% 
  bind_rows(Syk)

#fingur med arbeidsledighet og sykefravær over tid fordelt på kjønn, valgte å ikke bruke to y-akser da min forståelse er at det skal ungås og mener svingningen var synlige nok her  
ggplot(data, aes(år, value, group = statistikkvariabel, colour = statistikkvariabel)) +
  geom_line() +
  labs(caption = "Kilde: SSB", x = "År", y = "Prosent") +
  facet_wrap(~kjønn)
