setwd("F:/google drive/森林動態研究室相關資料/南仁山2018年計畫/資料/欖仁溪電子輸入/輸入1/Line38 (1)")
filenames <- list.files(pattern = ".csv")
All<-lapply(filenames,function(i){
  read.csv(i)
})
df<-do.call(rbind.data.frame, All)
write.csv(df,"cline38.csv",row.names = FALSE)

library(sqldf)
library(dplyr)
library(magrittr)
dt<-read.csv("./cline38.csv")
tagcount<-sqldf("select tag,count(tag) from dt group by tag,B having count(tag)>1 order by count(tag) desc")
Y18new<-sqldf("select * from dt where Tag like 'Y180%' order by Tag")
colnames(Y18new)[1]<-"x1"
colnames(Y18new)[2]<-"y1"
colnames(Y18new)[3]<-"x2"
colnames(Y18new)[4]<-"y2"
colnames(Y18new)[5]<-"tag"
colnames(Y18new)[12]<-"odbh"
colnames(Y18new)[14]<-"狀態18"
Y18new$odbh<-as.numeric(as.character(Y18new$odbh))
Y18new %<>% mutate(.,ba=pi*odbh^2)
y18newdplyr<-Y18new %>% group_by(tag) %>% mutate(.,sumba=sum(ba)) %>% filter(.,B==0) %>% mutate(.,dbh=sqrt(sumba/pi))
y18plot<-select(y18newdplyr,x1,y1,x2,y2,tag,sp,dbh) %>% mutate(.,x3="",y3="")
write.csv(y18plot,"line38forplot.csv",row.names = FALSE)
