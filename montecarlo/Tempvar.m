clear all
close all;
tic
% Parameters
L_rows = 100; % Number of rows in lattice
L_cols = 100; % Number of columns in lattice
J = 1; % Interaction energy (positive for ferromagnetic material)
H_vals = linspace(0, 20, 1000); % Range of external magnetic field (0 to 10)
steps_per_H = 5000; % Monte Carlo steps for each H value
T_vals = linspace(0, 5,5); % Temperature range from 0 to 3
n=20;
% Initialize temperature vs. M_sp plot
M_sp = zeros(1, length(T_vals));
steps=length(T_vals); 
% Loop over different temperatures
for temp_idx = 1:steps
    T = T_vals(temp_idx); % Current temperature
    disp(['Running for T = ', num2str(T)]);
    
    % Calculate the number of hashtags to display
    numHashtags = floor((temp_idx / steps) * n);  % Use floor to ensure it's an integer
    
    % Create a string with the appropriate number of hashtags
    displayString = [repmat('#', 1, numHashtags), repmat(' ', 1, n - numHashtags)];
    
    % Display the box with hashtags
    fprintf('[%s]\n', displayString);
    
    
    % Initialize spin lattice with random spins (-1 or +1)
    spin_lattice = 2 * randi([0, 1], L_rows, L_cols) - 1; 

    % Monte Carlo simulation for forward field sweep (0 to 10)
    magnetization = zeros(1, length(H_vals));
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

    % Reverse the field sweep: H goes from 10 to 0
    H_vals_back = linspace(10, 0, 2000); % Range of external magnetic field (10 to 0)
    magnetization_back = zeros(1, length(H_vals_back));

    % Start reverse sweep from the final lattice state of forward sweep
    spin_lattice_back = spin_lattice;

    % Monte Carlo simulation with Metropolis algorithm for reverse field sweep (10 to 0)
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

    % Find y-intercept for reverse sweep (when H = 0)
    % This assumes the magnetization_back at h=length(H_vals_back) should correspond to H = 0
    M_sp(temp_idx) = magnetization_back(end); % Store final magnetization after reverse sweep
end


% Plot M_sp vs temperature to find critical temperature
figure;
plot(T_vals, M_sp, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Temperature (T)');
ylabel('Magnetization at H = 0 (M_{sp})');
title('Magnetization at H = 0 vs Temperature');
grid on;
toc
