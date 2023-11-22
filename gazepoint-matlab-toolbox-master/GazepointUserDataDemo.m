%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gazepoint sample program for USER_DATA embedding via the Gazepoint API 
% Written in 2017 by Gazepoint www.gazept.com
%
% To the extent possible under law, the author(s) have dedicated all copyright 
% and related and neighboring rights to this software to the public domain worldwide. 
% This software is distributed without any warranty.
%
% You should have received a copy of the CC0 Public Domain Dedication along with this 
% software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup address and port
client_socket = tcpip('127.0.0.1', 4242); 

client_socket.Timeout = 5;

fopen(client_socket);

% setup line terminator
%set(client_socket, 'Terminator', 'CR/LF'); 
%configureTerminator(client_socket,'CR/LF');
%client_socket.Terminator = "CR/LF";

% Test Calibration
command = {
    '<SET ID="CALIBRATE_SHOW" STATE="1" /\r\n>'
    '<SET ID="CALIBRATE_START" STATE ="1" />\r\n'
};

for i = 1:numel(command)
    data = uint8(command{i});
    write(client_socket, data); % begin EXP1
end
pause(1)

calibration_complete = false;

%check calibratoin
while ~calibration_complete
    data = uint8('<GET ID = "CALIBRATION_RESULT_PT" />\r\n');
    write(client_socket, data); % begin EXP1
    response = read(client_socket, 'Timeout', 5); % begin EXP1
    
    if contains(repsonse, '<CAL ID="CALIB_RESULT"')
        calibration_complete = true;
        disp('Calibration complete');
        data = uint8('<SET ID = "CALIBRATE_SHOW" STATE = "0" />\r\n');
        write(client_socket, data); % begin EXP1
        pause(3)
        break;
    else
        disp('Calibration in progress...');
        pause(2);
    end
end

% Send the USER_DATA value to mark a region of gaze data (such as Experiment 1)
% Use a numeric value to simplify further analysis
command = '<SET ID="USER_DATA" VALUE="1" />\r\n';
data = uint8(command);
write(client_socket, data); % begin EXP1
pause(1);

command = '<SET ID="USER_DATA" VALUE="2" />\r\n';
data = uint8(command);
write(client_socket, data); % begin EXP2
pause(1.5);


command = '<SET ID="USER_DATA" VALUE="3" />\r\n';
data = uint8(command);
write(client_socket, data); % begin EXP3
pause(2);

command = '<SET ID="USER_DATA" VALUE="" />\r\n';
data = uint8(command);
write(client_socket, data); % clear field 

% Send the USER_DATA value to mark a single event, assign an event a number
command = '<SET ID="USER_DATA" VALUE="88" DUR="1" />\r\n';
data = uint8(command);
write(client_socket, data);  % Event 88 occured
pause(0.2);

command = '<SET ID="USER_DATA" VALUE="99" DUR="1" />\r\n';
data = uint8(command);
write(client_socket, data);% Event 99 occured
pause(0.5);

command = '<SET ID="USER_DATA" VALUE="88" DUR="1" />\r\n';
data = uint8(command);
write(client_socket, data);  % Event 88 occured
pause(0.2);

command = '<SET ID="USER_DATA" VALUE="88" DUR="1" />\r\n';
data = uint8(command);
write(client_socket, data);% Event 88 occured
pause(0.2);

command = '<SET ID="USER_DATA" VALUE="101" DUR="1" />\r\n';
data = uint8(command);
write(client_socket, data); %Event 101 occured
pause(0.4);

command = '<SET ID="USER_DATA" VALUE="99" DUR="1" />\r\n';
data = uint8(command);
write(client_socket, data); % Event 99 occured
pause(0.5);

% clean up
clear client_socket 
