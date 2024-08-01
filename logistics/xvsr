clear all
close all
x(1)=0.4;
t=0.001;
r=1:t:4;
p=0;
n=1000;
m=100;
for k= r
    p=p+1;
    for i =1:n
        x(i+1)=k*x(i)*(1-x(i)); 
    end
    M(:,p)=x(end-(m+1):end);
end
plot(r,M,'.k','MarkerSize',2); 
