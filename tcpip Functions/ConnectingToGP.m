function clientpsych = ConnectingToGP

%Creates Matlab client to connect to GazePoint GP3 server TCP socket in the main Matlab session
%Author: Banki Adewalae (badewale@algomau.ca)
%Created: 9/26/2023
%Last Update: N/A

clientpsych = tcpip_open('192.0. 2.0',4242);
