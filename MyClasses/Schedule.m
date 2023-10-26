% obj = Schedule([participantId], [runType], [nBlocks], [tourHand])
classdef Schedule
        
    properties
        
         trials;
        
    end
    
    properties (GetAccess = public, SetAccess = protected)
        
        runType;
        nBlocks;
        mazePath            = 'Mazes';
        participantId       = 0;       
        nMazes;
        nMazesPerBlock;
        nTours;
        nTrials;
        nCols;
        mazeFileNames;
        nToursPerTrial      = 1;
        tourHand;
        tourFileNames;
        
    end
    
    properties (Constant)
        
        COL = struct(...
            'MAZE_FILE_INDEX',  1,...
            'BLOCK',            2,...
            'TOUR_HAND',        3,...
            'IS_COMPLETE',      4,...
            'DELTA_TIME',       5,...
            'N_ERRORS',         6,...
            'EOL_RATING',       7,...
            'JOL_RATING',       8,...
            'RCJ_RATING',       9);        
        
        dataFileNameSuffix      = '.data.txt';
        validRunTypes           = {'PRACTICE', 'EXPERIMENT'};
        validTourHand           = [1 2];
        
        dataFileHeaders = strcat(...            
            'MAZE_FILE_INDEX\t',...
            'BLOCK\t',...
            'TOUR_HAND\t',...
            'IS_COMPLETE\t',...
            'DELTA_T\t',...
            'N_ERRORS\t',...
            'EOL_RATING\t',...
            'JOL_RATING\t',...
            'RCJ_RATING\t',...
            'PLAYER_LIN_VEL\t',...
            'PLAYER_RAD_VEL\t',...
            'PLAYER_BODY_RADIUS\t',...
            'N_PRAC_TRIALS\t',...
            'N_BLOCKS\t',...
            'TOUR_LIN_VEL\t',...
            'TOUR_RAD_VEL\t',...
            'FRAME_RATE\t',...
            'PERSPEC_ANGLE\t',...
            'EYE_LEVEL\t',...
            'COORD_T_INTERVAL\t',...
            'COORD_MAX_T\t',...
            'N_ROWS\t',...
            'N_COLS\t',...
            'NOW_NUM\t',...
            'DATE\n'...
            );
        
    end
    
    methods
        
        function obj = Schedule(varargin)
            
            if nargin > 0
               
                if isnumeric(varargin{1})
                    
                    obj.participantId = varargin{1};
                    
                end
                
            end
            
            if nargin > 1
                
                obj.runType = upper(varargin{2});
                
                obj = LoadMazeFileNames(obj);
                
            end
            
            if nargin > 2
                
                switch upper(obj.runType)
                    
                    case 'PRACTICE'
                        
                        obj.nBlocks = varargin{3};
                        obj.nMazesPerBlock = 1;
                    
                    case 'EXPERIMENT'
                        
                        if ~isempty(obj.runType) && ~isempty(obj.nMazes)
                            
                            if mod(obj.nMazes, varargin{3}) == 0
                                
                                obj.nBlocks = varargin{3};
                                obj.nMazesPerBlock = obj.nMazes / obj.nBlocks;
                                
                            else
                                
                                error('nBlocks must divide evenly into the number of mazes');
                                
                            end
                            
                        end
                        
                        
                end
                
                
            end
            
            if nargin > 3
                
                if isnumeric(varargin{4})
                    
                    if ismember(varargin{4}, obj.validTourHand)
                        
                        obj.tourHand = varargin{4};
                        
                    end
                    
                end
                
            end
                                    
            
            if nargin > 4
                
                error('Too many input arguments');
                
            end
            
            
            if ~isempty(obj.runType) && ~isempty(obj.nBlocks) && ~isempty(obj.nMazesPerBlock) && ~isempty(obj.tourHand)
                
                obj = InitTrials(obj);
                
            end
            
        end
        
        
        function obj = LoadMazeFileNames(obj)
            
            if isempty(obj.runType)
                
                error('Maze runType must be defined prior to loading maze files');
                
            end
            
            obj.mazeFileNames = {};
            obj.nMazes = [];
            
            switch upper(obj.runType)
                
                case 'PRACTICE'
                    
                    h = dir(fullfile(obj.mazePath, 'MazeTemplate.txt'));
                    obj.mazeFileNames = {h(:).name};
                    obj.nMazes = numel(h);
                    
                    if obj.nMazes ~= 1
                        
                        error('Expected number of mazes doesn''t match number of actual mazes');
                        
                    end
                    
                    % Used for AI tour of maze

                    %h = dir(fullfile(obj.mazePath, 'P5.tour.txt'));
                    %obj.tourFileNames = {h(:).name};
                    %obj.nTours = numel(h);
                    
                    %if obj.nTours ~= 1
                        
                        %error('Expected number of tours doesn''t match number of actual mazes');
                        
                    %end
                    
                    
                case 'EXPERIMENT'
                    
                    h = dir(fullfile(obj.mazePath, strcat('*', Maze.fileNameSuffix)));
                    practiceIndex = find(strcmp({h(:).name}, 'MazeTemplate.txt'));
                    fullIndex = 1:numel(h);
                    
                    h = h(setxor(practiceIndex, fullIndex));
                    
                    obj.mazeFileNames = {h(:).name}';
                    obj.nMazes = numel(h);

                     % Used for AI tour of maze
                                        
                   % h = dir(fullfile(obj.mazePath, strcat('*', MazeTour.fileNameSuffix)));
                    %practiceIndex = find(strcmp({h(:).name}, 'P5.tour.txt'));
                    %fullIndex = 1:numel(h);
                    
                    %h = h(setxor(practiceIndex, fullIndex));
                    
                    %obj.tourFileNames = {h(:).name}';
                    %obj.nTours = numel(h);
                    
                    %if obj.nTours ~= obj.nMazes
                        
                        %error('Number of tours doesn''t match number of mazes');
                        
                    %end
                    
                    
                otherwise
                    
                    error('Unknown tour runType');
                    
            end
            
        end
        
        
        function obj = InitTrials(obj)
            
            if isempty(obj.runType)
                
                error('Object runType (PRACTICE or EXPERIMENT) must be defined prior to initialization');
                
            elseif isempty(obj.nBlocks)
                
                error('Object nBlocks must be defined prior to initialization');
                                
            elseif isempty(obj.nMazesPerBlock)
                
                error('Object nMazesPerBlock must be defined prior to initialization');
            
            elseif isempty(obj.tourHand)
                
                error('Object tourHand must be defined prior to initialization');
                
            else
                
            end
            
            obj.nCols = numel(fieldnames(obj.COL));
            
            obj.nTrials = obj.nBlocks * obj.nMazesPerBlock;
            
            obj.trials = zeros(obj.nTrials, obj.nCols);
                                    
            obj.trials(:, obj.COL.MAZE_FILE_INDEX) = randperm(obj.nMazes)';
                                    
            trialIndex = 1;
            
            thisTourHand = obj.tourHand;
            
            for blockIndex = 1:obj.nBlocks

                for mazesPerBlockIndex = 1:obj.nMazesPerBlock
                
                    obj.trials(trialIndex, obj.COL.BLOCK) = blockIndex;
                                                            
                    obj.trials(trialIndex, obj.COL.TOUR_HAND) = thisTourHand;
                    thisTourHand = 1-(thisTourHand-1) + 1;
                    
                    trialIndex = trialIndex + 1;
                    
                end
                
            end 
                        
        end
        
        
        function obj = Randomize(obj)
            
            oddTrialIndex = find(obj.trials(:, obj.COL.TOUR_HAND) == 1);
            oddTrialIndex = oddTrialIndex(randperm(numel(oddTrialIndex)), :);
            evenTrialIndex = find(obj.trials(:, obj.COL.TOUR_HAND)  == 2);
            evenTrialIndex = evenTrialIndex(randperm(numel(evenTrialIndex)), :);
            
            if obj.tourHand == 1
                
                randomIndex = [oddTrialIndex evenTrialIndex];
                
            elseif obj.tourHand == 2
                
                randomIndex = [evenTrialIndex oddTrialIndex];
                
            else
                
                error('Unknown tour hand');
                
            end
            
            randomIndex = reshape(randomIndex', [obj.nTrials 1]);
            
            obj.trials = obj.trials(randomIndex, :);
            
            blockIndex = repmat((1:obj.nBlocks)', [1 obj.nMazesPerBlock]);
            blockIndex = reshape(blockIndex', [obj.nTrials 1]);
            
            obj.trials(:, obj.COL.BLOCK) = blockIndex;
            
        end
        
        
        function obj = set.runType(obj, MazeType)
            
            if ischar(MazeType)
                
                if any(strcmp(obj.validRunTypes, MazeType))
                    
                    obj.runType = MazeType;
                    
                else
                    
                    error('Invalid Maze runType');
                    
                end
                
            else
                
                error('Maze runType must be a string');
                
            end
            
        end
        
        
        function obj = set.nBlocks(obj, NBlocks)
            
            if isnumeric(NBlocks)
                
                obj.nBlocks = NBlocks;
                
            else
                
                error('nBlocks must be numeric');
                
            end
            
        end
        
        
        function obj = set.nMazesPerBlock(obj, NMazesPerBlock)
            
            if isnumeric(NMazesPerBlock)
                
                obj.nMazesPerBlock = NMazesPerBlock;
                
            else
                
                error('nBlocks must be numeric');
                
            end
            
        end
        
        
        function obj = set.tourHand(obj, TourHand)
            
            if isnumeric(TourHand)
                
                obj.tourHand = TourHand;
                
            else
                
                error('tourHand must be a string');
                
            end
            
        end
        
        
        function SaveToFile(obj, p)
            
            fileName = strcat(num2str(p.participantId), '.', MazeTour.TourHandStr(p.tourHand), obj.dataFileNameSuffix);
            
            % Save header
            if ~exist(fullfile(p.dataPath, fileName),'file')
            
                fid = fopen( fullfile(p.dataPath, fileName), 'at');
                
                if (fid == -1)
                    
                    error('Cannot open data file');
                    
                else
                    
                    obj.PrintHeader(fid);
                    fclose(fid);
                    
                end
                
            end
            
            % Save data
            fid = fopen( fullfile(p.dataPath, fileName), 'at');
            
            if (fid == -1)
                
                error('Cannot open data file');
                
            else
                
                obj.PrintData(fid, p);
                fclose(fid);
                
            end
            
        end
        
        
        function PrintHeader(obj, fid)
            
            fprintf(fid, obj.dataFileHeaders);
            
        end
        
        function PrintData(obj, fid, p)
            
            for trialIndex = 1:obj.nTrials
                
                fprintf(fid, '%i\t%i\t%i\t%i\t%3.4f\t%i\t%i\t%i\t%i\t', obj.trials(trialIndex, :));
                fprintf(fid, '%3.4f\t', p.playerDeltaUnitPerFrame);
                fprintf(fid, '%3.4f\t', p.playerDeltaDegPerFrame);
                fprintf(fid, '%3.4f\t', p.playerBodyRadius);
                fprintf(fid, '%i\t', p.nPracticeTrials);
                fprintf(fid, '%i\t', p.nBlocks);
                fprintf(fid, '%3.4f\t', p.tourDeltaUnitPerFrame);
                fprintf(fid, '%3.4f\t', p.tourDeltaDegPerFrame);
                fprintf(fid, '%3.4f\t', p.frameRate);
                fprintf(fid, '%3.4f\t', p.perspectiveAngle);
                fprintf(fid, '%3.4f\t', p.eyeLevel);
                fprintf(fid, '%3.4f\t', p.coordPollInterval);
                fprintf(fid, '%3.4f\t', p.coordPollTimeLimit);
                fprintf(fid, '%i\t', p.nRows);
                fprintf(fid, '%i\t', p.nCols);
                fprintf(fid, '%f\t', p.nowNum);
                fprintf(fid, '%s\n', datestr(p.nowNum, 0));
                
            end
            
        end
        
    end
        
end
    
