outputFileName = "Test";

fileID = fopen(outputFileName,'w');

% set up address and port, and configure socket properties
session2_client = tcpip_open('144.212.130.17', 80);