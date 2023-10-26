function RecordGPData(client, outputFileName, varargin)
%Starts a new Matlab session and runs RecordGPData function; Also pauses
%the main Matlab session to give the new session time to load up
%
%varargin are the user-defined GP3 data configuration options for session2
%client
%
%%Author: Ringo Huang (ringohua@usc.edu)
%Created: 8/8/2017
%Last Update: 8/20/2017

tcpip_write(client,'');
tcpip_write(client, '<SET ID="ENABLE_SEND_USER_DATA" STATE="1" />');
tcpip_write(client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
tcpip_write(client,'START_RECORDING')

if exist([pwd '/RecordGPData.m'],'file')
    % run this if the GP functions are in the same folder as the main
    % script
    fn_args = CreateInputfn_args(varargin{:});
    eval(['!matlab -nosplash -nodesktop -r "RecordGPData(''' outputFileName fn_args ''')" &'])
else
    % run this if the GP functions are in a sub-folder of the main script
    fn_args = CreateInputfn_args(varargin{:});
    eval(['!matlab -nosplash -nodesktop -r "addpath(genpath(pwd)); RecordGPData(''' outputFileName fn_args ''')" &'])
end

tcpip_write(client, '\nConnecting with session 2 client. Please wait...\n\n')
pause(.05)

%% Wait until session2 client is ready
time_start=tic;
while  1
    %scan data from buffer and parse the xml format
    dataReceived = tcpip_read(client, 1024);
    split = strsplit(dataReceived,'"');
    current_user_data = split{end-1};
    if strcmp(current_user_data,'CLIENT2_READY')
        tcpip_write(client, '\nConnection Successful! Starting Experiment...\n\n')
        break
    end
    if toc(time_start) > 120
        error('Connection time out: could not connect to session 2 client;')
    end
     pause(.01);
end

%% Stop recording on this client
tcpip_write(client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');

commandwindow; %returns window control to session 1's command window

%% Creates the fn_args that is passed into the eval function
function fn_args = CreateInputfn_args(varargin)
    fn_args = '';
    for i=1:length(varargin)
        fn_args = [fn_args ''',''' varargin{i} ];
    end

