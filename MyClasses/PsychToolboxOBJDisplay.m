classdef PsychToolboxOBJDisplay
    properties
        objData
        texture
    end
    
    methods
        function obj = PsychToolboxOBJDisplay(objData, texturePath)
            % Constructor: Load the 3D model and texture
            obj.objData = objData;
            obj.texture = imread(texturePath);
        end
        
        function modeldisplay(obj)
            % Display the 3D model with the loaded texture
            texture_img = flipud(obj.texture);
            [sy, sx, sz] = size(texture_img);
            texture_img = reshape(texture_img, sy * sx, sz);
            
            % Make image 3D if grayscale
            if sz == 1
                texture_img = repmat(texture_img, 1, 3);
            end
            
            % Select what texture corresponds to each vertex according to face definition
            [~, fv_idx] = unique(obj.objData.f.v);
            texture_idx = obj.objData.f.vt(fv_idx);
            x = abs(round(obj.objData.vt(:, 1) * (sx - 1))) + 1;
            y = abs(round(obj.objData.vt(:, 2) * (sy - 1)) + 1);
            xy = sub2ind([sy, sx], y, x);
            texture_pts = xy(texture_idx);
            tval = double(texture_img(texture_pts, :)) / 255;
            
            % Display object
            figure;
            patch('vertices', obj.objData.v, 'faces', obj.objData.f.v, 'FaceVertexCData', tval);
            shading interp;
            colormap gray(256);
            lighting phong;
            camproj('perspective');
            axis square;
            axis off;
            axis equal;
            axis tight;
            cameramenu;
        end
    end
end