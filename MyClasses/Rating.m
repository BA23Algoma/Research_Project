classdef Rating
    
    properties
        
        texturePtrArray;
        messagePtrArray;
        labelsPtrArray;
        fontSize1           = 72;
        imageSize           = 200;
        currentNumber;
        imagePathName;
        waitTime            = .2;
        
    end
    
    properties (Constant)
        
        nNumbers = 5;
        validFileSuffix = {'.off.jpg', '.on.jpg'};
        ratingIndex = [0 25 50 75 100];
        OFF = 1;
        ON = 2;
        validModes = {'EOL', 'JOL', 'RCJ'};
        nModes = 3;
        nLabels = 4;
        
    end
    
    methods
        
        function obj = Rating(varargin)
            
            if nargin > 0
                
                obj.imageSize = varargin{1};
                
            end
            
            if nargin > 1
                
                obj.imagePathName = varargin{2};
                
            end
            
        end
        
        function obj = Load(obj, render)
            
            if ~render.isPtbWindowOk
                
                error('PsychToolbox window must be active');
                
            else
                
                obj.texturePtrArray = zeros(obj.nNumbers, 2);
                
                for numberIndex = 1:obj.nNumbers
                    
                    for offOnIndex = 1:2
                        
                        fileName = strcat(num2str(obj.ratingIndex(numberIndex)), Rating.validFileSuffix{offOnIndex});
                        imageMatrix = imread(fullfile(obj.imagePathName, fileName));
                        obj.texturePtrArray(numberIndex, offOnIndex) = Screen('MakeTexture', render.viewportPtr, imageMatrix);
                        
                    end
                    
                end
                
                obj.messagePtrArray = zeros(obj.nModes, 1);
                obj.messagePtrArray(1) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'EOLtext.jpg')));
                obj.messagePtrArray(2) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'JOLtext.jpg')));
                obj.messagePtrArray(3) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'RCJtext.jpg')));
                
                obj.labelsPtrArray = zeros(obj.nLabels, 1);
                obj.labelsPtrArray(1) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'Difficult.jpg')));
                obj.labelsPtrArray(2) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'Easy.jpg')));
                obj.labelsPtrArray(3) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'NotConfident.jpg')));
                obj.labelsPtrArray(4) = Screen('MakeTexture', render.viewportPtr, imread(fullfile(obj.imagePathName, 'Confident.jpg')));

                
            end
            
        end
        
        function currentRating = RatingSelect(obj, render, inputDevice, ratingMode)
            
            if ~render.isPtbWindowOk
                
                error('PsychToolbox window must be open');
                
            else
                
                % --------------------
                % JPG
                switch upper(ratingMode)
                    
                    case 'EOL'
                        
                        messagePtr = obj.messagePtrArray(1);
                        label1Ptr = obj.labelsPtrArray(1);
                        label2Ptr = obj.labelsPtrArray(2);
                        
                    case 'JOL'
                        
                        messagePtr = obj.messagePtrArray(2);
                        label1Ptr = obj.labelsPtrArray(3);
                        label2Ptr = obj.labelsPtrArray(4);
                        
                    case 'RCJ'
                        
                        messagePtr = obj.messagePtrArray(3);
                        label1Ptr = obj.labelsPtrArray(3);
                        label2Ptr = obj.labelsPtrArray(4);

                        
                end
                
                messageRect = render.scaleRatio * Screen('Rect', messagePtr);
                messageRect = AlignRect(messageRect, render.viewportRect, 'center', 'top');                
                
                % --------------------                
                mazePosX = render.x0 + render.scaleRatio * 1.5 * obj.imageSize * ((0:obj.nNumbers-1) - (obj.nNumbers-1)/2);
                
                numberRectArray = zeros(4, obj.nNumbers);
                
                for numberIndex = 1:obj.nNumbers
                    
                    numberRectArray(:, numberIndex) = CenterRectOnPoint(render.scaleRatio * SetRect(0, 0, obj.imageSize, obj.imageSize), mazePosX(numberIndex), render.y0)';
                    
                end
                
                labelRectArray = zeros(4, 2);
                [x0, ~] = RectCenter(numberRectArray(:, 1)');
                labelRectArray(:, 1) = CenterRectOnPoint(render.scaleRatio * Screen('Rect', label1Ptr), x0, render.y0 + render.scaleRatio * 200)';
                [x0, ~] = RectCenter(numberRectArray(:, end)');
                labelRectArray(:, 2) = CenterRectOnPoint(render.scaleRatio * Screen('Rect', label2Ptr), x0, render.y0 + render.scaleRatio * 200)';
                
                currentIndex = 3;
                decisionFlag = 0;
                while ~decisionFlag
                    
                    [xPosDelta, decisionFlag] = inputDevice.PollRating();
                    
                    currentIndex = currentIndex + xPosDelta;
                    currentIndex = 1 + mod(currentIndex-1, obj.nNumbers);
                    
                    offIndexes = setxor(currentIndex, 1:obj.nNumbers);
                    Screen('DrawTextures', render.viewportPtr, messagePtr, [], messageRect);
                    Screen('DrawTextures', render.viewportPtr, label1Ptr, [], labelRectArray(:, 1));
                    Screen('DrawTextures', render.viewportPtr, label2Ptr, [], labelRectArray(:, 2));
                    Screen('DrawTextures', render.viewportPtr, obj.texturePtrArray(offIndexes, obj.OFF), [], numberRectArray(:, offIndexes));
                    Screen('DrawTexture', render.viewportPtr, obj.texturePtrArray(currentIndex, obj.ON), [], numberRectArray(:, currentIndex));
                    Screen('Flip', render.viewportPtr);
                    
                    if (xPosDelta ~= 0)
                        
                        t0 = GetSecs;
                        tDelta = 0;
                        
                        while tDelta < obj.waitTime
                            
                            tDelta = GetSecs - t0;
                            
                        end
                        
                    end
                    
                end
                
                Screen('Flip', render.viewportPtr);
                
                currentRating = obj.ratingIndex(currentIndex);
                
            end
            
        end
        
    end
    
end