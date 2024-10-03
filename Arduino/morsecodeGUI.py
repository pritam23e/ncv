import pygame
import serial
import time

# Initialize Pygame
pygame.init()

# Set up the display
window_size = (1000, 500)  # Increased window size
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("Morse Code Detection")

# Define colors
RED = (255, 0, 0)
GREEN = (0, 255, 0)
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
current_color = RED

# Set thresholds for detecting the touch cycle
downward_peak_threshold = 150  # Value when the sensor is pressed (down peak)
upward_peak_threshold = 380  # Value when the sensor is released (up peak)

# Timing for detecting short and long taps
short_tap_threshold = 0.2  # Duration for a short tap (1)
long_tap_threshold = 0.25  # Duration for a long tap (5)

# Timing for consecutive taps
min_time_interval = 0.6  # Minimum time between two cycles in milliseconds
last_upward_time = 0      # Time when the last upward peak occurred
tap_start_time = 0        # Time when a tap starts

# State to track if the sensor is in a touch cycle
in_touch_cycle = False
tap_duration = 0          # Duration of a single tap cycle
F = []                    # List to store the current sequence of taps (1s and 5s)
P = []                    # List of sequences representing Morse code patterns

# Morse Code Mapping
morse_code_dict = {
    (1, 5): 'A', (5, 1, 1, 1): 'B', (5, 1, 5, 1): 'C', (5, 1, 1): 'D',
    (1,): 'E', (1, 1, 5, 1): 'F', (5, 5, 1): 'G', (1, 1, 1, 1): 'H',
    (1, 1): 'I', (1, 5, 5, 5): 'J', (5, 1, 5): 'K', (1, 5, 1, 1): 'L',
    (5, 5): 'M', (5, 1): 'N', (5, 5, 5): 'O', (1, 5, 5, 1): 'P',
    (5, 5, 1, 5): 'Q', (1, 5, 1): 'R', (1, 1, 1): 'S', (5,): 'T',
    (1, 1, 5): 'U', (1, 1, 1, 5): 'V', (1, 5, 5): 'W', (5, 1, 1, 5): 'X',
    (5, 1, 5, 5): 'Y', (5, 5, 1, 1): 'Z',

    # Numbers
    (5, 5, 5, 5, 5): '0',
    (1, 5, 5, 5, 5): '1',
    (1, 1, 5, 5, 5): '2',
    (1, 1, 1, 5, 5): '3',
    (1, 1, 1, 1, 5): '4',
    (1, 1, 1, 1, 1): '5',
    (5, 1, 1, 1, 1): '6',
    (5, 5, 1, 1, 1): '7',
    (5, 5, 5, 1, 1): '8',
    (5, 5, 5, 5, 1): '9',

    # Punctuation
    (1, 5, 1, 5, 1, 5): '.',  # Period
    (5, 5, 1, 1, 5, 5): ',',  # Comma
    (1, 1, 5, 5, 1, 1): '?',  # Question Mark
    (1, 5, 5, 5, 5, 1): "'",  # Apostrophe
    (5, 1, 5, 1, 5, 5): '!',  # Exclamation Mark
    (5, 1, 1, 5, 1): '   ',   # SPACE
    (5, 1, 5, 5, 1, 5): '(',  # Left Parenthesis
    (5, 1, 5, 5, 1, 5): ')',  # Right Parenthesis
}

# Font for displaying the text
font = pygame.font.SysFont(None, 50)
small_font = pygame.font.SysFont(None, 36)

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
                tap_start_time = current_time  # Record the start time of the tap

            # Check for the upward peak (release detected)
            if in_touch_cycle and sense_value > upward_peak_threshold:
                current_color = RED  # Turn the box red when released
                in_touch_cycle = False  # End the touch cycle
                tap_duration = current_time - tap_start_time  # Calculate the tap duration

                # Classify the tap as a short tap (1) or long tap (5)
                if tap_duration <= short_tap_threshold:
                    F.append(1)  # Short tap
                elif tap_duration > long_tap_threshold:
                    F.append(5)  # Long tap

                last_upward_time = current_time  # Record the upward peak time

    # Check if the time interval has passed with no new tap (sequence finished)
    if len(F) > 0 and not in_touch_cycle and (time.time() - last_upward_time) > min_time_interval:
        P.append(F[:])  # Store the current sequence F in P
        F.clear()       # Reset F for the next sequence

    # Fill the window with a white background
    window.fill(WHITE)

    # Display "Morse Code Detected" in the top left corner
    count_text = small_font.render("Detected SEQUENCE", True, BLACK)
    window.blit(count_text, (10, 10))

    # Draw the box with the current color (Red or Green)
    pygame.draw.rect(window, current_color, (250, 70, 100, 100))  # Box with size 100x100

    # Display the Morse code sequence in the middle of the box
    morse_sequence = ''.join(map(str, F))
    sequence_text = font.render(morse_sequence, True, BLACK)
    window.blit(sequence_text, (270, 100))  # Center the sequence in the middle of the box

    # Display "Final Morse Code" in the middle
    final_sequence_text = small_font.render("Final Morse Code", True, BLACK)
    window.blit(final_sequence_text, (250, 250))

    # Display the corresponding letters for the Morse code sequences in P
    decoded_text = ''
    morse_code_display = []  # To store Morse code representations
    for sequence in P:
        decoded_letter = morse_code_dict.get(tuple(sequence), '?')  # Get the letter or '?' if not found
        decoded_text += decoded_letter
        
        # Convert the sequence to Morse code format
        morse_code_str = ''.join(['.' if x == 1 else '- ' for x in sequence])
        morse_code_display.append(morse_code_str)  # Add Morse code representation

    # Create the Morse code representation with partitions
    morse_code_representation = ' | '.join(morse_code_display)

    # Render the decoded text (Morse code letters) below "Final Morse Code"
    decoded_text_surface = font.render(decoded_text, True, BLACK)
    window.blit(decoded_text_surface, (50, 290))  # Display decoded text below

    # Render the Morse code representation below the decoded text
    morse_code_surface = font.render(morse_code_representation, True, BLACK)
    window.blit(morse_code_surface, (50, 330))  # Display Morse code representation below

    # Update the display
    pygame.display.flip()

# Clean up and close the serial port
ser.close()
pygame.quit()
