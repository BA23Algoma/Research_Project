         function MazeExp                   
         
    %     %   GUI modifiable parameters                     
    %     p.participantId                 = 0;
    %     p.nBlocks                       = 5;  
    %     p.nPracticeTrials               = 5;     
    %     p.tourHand                      = 1;
    %     p.inputDevice                   = 1;
    %     p.playerBodyRadius              = 0.125;
    %     p.playerDeltaUnitPerFrame       = 0.075;
    %     p.playerDeltaDegPerFrame        = 3.0;
    %     p.tourDeltaUnitPerFr ame        = 0.075;
    %     p.tourDeltaDegPerFrame          = 3.0;   
    %     p.viewPoint                     = 1;
    %     p.frameRate                     = 60;
    %     p.perspectiv eAngle             = 45;
    %     p.eyeLevel                      = -0.55;
    %     p.coordPollInterval             = 0.1;
    %     p.coordPollTimeLimit            = 240;
    
    Randomizer();

    %add 2007 file to path
    setPath = what('MatlabWindowsFilesR2007a');
    addpath(setPath.path);
      
    mazeExpConfig = MazeExpConfig;
    p = mazeExpConfig.Read();
    
    p = MazeExpGUI(p);
    
    if p.isExit              
        
        error('User abort');
        
    end
    
    p.nowNum = now;  
    
    % Internal fixed param  eters
    p.checkCollisionFlag            = 1;
    
    % Path
    p.dataPath                      = 'Data';
    p.eolPracticeFlag               = 0;
    p.initialTourFlag               = 0;
    p.blockPracticeFlag             = 0;
    p.blockTourFlag                 = 0;
    p.blockRunFlag                  = 1;
    
    if (exist(p.dataPath, 'dir')==7)
        
        %         do nothing
        
    else
        
        if ~mkdir(p.dataPath)
            
            error('Cannot create directory');
              
        end
        
    end
    
    % Input device (hack for now)
    if p.inputDevice == 1
        
        inputDevice = Keyboard();
        
    elseif p.inputDevice == 2
        
        if ismac
            
            inputDevice = JoystickMac(0.25);
            
        elseif ispc
            
            inputDevice = JoystickWin(0.25);
            
        else
            
            error('Invalid platform (not Mac and not PC)');
            
        end
        
    else
        
        error('Unknown input device');
        
    end
    
    % Player
    player = Player(p.playerBodyRadius, p.playerDeltaDegPerFrame, p.playerDeltaUnitPerFrame);
    
    % Render
    render = Render([p.screenWidth p.screenHeight p.frameRate]);
    render = render.InitMazeWindow(p.perspectiveAngle, p.eyeLevel, p.viewPoint);
    p.nRows = render.nRows;
    p.nCols = render.nCols;
    
    % Rating
    rating = Rating(150, 'Textures');
    rating = rating.Load(render);
    
    % Standby
    standby =    Standby;
    
    % Standby Big Numbers
    standbyBigNumber = StandbyBigNumber;
    
    % SplashScreen
    splashScreen = SplashScreen;
    
    % -----------------------
    % PHASE 1 (PRACTICE EOL)
    
    % Practice EOL
    if p.eolPracticeFlag
        
        splashScreen.ShowSplashScreen(render, inputDevice, 'Instructions1.jpg', 'Textures');
        
        schedule = Schedule(p.participantId, 'PRACTICE', p.nPracticeTrials, p.tourHand);
        
        for trialIndex = 1:schedule.nTrials
       
            % Load maze
            mazeFileIndex = schedule.trials(trialIndex, Schedule.COL.MAZE_FILE_INDEX   );
            mazeFileName = schedule.mazeFileNames{mazeFileIndex};
            
            maze = Maze(mazeFileName, p.checkCollisionFlag);
            
            standby.ShowStandby(render, inputDevice, 'Get Ready for Practice Tour', 'Hit SPACE BAR when ready.');
            
            % Maze tour
            mazeTour = MazeTour(maze.FilePrefix, p.tourHand, maze.pathName, p.tourDeltaDegPerFrame, p.tourDeltaUnitPerFrame);
            maze.Tour(mazeTour, render, player, inputDevice);
            
            rating = rating.Load(render);
            rating.RatingSelect(render, inputDevice, 'EOL');
            
        end
        
    end
    
    % -----------------------
    % PHASE 2 (EXPERIMENT EOL)
    
    expSchedule = Schedule(p.participantId, 'EXPERIMENT', p.nBlocks, p.tourHand);
    if p.initialTourFlag
        
        splashScreen.ShowSplashScreen(render, inputDevice, 'Instructions2.jpg', 'Textures');        
        
        for trialIndex = randperm(expSchedule.nTrials)        
            
            % Load maze
            mazeFileIndex = expSchedule.trials(trialIndex, Schedule.COL.MAZE_FILE_INDEX);
            mazeFileName = expSchedule.mazeFileNames{mazeFileIndex};
            tourHand = expSchedule.trials(trialIndex, Schedule.COL.TOUR_HAND);
            maze = Maze(mazeFileName, p.checkCollisionFlag);
            
            % Maze tour
            mazeTour = MazeTour(maze.FilePrefix, tourHand, maze.pathName, p.tourDeltaDegPerFrame, p.tourDeltaUnitPerFrame);
            
            standby.ShowStandby(render, inputDevice, 'Get Ready For Maze Tour', 'Hit SPACE BAR when ready.');
            
            maze.Tour(mazeTour, render, player, inputDevice);
            
            WaitSecs(.25);
            eolRating = rating.RatingSelect(render, inputDevice, 'EOL');
            expSchedule.trials(trialIndex, Schedule.COL.EOL_RATING) = eolRating;
            
        end
        
        message1Str = 'You may take a short break.';
        message2Str = 'Please stay seated and do not disturb others.';
        message3Str = 'Hit SPACE BAR to begin next phase.';
        standby.ShowStandby(render, inputDevice, message1Str, message2Str, message3Str);
        
    end
    
    
    % -----------------------
    % PHASE 3 PRACTICE (JOLs and RCJs)
    
    if p.blockPracticeFlag
        
        schedule = Schedule(p.participantId, 'PRACTICE', p.nPracticeTrials, p.tourHand);
        
        splashScreen.ShowSplashScreen(render, inputDevice, 'Instructions3.jpg', 'Textures');
        
        for trialIndex = 1:schedule.nTrials
            
            % Load maze
            mazeFileIndex = schedule.trials(trialIndex, Schedule.COL.MAZE_FILE_INDEX);
            mazeFileName = schedule.mazeFileNames{mazeFileIndex};
            maze = Maze(mazeFileName, p.checkCollisionFlag);
            
            standby.ShowStandby(render, inputDevice, 'Get Ready for Practice Tour', 'Hit SPACE BAR when ready.');
            
            % Maze tour
            mazeTour = MazeTour(maze.FilePrefix, p.tourHand, maze.pathName, p.tourDeltaDegPerFrame, p.tourDeltaUnitPerFrame);
            maze.Tour(mazeTour, render, player, inputDevice);
            rating = rating.Load(render);
            rating.RatingSelect(render, inputDevice, 'JOL');
            
            % Maze run  
            message1Str = sprintf('Get Ready To Run In Maze');
            standby.ShowStandby(render, inputDevice, message1Str, 'Hit SPACE BAR when ready.');
            maze.Explore(render, player, inputDevice, p.coordPollTimeLimit, p.coordPollInterval, p.nowNum);
            %         WaitSecs(.25);
            rating.RatingSelect(render, inputDevice, 'RCJ');
            
        end
        
    end
    
    % -----------------------
    % PHASE 4 EXPERIMENT (JOLs and RCJs)
    
    splashScreen.ShowSplashScreen(render, inputDevice, 'Instructions4.jpg', 'Textures');
    
    expSchedule = expSchedule.Randomize();
    
    for blockIndex = 1:expSchedule.nBlocks
        
        message1Str = sprintf('Block %i', blockIndex);
        standby.ShowStandby(render, inputDevice, message1Str, 'Hit SPACE BAR when ready.');
        
        % -----------------------
        % JOL
        
        if p.blockTourFlag
            
            for labelIndex = 1:expSchedule.nMazesPerBlock
                
                trialIndex = labelIndex + (blockIndex-1) * expSchedule.nMazesPerBlock;
                
                % Load maze        
                mazeFileIndex = expSchedule.trials(trialIndex, Schedule.COL.MAZE_FILE_INDEX);
                mazeFileName = expSchedule.mazeFileNames{mazeFileIndex};
                
                maze = Maze(mazeFileName, p.checkCollisionFlag);
                
                % Maze tour
                
                if expSchedule.nMazesPerBlock ~= 1
                    
                    standbyBigNumber.ShowStandbyBigNumber(render, inputDevice, 'Get Ready For Maze Tour:', labelIndex, 'Hit SPACE BAR when ready.');
                    
                end
                mazeTour = MazeTour(maze.FilePrefix, p.tourHand, maze.pathName, p.tourDeltaDegPerFrame, p.tourDeltaUnitPerFrame);
                maze.Tour(mazeTour, render, player, inputDevice);
                
                WaitSecs(.25);
                jolRating = rating.RatingSelect(render, inputDevice, 'JOL');
                expSchedule.trials(trialIndex, Schedule.COL.JOL_RATING) = jolRating;
                
            end
            
        end
        
        % -----------------------
        % RCJ
        
        if p.blockRunFlag
            
            for labelIndex = randperm(expSchedule.nMazesPerBlock)
                
                trialIndex = labelIndex + (blockIndex-1) * expSchedule.nMazesPerBlock;
                
                % Load maze
                mazeFileIndex = expSchedule.trials(trialIndex, Schedule.COL.MAZE_FILE_INDEX);
                mazeFileName = expSchedule.mazeFileNames{mazeFileIndex};
                
                maze = Maze(mazeFileName, p.checkCollisionFlag);
                
                if expSchedule.nMazesPerBlock ~= 1
                
                    standbyBigNumber.ShowStandbyBigNumber(render, inputDevice, 'Get Ready To Run In Maze:', labelIndex, 'Hit SPACE BAR when ready.');
                
                end
                [coordPoll, isCompleteFlag, stats] = maze.Explore(render, player, inputDevice, p.coordPollTimeLimit, p.coordPollInterval, p.nowNum);
                
                coordPoll.SaveToFile(p.dataPath, p.participantId, maze.filePrefix, MazeTour.TourHandStr(p.tourHand));
                
                expSchedule.trials(trialIndex, Schedule.COL.IS_COMPLETE) = isCompleteFlag;
                expSchedule.trials(trialIndex, Schedule.COL.DELTA_TIME) = stats(1);
                expSchedule.trials(trialIndex, Schedule.COL.N_ERRORS) = stats(2);
                
                WaitSecs(.25);
                rcjRating = rating.RatingSelect(render, inputDevice, 'RCJ');
                expSchedule.trials(trialIndex, Schedule.COL.RCJ_RATING) = rcjRating;
                                
            end
            
            message1Str = 'You may take a short break.';
            message2Str = 'Please stay seated and do not disturb others.';
            message3Str = 'Hit SPACE BAR to begin next block.';
            standby.ShowStandby(render, inputDevice, message1Str, message2Str, message3Str);
            
        end
        
    end
             
    expSchedule.SaveToFile(p);
          
    splashScreen.ShowSplashScreen(render, inputDevice, 'Debriefing.jpg', 'Textures');
    
    Render.Close();
    
end