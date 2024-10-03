import pygame
import serial
import time

# Initialize Pygame
pygame.init()

# Set up the display
window_size = (1000, 523)
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("Consecutive Tap Detection")

# Define colors
RED = (255, 0, 0)
GREEN = (0, 255, 0)
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
current_color = RED

# Set thresholds for detecting the touch cycle
downward_peak_threshold = 150  # Value when the sensor is pressed (down peak)
upward_peak_threshold = 380  # Value when the sensor is released (up peak)

# State to track if the sensor is in a touch cycle
in_touch_cycle = False
tap_count = 0  # Counter for consecutive taps within a cycle
F = []  # List to store the number of consecutive taps in each sequence

# Timing for consecutive taps
min_time_interval = 0.6  # Minimum time between upward peak and next down peak (600 ms)
last_upward_time = 0  # Time when the last upward peak occurred

# Font for displaying the text
font = pygame.font.SysFont(None, 36)
small_font = pygame.font.SysFont(None, 24)

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

            current_time = time.time()

            # Check for the downward peak (touch detected)
            if not in_touch_cycle and sense_value < downward_peak_threshold:
                current_color = GREEN  # Turn the box green when touched
                in_touch_cycle = True  # Mark the start of a touch cycle
                tap_count += 1  # Increment consecutive tap count

            # Check for the upward peak (release detected)
            if in_touch_cycle and sense_value > upward_peak_threshold:
                current_color = RED  # Turn the box red when released
                in_touch_cycle = False  # End the touch cycle
                last_upward_time = current_time  # Record the upward peak time

    # Check if the time interval has passed with no new tap (cycle finished)
    if tap_count > 0 and not in_touch_cycle and (time.time() - last_upward_time) > min_time_interval:
        if tap_count > 0:
            F.append(tap_count)  # Store the tap count in F
        tap_count = 0  # Reset the tap count for the next sequence

    # Fill the window with a white background
    window.fill(WHITE)

    # Display "Counts Detected" in the top left corner
    count_text = small_font.render("Counts Detected", True, BLACK)
    window.blit(count_text, (80, 80))

    # Draw the smaller box with the current color (Red or Green) and display tap count
    pygame.draw.rect(window, current_color, (350, 50, 123, 123))  # Smaller box (100x100)
    clap_text = font.render(str(tap_count), True, WHITE)
    window.blit(clap_text, (390, 85))  # Center the text in the middle of the box

    # Display "Final Sequence" in the middle
    final_sequence_text = small_font.render("Final Sequence", True, BLACK)
    window.blit(final_sequence_text, (150, 470))

    # Draw the bar graph for F in the bottom left corner
    if F:
        bar_width = 23
        for i, count in enumerate(F):
            # Draw the bar
            pygame.draw.rect(window, BLACK, (40 + i * bar_width, 420 - count * 10, bar_width, count * 10))
            # Display the corresponding count below the bar
            bar_label = small_font.render(str(count), True, BLACK)
            window.blit(bar_label, (40 + i * bar_width + 10, 430))

    # Update the display
    pygame.display.update()

# Close the serial port and Pygame
ser.close()
pygame.quit()
