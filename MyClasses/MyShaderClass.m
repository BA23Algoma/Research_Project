classdef MyShaderClass
    properties
        shaderProgram
    end

    methods
        function obj = MyShaderClass()
            vertexShaderCode = fileread('vertex_shader.glsl');
            fragmentShaderCode = fileread('fragment_shader.glsl');

            GL_VERTEX_SHADER = 0x8B31;
            GL_FRAGMENT_SHADER = 0x8B30;

            vertexShader = glCreateShader(GL_VERTEX_SHADER);
            fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);

            glShaderSource(vertexShader, vertexShaderCode);
            glCompileShader(vertexShader);

            glShaderSource(fragmentShader, fragmentShaderCode);
            glCompileShader(fragmentShader);

            obj.shaderProgram = glCreateProgram();

            glAttachShader(obj.shaderProgram, vertexShader);
            glAttachShader(obj.shaderProgram, fragmentShader);

            glLinkProgram(obj.shaderProgram);

            glUseProgram(obj.shaderProgram);
        end
    end
end
