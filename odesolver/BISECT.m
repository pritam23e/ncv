function xyz= BISECT(al,bl,fl)
  h=0.01;
  A=al;
  B=A+h;
  r=[ ];
  while B<bl
    if (fl(A)*fl(B))<0
      f3=1;
      er=1e-6;
      while abs(f3)>er
        c=(A+B)/2;
        f1=fl(A);
        f2=fl(B);
        f3=fl(c);
        if (f3*f1)<0
          B=c;
        end
        if (f3*f2)<0
          A=c;
        end
      end
      r=[r,c];
    end
    A=B;
    B=B+h;
  end
 

  xyz=r;
 
end
