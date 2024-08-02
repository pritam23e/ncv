function [A, B] = bisectHM(k, Eo, xi, y_0, y1_0, xf, ddy, N)
    Ev = [];
    E = [];
    for j = 1:k-1
        Ep = Eo(j);
        En = Eo(j+1);
        D= EulerHM(xi, y_0, y1_0, xf, ddy, Ep, N);
        H=EulerHM(xi, y_0, y1_0, xf, ddy, En, N);
        if j == 1
        Ev=[Ev,D(end)];
        end
        Ev=[Ev,H(end)]; 
        
        if D(end)*H(end) < 0
            a = Ep;
            b = En;
            while abs(b-a) > 1e-6
                c = (a+b)/2;
                fc = EulerHM(xi, y_0, y1_0, xf, ddy, c, N);
                if fc(end)*D(end) < 0
                    b = c;
                else
                    a = c;
                end
            end
            E = [E, (a+b)/2];
        end
    end
    A = E;
    B = Ev;
end



