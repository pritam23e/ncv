import pygame
import serial
import time

# Initialize Pygame
pygame.init()

# Set up the display
window_size = (400, 400)
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("Tap Counter Box")

# Define colors
RED = (255, 0, 0)
GREEN = (0, 255, 0)
current_color = RED

# Set font for displaying the tap count
font = pygame.font.Font(None, 100)

# Set threshold for touch detection
threshold_value = 850
debounce_time = 180  # Debounce time in milliseconds
count = 0
last_tap_time = 0

# Timer to control the green box display duration
green_duration = 0.3  # 0.5 seconds to keep the box green

# Open serial port (replace with your port)
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

            # Get the current time in milliseconds
            current_time = int(time.time() * 1000)

            # Check if touch value is greater than threshold value
            if sense_value > threshold_value:
                # Check if the debounce time has passed since the last tap
                if current_time - last_tap_time > debounce_time:
                    count += 1
                    last_tap_time = current_time
                    current_color = GREEN  # Turn the box green
    # Check if the green box should revert to red after 0.5 seconds
    if current_color == GREEN and time.time() - (last_tap_time / 1000) > green_duration:
        current_color = RED

    # Fill the window with a white background
    window.fill((255, 255, 255))

    # Draw the box with the current color (Red or Green)
    pygame.draw.rect(window, current_color, (100, 100, 200, 200))

    # Render the tap count and display it in the box
    text = font.render(str(count), True, (0, 0, 0))  # Black color for the text
    text_rect = text.get_rect(center=(window_size[0] // 2, window_size[1] // 2))
    window.blit(text, text_rect)

    # Update the display
    pygame.display.update()

# Close the serial port and Pygame
ser.close()
pygame.quit()
