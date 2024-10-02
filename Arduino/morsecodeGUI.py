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
blue = (0, 0, 255)
orange = (255, 165, 0)
black = (0, 0, 0)
current_color = RED
font_size = 70
font = pygame.font.Font(None, font_size)

# Set font for displaying the tap count and array
font = pygame.font.Font(None, 74)
small_font = pygame.font.Font(None, 36)

# Open serial port
ser = serial.Serial('COM3', 19200)
height = 500
threshold_value = 850
debounce_time = 200  # Debounce time in milliseconds
min_interval = 500  # Minimum interval between claps in a sequence (milliseconds)
ignore_time = 50  # Ignore time in milliseconds (to ignore subsequent values)
max_interval = 1500
count = 0
last_tap_time = 0
ignore_until = 0
F = []
P = []
M = []
# Timer to control the green box display duration
green_duration = 0.2  # 0.2 seconds to keep the box green

# Set maximum sequences to display
max_sequences = 23

morse_code = {
    'A': [1, 5],       # .-
    'B': [5, 1, 1, 1], # -...
    'C': [5, 1, 5, 1], # -.-.
    'D': [5, 1, 1],    # -..
    'E': [1],          # .
    'F': [1, 1, 5, 1], # ..-.
    'G': [5, 5, 1],    # --.
    'H': [1, 1, 1, 1], # ....
    'I': [1, 1],       # ..
    'J': [1, 5, 5, 5], # .---
    'K': [5, 1, 5],    # -.- 
    'L': [1, 5, 1, 1], # .-..
    'M': [5, 5],       # --
    'N': [5, 1],       # -.
    'O': [5, 5, 5],    # ---
    'P': [1, 5, 5, 1], # .--.
    'Q': [5, 5, 1, 5], # --.-
    'R': [1, 5, 1],    # .-.
    'S': [1, 1, 1],    # ...
    'T': [5],          # -
    'U': [1, 1, 5],    # ..-
    'V': [1, 1, 1, 5], # ...-
    'W': [1, 5, 5],    # .--
    'X': [5, 1, 1, 5], # -..-
    'Y': [5, 1, 5, 5], # -.-- 
    'Z': [5, 5, 1, 1], # --..
    '1': [1, 5, 5, 5, 5],  # .----
    '2': [1, 1, 5, 5, 5],  # ..---
    '3': [1, 1, 1, 5, 5],  # ...--
    '4': [1, 1, 1, 1, 5],  # ....-
    '5': [1, 1, 1, 1, 1],  # .....
    '6': [5, 1, 1, 1, 1],  # -....
    '7': [5, 5, 1, 1, 1],  # --...
    '8': [5, 5, 5, 1, 1],  # ---..
    '9': [5, 5, 5, 5, 1],  # ----.
    '0': [5, 5, 5, 5, 5]   # -----
}

# Create a reverse dictionary where Morse code patterns are the keys
reverse_morse_code = {tuple(v): k for k, v in morse_code.items()}
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

            # Check if sound value is greater than threshold value
            if sense_value > threshold_value:
                # Check if the debounce time has passed since the last clap
                if current_time - last_tap_time > debounce_time and current_time > ignore_until:
                    current_color = GREEN  # Turn the box green
                    # Check if the interval between claps is less than min_interval
                    if current_time - last_tap_time < min_interval:
                        count += 1
                    else:
                        if current_time - last_tap_time < max_interval:
                            # If the interval is too large, start a new sequence
                            print(f"Final count: {count}")
                            if count == 1:
                                F.append(1)
                            if count >= 2:
                                F.append(5)
                            print(f"F={F}")

                        if current_time - last_tap_time > max_interval:
                            if count == 1:
                                F.append(1)
                            if count >= 2:
                                F.append(5)
                            print(f"F={F}")
                            P.append(F)
                            if [] in P:
                                P.remove([])
                            print(f"P={P}")
                            F = []
                            if len(P) >= 1:
                                code = P[-1]
                                code_tuple = tuple(code)  # Convert list to tuple to match keys
                                rm = reverse_morse_code[code_tuple]
                                M.append(rm)
                                print(f"M={M}")
                        count = 1

                    last_tap_time = current_time
                    ignore_until = current_time + ignore_time
                    print(f"Clap detected! Consecutive count: {count}")

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

    # Draw the M array (Morse code representation) below the F array
    morse_start_y = 300  # Y position for M array
    morse_start_x = 300  # Same X position as F array
    
    # Loop through the array `M` and display each Morse character
    for i, char in enumerate(M):
        char_text = small_font.render(char, True, BLACK)  # Render the character
        window.blit(char_text, (morse_start_x + (i * (bar_width + 10)), morse_start_y))  # Display it below the F bars

    # Update the display

    x_start = 50  # Initial position on the x-axis
    for idx, inner_list in enumerate(P):
        for value in inner_list:
            if value == 1:
                # Draw a dot for the value 1
                dot = font.render('.', True, blue)
                window.blit(dot, (x_start, height // 2 - font_size // 2))
                x_start += 10  # Move to the next position (smaller gap)
            elif value == 5:
                # Draw an underscore for the value 5
                bar = font.render('_', True, orange)
                window.blit(bar, (x_start, height // 2 - font_size // 2))
                x_start += 40  # Move to the next position (smaller gap)

        # Draw partition between different arrays (except for the last one)
        if idx < len(P) - 1:
            partition = font.render('|', True, black)
            window.blit(partition, (x_start, height // 2 - font_size // 2))
            x_start += 10  # Space between different sequences

    # Update the display
    pygame.display.update()

# Clean up
ser.close()
pygame.quit()
