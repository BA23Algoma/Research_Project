classdef GlConstant
    
    
    properties (SetAccess = private)
        
        GL;
        
    end
    
    
    methods
        
        function obj = GlConstant()
            
            InitializeMatlabOpenGL(0);
            
            % OpenGL stuff
            eval('agl = AGL;');
            obj.AGL = agl;
            
        end
        
        
    end
    
end



%             eval('gl = GL;');
%             obj.GL =  gl;
%             eval('glu = GLU;');
%             obj.GLU =  gl;
