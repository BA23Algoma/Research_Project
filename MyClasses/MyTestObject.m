classdef MyTestObject
    
    properties
        
        x = 0;
        y;
        
    end
        
    methods
        
        function obj = set.x(obj, value)
           
            if isempty(value)
                
            elseif isnumeric(value)
                
                obj.x = value;                
                
            end                
                            
        end
        
        function obj = Whatever(obj)
            
           obj.x = 1;
           obj.y = 3;
            
        end
        
    end
    
end