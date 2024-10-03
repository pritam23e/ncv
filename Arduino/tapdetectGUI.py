import pygame
import serial
import time

# Initialize Pygame
pygame.init()

# Set up the display
window_size = (400, 400)
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("Touch Sensor Color Box")

# Define colors
RED = (255, 0, 0)
GREEN = (0, 255, 0)
current_color = RED

# Set thresholds for detecting the touch cycle
downward_peak_threshold = 200  # Value when the sensor is pressed
upward_peak_threshold = 380  # Value when the sensor is released
idle_lower_bound = 150  # Normal sensor range (lower bound)
idle_upper_bound = 350  # Normal sensor range (upper bound)

# State to track if the sensor is in a touch cycle
in_touch_cycle = False

# Open serial port (replace 'COM3' with your port)
ser = serial.Serial('COM3', 19200)
time.sleep(2)  # Wait for the serial connection to initialize

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Read data from Arduino
    if ser.in_waiting > 0:
        data = ser.readline()

        try:
            # Try to decode the data using UTF-8
            data_decoded = data.decode('utf-8').strip()
        except UnicodeDecodeError:
            # If decoding fails, skip this iteration
            continue

        # Check if data is not empty
        if data_decoded:
            try:
                sense_value = int(data_decoded)
            except ValueError:
                # If conversion to int fails, skip this iteration
                continue

            # Check for the downward peak (touch detected)
            if not in_touch_cycle and sense_value < downward_peak_threshold:
                current_color = GREEN  # Turn the box green when touched
                in_touch_cycle = True  # Mark the start of a touch cycle

            # Check for the upward peak (release detected)
            if in_touch_cycle and sense_value > upward_peak_threshold:
                current_color = RED  # Turn the box red when released
                in_touch_cycle = False  # End the touch cycle

    # Fill the window with a white background
    window.fill((255, 255, 255))

    # Draw the box with the current color (Red or Green)
    pygame.draw.rect(window, current_color, (100, 100, 200, 200))

    # Update the display
    pygame.display.update()

# Close the serial port and Pygame
ser.close()
pygame.quit()
