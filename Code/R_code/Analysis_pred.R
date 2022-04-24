###########################################################
###                INTERPRETATION SRIPT                 ###
### This code is designed to make use of BERT           ###
### classification (sentiment) for tweets of french MPs ###
###               Mathis SANSU - 23/04/2022             ###
###########################################################

# Libraries

library(ggplot2)
library(dplyr)
library(data.table)
library(ggthemes)
library(xtable)
library(nnet)
library(stargazer)

#########################
### LOCKDOWN
#########################

#Data
df <- read.csv("C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\Tweets_sample_confinement_pred.csv",encoding = "UTF-8")


# Plot ratios of sentiment by date
df$pred <- as.character(df$pred)
df$date <- as.Date(df$date)
data_plot <- df %>% count(date,pred)
data_plot2 <- df %>% count(date)
setnames(data_plot2,"n","n_tot")
data_plot <- data_plot %>% full_join(data_plot2, by = c("date"))
data_plot$n_ratio <- data_plot$n / data_plot$n_tot
ggplot(data = data_plot, aes(x=date, y=n_ratio)) +
  geom_point(aes(colour = pred),alpha =0.5) +
  geom_line(aes(colour = pred)) +
  xlab("") + ylab("Ratio") +
  theme_hc()+
  scale_color_manual("Sentiment",values=c("black","blue","red"),
                     labels=c("Other","Positive","Negative"))
ggsave("C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\ratio_sentiment_confinement.png")


# Cross table of sentiment ratio and gender
tab <- cbind(prop.table(addmargins(table(df$sexe,df$pred),1),1),
      c(margin.table(table(df$sexe,df$pred),1),sum(table(df$sexe,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab) <- c("Women","Men","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to gender", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_confinement.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and political group
tab <- cbind(prop.table(addmargins(table(df$groupe_sigle,df$pred),1),1),
             c(margin.table(table(df$groupe_sigle,df$pred),1),sum(table(df$groupe_sigle,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)[9] <- c("Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to political group", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_confinement.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and age group
tab <- cbind(prop.table(addmargins(table(df$age_group,df$pred),1),1),
             c(margin.table(table(df$age_group,df$pred),1),sum(table(df$age_group,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)<-c("24-34","35-44","45-54","55-64","65+","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to age group", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_confinement.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and number of mandates
tab <- cbind(prop.table(addmargins(table(df$nb_mandats,df$pred),1),1),
             c(margin.table(table(df$nb_mandats,df$pred),1),sum(table(df$nb_mandats,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)<-c("1","2","3","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to number of mandates", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_confinement.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Multinomial Logistic Regression
# Setting reference levels
df$pred <- as.factor(df$pred)
df$pred2 <- relevel(df$pred, ref = "0")
df$sexe <- relevel(as.factor(df$sexe), ref = "M")
df$groupe_sigle <- relevel(as.factor(df$groupe_sigle), ref = "LREM")
df$majo <- relevel(as.factor(df$majo), ref = "True")
# Regression
multinom.fit <- multinom(pred2 ~ sexe + age + nb_mandats + groupe_sigle + majo, data = df)
# Checking the model
summary(multinom.fit)
# Export the model
stargazer(multinom.fit, type="latex", title="Multinomial Logistic Regression on tweet sentiment",
          dep.var.labels=c("Positive","Negative"),
          covariate.labels=c("Women","Age","Nb. mandates","Group GDR", "Group LFI","Group LR","Group MODEM",
                             "Group NG","Group NI","Group UAI","Not in majority"),
          align=TRUE, no.space=TRUE,
          out="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\multinom_confinement.tex")
          

#########################
### BENALLA
#########################

#Data
df <- read.csv("C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\Tweets_sample_benalla_pred.csv",encoding = "UTF-8")
df <- df[as.Date(df$date) < "2018-05-16" & as.Date(df$date) > '2018-04-30',]


# Plot ratios of sentiment by date
df$pred <- as.character(df$pred)
df$date <- as.Date(df$date)
data_plot <- df %>% count(date,pred)
data_plot2 <- df %>% count(date)
setnames(data_plot2,"n","n_tot")
data_plot <- data_plot %>% full_join(data_plot2, by = c("date"))
data_plot$n_ratio <- data_plot$n / data_plot$n_tot
ggplot(data = data_plot, aes(x=date, y=n_ratio)) +
  geom_point(aes(colour = pred),alpha =0.5) +
  geom_line(aes(colour = pred)) +
  xlab("") + ylab("Ratio") +
  theme_hc()+
  scale_color_manual("Sentiment",values=c("black","blue","red"),
                     labels=c("Other","Positive","Negative"))
ggsave("C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\ratio_sentiment_benalla.png")


# Cross table of sentiment ratio and gender
tab <- cbind(prop.table(addmargins(table(df$sexe,df$pred),1),1),
             c(margin.table(table(df$sexe,df$pred),1),sum(table(df$sexe,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab) <- c("Women","Men","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to gender", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_benalla.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and political group
tab <- cbind(prop.table(addmargins(table(df$groupe_sigle,df$pred),1),1),
             c(margin.table(table(df$groupe_sigle,df$pred),1),sum(table(df$groupe_sigle,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)[9] <- c("Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to political group", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_benalla.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and age group
tab <- cbind(prop.table(addmargins(table(df$age_group,df$pred),1),1),
             c(margin.table(table(df$age_group,df$pred),1),sum(table(df$age_group,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)<-c("24-34","35-44","45-54","55-64","65+","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to age group", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_benalla.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and number of mandates
tab <- cbind(prop.table(addmargins(table(df$nb_mandats,df$pred),1),1),
             c(margin.table(table(df$nb_mandats,df$pred),1),sum(table(df$nb_mandats,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)<-c("1","2","3","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to number of mandates", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_benalla.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Multinomial Logistic Regression
# Setting reference levels
df$pred <- as.factor(df$pred)
df$pred2 <- relevel(df$pred, ref = "0")
df$sexe <- relevel(as.factor(df$sexe), ref = "M")
df$groupe_sigle <- relevel(as.factor(df$groupe_sigle), ref = "LREM")
df$majo <- relevel(as.factor(df$majo), ref = "True")
# Regression
multinom.fit <- multinom(pred2 ~ sexe + age + nb_mandats + groupe_sigle + majo, data = df)
# Checking the model
summary(multinom.fit)
# Export the model
stargazer(multinom.fit, type="latex", title="Multinomial Logistic Regression on tweet sentiment",
          dep.var.labels=c("Positive","Negative"),
          covariate.labels=c("Women","Age","Nb. mandates","Group GDR", "Group LFI","Group LR","Group MODEM",
                             "Group NG","Group NI","Group UAI","Not in majority"),
          align=TRUE, no.space=TRUE,
          out="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\multinom_benalla.tex")



#########################
### CDM
#########################

#Data
df <- read.csv("C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\Tweets_sample_CDM_pred.csv",encoding = "UTF-8")
df <- df[as.Date(df$date) < "2018-07-21" & as.Date(df$date) > '2018-07-09',]


# Plot ratios of sentiment by date
df$pred <- as.character(df$pred)
df$date <- as.Date(df$date)
data_plot <- df %>% count(date,pred)
data_plot2 <- df %>% count(date)
setnames(data_plot2,"n","n_tot")
data_plot <- data_plot %>% full_join(data_plot2, by = c("date"))
data_plot$n_ratio <- data_plot$n / data_plot$n_tot
ggplot(data = data_plot, aes(x=date, y=n_ratio)) +
  geom_point(aes(colour = pred),alpha =0.5) +
  geom_line(aes(colour = pred)) +
  xlab("") + ylab("Ratio") +
  theme_hc()+
  scale_color_manual("Sentiment",values=c("black","blue","red"),
                     labels=c("Other","Positive","Negative"))
ggsave("C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\ratio_sentiment_CDM.png")


# Cross table of sentiment ratio and gender
tab <- cbind(prop.table(addmargins(table(df$sexe,df$pred),1),1),
             c(margin.table(table(df$sexe,df$pred),1),sum(table(df$sexe,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab) <- c("Women","Men","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to gender", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_CDM.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and political group
tab <- cbind(prop.table(addmargins(table(df$groupe_sigle,df$pred),1),1),
             c(margin.table(table(df$groupe_sigle,df$pred),1),sum(table(df$groupe_sigle,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)[9] <- c("Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to political group", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_CDM.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and age group
tab <- cbind(prop.table(addmargins(table(df$age_group,df$pred),1),1),
             c(margin.table(table(df$age_group,df$pred),1),sum(table(df$age_group,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)<-c("24-34","35-44","45-54","55-64","65+","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to age group", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_CDM.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Cross table of sentiment ratio and number of mandates
tab <- cbind(prop.table(addmargins(table(df$nb_mandats,df$pred),1),1),
             c(margin.table(table(df$nb_mandats,df$pred),1),sum(table(df$nb_mandats,df$pred))))
colnames(tab) <- c("Other", "Positive","Negative","Total")
rownames(tab)<-c("1","2","3","Total")
tab <- xtable(tab, caption= "Ratio of tweets by sentiment classified according to number of mandates", 
              align=c("c","||c","|c","|c","|c"))
print(tab,file="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\tab_sentiment_CDM.tex",
      append=T,table.placement = "h", caption.placement="bottom",
      hline.after=seq(from=-1,to=nrow(tab),by=1))

# Multinomial Logistic Regression
# Setting reference levels
df$pred <- as.factor(df$pred)
df$pred2 <- relevel(df$pred, ref = "0")
df$sexe <- relevel(as.factor(df$sexe), ref = "M")
df$groupe_sigle <- relevel(as.factor(df$groupe_sigle), ref = "LREM")
df$majo <- relevel(as.factor(df$majo), ref = "True")
# Regression
multinom.fit <- multinom(pred2 ~ sexe + age + nb_mandats + groupe_sigle + majo, data = df)
# Checking the model
summary(multinom.fit)
# Export the model
stargazer(multinom.fit, type="latex", title="Multinomial Logistic Regression on tweet sentiment",
          dep.var.labels=c("Positive","Negative"),
          covariate.labels=c("Women","Age","Nb. mandates","Group GDR", "Group LFI","Group LR","Group MODEM",
                             "Group NG","Group NI","Group UAI","Not in majority"),
          align=TRUE, no.space=TRUE,
          out="C:\\Users\\mthsa\\Desktop\\SQD_DSSS\\S2\\MLNLP\\multinom_CDM.tex")
