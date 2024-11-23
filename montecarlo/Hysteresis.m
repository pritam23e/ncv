% HYSTERISIS CURVE 
clear all
close all;
tic
% MATLAB code for Hysteresis curve using Ising model, Monte Carlo method, and Metropolis conditions
% Parameters

L_rows = 20; % Number of rows in lattice
L_cols = 20; % Number of columns in lattice
J = 1; % Interaction energy (positive for ferromagnetic material)
T = 1.5; % Temperature (in units of J/kB)
H_vals = linspace(0, 3, 100); % Range of external magnetic field (0 to 10)
steps_per_H = 100; % Monte Carlo steps for each H value

% Initialize spin lattice with random spins (-1 or +1)
spin_lattice = 2 * randi([0, 1], L_rows, L_cols) - 1;

% Display initial lattice configuration
figure;
imagesc(spin_lattice);
colormap([0 0 0; 1 1 1]); % Custom colormap: black for -1, white for 1
caxis([-1 1]); % Set color axis limits to fix mapping
colorbar_handle = colorbar;
set(colorbar_handle, 'YTick', [-1, 1]);          % Set the tick positions
set(colorbar_handle, 'YTickLabel', {'-1', '1'}); % Set the tick labels
title('Initial Spin Lattice');
xlabel('X Position');
ylabel('Y Position');
set(gca, 'YDir', 'normal'); % Reverse y-axis direction
drawnow;
toc

% Initialize magnetization and field arrays
magnetization = zeros(1, length(H_vals));
%Initial starting from 0
% Monte Carlo simulation with Metropolis algorithm for forward field sweep (0 to 10)
for h = 1:length(H_vals)
    H = H_vals(h); % Current magnetic field
    for step = 1:steps_per_H
        % Choose a random spin to flip
        i = randi([1, L_rows]);
        j = randi([1, L_cols]);
        % Calculate energy difference (dE) if this spin is flipped
        S = spin_lattice(i, j);
        neighbors = spin_lattice(mod(i, L_rows) + 1, j) + spin_lattice(mod(i - 2, L_rows) + 1, j) + ...
                    spin_lattice(i, mod(j, L_cols) + 1) + spin_lattice(i, mod(j - 2, L_cols) + 1);
        dE = 2 * S * (J * neighbors + H);
        % Metropolis condition: accept flip if dE < 0 or with probability exp(-dE / T)
        if dE < 0 || rand() < exp(-dE / T)
            spin_lattice(i, j) = -S;
        end
    end

    % Calculate magnetization after equilibration for this H
    magnetization(h) = mean(spin_lattice(:));
end

figure;
imagesc(spin_lattice);
colormap([0 0 0; 1 1 1]); % Custom colormap: black for -1, white for 1
caxis([-1 1]); % Set color axis limits to fix mapping
colorbar_handle = colorbar;
set(colorbar_handle, 'YTick', [-1, 1]);          % Set the tick positions
set(colorbar_handle, 'YTickLabel', {'-1', '1'}); % Set the tick labels
title('Forward field Spin Lattice');
xlabel('X Position');
ylabel('Y Position');
set(gca, 'YDir', 'normal'); % Reverse y-axis direction
drawnow;
toc


% Reverse the field sweep:
H_vals_back = linspace(3, -3, 100); % Range of external magnetic field (10 to -10)
magnetization_back = zeros(1, length(H_vals_back));
% Start reverse sweep from the final lattice state of forward sweep
spin_lattice_back = spin_lattice;
% Monte Carlo simulation with Metropolis algorithm for reverse field sweep (10 to -10)
for h = 1:length(H_vals_back)
    H = H_vals_back(h); % Current magnetic field
    for step = 1:steps_per_H
        % Choose a random spin to flip
        i = randi([1, L_rows]);
        j = randi([1, L_cols]);
        % Calculate energy difference (dE) if this spin is flipped
        S = spin_lattice_back(i, j);
        neighbors = spin_lattice_back(mod(i, L_rows) + 1, j) + spin_lattice_back(mod(i - 2, L_rows) + 1, j) + ...
                    spin_lattice_back(i, mod(j, L_cols) + 1) + spin_lattice_back(i, mod(j - 2, L_cols) + 1);
        dE = 2 * S * (J * neighbors + H);
        % Metropolis condition: accept flip if dE < 0 or with probability exp(-dE / T)
        if dE < 0 || rand() < exp(-dE / T)
            spin_lattice_back(i, j) = -S;
        end
    end
    % Calculate magnetization after equilibration for this H
    magnetization_back(h) = mean(spin_lattice_back(:));
end

figure;
imagesc(spin_lattice_back);
colormap([0 0 0; 1 1 1]); % Custom colormap: black for -1, white for 1
caxis([-1 1]); % Set color axis limits to fix mapping
colorbar_handle = colorbar;
set(colorbar_handle, 'YTick', [-1, 1]);          % Set the tick positions
set(colorbar_handle, 'YTickLabel', {'-1', '1'}); % Set the tick labels
title('Reverse field Spin Lattice');
xlabel('X Position');
ylabel('Y Position');
set(gca, 'YDir', 'normal'); % Reverse y-axis direction
drawnow;
toc


% Forward the field sweep again:
H_vals_forw = linspace(-3, 3, 100); % Range of external magnetic field (10 to -10)
magnetization_forw = zeros(1, length(H_vals_forw));
% Start reverse sweep from the final lattice state of forward sweep
spin_lattice_forw = spin_lattice_back;
% Monte Carlo simulation with Metropolis algorithm for reverse field sweep (10 to -10)
for h = 1:length(H_vals_forw)
    H = H_vals_forw(h); % Current magnetic field
    for step = 1:steps_per_H
        % Choose a random spin to flip
        i = randi([1, L_rows]);
        j = randi([1, L_cols]);
        % Calculate energy difference (dE) if this spin is flipped
        S = spin_lattice_forw(i, j);
        neighbors = spin_lattice_forw(mod(i, L_rows) + 1, j) + spin_lattice_forw(mod(i - 2, L_rows) + 1, j) + ...
                    spin_lattice_forw(i, mod(j, L_cols) + 1) + spin_lattice_forw(i, mod(j - 2, L_cols) + 1);
        dE = 2 * S * (J * neighbors + H);
        % Metropolis condition: accept flip if dE < 0 or with probability exp(-dE / T)
        if dE < 0 || rand() < exp(-dE / T)
            spin_lattice_forw(i, j) = -S;
        end
    end
    % Calculate magnetization after equilibration for this H
    magnetization_forw(h) = mean(spin_lattice_forw(:));
end

figure;
imagesc(spin_lattice_forw);
colormap([0 0 0; 1 1 1]); % Custom colormap: black for -1, white for 1
caxis([-1 1]); % Set color axis limits to fix mapping
colorbar_handle = colorbar;
set(colorbar_handle, 'YTick', [-1, 1]);          % Set the tick positions
set(colorbar_handle, 'YTickLabel', {'-1', '1'}); % Set the tick labels
title('Reverse field Spin Lattice');
xlabel('X Position');
ylabel('Y Position');
set(gca, 'YDir', 'normal'); % Reverse y-axis direction
drawnow;
toc

% Plot Hysteresis curve (Forward sweep)
figure;
plot(H_vals, magnetization, 'o', 'DisplayName', 'Forward Sweep');
hold on;
plot(H_vals_back, magnetization_back, 'o', 'DisplayName', 'Reverse Sweep');
hold on;
plot(H_vals_forw, magnetization_forw, 'o', 'DisplayName', 'Forward Back Sweep');
xlabel('Magnetic Field H');
ylabel('Magnetization M');
title('Hysteresis Curve using Ising Model and Monte Carlo Method');
legend('show');
grid on;
