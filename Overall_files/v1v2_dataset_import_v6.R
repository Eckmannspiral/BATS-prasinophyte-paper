## ----setup, include=FALSE------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE)


## ---- echo = TRUE, message = FALSE,warning = FALSE-----------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(RColorBrewer)
library(ggplot2)
library(lubridate) #for ODV plot
library(reshape2) #for ODV plot
library(MBA) #for ODV plot
library(mgcv) #for ODV plot

library(patchwork)

#logical arguments
`%notin%` <- Negate(`%in%`)

round_any = function(x, accuracy, f=round){f(x/ accuracy) * accuracy}
#thanks to Holger Brandl from stackoverflow for this plyr workaround!

## ---- message=FALSE, warning=FALSE---------------------------------------------------------------------------------------------

cyanoplastid <- read_tsv("rep_cyano_plastid_seqs.fasta.aln.jplace.tab") %>%
  select(name, taxon) %>%
  mutate(taxon = replace_na(taxon, "cyanoplastid_na")) %>%
  rename(cyanoplastid = taxon)

viridi <- read_tsv("rep_viridi_seqs.fasta.aln.jplace.tab2.txt") %>%
  select(name, taxon) %>%
  mutate(taxon = replace_na(taxon, "viridi_na")) %>%
  rename(viridi = taxon)

strameno <- read_tsv("rep_strameno_seqs.fasta.aln.jplace.tab")  %>%
  select(name, taxon) %>%
  mutate(taxon = replace_na(taxon, "strameno_na")) %>%
  rename(strameno = taxon)

pelago <- read_tsv("rep_pelago_seqs.fasta.aln.jplace.tab") %>%
  select(name, taxon) %>%
  mutate(taxon = replace_na(taxon, "pelago_na")) %>%
  rename(pelago = taxon)

dictyo <- read_tsv("rep_dictyo_seqs.fasta.aln.jplace.tab") %>%
  select(name, taxon) %>%
  mutate(taxon = replace_na(taxon, "dictyo_na")) %>%
  rename(dictyo = taxon)

feature <- read_tsv("feature_table.tsv") %>%
  rename(name = seqname) %>%
  rename_all(funs(str_remove(.,"_L001_R1_001.fastq"))) %>% # modifying V1V2_ID (which is column name at this point)
  rename_all(funs(str_remove(.,"X672."))) %>% # modifying V1V2_ID (which is column name at this point)
  full_join(cyanoplastid, by = "name") %>%
  full_join(viridi, by = "name") %>%
  full_join(strameno, by = "name") %>%
  full_join(pelago, by = "name") %>%
  full_join(dictyo, by =  "name") %>%
  relocate(cyanoplastid,viridi,strameno,pelago,dictyo)  %>%
  pivot_longer(cols = C4_1_S25:`BS.96b_S152`,
               names_to = "V1V2_ID", values_to = "copies") %>%
  mutate(V1V2_ID = gsub("X1","1",V1V2_ID),  #correct names to match with metadata
         V1V2_ID = gsub("\\.","_",V1V2_ID))

metadata <- read_excel("/Users/ceckmann/Desktop/bats_2016_2019/processed_data/data_fig6/BATS_BS_COMBINED_MASTER_2021.12.17.xlsx",sheet = 6) %>%
  separate_rows(V1V2_ID,sep = ";") %>%
  relocate(V1V2_ID) %>%
  #na_if("-999.0") %>% #convert character -999.0 to NA
  #na_if(-999) %>% #convert -999 to NA
  #updated R and this broke :/
  select(which(colMeans(is.na(.)) < 1)) %>% #removing every col that is all NA
  filter(!is.na(yyyymmdd),
         !is.na(`time(UTC)`)) %>%
  mutate(date = as.Date(as.character(yyyymmdd),format="%Y%m%d", ordered = T),
         time = gsub("([0-9])([0-9])([0-9])$", "\\1:\\2\\3" , `time(UTC)`), # first time column transformation
         time = gsub("(^[0-9]):", "0\\1:" , time), # second time column transformation
         year = as.factor(format(date, "%Y")),
         month = as.factor(format(date, "%m")),
         date_time = as.character(paste(date, time), format="%m-%d-%Y %H:%M")) # as.character essential, doesn't work 

metadata[metadata == -999] <- NA

pigments <- read_excel("/Users/ceckmann/Desktop/bats_2016_2019/metadata/chl_data/og_bats_pigments_data/bats_pigments.xlsx") %>%
  #na_if("-999.0") %>% #convert character -999.0 to NA
  #na_if(-999) %>% #convert -999 to NA
  select(which(colMeans(is.na(.)) < 1)) #%>% #removing every col that is all NA
#filter(!is.na(yyyymmd)) %>%
#mutate(date = as.Date(as.character(yyyymmd),format="%Y%m%d", ordered = T),
#year = as.factor(format(date, "%Y")),
#month = as.factor(format(date, "%m")),
#date_time = as.character(paste(date, time), format="%m-%d-%Y %H:%M")) # as.character essential, doesn't work 

pigments[pigments == -999] <- NA

#just keep Chl column and ID for matching

pigments2 <- pigments %>% select(New_ID, Chl)

#metadata table is missing some data that is from the BATS website (bats_pigments.txt, bats_bottle.txt)

metadata_pigments <- left_join(metadata, pigments2, by= "New_ID")

#replace NAs in og Chl column with those in new dataframe

metadata_pigments2 <- metadata_pigments %>% mutate(Chl = coalesce(Chl.x,Chl.y))

bottle <- read_excel("/Users/ceckmann/Desktop/bats_2016_2019/metadata/nutrients/og_bats_bottle/bats_bottle.xlsx") %>%
  #na_if("-999.0") %>% #convert character -999.0 to NA
  #na_if(-999) %>% #convert -999 to NA
  select(which(colMeans(is.na(.)) < 1)) #%>% #removing every col that is all NA
#filter(!is.na(yyyymmdd)) %>%
#mutate(date = as.Date(as.character(yyyymmdd),format="%Y%m%d", ordered = T),
#year = as.factor(format(date, "%Y")),
#month = as.factor(format(date, "%m")),
#date_time = as.character(paste(date, time), format="%m-%d-%Y %H:%M")) # as.character essential, doesn't work 

bottle[bottle == -999] <- NA

bottle2 <- bottle %>% select(New_ID, NO31, PO41, POC)

metadata_pigments_bottle <- left_join(metadata_pigments2, bottle2, by= "New_ID")

#now read in primary production data from Craig Carlson's datasheet

pp <- read_excel("/Users/ceckmann/Desktop/bats_2016_2019/metadata/primary_production/og_data_cjc/BATS_PP_2016_2020.xlsx") %>%
  #na_if("-999.0") %>% #convert character -999.0 to NA
  #na_if(-999) %>% #convert -999 to NA
  select(which(colMeans(is.na(.)) < 1)) #%>% #removing every col that is all NA

pp[pp == -999] <- NA

pp2 <- pp %>% select(New_ID, `Mean Light-dark (mgC/m3/d) no neg values`)

metadata_pigments_bottle_pp <- left_join(metadata_pigments_bottle, pp2, by= "New_ID")

metadata_pigments_bottle2 <- metadata_pigments_bottle_pp %>% mutate(`NO3+NO2(umol/kg)` = coalesce(`NO3+NO2(umol/kg)`,NO31)) %>% 
  mutate(`PO4(umol/kg)` = coalesce(`PO4(umol/kg)`,PO41)) %>% 
  mutate(`POC (ug/kg)` = coalesce(`POC (ug/kg)`,POC)) %>% 
  mutate(`pp(mgC/m^3/day)` = coalesce(`pp(mgC/m^3/day)`,`Mean Light-dark (mgC/m3/d) no neg values`))

#CTD data

ctd_data <- read_excel("/Users/ceckmann/Desktop/bats_2016_2019/metadata/ctd_data/2016_to_2019_ctd_data.xlsx") %>%
  #na_if("-999.0") %>% #convert character -999.0 to NA
  #na_if(-999) %>% #convert -999 to NA
  select(which(colMeans(is.na(.)) < 1)) #%>% #removing every col that is all NA

ctd_data[ctd_data == -999] <- NA

#start it at same date as the other "ODV" plots

#ctd_data = ctd_data[ctd_data$decy >= 2016.5212,]

#get rid of outlier profile (very low temp and sal)

ctd_data <-ctd_data[!(ctd_data$BATS_id== 91703001),] 

#since no NEW_ID, match by decy and depth

#first round depth 

ctd_data$Depth <- round_any(ctd_data$Depth, 1)

ctd_data <- ctd_data %>% select(BATS_id, decy, Depth, Fluor)

metadata_pigments_bottle2$Depth <- round_any(metadata_pigments_bottle2$Depth, 1)

metadata_pigments_bottle3 <- left_join(metadata_pigments_bottle2, ctd_data, by= c("decy", "Depth"))

metadata_pigments_bottle3 <- metadata_pigments_bottle3 %>% mutate(`Fluo(RFU)` = coalesce(`Fluo(RFU)`,Fluor))

#get rid of now-redundant columns

metadata_new = subset(metadata_pigments_bottle3, select = -c(Chl.y, Chl.x, NO31, PO41, POC, Fluor) )

#get only samples in date range of this project

metadata_new = metadata_new[metadata_new$decy >= 2016.5212,]
