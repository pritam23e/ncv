% Generate array of 10 random numbers with 15 digits
random_numbers = randi([10^14, 10^15 - 1], 1, 500);

% Print each number with a comma in between
for i = 1:numel(random_numbers)
    fprintf('%d', random_numbers(i));
    if i < numel(random_numbers)
        fprintf(', ');
    end
end
fprintf('\n');
