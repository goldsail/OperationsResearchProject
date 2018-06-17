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

T2=T(3:9,3:9);
T2(8,:)=T2(1,:);
T2(:,8)=T2(:,1);

flag=1;
if(size(x,2)==7) % mid matrix check
    T=T2;
    for m=1:7
        for n=(m+1):8
            for i=2:7
                for j=1:(i-1)
                    if(x(m,i)<x(n,j) && x(m,i)+3+T(i+1,j)>x(n,j))
                        flag=0;
                    end
                    if(x(m,i)>x(n,j) && x(m,i)<x(n,j)+3+T(j+1,i))
                        flag=0;
                    end
                end
            end
        end
    end
end

if(size(x,2)==11) % full matrix check
    s=[1,2,10,11];
    t=3:9;
    for m=1:7
        for n=(m+1):8
            for i=2:4
                for j=1:(i-1)
%                     if(m==1 && i==3 && n==6 && j==2)
%                         x(m,s(i))
%                         x(n,s(j))
%                         x(m,s(i))<x(n,s(j))
%                         x(m,s(i))+3+T(s(i)+1,s(j))>x(n,s(j))
%                     end % for yqy debug
                    if(x(m,s(i))<x(n,s(j)) && x(m,s(i))+3+T(s(i)+1,s(j))>x(n,s(j)))
                        flag=0;
                    end
                    if(x(m,s(i))>x(n,s(j)) && x(m,s(i))<x(n,s(j))+3+T(s(j)+1,s(i)))
                        flag=0;
                    end
                end
            end
            for i=2:7
                for j=1:(i-1)
                    if(x(m,t(i))<x(n,t(j)) && x(m,t(i))+3+T(t(i)+1,t(j))>x(n,t(j)))
                        flag=0;
                    end
                    if(x(m,t(i))>x(n,t(j)) && x(m,t(i))<x(n,t(j))+3+T(t(j)+1,t(i)))
                        flag=0;
                    end
                end
            end
        end
    end
end

end
