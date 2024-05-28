import serial
import time

# Define serial port parameters
ser = serial.Serial('COM5', 9600, timeout=30)

# Send 8 bits through UART
data_to_send = b'\x01'
ser.write(data_to_send)

# Receive 8 bits through UART
received_data = ser.read(1)

# Print received data
print("Received data:", received_data.hex())

# Close serial port
ser.close()