classdef Standby
    
    properties
                
        
    end
    
    methods
        
        function obj = Standby
            
            
        end
        
    end
    
    methods
        
        function obj = ShowStandby(obj, render, inputDevice, varargin)
            
            WaitSecs(0.25);
            
            nVargin = nargin - 3;
            normBoundsRect = Screen('TextBounds', render.viewportPtr, 'test');
            rectHeight = RectHeight(normBoundsRect);
            
            ySpace = render.scaleRatio * 2 * rectHeight * linspace(0, nVargin-1, nVargin) + render.y0;
            
            for textIndex = 1:nVargin
                
                if textIndex == 1
                    
                    Screen('TextStyle', render.viewportPtr, 1);
                    
                else
                    
                    Screen('TextStyle', render.viewportPtr, 0);
                    
                end

                normBoundsRect = Screen('TextBounds', render.viewportPtr, varargin{textIndex});
                normBoundsRect = CenterRectOnPoint(normBoundsRect, render.x0, ySpace(textIndex));
                Screen('DrawText', render.viewportPtr, varargin{textIndex}, normBoundsRect(RectLeft), normBoundsRect(RectTop));                
                
            end
                        
            Screen('Flip', render.viewportPtr);
            
            goFlag = 0;
            
            while ~goFlag
            
                goFlag = inputDevice.PollStandby();
                
            end
            
            Screen('Flip', render.viewportPtr);
            
        end
        
    end
    
end