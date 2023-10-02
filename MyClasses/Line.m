classdef Line
    
    properties
        
        p1;
        p2;
        
    end
    
    
    methods
        
        function obj = Line(varargin)
            
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