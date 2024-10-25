clear all;
close all;
tic
% Define the size of the matrix
rows = 5;
cols = 5;
% Create a matrix with random values of 1 and -1
M0 = 2 * randi([0, 1], rows, cols) - 1
sn = 5000; % Number of sweeps
dn = 2000; % Number of sweeps to be discarded
J=1;

% VARYING H EXTERNAL FIELD
dh = 0.5; % Step size for h
T = 3; % Temperature
h_values = -5:dh:5; % Range of h values
num_h_values = length(h_values); 
mean_magnetization = zeros(1, num_h_values); % Initialize array to store mean magnetization
susceptibility = zeros(1, num_h_values); % Initialize array to store susceptibility                                      

for k = 1:num_h_values
    h = h_values(k); % Current value of h
    Mp = M0; % Use the fixed M0
    b = 1 / T;
    [mean_magnetization(k),susceptibility(k)]= magnetization(Mp,h,J,b,sn,dn); % Store the mean magnetization
end

% Plot T vs mean magnetization
subplot(2,2,1)
plot(h_values, mean_magnetization, 'o');
xlabel('h');
ylabel('Mean Magnetization');
title('Mean Magnetization vs. h');
grid on

subplot(2,2,2)
plot(h_values, susceptibility, 'o');
xlabel('h');
ylabel('Susceptibility');
title('Susceptibility vs. h');
grid on
disp(" half way");
toc
% VARYING TEMPERATURE 
h = 0; % external magnetization 
dT = 0.1; % Step size for T
T_values = 0.001:dT:50; % Range of T values
num_T_values = length(T_values);
mean_magnetization = zeros(1, num_T_values); % Initialize array to store mean magnetization
susceptibility = zeros(1, num_T_values); % Initialize array to store susceptibility


for k = 1:num_T_values
    T = T_values(k); % Current value of h
    Mp = M0; % Use the fixed M0
    b = 1 / T;
    [mean_magnetization(k),susceptibility(k)] = magnetization(Mp,h,J,b,sn,dn); % Store the mean magnetization
end

% Plot h vs mean magnetization
subplot(2,2,3)
plot(T_values, mean_magnetization, 'o');
xlabel('T');
ylabel('Mean Magnetization');
title('Mean Magnetization vs. T');
grid on
subplot(2,2,4)
plot(T_values, susceptibility, 'o');
xlabel('T');
ylabel('Susceptibility');
title('Susceptibility vs. T');
grid on
toc

