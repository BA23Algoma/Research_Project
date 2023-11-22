function X_value = processData(data_dict)

% Access individual variables
FPOGX = data_dict;

X_value = FPOGX;

% Process an duse data
disp('Received data from Python:');
disp(['Function FPOGX: ', num2str(FPOGX)]);
%disp(['Function FPOGY: ', num2str(FPOGY)]);
%disp(['Function FPOGV: ', num2str(FPOGV)]);
%disp(['Function CX: ', num2str(CX)]);
%disp(['Function CY: ', num2str(CY)]);

end