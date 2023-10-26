%open new socket communication
t_socket = tcpip_servsocket(4242);

%Establish connection using socket
t = tcpip_open('144.212.130.17', 4242);
%t = tcpip_open('127.0.0.1', 4242);

fprintf("Test connection...");
pause(5);

tcpip_close()