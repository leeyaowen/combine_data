library(sqldf)
library(dplyr)
library(magrittr)
library(stringr)
setwd("F:/google drive/森林動態研究室相關資料/南仁山2018-2019年計畫/欖仁溪/資料/欖仁溪電子輸入/輸入1/Line26")
filenames <- list.files(pattern = ".csv")
All<-lapply(filenames,function(i){
  read.csv(i,stringsAsFactors = FALSE)
})
df<-do.call(rbind.data.frame, All)
dt %<>% mutate_if(is.character,str_trim)
write.csv(df,"cline26.csv",row.names = FALSE)

dt<-read.csv("./cline26.csv")
tagcount<-sqldf("select tag,B,count(tag) from dt group by tag,B having count(tag)>1 order by count(tag) desc")
Y18dt<-sqldf("select * from dt where Status != '-5'")
colnames(Y18dt)[1]<-"x1"
colnames(Y18dt)[2]<-"y1"
colnames(Y18dt)[3]<-"x2"
colnames(Y18dt)[4]<-"y2"
colnames(Y18dt)[5]<-"tag"
colnames(Y18dt)[14]<-"odbh"
colnames(Y18dt)[16]<-"狀態18"
Y18dt$odbh<-as.numeric(as.character(Y18dt$odbh))
Y18dt %<>% mutate(.,ba=pi*(odbh/2)^2)
Y18dtdplyr<-Y18dt %>% group_by(tag) %>% mutate(.,sumba=sum(ba)) %>% filter(.,B==0) %>% mutate(.,dbh=2*sqrt(sumba/pi))
Y18plot<-select(Y18dtdplyr,x1,y1,x2,y2,tag,sp,dbh) %>% mutate(.,x3="",y3="")
write.csv(Y18plot,"line26forplot.csv",row.names = FALSE,quote = F)


# dt<-read.csv("./Lanjenchi5.88survey.csv")
# dup<-group_by(dt,Tag,B) %>% filter(.,n()>1) %>% arrange(.,Tag)
# du<-sqldf("select Tag,B,count(Tag) from dt group by Tag,B having count(Tag)>1 order by count(Tag) desc")
# 
# setwd("F:/google drive/森林動態研究室相關資料/南仁山2018年計畫/資料/欖仁溪電子輸入/輸入1/Line38 (1)")
# cdt<-read.csv("./cline38.csv",stringsAsFactors = FALSE)
# cdt<-trim(cdt)
# cline<-cdt %>% mutate(.,D05=ifelse(D05=="(-1)","-1",D05)) %>%
#   mutate(.,D05=ifelse(D05=="(-2)","-2",D05)) %>%
#   mutate(.,D05=ifelse(D05=="(-3)","-3",D05)) %>%
#   mutate(.,D05=ifelse(D05=="(-4)","-4",D05)) %>%
#   mutate(.,D05=ifelse(D05=="(-5)","-5",D05)) %>%
#   mutate(.,D13=ifelse(D13=="(-1)","-1",D13)) %>%
#   mutate(.,D13=ifelse(D13=="(-2)","-2",D13)) %>%
#   mutate(.,D13=ifelse(D13=="(-3)","-3",D13)) %>%
#   mutate(.,D13=ifelse(D13=="(-4)","-4",D13)) %>%
#   mutate(.,D13=ifelse(D13=="(-5)","-5",D13))
# write.csv(cline,"cline38.csv")
  
