classdef StandbyBigNumber
    
    properties
        
        
    end
    
    methods
        
        function obj = StandbyBigNumber
            
            
        end
        
        function obj = ShowStandbyBigNumber(obj, render, inputDevice, topMessageStr, mazeNumber, bottomMessageStr)
            
            WaitSecs(0.25);
            
            oldTextSize = Screen('TextSize', render.viewportPtr);
            
            Screen('TextSize', render.viewportPtr, oldTextSize);
            Screen('TextStyle', render.viewportPtr, 0);
            normBoundsRect1 = Screen('TextBounds', render.viewportPtr, topMessageStr);
            normBoundsRect1 = CenterRectOnPoint(normBoundsRect1, render.x0, render.y0 -  150);
            Screen('DrawText', render.viewportPtr, topMessageStr, normBoundsRect1(RectLeft), normBoundsRect1(RectTop), [127 127 127], [0 0 0]);
            
            Screen('TextSize', render.viewportPtr, 127);
            Screen('TextStyle', render.viewportPtr, 0);
            myText = sprintf('%i', mazeNumber);
            normBoundsRect2 = Screen('TextBounds', render.viewportPtr, myText);
            normBoundsRect2 = CenterRectOnPoint(normBoundsRect2, render.x0, render.y0);
            Screen('DrawText', render.viewportPtr, myText, normBoundsRect2(RectLeft), normBoundsRect2(RectTop), [127 127 127], [0 0 0]);
            
            Screen('TextSize', render.viewportPtr, oldTextSize);
            Screen('TextStyle', render.viewportPtr, 0);
            normBoundsRect3 = Screen('TextBounds', render.viewportPtr, bottomMessageStr);
            normBoundsRect3 = CenterRectOnPoint(normBoundsRect3, render.x0, render.y0 + 150);
            Screen('DrawText', render.viewportPtr, bottomMessageStr, normBoundsRect3(RectLeft), normBoundsRect3(RectTop), [127 127 127], [0 0 0]);
            
            Screen('Flip', render.viewportPtr);
            
            goFlag = 0;
            
            while ~goFlag
                
                goFlag = inputDevice.PollStandby();
                
            end
            
            Screen('Flip', render.viewportPtr);
            
        end
        
    end
    
end