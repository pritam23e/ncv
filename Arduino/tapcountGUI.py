import pygame
import serial
import time

# Initialize Pygame
pygame.init()

# Set up the display
window_size = (400, 400)
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("Touch Sensor Cycle Counter")

# Define colors
RED = (255, 0, 0)
GREEN = (0, 255, 0)
WHITE = (255, 255, 255)
current_color = RED

# Set thresholds for detecting the touch cycle
downward_peak_threshold = 180  # Value when the sensor is pressed
upward_peak_threshold = 350  # Value when the sensor is released

# State to track if the sensor is in a touch cycle
in_touch_cycle = False
cycle_count = 0  # Counter for completed cycles

# Font for displaying the cycle count
font = pygame.font.SysFont(None, 72)

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
                cycle_count += 1  # Increment cycle count when one full cycle completes

    # Fill the window with a white background
    window.fill(WHITE)

    # Draw the box with the current color (Red or Green)
    pygame.draw.rect(window, current_color, (100, 100, 200, 200))

    # Render the cycle count text
    count_text = font.render(str(cycle_count), True, WHITE)
    text_rect = count_text.get_rect(center=(200, 200))  # Center the text in the middle of the box
    window.blit(count_text, text_rect)

    # Update the display
    pygame.display.update()

# Close the serial port and Pygame
ser.close()
pygame.quit()
