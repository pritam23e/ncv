% Parameters
num_iterations = 1000; % Number of iterations
num_transient_iterations = 500; % Number of transient iterations
r_values = linspace(2.5, 4, 1000); % Range of r values

% Initialize figure
figure;
hold on;

% Loop over r values
for r = r_values
    x = 0.5; % Initial population
    % Transient iterations
    for n = 1:num_transient_iterations
        x = r * x * (1 - x);
    end
    % Collect data for bifurcation diagram
    x_values = zeros(1, num_iterations - num_transient_iterations);
    for n = 1:num_iterations - num_transient_iterations
        x = r * x * (1 - x);
        x_values(n) = x;
    end
    % Plot data
    plot(r * ones(size(x_values)), x_values, '.', 'MarkerSize', 1, 'Color', [0, 0, 0]);
end

xlabel('r');
ylabel('Population');
title('Bifurcation Diagram');
hold off;
