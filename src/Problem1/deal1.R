rm(list = ls())
dat=read.table("result.txt",header = F,sep = ",")
dat=as.matrix(dat)
time=sort(dat)
len=length(time)

o=order(dat)
column=ceiling(o / 8)
row=o %% 8
row[row==0]=8

hand=ifelse(column %in% c(1,2,10,11),1,2)
room=c("In","Pre","Buffer","P1","P2","P3","P4","P5","P6","Buffer","Post","Out")

ans=character(len)
for (i in 1:len){
    mid=paste0("R",hand[i],"将产品A",row[i],"由",room[column[i]],"传递到",room[column[i]+1])
    ans[i]=paste(i,"&",mid,"&",time[i],"\\\\")
}
write(ans,file="release.txt")


