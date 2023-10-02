classdef TripWire < Wall
    
    properties
        
        tripFlag = 0;
        tripCount = 0;
        collisionFlag = 0;
        
    end
        
    methods
        
        function obj = TripWire(varargin)
                        
            obj = obj@Wall();
            
            nVarargin = numel(varargin);
            
            if nVarargin > 0
                obj.p1 = varargin{1};
            end
            
            if nVarargin > 1
                obj.p2 = varargin{2};
            end
            
        end
        
    end
    
end