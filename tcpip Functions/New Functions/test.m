%open new socket communication
%t = tcpip_open('144.212.130.17', 80);
t = tcpip_open('144.212.130.17', 4242);

%open client
fopen(t);

%run calibration
tcpip_write(t, '<SET ID="CALIBRATE_RESET"/>');
tcpip_write(t, '<SET ID="CALIBRATE_SHOW" STATE="1" />');
tcpip_write(t, '<SET ID="CALIBRATE_START" STATE="1" />');
pause(3);
tcpip_write(t,'<SET ID="CALIBRATE_START" STATE="0" />');
tcpip_write(t,'<SET ID="CALIBRATE_SHOW" STATE="0" />');

%Review the calibration summary
%tcpip_write(t, '<GET ID="CALIBRATE_RESULT_SUMMARY" />');

%% Spawn a second Matlab session2 that records GP3 data to output file
outputFileName = 'example_output.txt';

%Execute recording GP3 Update
%ExecuteRecordGP3DataUpdated(t,outputFileName);

% Wait for Client2_Ready Message before proceeding
Client_WaitForMessage(t, 'Client2_Ready');

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(t);

