rm(list = ls())
dat=read.table("result.txt",header = F,sep = ",")
dat=as.matrix(dat)
time=sort(dat)
len=length(time)

o=order(dat)
column=ceiling(o / 8)
row=o %% 8
row[row==0]=8

myClass=row %% 2

column[column==7]=10;column[column==8]=11;
column[column==6 & myClass==1]=8
column[column==5 & myClass==1]=6;
column[column==4 & myClass==1]=4;
column[column==6 & myClass==0]=9
column[column==5 & myClass==0]=7;
column[column==4 & myClass==0]=5;

roomNext=column+1
roomNext[column==3 && myClass==0]=5
roomNext[column %in% 4:8]=column[column %in% 4:8]+2

time=sort(dat)
hand=ifelse(column %in% c(1,2,10,11),1,2)
room=c("In","Pre","Buffer","P1","P2","P3","P4","P5","P6","Buffer","Post","Out")

ans=character(len)
for (i in 1:len){
    mid=paste0("R",hand[i],"将产品B",row[i],"由",room[column[i]],"传递到",room[roomNext[i]])
    ans[i]=paste(i,"&",mid,"&",time[i],"\\\\")
}
write(ans,file="release.txt")


