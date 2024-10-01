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

# Set threshold for sound detection
threshold_value = 850

# Timer to control the green box display duration
green_duration = 0.2  # time seconds to keep the box green
last_tap_time = 0

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

            # If sound value exceeds the threshold, turn the box green
            if sense_value > threshold_value:
                current_color = GREEN
                last_tap_time = time.time()  # Record the time of the clap

    # Check if the green box should revert to red after 0.5 seconds
    if current_color == GREEN and time.time() - last_tap_time > green_duration:
        current_color = RED

    # Fill the window with a white background
    window.fill((255, 255, 255))

    # Draw the box with the current color (Red or Green)
    pygame.draw.rect(window, current_color, (100, 100, 200, 200))

    # Update the display
    pygame.display.update()

# Close the serial port and Pygame
ser.close()
pygame.quit()
