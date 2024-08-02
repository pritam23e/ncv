function [A,B]=EULER(ti,x_0,x1_0,tf,ddx,N)
        
    % Time steps
    dt=(tf-ti)/N;
    T= ti:dt:tf;
    % Set initial conditions
    X = [x_0];
    G = [x1_0];
    % Euler method
    for i = 2:N+1
        t = T(i-1);
        x = X(i-1);
        x1 = G(i-1);
        x1n = x1 + dt *ddx(x,x1,t);
        xn = x + dt * x1n;
        X = [X,xn];
        G = [G,x1n];
    end
    A=X;
    B=T;
end
