clear all
%original Matrix
%matrix size
n=input('enter number of variables= ');
for i=1:n
  o=input('enter element of the equation= ','s');
  a(i,:)=str2num(o);
end
a
triang=a;

%gauss elimination
for k = 1:n-1
  for i = k+1:n
    factor = triang(i,k)/triang(k,k);
    triang(i,:) = triang(i,:)-factor*triang(k,:);
   
  end
end
b=triang(:,n+1);

%root calculation
p=0;
r=zeros(1,n);
for l=0:n-1
  for m=1:n  
    if (n-l)==(m)
      continue
    end
    p=p+triang(n-l,m)*(r(m));
    end
  q=b(n-l)-p;
  r(n-l)=q/triang(n-l,n-l);
  p=0;
    
end
r

