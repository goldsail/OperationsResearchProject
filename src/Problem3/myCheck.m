clear all;
clc;
dat=xlsread('temp.xlsx');
T=[0,1,2,0,0,0,0,0,0,2,3;
   3,0,1,0,0,0,0,0,0,1,2;
   2,3,0,1,2,3,4,5,6,0,1;
   0,0,6,0,1,2,3,4,5,0,0;
   0,0,5,6,0,1,2,3,4,0,0;
   0,0,4,5,6,0,1,2,3,0,0;
   0,0,3,4,5,6,0,1,2,0,0;
   0,0,2,3,4,5,6,0,1,0,0;
   0,0,1,2,3,4,5,6,0,1,0;
   2,3,0,0,0,0,0,0,0,0,1;
   1,2,3,0,0,0,0,0,0,3,0];
T(10,:)=T(3,:);
T(:,10)=T(:,3);
T(12,:)=T(1,:);
T(:,12)=T(:,1);

x=reshape(dat,11,8)';
s=[1,2,10,11];
t=3:9;
mh1=reshape(x(:,s),1,[]);
mh2=reshape(x(:,t),1,[]);
room1=repelem(s,8);
room2=repelem(t,8);
nrow1=repmat(1:8,1,4);nrow2=repmat(1:8,1,7);
[mh1,index1]=sort(mh1);room1=room1(index1);nrow1=nrow1(index1);
[mh2,index2]=sort(mh2);room2=room2(index2);nrow2=nrow2(index2);
ind=(mh2~=0);
mh2=mh2(ind);room2=room2(ind);nrow2=nrow2(ind);

% 检查机械手1约束
errorPos1=[];
flag1=1;
temp1=zeros(1,length(mh1)-1);
for i=1:(length(mh1)-1)
    temp1(i)=T(room1(i),room1(i)+1)+2+T(room1(i)+1,room1(i+1));
    if((mh1(i+1)-mh1(i))<temp1(i))
        flag1=0;
        errorPos1=[errorPos1,i];
    end
end

% 检查机械手2约束
group1=[3,4,6,8,9];
group2=[3,4,5,7,8];
roomNext2=zeros(size(room2));
for i=1:length(room2)
    if(nrow2(i)<=4)
        index=find(group1==room2(i));
        if(index<5)
            roomNext2(i)=group1(index+1);
        else
            roomNext2(i)=10;
        end
    else
        index=find(group2==room2(i));
        if(index<5)
            roomNext2(i)=group2(index+1);
        else
            roomNext2(i)=10;
        end
    end
end
errorPos2=[];
flag2=1;
temp2=zeros(1,length(mh2)-1);
for i=1:(length(mh2)-1)
    temp2(i)=T(room2(i),roomNext2(i))+2+T(roomNext2(i),room2(i+1));
    if((mh2(i+1)-mh2(i))<temp2(i))
        flag2=0;
        errorPos2=[errorPos2,i];
    end
end

if(flag1~=1)
    disp('机械手1约束违背：(行,列,当前时间，下一时刻时间，最小间隔)')
    [nrow1(errorPos1)',room1(errorPos1)',mh1(errorPos1)',mh1(errorPos1+1)',temp1(errorPos1)']
end

if(flag2~=1)
    disp('机械手2约束违背：(行,列,当前时间，下一时刻时间，最小间隔)')
    [nrow2(errorPos2)',room2(errorPos2)',mh2(errorPos2)',mh2(errorPos2+1)',temp2(errorPos2)']
end

if(flag1 && flag2)
	disp('通过了！！！您真强！')
end



