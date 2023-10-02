classdef Wall < Line
    
    properties
        
        type;
        glTextureId;      
        v;
        norm;
        normSqr;
        normal;
        unitNormal;
        
    end
            
    
    methods
        
        function obj = Wall(varargin)
                        
            obj = obj@Line();
            
            nVarargin = numel(varargin);
            
            if nVarargin > 0
                obj.p1 = varargin{1};
            end
            
            if nVarargin > 1
                obj.p2 = varargin{2};
            end
                        
        end
        
        
        function obj = set.glTextureId(obj, GLTextureId)            
            
            
            obj.glTextureId = GLTextureId;            
            
        end
        

        function obj = set.type(obj, WallType)
            
            if ischar(WallType)
                
                if any(strcmp(Wall.ValidTypes, WallType))
            
                    obj.type = WallType;
                    
                else
                    
                    error('Undefined wall type');
                    
                end
                
            else
                
                error('Wall type must be a string');
                
            end
            
        end
        
        
        function obj = Precompute(obj)
            
            obj.v = obj.p2 - obj.p1;
            obj.normSqr = obj.v * obj.v';
            obj.norm = realsqrt(obj.normSqr);
            obj.normal = [-obj.v(2) obj.v(1)];
            
            if obj.norm == 0
                
                error('Wall length must be greater than 0');
                
            else
                
                obj.unitNormal = obj.normal / obj.norm;
                
            end
            
        end
                
    end
    
    
    methods (Static)
        
        function validTypes = ValidTypes()
            
            validTypes = {'normal', 'target', 'tripwire'};
            
        end

    end
    
end