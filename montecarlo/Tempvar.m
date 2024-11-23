% TEMPERATURE VARIANCE AND MAGNETIZATION

clear all
close all;
tic;

% Parameters
L_rows = 10; % Number of rows in lattice
L_cols = 10; % Number of columns in lattice
J = 1; % Interaction energy (positive for ferromagnetic material)
H_vals = linspace(0, 10, 100); % Range of external magnetic field (0 to 10)
steps_per_H = 50; % Monte Carlo steps for each H value
T_vals = linspace(0, 5, 10); % Temperature range from 0 to 3

n = 20; % For progress bar
M_sp = zeros(1, length(T_vals)); % Initialize temperature vs. M_sp plot
steps = length(T_vals);

% Loop over different temperatures
for temp_idx = 1:steps
    T = T_vals(temp_idx); % Current temperature
    disp(['Running for T = ', num2str(T)]);
    
    % Display progress bar
    numHashtags = floor((temp_idx / steps) * n);
    displayString = [repmat('#', 1, numHashtags), repmat(' ', 1, n - numHashtags)];
    fprintf('[%s]\n', displayString);
    
    
    % Initialize spin lattice with random spins (-1 or +1)
    spin_lattice = 2 * (randi([0, 1], L_rows, L_cols)) - 1;

    
    % Monte Carlo simulation for forward field sweep (0 to 10)
    magnetization = zeros(1, length(H_vals));
    
    for h = 1:length(H_vals)
        H = H_vals(h); % Current magnetic field
        for step = 1:steps_per_H

        
            % Choose a random spin to flip
            i = randi(L_rows);
            j = randi(L_cols);

            
            % Calculate energy difference (dE) if this spin is flipped
            S = spin_lattice(i, j);
            neighbors = spin_lattice(mod(i, L_rows) + 1, j) + spin_lattice(mod(i - 2, L_rows) + 1, j) + ...
                        spin_lattice(i, mod(j, L_cols) + 1) + spin_lattice(i, mod(j - 2, L_cols) + 1);
            dE = 2 * S * (J * neighbors + H);

            
            % Metropolis condition
            if dE < 0 || rand() < exp(-dE / T)
                spin_lattice(i, j) = -S;
            end
        end
        magnetization(h) = mean(spin_lattice(:));
    end

    
    % Reverse the field sweep: H goes from 10 to 0
    H_vals_back = linspace(10, 0, 10);
    magnetization_back = zeros(1, length(H_vals_back));
    spin_lattice_back = spin_lattice; % Start reverse sweep with final lattice state

    
    for h = 1:length(H_vals_back)
        H = H_vals_back(h);
        for step = 1:steps_per_H
            i = randi(L_rows);
            j = randi(L_cols);
            S = spin_lattice_back(i, j);

            
            neighbors = spin_lattice_back(mod(i, L_rows) + 1, j) + spin_lattice_back(mod(i - 2, L_rows) + 1, j) + ...
                        spin_lattice_back(i, mod(j, L_cols) + 1) + spin_lattice_back(i, mod(j - 2, L_cols) + 1);
            dE = 2 * S * (J * neighbors + H);
            if dE < 0 || rand() < exp(-dE / T)
                spin_lattice_back(i, j) = -S;
            end
        end
        magnetization_back(h) = mean(spin_lattice_back(:));
    end
    
    % Store final magnetization after reverse sweep
    M_sp(temp_idx) = magnetization_back(end);
end

% Plot M_sp vs temperature to find critical temperature
figure;
plot(T_vals, M_sp, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Temperature (T)');
ylabel('Magnetization at H = 0 (M_{sp})');
title('Magnetization at H = 0 vs Temperature');
grid on;
toc;
