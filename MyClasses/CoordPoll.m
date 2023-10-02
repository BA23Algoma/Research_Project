% obj = CoordPoll([timeLimit], [timeInterval])
classdef CoordPoll
    
    properties
        
        elapsedTime;
        nSamples;
        samples;
        tIndex                  = 1;
        t0;
        tStart;
        tDelta;
        timeInterval            = 0.1;
        timeLimit               = 4 * 60;
        nowNum;
        timeoutFlag             = 0;
        
    end
        
    properties (Constant = true)
    
        fileNameSuffix = '.coord.txt';
        
        dataFileHeaders = strcat(...
            'T\t',...
            'X\t',...
            'Y\t',...
            'HEADING\t',...
            'NOW_NUM\n'...
            );
        
    end
    
    methods
        
        function obj = CoordPoll(varargin)
            
            if nargin > 0
            
                obj.timeLimit = varargin{1};
                
            end
            
            if nargin > 1
                
                obj.timeInterval = varargin{2};
                
            end
                        
            obj.nSamples = numel(0:obj.timeInterval:obj.timeLimit);
            obj.samples = zeros(obj.nSamples, 5);
                        
            if nargin > 2
                
                obj.nowNum = varargin{3};
                obj.samples(:, 5) = obj.nowNum;
                
            end
            
        end
        
        
        function obj = Start(obj)
           
            obj.t0 = GetSecs;
            obj.tStart = obj.t0;
            
        end
        
        
        function obj = Update(obj, player)
                      
            t1 = GetSecs;
            obj.tDelta = t1 - obj.t0;
            obj.elapsedTime = t1 - obj.tStart;
           
            if obj.elapsedTime > obj.timeLimit
                
                obj = obj.Stop();
                obj.timeoutFlag = 1;
                return;
            
            elseif obj.tDelta >= obj.timeInterval
               
               obj.samples(obj.tIndex, 1:4) = [obj.elapsedTime player.previousPos(1) player.previousPos(2) player.heading];
               obj.tIndex = obj.tIndex + 1;
               obj.t0 = GetSecs;
               
           end
            
        end
        

        function obj = Stop(obj)
            
            obj.samples = obj.samples(1:obj.tIndex-1, :);
            
        end
        
        
        function SaveToFile(obj, dataPath, participantId, mazeFilePrefix, tourHandStr)
            
           fileName = strcat(num2str(participantId), '.', mazeFilePrefix, '.', tourHandStr, obj.fileNameSuffix);
           
                       % Save header
            if ~exist(fullfile(dataPath, fileName),'file')
            
                fid = fopen( fullfile(dataPath, fileName), 'at');
                
                if (fid == -1)
                    
                    error('Cannot open data file');
                    
                else
                    
                    obj.PrintHeader(fid);
                    fclose(fid);
                    
                end
                
            end
            
            % Save data
            fid = fopen( fullfile(dataPath, fileName), 'at');
            
            if (fid == -1)
                
                error('Cannot open data file');
                
            else
                
                obj.PrintData(fid);
                fclose(fid);
                
            end
            
        end

        
        function PrintHeader(obj, fid)
            
            fprintf(fid, obj.dataFileHeaders);
            
        end
        
        function PrintData(obj, fid)
            
            fprintf(fid, '%3.4f\t%3.4f\t%3.4f\t%3.4f\t%f\n', obj.samples');            
            
        end
                
    end
    
end
