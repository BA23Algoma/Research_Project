classdef WallArray
    
    properties
        
        walls;
        nWalls;
        p1;
        p2;
        norm;
        v;
        normSqr;
        normal;
        unitNormal;
        
    end
    
    methods
        
        function obj = WallArray(structArrayOfWalls)
            
            if ~isa(Wall, 'Wall')
                
                error('Method argument needs to be of class ''Wall''');
                
            end
            
            obj.nWalls = numel(structArrayOfWalls);
            obj.walls = Wall(obj.nWalls, 1);
            
            for wallIndex = 1:obj.nWalls
                
                thisWall = structArrayOfWalls(wallIndex);
                thisWall = thisWall.Precompute;
                
                obj.walls(wallIndex) = thisWall;
                
            end
            
            obj.p1          = reshape([obj.walls(:).p1], [2 obj.nWalls])';
            obj.p2          = reshape([obj.walls(:).p2], [2 obj.nWalls])';
            obj.v           = reshape([obj.walls(:).v], [2 obj.nWalls])';
            obj.normSqr     = [obj.walls(:).normSqr]';
            obj.norm        = [obj.walls(:).norm]';
            obj.normal      = reshape([obj.walls(:).normal], [2 obj.nWalls])';
            obj.unitNormal  = reshape([obj.walls(:).unitNormal], [2 obj.nWalls])';
                        
        end
        
    end    
    
end