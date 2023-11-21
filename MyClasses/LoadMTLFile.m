function materials = LoadMTLFile(mtlFileName)
    % Initialize the material library struct
    materials = struct();

    % Open the .mtl file
    fid = fopen(mtlFileName, 'rt');
    if fid < 0
        error(['Could not open .mtl file: ' mtlFileName]);
    end

    currentMaterial = ''; % Current material being parsed

    while ~feof(fid)
        line = fgetl(fid);

        % Skip empty lines and comments
        if isempty(line) || line(1) == '#'
            continue;
        end

        % Tokenize the line
        tokens = strsplit(line, ' ');

        % Get the token type
        tokenType = tokens{1};

        switch tokenType
            case 'newmtl' % New material definition
                currentMaterial = tokens{2};
                materials.(currentMaterial) = struct();
            case 'Ka' % Ambient color
                materials.(currentMaterial).Ka = str2double(tokens(2:end));
            case 'Kd' % Diffuse color
                materials.(currentMaterial).Kd = str2double(tokens(2:end));
            case 'Ks' % Specular color
                materials.(currentMaterial).Ks = str2double(tokens(2:end));
            case 'Ns' % Shininess
                materials.(currentMaterial).Ns = str2double(tokens(2));
            case 'map_Kd' % Diffuse texture map
                materials.(currentMaterial).map_Kd = tokens{2};
            % Add more cases for other material properties as needed
            otherwise
                % Ignore unsupported tokens
        end
    end

    % Close the .mtl file
    fclose(fid);
end
