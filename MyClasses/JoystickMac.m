classdef JoystickMac < InputDevice
    
    properties
        
        gamepadIndex    = 1;
        triggerIndex    = 1;
        thumbIndex      = 2;
        threshold       = 0.25;
        hNegThreshold;
        hPosThreshold;
        vNegThreshold;
        vPosThreshold;
        
    end
    
    properties (Constant)
        
        resolution              = 32768;
        resolutionMidPoint      = 16384;
        signedResolutionRange   = 16384;
        xPosDeltaLeftIndex      = 3;
        xPosDeltaRightIndex     = 4;
        hAxisIndex              = 1;
        vAxisIndex              = 2;
        quitButtonIndex         = 11;
        
    end
    
    
    methods
        
        function obj = JoystickMac(varargin)
            
            obj = obj@InputDevice('JOYSTICK', 'MAC');
            
            if nargin > 0
                
                obj.threshold = varargin{1};
                obj.hNegThreshold = -obj.signedResolutionRange * obj.threshold;
                obj.hPosThreshold = obj.signedResolutionRange * obj.threshold;
                obj.vNegThreshold = -obj.signedResolutionRange * obj.threshold;
                obj.vPosThreshold = obj.signedResolutionRange * obj.threshold;
                
                
            end
            
            if nargin > 1
                
                obj.gamepadIndex = varargin{2};
                
                
            end
            
            
        end
        
        
        function goFlag = PollStandby(obj)
            
            goFlag = 0;
            
            if Gamepad('GetButton', obj.gamepadIndex, obj.triggerIndex);
                
                goFlag = 1;
                
            end
            
        end
        
        
        function [xPosDelta, decisionFlag] = PollRating(obj)
            
            xPosDelta = 0;
            decisionFlag = 0;
            
            if Gamepad('GetButton', obj.gamepadIndex, obj.triggerIndex)
                
                decisionFlag = 1;
                
            elseif Gamepad('GetButton', obj.gamepadIndex, obj.xPosDeltaLeftIndex)
                
                xPosDelta = -1;
                
            elseif Gamepad('GetButton', obj.gamepadIndex, obj.xPosDeltaRightIndex)
                
                xPosDelta = 1;
                
            else
                
                % do nothing
            end
            
        end
        
        
        function [proposedPosition, proposedHeading, quitCode] = PollPlayer(obj, player)
            
            proposedPosition = player.previousPos;
            proposedHeading = player.heading;
            quitCode = 0;
            
            hAxisValue = Gamepad('GetAxis', obj.gamepadIndex, obj.hAxisIndex);
            vAxisValue = Gamepad('GetAxis', obj.gamepadIndex, obj.vAxisIndex);
            
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
            
            if Gamepad('GetButton', obj.gamepadIndex, obj.triggerIndex) && Gamepad('GetButton', obj.gamepadIndex, obj.thumbIndex)
                
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