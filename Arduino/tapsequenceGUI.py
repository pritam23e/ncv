import pygame
import serial
import time

# Initialize Pygame
pygame.init()

# Set up the display
window_size = (1000, 500)
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("Morse Code")

# Define colors
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
current_color = RED

# Set font for displaying the tap count and array
font = pygame.font.Font(None, 74)
small_font = pygame.font.Font(None, 36)

# Open serial port 
ser = serial.Serial('COM3', 19200)
time.sleep(2)  # Wait for the serial connection to initialize

# Set threshold and debounce values
threshold_value = 850
debounce_time = 200  # Debounce time in milliseconds
min_interval = 500  # Minimum interval between taps in a sequence (milliseconds)
ignore_time = 50  # Ignore time in milliseconds (to ignore subsequent values)
count = 0
last_tap_time = 0
ignore_until = 0
F = []  # List to store final counts of claps in each sequence

# Timer to control the green box display duration
green_duration = 0.2  # 0.2 seconds to keep the box green

# Set maximum sequences to display
max_sequences = 23

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
                if current_time - last_tap_time > debounce_time and current_time > ignore_until:
                    # Check if the interval between taps is less than min_interval
                    if current_time - last_tap_time < min_interval:
                        count += 1
                    else:
                        # If the interval is too large, start a new sequence
                        if len(F) >= max_sequences:
                            F.pop(0)  # Remove the oldest count if exceeding max_sequences
                        F.append(count)  # Store the final count of the sequence
                        print(f"Final count: {count}")
                        print(F)
                        count = 1  # Start new sequence

                    last_tap_time = current_time
                    ignore_until = current_time + ignore_time
                    current_color = GREEN  # Change color to green on tap detection
                    print(f"Tap detected! Consecutive count: {count}")

    # Check if the green box should revert to red after the duration
    if current_color == GREEN and time.time() - (last_tap_time / 1000) > green_duration:
        current_color = RED

    # Fill the window with a white background
    window.fill(WHITE)

    # Draw the "Final Count" statement in the top left corner
    final_count_text = small_font.render("Final Count:", True, BLACK)
    window.blit(final_count_text, (150, 50))

    # Draw the box with the current color (Red or Green) in the top middle
    box_x = (window_size[0] // 2) - 40  # Center the box horizontally
    box_y = 50  # Position from the top
    pygame.draw.rect(window, current_color, (box_x, box_y, 80, 80))

    # Render the current tap count and display it in the box
    count_text = font.render(str(count), True, BLACK)  # Black color for the text
    count_text_rect = count_text.get_rect(center=(box_x + 40, box_y + 40))  # Center the count inside the box
    window.blit(count_text, count_text_rect)

    # Draw the graphical array from the middle of the window
    array_start_x = (window_size[0] - (len(F) * (20 + 10) - 10)) // 2  # Center based on total width of bars
    array_y = 250        # Y position for all array bars
    bar_width = 20       # Width of each bar
    bar_height_factor = 10  # Multiply the count by this to determine bar height

    # Loop through the array `F` and draw each count as a bar
    for i, val in enumerate(F):
        bar_height = val * bar_height_factor  # Calculate bar height based on count
        pygame.draw.rect(window, BLACK, (array_start_x + (i * (bar_width + 10)), array_y - bar_height, bar_width, bar_height))

        # Display the value of each count below the corresponding bar
        value_text = small_font.render(str(val), True, BLACK)
        window.blit(value_text, (array_start_x + (i * (bar_width + 10)), array_y + 10))

    # Update the display
    pygame.display.update()

# Close the serial port and Pygame
ser.close()
pygame.quit()
