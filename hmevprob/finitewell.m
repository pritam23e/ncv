% FINITE WELL
clear all
close all
% Parameters
xvi = -3;         % Initial time
y_0 = 0;       % Initial value of wave function
y1_0 = 1;       % Initial slope
y_f=0;          %Final value of wave function
xvf= 3;     % End time
N=1000;    %Number of iterations for Euler
V0=4;
xi=xvi-1;
xf=xvf+1;
% Initialize Function
ddy = @(xl, yl, y1l, El) (-El*yl).*(xl > xvi & xl < xvf) + ((V0 - El)*yl).*(~(xl > xvi & xl < xvf));      
%Eigen value conditions
dn=0.01;
Ei=0;
Ef=3;
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
subplot(2, 1, 1)
grid on;
xlim([-6 6])
xlabel('x');
ylabel('y');
title('Solution of Potential Well');
legend(legends, 'Location', 'best');
subplot(2, 1, 2);
plot(Eo,Ev)
grid on
xlabel('Final value of function  ');
ylabel('EneRgy values');
title('Eigen Value Finder');
