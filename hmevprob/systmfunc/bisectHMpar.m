function [A, B] = bisectHMpar(k, Eo, xi, y_f, xf, ddy, N)           
    Ev = [];
    E = [];
    y1_0=0;
    y_0 = 1;
    for j = 1:k-1
        Ep = Eo(j);
        En = Eo(j+1);
        D= EulerHM(xi, y_0, y1_0, xf, ddy, Ep, N);
        H=EulerHM(xi, y_0, y1_0, xf, ddy, En, N);
        if j == 1
        Ev=[Ev,D(end)];
        end
        Ev=[Ev,H(end)]; 
        
        if D(end)*H(end) < y_f
            a = Ep;
            b = En;
            G=EulerHM(xi, y_0, y1_0, xf, ddy, a, N);
           
            while abs(b-a) > 1e-6
                c = (a+b)/2;
                fc = EulerHM(xi, y_0, y1_0, xf, ddy, c, N);
                if fc(end)*G(end) < y_f
                    b = c;
                else
                    a = c;
                end
                
            end
            E = [E, (a+b)/2];
        end
        kl=length(E);
        if mod((kl+1),2) == 0
            y1_0=1; 
            y_0=0;
        else
            y1_0=0; 
            y_0=1;         
    end
    A = E;
    B = Ev;
end
