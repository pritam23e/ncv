% INFINITE WELL PARITY
clear all
close all
% Initialize Function
ddy=@(xl,yl,y1l,El) -El*yl;

% Parameters
xi = 0;         % Initial time
y_f=0;          %Final value of wave function
xf= pi;     % End time
N=10000;    %Number of iterations for Euler

%Eigen value conditions
dn=0.01;
Ei=0;
Ef=3;
Eo=Ei:dn:Ef;
k=length(Eo);

%Eigen value finder
[E,Ev]=bisectHMpar(k,Eo,xi,y_f,xf,ddy,N);
E
Ne=length(E)

%Plotter
for i=1:Ne
    if mod(i,2) == 0
        y1_0=1; 
        y_0=0;
        p=-1;
    else
        y1_0=0; 
        y_0=1; 
        p=1;
    end 
    [Y,X]=Rk4HM(xi,xf,y_0, y1_0,ddy,N,E(i));
    A=-1*fliplr(X);
    B=p*fliplr(Y);
    X=[A X];
    Y=[B Y];   
    subplot(2, 1, 1);
    plot(X,Y)
    %legends{i} = sprintf('%dth excited state, E = %.6f', i-1, E(i));              
    hold on   
end

subplot(2, 1, 1);
grid on;
xlabel('x');
ylabel('y');
title('Solution of Potential Well');
%legend(legends, 'Location', 'best');

subplot(2, 1, 2);
plot(Eo,Ev)
grid on
xlabel('Final value of function  ');
ylabel('Eneegy values');
title('Eigen Value Finder');


