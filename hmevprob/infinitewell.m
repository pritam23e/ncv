% INFINITE WELL

clear all
close all
% Initialize Function
ddy=@(xl,yl,y1l,El) -El*yl;

% Parameters
xi = 0;         % Initial time
y_0 = 0;       % Initial value of x (x)
y1_0 = 1;       % Initial slope x' (x1)
y_f=0;          %Final value of x
xf= 4;     % End time
N=1000;    %Number of iterations for Euler

%Eigen value conditions
dn=0.1;
Ei=0;
Ef=20;
Eo=Ei:dn:Ef;
k=length(Eo);

%Eigen value finder
[E,Ev]=bisectHM(k,Eo,xi,y_0,y1_0,xf,ddy,N);
E
Ne=length(E)

%Plotter
for i=1:Ne
    [Y,X]=Rk4HM(xi,xf,y_0,y1_0,ddy,N,E(i));
    subplot(2, 1, 1);
    plot(X,Y)
    legends{i} = sprintf('%dth excited state, E = %.6f', i-1, E(i));              
    hold on   
end

subplot(2, 1, 1);
grid on;
xlabel('x');
ylabel('y');
title('Solution of Potential Well');
legend(legends, 'Location', 'best');

subplot(2, 1, 2);
plot(Eo,Ev)
grid on
xlabel('Final value of function  ');
ylabel('Eneegy values');
title('Eigen Value Finder');

