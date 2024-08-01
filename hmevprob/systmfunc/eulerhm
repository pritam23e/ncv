function A=EulerHM(ti,x_0,x1_0,tf,ddx,El,N)
        
    dt = (tf - ti) / N;
    X = zeros(1, N+1);
    X(1) = x_0;
    G = X;
    G(1) = x1_0;
    t=ti;
    
    for i = 2:N+1
        X(i) = X(i-1) + dt * G(i-1);
        G(i) = G(i-1) + dt * ddx(t, X(i-1), G(i-1), El);               
        t=t+dt;
    end

    A = X;
end
