classdef RoundTexturedObject
    properties
        texturedObject
    end
    
    methods
        function obj = RoundTexturedObject(texName, target)
            if nargin > 0
                obj.texturedObject = struct('texNameFront', texName, 'targetFront', target);
            else
                obj.texturedObject = struct();
            end
        end
        
        function addRoundTexture(obj, texName, target)
            newIdx = numel(obj.texturedObject) + 1;
            obj.texturedObject(newIdx).texNameFront = texName;
            obj.texturedObject(newIdx).targetFront = target;
        end
    end
end
