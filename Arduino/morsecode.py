import serial
import time

# Open serial port
ser = serial.Serial('COM3', 19200)

threshold_value = 850
debounce_time = 200  # Debounce time in milliseconds
min_interval = 500  # Minimum interval between claps in a sequence (milliseconds)
ignore_time = 50  # Ignore time in milliseconds (to ignore subsequent values)
max_interval=1000
count = 0
last_clap_time = 0
ignore_until = 0
F=[]
P=[]
M=[]

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


while True:
    # Read data from Arduino
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
            sound_value = int(data_decoded)
        except ValueError:
            # If conversion to int fails, skip this iteration
            continue

        # Get the current time in milliseconds
        current_time = int(time.time() * 1000)

        # Check if sound value is greater than threshold value
        if sound_value > threshold_value:
            # Check if the debounce time has passed since the last clap
            if current_time - last_clap_time > debounce_time and current_time > ignore_until:
                # Check if the interval between claps is less than min_interval
                if current_time - last_clap_time < min_interval:
                    count += 1
                else:
                    if current_time - last_clap_time < max_interval:
                        # If the interval is too large, start a new sequence
                        print(f"Final count: {count}")
                        if count==1 :
                            F.append(1)
                        if count>=2 :
                            F.append(5)
                        print(f"F={F}")
                       
                    if current_time - last_clap_time > max_interval:
                        if count==1:
                            F.append(1)
                        if count>=2 :
                            F.append(5)
                        print(f"F={F}")
                        P.append(F)
                        if [] in P:
                            P.remove([])
                        print(f"P={P}")
                        F=[]
                        if len(P) >=1:
                            code=P[-1]
                            code_tuple = tuple(code)  # Convert list to tuple to match keys
                            rm=reverse_morse_code[code_tuple]
                            M.append(rm)
                            print(f"M={M}")
                    count = 1


                last_clap_time = current_time
                ignore_until = current_time + ignore_time
                print(f"Clap detected! Consecutive count: {count}")

    time.sleep(0.0001)
