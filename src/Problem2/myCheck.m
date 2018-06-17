function flag=myCheck(x)
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


if(size(x,2)==8) % full matrix check
    s=[1,2,7,8];
    t=3:6;
    mh1=reshape(x(:,s),1,[]);
    mh2=reshape(x(:,t),1,[]);
    room1=repelem(s,8);
    room2=repelem(t,8);nrow=repmat(1:8,1,4);
    [mh1,index1]=sort(mh1);room1=room1(index1);
    [mh2,index2]=sort(mh2);room2=room2(index2);nrow=nrow(index2);
    room1(room1==7)=10;room1(room1==8)=11;
    
    group1=[3,4,6,8];
    group2=[3,5,7,9];
    roomNext2=zeros(size(room2));
    
    % 分配房间
    room2(room2==6 & mod(nrow,2)==1)=8;
    room2(room2==5 & mod(nrow,2)==1)=6;
    room2(room2==4 & mod(nrow,2)==1)=4;
    room2(room2==6 & mod(nrow,2)==0)=9;
    room2(room2==5 & mod(nrow,2)==0)=7;
    room2(room2==4 & mod(nrow,2)==0)=5;
    
    % 寻找下一个房间
    for i=1:length(room2)
        if(mod(nrow(i),2)==1)
            index=find(group1==room2(i));
            if(index<4)
                roomNext2(i)=group1(index+1);
            else
                roomNext2(i)=10;
            end
        else
            index=find(group2==room2(i));
            if(index<4)
                roomNext2(i)=group2(index+1);
            else
                roomNext2(i)=10;
            end
        end
    end
    
    % 检查机械手2的约束
    flag2=1;
    temp2=zeros(1,length(mh2)-1);
    for i=1:(length(mh2)-1)
        temp2(i)=T(room2(i),roomNext2(i))+2+T(roomNext2(i),room2(i+1));
        if((mh2(i+1)-mh2(i))<temp2(i))
            flag2=0;
        end
    end
    
    % 检查机械手1的约束
    flag1=1;
    temp1=zeros(1,length(mh1)-1);
    for i=1:(length(mh1)-1)
        temp1(i)=T(room1(i),room1(i)+1)+2+T(room1(i)+1,room1(i+1));
        if((mh1(i+1)-mh1(i))<temp1(i))
            flag1=0;
        end
    end
    flag=flag1 & flag2;
end
end


