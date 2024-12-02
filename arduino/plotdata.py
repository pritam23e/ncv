import matplotlib.pyplot as plt

# Example array with (x, y) pairs
data = [
    (0.00,0.00),
(0.00,0.00),
(0.00,0.00),
(0.04,0.00),
(0.00,0.00),
(0.00,0.00),
(0.04,0.00),
(0.01,0.00),
(0.14,0.00),
(0.03,0.00),
(0.01,0.00),
(0.08,0.00),
(0.02,0.00),
(0.24,0.00),
(0.05,0.00),
(0.01,0.00),
(0.13,0.00),
(0.03,0.00),
(0.36,0.00),
(0.08,0.00),
(0.02,0.00),
(0.18,0.00),
(0.05,0.00),
(0.48,0.00),
(0.11,0.00),
(0.03,0.00),
(0.24,0.00),
(0.06,0.00),
(0.62,0.00),
(0.14,0.00),
(0.04,0.00)


]

# Separate x and y values from the array
x_values, y_values = zip(*data)

# Plot the data
plt.figure(figsize=(8, 5))
plt.scatter(x_values, y_values, color='b', label="Data Points")
plt.title("Scatter Plot of (x, y) Data")
plt.xlabel("X-axis")
plt.ylabel("Y-axis")
plt.grid(True)
plt.legend()
plt.show()
