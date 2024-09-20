import serial
import time

# Open serial port
ser = serial.Serial('/dev/ttyACM0', 38400)

threshold_value = 550
debounce_time = 180  # Debounce time in milliseconds
count = 0
last_clap_time = 0

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
            if current_time - last_clap_time > debounce_time:
                count += 1
                last_clap_time = current_time
                print("Clap detected! Count:", count)

    time.sleep(0.0001)