rm(list = ls())
dat=read.table("result.txt",header = F,sep = ",")
dat=as.matrix(dat)
time=sort(dat)


o=order(dat)
column=ceiling(o / 8)
row=o %% 8
row[row==0]=8

ind=(time==0 & column!=1)
time=time[!ind];column=column[!ind];row=row[!ind]
len=length(time)

hand=ifelse(column %in% c(1,2,10,11),1,2)

group1=c(1,2,3,4,6,8,9,10,11)
group2=c(1,2,3,4,5,7,8,10,11)
roomNext=column+1;
for (i in 1:length(column)){
    if(row[i] %% 2==0){
        ind=which(group1==column[i])
        roomNext[i]=ifelse(ind<9,group1[ind+1],12)
    }else{
        ind=which(group2==column[i])
        roomNext[i]=ifelse(ind<9,group2[ind+1],12)
    }
}
room=c("In","Pre","Buffer","P1","P2","P3","P4","P5","P6","Buffer","Post","Out")

ans=character(len)
for (i in 1:len){
    if(row[i] %% 2==0){
        mid=paste0("R",hand[i],"将产品C",row[i]/2,"由",room[column[i]],"传递到",room[roomNext[i]])
        ans[i]=paste(i,"&",mid,"&",time[i],"\\\\") 
    }else{
        mid=paste0("R",hand[i],"将产品D",(row[i]+1)/2,"由",room[column[i]],"传递到",room[roomNext[i]])
        ans[i]=paste(i,"&",mid,"&",time[i],"\\\\") 
    }
    
}
write(ans,file="release.txt")


