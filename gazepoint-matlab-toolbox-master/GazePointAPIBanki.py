import csv
import time
import datetime
import socket
import matlab.engine
import signal
import sys

# Host machine IP
HOST = '127.0.0.1'
# Gazepoint Port
PORT = 4242
ADDRESS = (HOST, PORT)

# Connect to Gazepoint API
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(ADDRESS)

# Send commands to initialize data streaming
#s.send(str.encode('<SET ID="CALIBRATE_SHOW" STATE="1" />\r\n'))
#s.send(str.encode('<SET ID="CALIBRATE_START" STATE="1" />\r\n'))
#time.sleep(11)
#s.send(str.encode('<SET ID="CALIBRATE_SHOW" STATE="0" />\r\n'))
s.send(str.encode('<SET ID="ENABLE_SEND_CURSOR" STATE="1" />\r\n'))
s.send(str.encode('<SET ID="ENABLE_SEND_POG_FIX" STATE="1" />\r\n'))
s.send(str.encode('<SET ID="ENABLE_SEND_DATA" STATE="1" />\r\n'))

# Connect to MATLAB engine
#eng = matlab.engine.start_matlab()

# Specify the CSV file path
csv_file_path = 'gaze_data_python.csv'

# Create file to output data
with open(csv_file_path, 'w', newline='') as csv_file:
    fieldnames = ['FPOGX', 'FPOGY', 'FPOGV', 'CX', 'CY']
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames) # Create a CSV writer object
    
    # Write the header row
    csv_writer.writeheader()


    def cleanup_and_terminate(signum, frame):
          print("Received terminatoin signal. Cleaning up and existing.")
          # Additional if needed
          s.close()
          sys.exit(0)
   
    signal.signal(signal.SIGTERM, cleanup_and_terminate)
    signal.signal(signal.SIGINT, cleanup_and_terminate)

    while True:
        # Receive data
        rxdat = s.recv(1024)
        data = bytes.decode(rxdat)

        # Get the current timestamp
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')

        # Parse data string
        FPOGX = 0
        FPOGY = 0
        FPOGV = 0
        CX = 0
        CY = 0

        # Split data string into a list of name="value" substrings
        datalist = data.split(" ")

        # Iterate through list of substrings to extract data values
        for el in datalist:
            if (el.find("FPOGX") != -1):
                FPOGX = float(el.split("\"")[1])

            if (el.find("FPOGY") != -1):
                FPOGY = float(el.split("\"")[1])

            if (el.find("FPOGV") != -1):
                FPOGV = float(el.split("\"")[1])

            if (el.find("CX") != -1):
                CX = float(el.split("\"")[1])

            if (el.find("CY") != -1):
                CY = float(el.split("\"")[1])

        # Write data to file
        data_dict = {
            'FPOGX': FPOGX,
            'FPOGY': FPOGY,
            'FPOGV': FPOGV,
            'CX': CX,
            'CY': CY
        }
        csv_writer.writerow(data_dict)

        # Parse data to MATLAB
        #eng.workspace['FPOGX'] = float(FPOGX)
        #eng.eval('processData(FPOGX);', nargout=1)

        # Print results
        print(timestamp)
        print("FPOGX:", FPOGX)
        print("FPOGY:", FPOGY)
        print("FPOGV:", FPOGV)
        print("CX:", CX)
        print("CY:", CY)
        print("\n")

# The file will be automatically closed when exiting the 'with' block

s.close()
