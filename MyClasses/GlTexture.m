classdef GlTexture
    
    properties
        
        nRows;        
        nCols;
        pixels;
        name;
        fileName;
        
    end
    
    methods
        
        function obj = GlTexture(texturePath, texFileName)

            myImage = imread(fullfile(texturePath, texFileName));
            imageDim = size(myImage);
            obj.nRows = imageDim(1);
            obj.nCols = imageDim(2);
            myImage = permute(flipdim(myImage,1),[ 3 2 1 ]);
            obj.pixels = myImage;
            obj.fileName = texFileName;
            
        end
        
        function obj = set.name(obj, Name)
            
            if ischar(Name)
                
                obj.name = Name;
                
            else
                
                error('Name must be a ''char'' array');
                
            end                
            
        end
        
    end
    
end
