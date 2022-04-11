#-----------------------------------------------------#
#
#     Machine learning for NLP
#
#                               Mathis Sansu and Yasmine Houri
#                               Academic year 2021-2022
#
#-----------------------------------------------------#

library("plyr")
library("dplyr")
library("data.table")
library("tidyverse")

path <- "C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\"

df <- readRDS(paste0(path,"base_tweet_tot_2022-02-21"))

# Read in the data
list_indexes <- scan(paste0(path,"list_indexes.txt"), character(), quote = "")

df_1000_rand_full <- df[list_indexes,]
to_del <- c("entities","public_metrics","referenced_tweets","attachments",
            "geo","withheld","clustRFSP","clustVEP")
df_1000_rand_full <- select(df_1000_rand_full, -to_del)
write.csv(df_1000_rand_full,paste0(path,"df_1000_rand_full.csv"), fileEncoding = "utf-8")

# names(df)
# unique(df$type)
# data <- df %>% filter(type == "tweet")
# rem <- c("entities","public_metrics","referenced_tweets","attachments",
#          "geo","withheld")
# del <- c("conversation_id","id.x","author_id","in_reply_to_user_id","id_twi",
#       "type","pre.nom","id.y","nom_de_famille","prenom","sites_web","url_an",
#       "id_an","slug","url_nosdeputes","url_nosdeputes_api","age_group")
# data <- select(data,-rem)
# data <- select(data,-del)
# data <- select(data,-c("source","twitter.y"))
# 
# data <- read.csv2("C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\sample_rem_del_cols.csv")
# data <- select(data,-c("clustRFSP","clustVEP"))
# data <- data %>% filter(lang == "fr")
# data <- select(data,-c("profession"))
# write.csv2(data,"C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\sample_rem_del_cols.csv",
#            fileEncoding = "UTF-8")
# data_text <- data[,c("text","possibly_sensitive","created_at","twitter.x","sexe")]

data_text <- read.csv("C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\data_text.csv")
data_text$created_at <- as.Date(data_text$created_at)
data_text$year <- year(data_text$created_at)
data_2019_2020 <- data_text %>% filter(year %in% c("2019","2020"))

write.csv(data_text,"C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\data_text.csv",
          fileEncoding = "utf-8")
write.csv(data_2019_2020,"C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\data_2019_2020.csv",
          fileEncoding = "utf-8")

df_10000_rand <- df[sample(nrow(df), 10000), ]
write.csv(data_10000_rand,"C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\df_10000_rand.csv",
          fileEncoding = "utf-8")
df_2000_rand <- df[sample(nrow(df), 2000), ]
write.csv(data_10000_rand,"C:\\Users\\HP\\Documents\\cours_ensae\\3A\\MLNLP\\Project\\df_10000_rand.csv",
          fileEncoding = "utf-8")