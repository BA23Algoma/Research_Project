classdef GameObject
    
    properties
        
        Id;
        
    end
    
    methods
        
        function obj = GameObject(id)
            
            if nargin > 0
            
                obj.Id = id;
                
            end
            
        end
        
        function obj = set.Id(obj, id)
            
            if isnumeric(id)
                
                obj.Id = id;
                
            else
                
                error('Id must be numeric');
                
            end
            
        end
        
        
        
    end % methods
    
end