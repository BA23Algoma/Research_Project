classdef JoystickWin < InputDevice
    
    properties
        
        gamepadIndex    = 0;
        triggerIndex    = 1;
        thumbIndex      = 2;
        threshold       = 0.25;
        hNegThreshold;
        hPosThreshold;
        vNegThreshold;
        vPosThreshold;
        
    end
    
    properties (Constant)
        
        resolution              = 65535;
        resolutionMidPoint      = 32768;
        xPosDeltaLeftIndex      = 3;
        xPosDeltaRightIndex     = 4;
        hAxisIndex              = 1;
        vAxisIndex              = 2;
        
    end
    
    
    methods
        
        function obj = JoystickWin(varargin)
            
            obj = obj@InputDevice('JOYSTICK', 'PC');
            
            if nargin > 0
                
                obj.threshold = varargin{1};
                obj.hNegThreshold = -(obj.resolution - obj.resolutionMidPoint) * obj.threshold;
                obj.hPosThreshold = (obj.resolution - obj.resolutionMidPoint) * obj.threshold;
                obj.vNegThreshold = -(obj.resolution - obj.resolutionMidPoint) * obj.threshold;
                obj.vPosThreshold = (obj.resolution - obj.resolutionMidPoint) * obj.threshold;
                
                
            end
            
            if nargin > 1
                
                obj.gamepadIndex = varargin{2};
                
                
            end
            
            
        end
        
        
        function goFlag = PollStandby(obj)
            
            goFlag = 0;
            
            [~, ~, ~, buttons] = WinJoystickMex(obj.gamepadIndex);
            
            if buttons(obj.triggerIndex)
                
                goFlag = 1;
                
            end
            
        end
        
        
        function [xPosDelta, decisionFlag] = PollRating(obj)
            
            xPosDelta = 0;
            decisionFlag = 0;
            
            [~, ~, ~, buttons] = WinJoystickMex(obj.gamepadIndex);
            
            if buttons(obj.triggerIndex)
                
                decisionFlag = 1;
                
            elseif buttons(obj.xPosDeltaLeftIndex)
                
                xPosDelta = -1;
                
            elseif buttons(obj.xPosDeltaRightIndex)
                
                xPosDelta = 1;
                
            else
                
                % do nothing
            end
            
        end
        
        
        function [proposedPosition, proposedHeading, quitCode] = PollPlayer(obj, player)
            
            proposedPosition = player.previousPos;
            proposedHeading = player.heading;
            quitCode = 0;
            
            [hAxisValue, vAxisValue, ~, buttons] = WinJoystickMex(obj.gamepadIndex);
            hAxisValue = hAxisValue - obj.resolutionMidPoint;
            vAxisValue = vAxisValue - obj.resolutionMidPoint;
            
            if hAxisValue > obj.hPosThreshold
                
                proposedHeading = player.heading - player.maxDegreesPerFrame;
                
            end
            
            if hAxisValue < obj.hNegThreshold
                
                proposedHeading = player.heading + player.maxDegreesPerFrame;
                
            end
            
            if vAxisValue > obj.vPosThreshold
                
                proposedPosition(1) = player.previousPos(1) + player.maxVelocityPerFrame * cos(proposedHeading * obj.piOver180);
                proposedPosition(2) = player.previousPos(2) - player.maxVelocityPerFrame * sin(proposedHeading * obj.piOver180);
                
            end
            
            if vAxisValue < obj.vNegThreshold
                
                proposedPosition(1) = player.previousPos(1) - player.maxVelocityPerFrame * cos(proposedHeading * obj.piOver180);
                proposedPosition(2) = player.previousPos(2) + player.maxVelocityPerFrame * sin(proposedHeading * obj.piOver180);
                
            end
            
            if buttons(obj.triggerIndex) && buttons(obj.thumbIndex)
                
                quitCode = 1;
                
            end
            
        end
        
        
        function obj = set.threshold(obj, Threshold)
            
            if isnumeric(Threshold)
                
                if (Threshold>0) && (Threshold<=1)
                    
                    obj.threshold = Threshold;
                    
                end
                
            end
            
        end
        
        
    end
    
end