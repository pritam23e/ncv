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
                        F.append(count)
                        print(f"F={F}")
                       
                    if current_time - last_clap_time > max_interval:
                       F.append(count)
                       print(f"F={F}")
                       P.append(F)
                       print(f"P={P}")
                       F=[]
                    count = 1


                last_clap_time = current_time
                ignore_until = current_time + ignore_time
                print(f"Clap detected! Consecutive count: {count}")

    time.sleep(0.0001)
