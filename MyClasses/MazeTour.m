classdef MazeTour
    
    properties (GetAccess = public, SetAccess = protected)
        
        deltaDegPerFrame        = 1.0;
        deltaUnitperFrame       = 0.02;
        
        coord;
        d;
        deltaTheta;
        fileName;
        isLoaded                = 0;
        nFrames;
        nSegments;
        p1;
        p2;
        pathName                = 'Mazes';
        theta;
        tourPlan;
        tourHand;
        v;
        
    end
    
    
    properties (Constant)
        
        fileNameSuffix          = '.tour.txt';
        validTourHands          = {'LEFT', 'RIGHT'};
        
    end
    
    
    
    methods
        
        function obj = MazeTour(varargin)
            
            if nargin > 0
                
                obj.fileName = strcat(varargin{1}, MazeTour.fileNameSuffix);
                
            end
            
            if nargin > 1
                
                if any(strcmp(MazeTour.TourHandStr(varargin{2}), MazeTour.validTourHands))
                    
                    obj.tourHand = varargin{2};
                    
                end
                
            end
            
            if nargin > 2
                
                obj.pathName = varargin{3};
                
            end
            
            if nargin > 3
                
                obj.deltaDegPerFrame = varargin{4};
                
            end
            
            
            if nargin > 4
                
                obj.deltaUnitperFrame = varargin{5};
                
            end
            
            
            if ~isempty(obj.fileName) && ~isempty(obj.tourHand)
                
                obj = Load(obj);
                
                if obj.isLoaded
                    
                    obj = Precompute(obj);
                    
                end
                
            end
            
            
        end
        
        
        function obj = Precompute(obj)
            
            if ~isempty(obj.tourPlan)
                
                obj.nSegments = size(obj.tourPlan, 1)-1;
                
                % 1st derivative (circular)
                p1Index = 1:obj.nSegments;
                p2Index = 1 + mod(1:obj.nSegments, obj.nSegments);
                
                obj.p1 = obj.tourPlan(p1Index, :);
                obj.p2 = obj.tourPlan(p2Index, :);
                obj.v = obj.p2 - obj.p1;
                obj.d = realsqrt(obj.v(:, 1).^2 + obj.v(:, 2).^2);
                obj.theta = atan2d(obj.v(:, 2), -obj.v(:, 1));
                
                obj.deltaTheta = zeros(size(obj.theta));
                
                for thetaIndex = 1:obj.nSegments
                    
                    theta2Index = 1 + mod(thetaIndex, obj.nSegments);
                    obj.deltaTheta(thetaIndex) = MazeTour.AngleDiff(obj.theta(theta2Index), obj.theta(thetaIndex));
                    %                     obj.theta(theta2Index) = rem(obj.theta(thetaIndex) + obj.deltaTheta(thetaIndex), 360);
                    
                end
                
                %                 theta1Index = 1:obj.nSegments;
                %                 theta2Index = 1 + mod(theta1Index, obj.nSegments);
                %
                %                 obj.deltaTheta = obj.theta(theta2Index) - obj.theta(theta1Index);
                %
                %                 obj.deltaTheta = mod(obj.deltaTheta+180, 360)-180;
                %
                %                 % Regularize angle changes
                %                 currentTheta = obj.theta(1);
                %                 for thetaIndex = 1:obj.nSegments
                %
                %                     obj.theta(thetaIndex) = currentTheta;
                %
                %                     currentTheta = currentTheta + obj.deltaTheta(thetaIndex);
                %
                %                 end
                
                obj.nFrames = sum(ceil(obj.d / obj.deltaUnitperFrame)) + sum(ceil(abs(obj.deltaTheta)/ obj.deltaDegPerFrame));
                obj.coord = zeros(obj.nFrames, 3);
                
                
                frameIndexStart = 1;
                
                for segmentIndex = 1:obj.nSegments
                    
                    % Segment change
                    nSegmentFrames = ceil(obj.d(segmentIndex) / obj.deltaUnitperFrame);
                    frameIndexEnd = frameIndexStart + nSegmentFrames - 1;
                    
                    x = linspace(obj.p1(segmentIndex, 1), obj.p2(segmentIndex, 1), nSegmentFrames)';
                    z = linspace(obj.p1(segmentIndex, 2), obj.p2(segmentIndex, 2), nSegmentFrames)';
                    heading = linspace(obj.theta(segmentIndex), obj.theta(segmentIndex), nSegmentFrames)';
                    thisCoord = [x z heading];
                    
                    obj.coord(frameIndexStart:frameIndexEnd, :) = thisCoord;
                    
                    frameIndexStart = frameIndexEnd + 1;
                    
                    % Heading change
                    nSegmentFrames = ceil(abs(obj.deltaTheta(segmentIndex))/ obj.deltaDegPerFrame);
                    frameIndexEnd = frameIndexStart + nSegmentFrames - 1;
                    
                    
                    x = linspace(obj.p2(segmentIndex, 1), obj.p2(segmentIndex, 1), nSegmentFrames)';                    
                    z = linspace(obj.p2(segmentIndex, 2), obj.p2(segmentIndex, 2), nSegmentFrames)';


                    
                    heading = linspace(obj.theta(segmentIndex), obj.theta(segmentIndex) + obj.deltaTheta(segmentIndex), nSegmentFrames)';
                    
                    thisCoord = [x z heading];
                    
                    obj.coord(frameIndexStart:frameIndexEnd, :) = thisCoord;
                    
                    frameIndexStart = frameIndexEnd + 1;
                    
                end                
                
            else
                
                % do nothing
                
            end
            
            
        end
        
        
        function obj = Load(obj)
            
            obj.tourPlan = load(fullfile(obj.pathName, obj.fileName));
            obj.tourPlan(:, 1) = -obj.tourPlan(:, 1);
            
            
            if isempty(obj.tourHand)
                
                error('MazeTour tourHand must be defined before loading maze tour file');
                
            end
            
            
            if obj.tourHand == 1 % Left hand
                
                obj.tourPlan = flipud(obj.tourPlan);
                
            elseif obj.tourHand == 2 % Right hand
                
                % do nothing
                
            else
                
                error('Unknown MazeTour tourHand');
                
            end
            
            obj.isLoaded = 1;
            
        end
        
        
        function Draw(obj)
            
            if ~isempty(obj.tourPlan)
                
                line([obj.p1(:, 1) obj.p2(:, 1)], [obj.p1(:, 2) obj.p2(:, 2)], 'Color', 'b');
                
            else
                
                
            end
            
        end
        
    end
    
    
    methods (Static)
        
        
        function validTourHands = ValidTourHands()
            
            validTourHands = MazeTour.validTourHands;
            
        end
        
        
        function numericTourHand = TourHandIndex(tourHandStr)
            
            if ischar(tourHandStr)
                
                if strcmp(tourHandStr, MazeTour.validTourHands{1})
                    
                    numericTourHand = 1;
                    
                elseif strcmp(tourHandStr, MazeTour.validTourHands{2})
                    
                    numericTourHand = 2;
                    
                else
                    
                    error('Invalid tourHandStr');
                    
                end
                
            else
                
                error('tourHandStr argument must be a string');
                
            end
            
        end
        
        
        function strTourHand = TourHandStr(tourHandIndex)
            
            if isnumeric(tourHandIndex)
                
                if tourHandIndex == 1
                    
                    strTourHand = MazeTour.validTourHands{1};
                    
                elseif tourHandIndex == 2
                    
                    strTourHand = MazeTour.validTourHands{2};
                    
                else
                    
                    error('Invalid tourHandIndex');
                    
                end
                
            else
                
                error('tourHandIndex argument must be numeric');
                
            end
            
        end
        
        function a = AngleDiff(targetA, sourceA)
            
            a = targetA - sourceA;
            
            if a > 180
                
                a = a - 360;
                
            elseif a < -180
                
                a = a + 360;
                
            else
                
                % do nothing
                
            end
            
        end
        
    end
    
end