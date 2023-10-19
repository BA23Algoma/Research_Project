classdef MySkyboxShaderClass
    properties
        shaderProgram
    end

    methods
        function obj = MySkyboxShaderClass()
            vertexShaderCode = fileread('vertex_shader.glsl');  % Define a skybox vertex shader
            fragmentShaderCode = fileread('fragment_shader.glsl');  % Define a skybox fragment shader

            vertexShader = glCreateShader(35633);
            fragmentShader = glCreateShader(35632);

            glShaderSource(vertexShader, vertexShaderCode);
            glCompileShader(vertexShader);

            glShaderSource(fragmentShader, fragmentShaderCode);
            glCompileShader(fragmentShader);

            % Check to see if the shaders were compiled successfully
            vertexInfoLog = char(zeros(1, 512));  % Preallocate for the vertex shader error message
            fragmentInfoLog = char(zeros(1, 512));  % Preallocate for the fragment shader error message
            
            % Check for vertex shader compilation success
            vertexSuccess = glGetShaderiv(vertexShader, 0x8B81);
            
            % Check if vertex shader compilation failed and retrieve the error message
            if ~vertexSuccess
                % Use glGetShaderInfoLog to get the error message
                glGetShaderInfoLog(vertexShader, 512, [], vertexInfoLog);
                
                % Display the error message
                fprintf('ERROR::SHADER::VERTEX::COMPILATION_FAILED\n%s\n', vertexInfoLog);
            end
            
            % Check for fragment shader compilation success
            fragmentSuccess = glGetShaderiv(fragmentShader, 35713);
            
            % Check if fragment shader compilation failed and retrieve the error message
            if ~fragmentSuccess
                % Use glGetShaderInfoLog to get the error message
                glGetShaderInfoLog(fragmentShader, 512, [], fragmentInfoLog);
                
                % Display the error message
                fprintf('ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n%s\n', fragmentInfoLog);
            end


            obj.shaderProgram = glCreateProgram();

            glAttachShader(obj.shaderProgram, vertexShader);
            glAttachShader(obj.shaderProgram, fragmentShader);

            glLinkProgram(obj.shaderProgram);

            % Check for linking success
            linkInfoLog = char(zeros(1, 512));  % Preallocate for the linking error message
            linkSuccess = glGetProgramiv(obj.shaderProgram, 35714);
            
            % Check if program linking failed and retrieve the error message
            if ~linkSuccess
                % Use glGetProgramInfoLog to get the error message
                glGetProgramInfoLog(obj.shaderProgram, 512, [], linkInfoLog);
                
                % Display the error message
                fprintf('ERROR::SHADER::PROGRAM::LINKING_FAILED\n%s\n', linkInfoLog);
            end
            % Delete shaders
            glDeleteShader(vertexShader);
            glDeleteShader(fragmentShader);

        end
    end
end
