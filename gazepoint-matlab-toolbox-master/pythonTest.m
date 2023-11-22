system(['python ', 'GazepointAPIBanki.py', '&']);

csvFilePath = 'gaze_data_python.csv';

while true
    
    try
        data = readtable(csvFilePath);
        
        FPOGX = data.FPOGX(end);
        FPOGY = data.FPOGY(end);
        FPOGV = data.FPOGV(end);
        CX = data.CX(end);
        CY = data.CY(end);
        
        % Process an duse data
        disp('Received data from Python:');
        disp(['Function FPOGX: ', num2str(FPOGX)]);
        disp(['Function FPOGY: ', num2str(FPOGY)]);
        disp(['Function FPOGV: ', num2str(FPOGV)]);
        disp(['Function CX: ', num2str(CX)]);
        disp(['Function CY: ', num2str(CY)]);
        
    catch
        disp('Error reading file. Waiting for data...'); 
    end
    
    pause(0.5);
end