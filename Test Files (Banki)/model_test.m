% Load the OBJ file
obj.hillProp = LoadOBJFile(fullfile(obj.texPath, 'YourModel.obj'), 1, 1);

% Assuming obj.hillProp is a loaded 3D object with vertices, UV coordinates, and normals
vertices = obj.hillProp{1}.vertices;
uvs = obj.hillProp{1}.texcoords; % Assuming UV coordinates exist
normals = obj.hillProp{1}.normals; % Assuming normals exist
faces = obj.hillProp{1}.faces;

% Load and bind textures (as you mentioned in previous code)
textureImage = obj.texNumId(4);
textureHandles = cell(1, numel(textureImage));
for i = 1:numel(obj.texNumId(4))
    textureHandles{i} = Screen('MakeTexture', obj.viewportPtr, textureImage{i});
end

% Enable 3D rendering mode
Screen('BeginOpenGL', windowPtr);

% Bind textures
for i = 1:numel(textureHandles)
    Screen('BindTexture', windowPtr, textureHandles{i});
end

% Draw Distal Queue (Hill)
for mesh = obj.distalQueue
    glBegin(GL.TRIANGLES); % Change to GL.QUADS if needed
    for i = 1:size(faces, 2)
        for j = 1:3
            vertexIndex = faces(j, i);
            vertex = vertices(:, vertexIndex);
            uv = uvs(:, vertexIndex);
            normal = normals(:, vertexIndex);
            
            % You can use vertex, uv, and normal to render the 3D object
            glTexCoord2fv(uv);
            glNormal3fv(normal);
            glVertex3fv(vertex);
        end
    end
    glEnd();
end

% End 3D rendering mode
Screen('EndOpenGL', windowPtr);
