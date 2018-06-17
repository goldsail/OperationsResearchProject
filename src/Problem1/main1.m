clear all;
clc;

% 约束1
p=[240,300,360,390,270,330];
A1=zeros(48,56);
A1temp=eye(7)+diag(-ones(1,6),1);
A1temp=A1temp(1:6,:);
A1=blkdiag(A1temp,A1temp,A1temp,A1temp,A1temp,A1temp,A1temp,A1temp);
b1=(-repmat(p,1,8)-3)';

% 约束2
A2=zeros(42,56);
for m=1:7
    for i=1:6
        row=6*(m-1)+i;
        index1=7*(m-1)+i+1;
        index2=7*(m)+i;
        A2(row,index1)=1;
        A2(row,index2)=-1;
    end
end
b2=-8 * ones(42,1);

% 约束3
A3=zeros(4,56);
A3(1,1)=1;
A3(2,7)=1;A3(2,36)=-1;
A3(3,14)=1;A3(3,43)=-1;
A3(4,21)=1;A3(4,50)=-1;
b3=[0,-11,-11,-11]';

A=[A1;A2;A3];
b=[b1;b2;b3];

m=zeros(56,1);m(56)=1;
options = optimoptions('intlinprog','Display','off');

tic
x=intlinprog(m,1:56,A,b,[],[],zeros(56,1),[],[],options);% R2017b professional
% x=intlinprog(m,1:56,A,b,[],[],zeros(56,1),[],options); % R2017a academic
% x=linprog(m,A,b,[],[],zeros(56,1));%经过实验整数线性规划计算收敛更快
toc

xmid=reshape(x,7,8)';
xmid=xmid+66;
% R2 的矩阵可以单独检验是否满足非线性约束
% flag=myCheck(xmid);
% if(flag)
%     disp('符合机械手非线性约束')
% else
%     disp('不符合机械手非线性约束')
% end

% 补充机械手1的部分
result=zeros(8,11);
result(:,3:9)=xmid;
for n=1:8
    result(n,2)=result(n,3)-3;
    result(n,1)=result(n,2)-63;
    result(n,10)=result(n,9)+3;
    result(n,11)=result(n,10)+103;
end

% 检查机械手的非线性约束
flag=myCheck(result);
if(flag)
    disp('符合机械手非线性约束')
else
    disp('不符合机械手非线性约束')
end

final=result(88)+3;
disp(['总时间为 ',num2str(final),' 秒'])
disp(['调度方案为：'])
result





