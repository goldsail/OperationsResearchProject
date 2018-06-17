clear all;clc;

p=[500,660,570];
T1=[0,1,3,5;
    6,0,2,4;
    4,5,0,2;
    2,3,5,0];
T2=[0,2,4,6;
    5,0,2,4;
    3,5,0,2;
    1,3,5,0];
T1(:,5)=T1(:,1);
T1(5,:)=T1(1,:);
T2(:,5)=T2(:,1);
T2(5,:)=T2(1,:);

% 约束1
A1=zeros(24,32);
A1temp=eye(4)+diag(-ones(1,3),1);
A1temp=A1temp(1:3,:);
A1=blkdiag(A1temp,A1temp,A1temp,A1temp,A1temp,A1temp,A1temp,A1temp);
temp=diag(T1,1);
b1temp1=p+temp(1:3)'+2;
temp=diag(T2,1);
b1temp2=p+temp(1:3)'+2;
b1temp=[b1temp1,b1temp2];
b1=(-repmat(b1temp,1,4))';

% 约束2
A2=zeros(18,32);
for m=1:6
    for i=1:3
        row=3*(m-1)+i;
        index1=4*(m-1)+i+1;
        index2=4*(m+1)+i;
        A2(row,index1)=1;
        A2(row,index2)=-1;
    end
end
b2temp1=zeros(3,1);
for i=1:3
    b2temp1(i)=2+T1(i+1,i+2)+T1(i+2,i);
end
b2temp2=zeros(3,1);
for i=1:3
    b2temp2(i)=2+T2(i+1,i+2)+T2(i+2,i);
end
b2temp=[b2temp1;b2temp2];
b2=(-repmat(b2temp,3,1));

A3=zeros(9,32);
for m=1:7
    index1=4*(m-1)+1;
    index2=4*m+1;
    A3(m,index1)=1;
    A3(m,index2)=-1;
end
A3(8,1)=1;
A3(9,8)=1;A3(9,25)=-1;
b3=[-68,-68,-68,-68,-68,-68,-68,0,-114]';

A=[A1;A2;A3];
b=[b1;b2;b3];
m=zeros(32,1);m(32)=1;
options = optimoptions('intlinprog','Display','off');

tic

x=intlinprog(m,1:32,A,b,[],[],zeros(32,1),[],[],options);% professional
%x=intlinprog(m,1:32,A,b,[],[],zeros(32,1),[],options);% academic
%x=linprog(m,A,b,[],[],zeros(32,1));

xmid=reshape(x,4,8)';
xmid=xmid+66;

% 补充机械手1部分
result=zeros(8,8);
result(:,3:6)=xmid;
for n=1:8
    result(n,2)=result(n,3)-3;
    result(n,1)=result(n,2)-63;
    if((mod(n,2))==1)
        result(n,7)=result(n,6)+T1(4,5)+2;
    else
        result(n,7)=result(n,6)+T2(4,5)+2;
    end
    if(n>1 && result(n,7)<result(n-1,8)+5)
        result(n,7)=result(n-1,8)+5;
    end
    result(n,8)=result(n,7)+103;
end

toc

flag=myCheck(result);
if(flag)
    disp('符合机械手非线性约束')
else
    disp('不符合机械手非线性约束')
end


final=result(64)+3;
disp(['总时间为 ',num2str(final),' 秒'])
disp(['调度方案为：'])
result
