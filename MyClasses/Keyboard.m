classdef Keyboard < InputDevice
    
    properties
        
        leftArrowCode;
        rightArrowCode;
        upArrowCode;
        downArrowCode;
        escapeCode;
        spaceCode;
        
    end
    
    methods
        
        function obj = Keyboard()
            
            obj = obj@InputDevice('KEYBOARD');
                        
            try
                
                KbCheck;
                
            catch
                
                error('Use of keyboard requires PsychToolbox->KbCheck');
                
            end
            
%             KbName('UnifyKeyNames');
            
            if ispc
                
                obj.leftArrowCode   = 37;
                obj.rightArrowCode  = 39;
                obj.upArrowCode     = 38;
                obj.downArrowCode   = 40;
                obj.escapeCode      = 27;
                obj.spaceCode       = 32;
                
            elseif ismac
                obj.leftArrowCode   = KbName('leftArrow');
                obj.rightArrowCode  = KbName('rightArrow');
                obj.upArrowCode     = KbName('upArrow');
                obj.downArrowCode   = KbName('downArrow');
                obj.escapeCode      = KbName('escape');
                obj.spaceCode       = KbName('space');
            end
%             ListenChar(2);
            
        end
        
        
        function goFlag = PollStandby(obj)
            
            goFlag = 0;
            
            [keyIsDown, ~, keyCode, ~] = KbCheck();
            
            if keyIsDown
                                    
                if keyCode(obj.spaceCode)
                    
                    goFlag = 1;
                    
                elseif keyCode(obj.escapeCode)
                    
                    Render.Close();
                
                else
                    
                    % do nothing
                end
                
            else
                
                % do nothing
                
            end
            
        end
        
        
        function [xPosDelta, decisionFlag] = PollRating(obj)
            
            xPosDelta = 0;
            decisionFlag = 0;
            
            [keyIsDown, ~, keyCode, ~] = KbCheck();
            
            if keyIsDown
                
                if keyCode(obj.leftArrowCode)
                    
                    xPosDelta = -1;
                    
                elseif keyCode(obj.rightArrowCode)
                    
                    xPosDelta = 1;
                    
                elseif keyCode(obj.spaceCode)
                    
                    decisionFlag = 1;
                    
                elseif keyCode(obj.escapeCode)
                    
                    Render.Close();
                    
                else
                    
                    % do nothing
                end
                
            else
                
                % do nothing
                
            end
            
        end
        
        
        function [proposedPosition, proposedHeading, quitCode] = PollPlayer(obj, player)
            
            proposedPosition = player.previousPos;
            proposedHeading = player.heading;
            quitCode = 0;
            
            [keyIsDown, ~, keyCode, ~] = KbCheck();
            
            if keyIsDown
                
                if keyCode(obj.rightArrowCode)
                    
                    proposedHeading = player.heading - player.maxDegreesPerFrame;
                    
                end
                
                if keyCode(obj.leftArrowCode)
                    
                    proposedHeading = player.heading + player.maxDegreesPerFrame;
                    
                end
                
                if keyCode(obj.downArrowCode)
                    
                    proposedPosition(1) = player.previousPos(1) + player.maxVelocityPerFrame * cos(proposedHeading * obj.piOver180);
                    proposedPosition(2) = player.previousPos(2) - player.maxVelocityPerFrame * sin(proposedHeading * obj.piOver180);
                    
                end
                
                if keyCode(obj.upArrowCode)
                    
                    proposedPosition(1) = player.previousPos(1) - player.maxVelocityPerFrame * cos(proposedHeading * obj.piOver180);
                    proposedPosition(2) = player.previousPos(2) + player.maxVelocityPerFrame * sin(proposedHeading * obj.piOver180);
                    
                end
                
                if keyCode(obj.escapeCode)
                    
                    Render.Close();
                    
                end
                
            end
            
        end
        
    end
    
end