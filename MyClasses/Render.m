classdef Render
    
    properties
        
        multiSampleFrames   = 1;
        texPath             = 'Textures';
        soundPath           = 'Sounds';
        objPath             = 'Objects\OBJ Textures';
        screenAspectRatio;
        screenId;
        isPtbWindowOk       = 0;
        viewPoint           = 1;
        teapotFlag;
        perspectiveAngle    = 55;
        eyeLevel            = -0.55;
        ceilingFlag         = 1;
        skybox;
        skyboxFace          = 1;
        tripwireFlag        = 0;
        nQueue              = 0;
        distalCueFlag       = 1;
        DistalCueName;
        DistalCueTarget;
        distalCueLocation;
        proxCueFlag         = 0;
        proxCueName;
        proxCueTarget;
        cueProperties;
        distalPerLocation;
    end
    
    properties (SetAccess = protected)
        
        viewportPtr;
        viewportRect;
        texNumId;
        nTex                = 0;
        x0;
        y0;
        nRows;
        nCols;
        newWidth;
        newHeight;
        newHz;
        scaleRatio;
        
        
    end
    
    properties (GetAccess = public, SetAccess = immutable)
        
        AGL;
        GL;
        GLU;
        
        oldWidth    = 1376;
        oldHeight   = 768;
        
    end
    
    
    
    methods
        
        function obj = Render(varargin)
            
            if nargin > 0
                
                if isnumeric(varargin{1})
                    
                    res = varargin{1};
                    
                    obj.newWidth        = res(1);
                    obj.newHeight       = res(2);
                    obj.newHz           = res(3);
                    
                    obj.scaleRatio      = obj.newWidth / obj.oldWidth;
                    
                else
                    
                    error('Invalid spatial resolution parameters');
                    
                end
                
            end
            
            if ispc
                
                if isdeployed
                
                    InitializeMatlabOpenGL_SR(0);
                    
                else
                    
                    InitializeMatlabOpenGL(0);
                    
                end
                
            elseif ismac
                
                InitializeMatlabOpenGL(0);
                
            end
                
            Screen('Preference', 'SuppressAllWarnings', 1);
            Screen('Preference', 'SkipSyncTests', 2);
            Screen('Preference','VisualDebugLevel', 0);
            Screen('Preference', 'Verbosity', 0);
            
            %*****Banki edit for screen selection
            % Get the screen numbers. This gives us a number for each of the screens
            % attached to our computer.
            screensCheck = Screen('Screens');

            % To draw we select the maximum of these numbers. So in a situation where we
            % have two screens attached to our monitor we will draw to the external
            % screen.
            screenNumber = max(screensCheck);
            %obj.screenId = screenNumber;
            obj.screenId = screenNumber;
            
            % Encapsulate and protect AGL, GL, and GLU constants
            
            %eval('agl = AGL;');
            %obj.AGL = agl;
            eval('gl = GL;');
            obj.GL = gl;
            eval('glul = GLU;');
            obj.GLU = glul;
            
        end
        
        function obj = InitMazeWindow(obj, varargin)
            
            if nargin > 0
                
                obj.perspectiveAngle = varargin{1};
                
            end
            
            if nargin > 1
                
                obj.eyeLevel = varargin{2};
                
            end
            
            if nargin > 2
                
                obj.viewPoint = varargin{3};
                
            end
            
            if obj.viewPoint == 2
                
                obj.teapotFlag = 1;
                obj.ceilingFlag = 1; %was zero banki
                obj.tripwireFlag = 0;
                
            else
                
                obj.teapotFlag = 0;
                
            end

            if nargin > 3
                
               obj.proxCueFlag  = varargin{4};
                
            end
            
            obj.texNumId = zeros(1,100);
            
            obj = OpenPtbWindow(obj);
            obj = InitOpenGl(obj);
            obj = obj.AddTexture(GlTexture(obj.texPath, 'wall.jpg'));
            obj = obj.AddTexture(GlTexture(obj.texPath, 'cheese.bmp'));
            obj = obj.AddTexture(GlTexture(obj.texPath, 'tripwire.jpg'));
            obj = obj.AddTexture(GlTexture(obj.texPath, 'ground.jpg'));


            %fprintf('screen Id after base walls is %f\n',  obj.nTex);
            % Skybox texture loading

            obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'skybox_right.jpg'));
            obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'skybox_left.jpg'));
            obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'skybox_top.jpg'));
            obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'skybox_ground.jpg'));
            obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'skybox_back.jpg'));
            obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'skybox_front.jpg'));
            


            % Distal feature (moon)
            if obj.distalCueFlag
                obj = obj.AddTextureDistalQueue('moon.jpg',  obj.viewportPtr);
            end

            % Periperhal Queue
            if obj.proxCueFlag
                %obj = obj.AddTexturePerQueue('Bench LP_DefaultMaterial_BaseColor.png',  obj.viewportPtr);
                %obj = obj.AddTexturePerQueue('baseball.jpg',  obj.viewportPtr);
                %obj = obj.AddTextureSkybox(GlTexture(obj.texPath, 'crate_1.jpg'));
                % load object
                obj.cueProperties = LoadOBJFile('wet_floor_sign.obj');
                %disp(obj.cueProperties);
                obj.cueProperties = AddNormalsToOBJ(obj.cueProperties);
                %disp(obj.cueProperties);
                %disp(size((obj.cueProperties{1}.faces), 2));
                obj = obj.AddTexture(GlTexture(obj.objPath, 'wet_floor_sign_.png'));
            end
        end
        
        function obj = OpenPtbWindow(obj)
            
            % Psychtoolbox stuff
            AssertOpenGL;
            
            oldRes = Screen('Resolution', obj.screenId);
            
            if ispc
                
                if (oldRes.width == obj.newWidth) && (oldRes.height== obj.newHeight) && (oldRes.hz== obj.newHz)
                    
                    switchResFlag = 0;
                    
                else
                    
                    switchResFlag = 1;
                    res = Screen('Resolutions', obj.screenId);
                    resIndex = find( ([res(:).width] == obj.newWidth) & ([res(:).height] == obj.newHeight) & ([res(:).hz] == obj.newHz) & ([res(:).pixelSize] == 32) );
                    
                end
                
            elseif ismac
                
                if (oldRes.width == obj.newWidth) && (oldRes.height== obj.newHeight)
                    
                    switchResFlag = 0;
                    
                else
                    
                    switchResFlag = 1;
                    res = Screen('Resolutions', obj.screenId);
                    resIndex = find( ([res(:).width] == obj.newWidth) & ([res(:).height] == obj.newHeight) & ([res(:).pixelSize] == 24) );
                    
                end
                
                
            else
                
                error('Unknown platform');
                
            end
            
            if switchResFlag
                
                if isempty(resIndex)
                    
                    error('Cannot find resolution');
                    
                else
                    
                    SetResolution(obj.screenId, res(resIndex));
                    
                end
                
            end
            
            [windowPtr, windowRect] = Screen('OpenWindow', obj.screenId, 0);
            %             [windowPtr, windowRect] = Screen('OpenWindow', obj.screenId, 0, [], [], [], 0, obj.multiSampleFrames);
            obj.viewportPtr = windowPtr;
            obj.viewportRect = windowRect;
            [X0, Y0] = RectCenter(windowRect);
            obj.x0 = X0;
            obj.y0 = Y0;
            
            Screen('TextSize', obj.viewportPtr, 24);
            Screen('TextStyle', obj.viewportPtr, 0);
            Screen('TextFont', obj.viewportPtr, 'Arial');
            Screen('TextColor', obj.viewportPtr, [127 127 127]);
            
            obj.nRows = obj.viewportRect(3);
            obj.nCols = obj.viewportRect(4);
            obj.screenAspectRatio = obj.viewportRect(4)/obj.viewportRect(3);
            HideCursor;
            Screen('Flip', obj.viewportPtr);
            obj.isPtbWindowOk = 1;
            
        end
        
        function wallArray = AssignTexIdToWall(obj, wallArray, textureIndex)
            
            for wallIndex = 1:wallArray.nWalls
                
                wallArray.walls(wallIndex).glTextureId = obj.texNumId(textureIndex);
                
            end
            
        end
        
        
        function obj = AddTexture(obj, texObj)
            
            if ~isa(texObj, 'GlTexture')
                
                error('AddTexture needs a GlTexture object');
                
            end
            
            obj.nTex = obj.nTex + 1;
            texIndex = obj.nTex;
            
            while texIndex > numel(obj.texNumId)
                
                obj.texNumId = [obj.texNumId zeros(1, 100)];
                
            end
            
            obj.texNumId(texIndex) = glGenTextures(1);
            
            glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(texIndex));
            glTexImage2D(obj.GL.TEXTURE_2D, 0, obj.GL.RGB, texObj.nRows, texObj.nCols, 0, obj.GL.RGB, obj.GL.UNSIGNED_BYTE, texObj.pixels);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_WRAP_S,obj.GL.REPEAT);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_WRAP_T,obj.GL.REPEAT);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_MAG_FILTER,obj.GL.NEAREST);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_MIN_FILTER,obj.GL.NEAREST);
            
        end

          %Banki - Texture mapping for 3D Skybox feature
        function obj = AddTextureSkybox(obj, texObj)

            if ~isa(texObj, 'GlTexture')
                
                error('AddTexture needs a GlTexture object');
                
            end
            
            obj.nTex = obj.nTex + 1;
            texIndex = obj.nTex;
            
            while texIndex > numel(obj.texNumId)
                
                obj.texNumId = [obj.texNumId zeros(1, 100)];
                
            end
            
            obj.texNumId(texIndex) = glGenTextures(1);
            
            glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(texIndex));
            glTexImage2D(obj.GL.TEXTURE_2D, 0, obj.GL.RGB, texObj.nRows, texObj.nCols, 0, obj.GL.RGB, obj.GL.UNSIGNED_BYTE, texObj.pixels);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_WRAP_S,obj.GL.CLAMP_TO_EDGE);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_WRAP_T,obj.GL.CLAMP_TO_EDGE);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_WRAP_R,obj.GL.CLAMP_TO_EDGE);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_MAG_FILTER,obj.GL.LINEAR);
            glTexParameterfv(obj.GL.TEXTURE_2D,obj.GL.TEXTURE_MIN_FILTER,obj.GL.LINEAR);
            
        end
     
        function obj = AddTextureDistalQueue(obj, textFileName, window)

            % Load texture
            image = imread(textFileName);
            [s1, ~, ~] = size(image);
            image = im2double(image(1:s1, 1:s1, :));
            
            % Convert to a texture for PTB drawing (orientation needs changing for
            % rendering)
            imageFlipped = rot90(flipud(image));
            modelTexture = Screen('MakeTexture', window, imageFlipped, [], 1, 2);
            
            % Get the information we need about the texture
            [imw, imh] = Screen('WindowSize', modelTexture);
            [textureName, targetFront, ~, ~] = Screen('GetOpenGLTexture', window, modelTexture, imh, imw);
            
            %Create global attributes
            obj.DistalCueName = textureName;
            obj.DistalCueTarget = targetFront;
            obj.distalCueLocation = round(rand() + 1); % Randomly selects between the two text file input locations
            

            % Bind our texture and setup filtering to allow nice presentation of our
            % texture
            glBindTexture(targetFront, textureName);
            glGenerateMipmapEXT(targetFront); 
            
            glTexParameterf(targetFront, obj.GL.TEXTURE_MAG_FILTER, obj.GL.LINEAR);
            glTexParameterf(targetFront, obj.GL.TEXTURE_MIN_FILTER, obj.GL.LINEAR_MIPMAP_LINEAR);
            
            % Allow the texture and lighting to interact
            glTexEnvfv(obj.GL.TEXTURE_ENV, obj.GL.TEXTURE_ENV_MODE, obj.GL.MODULATE);
            
            % This gives nice texture rendering without artifacts
            maxAnisotropy = glGetFloatv(obj.GL.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
            glTexParameterf(targetFront, obj.GL.TEXTURE_MAX_ANISOTROPY_EXT, maxAnisotropy);
            
            % Clamping behaviour shall be a cyclic repeat:
            glTexParameteri(targetFront, obj.GL.TEXTURE_WRAP_S, obj.GL.REPEAT);
            glTexParameteri(targetFront, obj.GL.TEXTURE_WRAP_T, obj.GL.REPEAT);
                        
        end

        function obj = AddTexturePerQueue(obj, textFileName, window)

            % Load texture
            image = imread(textFileName);
            [s1, ~, ~] = size(image);
            image = im2double(image(1:s1, 1:s1, :));
            
            % Convert to a texture for PTB drawing (orientation needs changing for
            % rendering)
            imageFlipped = rot90(flipud(image));
            modelTexture = Screen('MakeTexture', window, imageFlipped, [], 1, 2);
            
            % Get the information we need about the texture
            [imw, imh] = Screen('WindowSize', modelTexture);
            [PertextureName, PertargetFront, ~, ~] = Screen('GetOpenGLTexture', window, modelTexture, imh, imw);
            
            %Create global attributes
            obj.proxCueName = PertextureName;
            obj.proxCueTarget = PertargetFront;            

            % Bind our texture and setup filtering to allow nice presentation of our
            % texture
            glBindTexture(PertargetFront, PertextureName);
            glGenerateMipmapEXT(PertargetFront); 
            
            glTexParameterf(PertargetFront, obj.GL.TEXTURE_MAG_FILTER, obj.GL.LINEAR);
            glTexParameterf(PertargetFront, obj.GL.TEXTURE_MIN_FILTER, obj.GL.LINEAR_MIPMAP_LINEAR);
            
            % Allow the texture and lighting to interact
            glTexEnvfv(obj.GL.TEXTURE_ENV, obj.GL.TEXTURE_ENV_MODE, obj.GL.MODULATE);
            
            % This gives nice texture rendering without artifacts
            maxAnisotropy = glGetFloatv(obj.GL.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
            glTexParameterf(PertargetFront, obj.GL.TEXTURE_MAX_ANISOTROPY_EXT, maxAnisotropy);
            
            % Clamping behaviour shall be a cyclic repeat:
            glTexParameteri(PertargetFront, obj.GL.TEXTURE_WRAP_S, obj.GL.REPEAT);
            glTexParameteri(PertargetFront, obj.GL.TEXTURE_WRAP_T, obj.GL.REPEAT);
                        
        end
        
        function obj = InitOpenGl(obj)
            
            if isempty(obj.viewportPtr)
                
                error('A PTB window must be opened prior to OpenGL initialization');
                
            end
            
            Screen('BeginOpenGL', obj.viewportPtr);
            glShadeModel(obj.GL.FLAT);
            glEnable(obj.GL.DEPTH_TEST);
            glPixelStorei(obj.GL.UNPACK_ALIGNMENT, 1);
            
            glEnable(obj.GL.LIGHTING);
            glEnable(obj.GL.LIGHT0);
            glLightModelfv(obj.GL.LIGHT_MODEL_TWO_SIDE, obj.GL.TRUE);
            glMaterialfv(obj.GL.FRONT_AND_BACK,obj.GL.AMBIENT, [1 1 1 1]);
            glMaterialfv(obj.GL.FRONT_AND_BACK,obj.GL.DIFFUSE, [1 1 1 1]);
            
            glEnable(obj.GL.TEXTURE_2D);
            
            glClearColor(0,0,0,0);
            
            glMatrixMode(obj.GL.PROJECTION);
            glLoadIdentity();
            gluPerspective(obj.perspectiveAngle, 1/obj.screenAspectRatio, 0.08, 20.0);
            glClearDepth(1.0);
            glMatrixMode(obj.GL.MODELVIEW);
            glLoadIdentity();
            glLightfv(obj.GL.LIGHT0, obj.GL.POSITION, [ 0 4 0 1 ]);
            glLightfv(obj.GL.LIGHT0, obj.GL.DIFFUSE, [ .75 .75 .75 1 ]);
            glLightfv(obj.GL.LIGHT0, obj.GL.AMBIENT, [ .25 .25 .25 1 ]);
            
            % Set uniforms and attributes, and then render your geometry

            if obj.viewPoint == 1
                
                glRotatef(90, 0, 1, 0);
                glTranslatef(0, obj.eyeLevel, 0);
                
            elseif obj.viewPoint == 2
                
                glTranslatef(0, 0, -6);
                glRotatef(90, 1, 0, 0);
                
            end
            
            Screen('EndOpenGL', obj.viewportPtr);
            
        end
        
        
        function UpdateDisplay(obj, player, maze)
            
            Screen('BeginOpenGL', obj.viewportPtr);
            glClear;
            glTexEnvf(obj.GL.TEXTURE_ENV, obj.GL.TEXTURE_ENV_MODE, obj.GL.REPLACE);
            
            if obj.viewPoint == 2
                
                if obj.teapotFlag
                    
                    glBindTexture(obj.GL.TEXTURE_2D, 0);
                    glMaterialfv(obj.GL.FRONT_AND_BACK,obj.GL.AMBIENT, [.25 1 .3 1]);
                    glMaterialfv(obj.GL.FRONT_AND_BACK,obj.GL.DIFFUSE, [.25 1 .3 1]);
                    glutSolidTeapot(player.bodyRadius);
                    
                end
                
            end
            
            % Rotate and translate world
            glPushMatrix();
            glRotatef(-player.heading, 0, 1, 0);
            glRotatef(180, 0, 1, 0);
            glTranslatef(-player.nextPos(1), 0, -player.nextPos(2));
            
            % Draw ground
            glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(4));
            glBegin(obj.GL.QUADS);
            glTexCoord2f(0.0, 0.0); glVertex3f(10, 0.0, -10);
            glTexCoord2f(0.0, 4); glVertex3f(10, 0.0, 10);
            glTexCoord2f(4, 4); glVertex3f(-10, 0.0, 10);
            glTexCoord2f(4, 0.0); glVertex3f(-10, 0.0, -10);
            glEnd;
            
            %   Draw ceiling
            if obj.ceilingFlag

                % Top
                glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(7));
                glBegin(obj.GL.QUADS);
                glTexCoord2f(0.0, 0.0); glVertex3f(-13.5, 6.0, -6.5);
                glTexCoord2f(0.0, 1); glVertex3f(-13.5, 6.0, 13.5);
                glTexCoord2f(1, 1); glVertex3f(13.5, 6.0, 6.5);
                glTexCoord2f(1, 0.0); glVertex3f(6.5, 6.0, -6.5);
                glEnd;


                %Banki Addition - Sky to ground 4 walls

                 % Right sky wall
                glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(5));
                glBegin(obj.GL.QUADS);
                glTexCoord2f(0.0, 0.0); glVertex3f(-13.5, 0.0, -6.5);  
                glTexCoord2f(0.0, 1); glVertex3f(-13.5, 6.0, -6.5);

                glTexCoord2f(1, 1); glVertex3f(6.5, 6.0, -6.5);
                glTexCoord2f(1, 0.0); glVertex3f(6.5, 0.0, -6.5);
                glEnd;
                
                % Left wall
                glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(6));
                glBegin(obj.GL.QUADS);
                glTexCoord2f(0.0, 0.0); glVertex3f(13.5, 0.0, 6.5);
                glTexCoord2f(0.0, 1); glVertex3f(13.5, 6.0, 6.5);

                glTexCoord2f(1, 1); glVertex3f(-13.5, 6.0, 13.5);
                glTexCoord2f(1, 0.0); glVertex3f(-13.5, 0.0, 13.5);
                glEnd;

                % Back sky wall
                glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(9));
                glBegin(obj.GL.QUADS);
                glTexCoord2f(0.0, 0.0); glVertex3f(-13.5, 0.0, 13.5);  
                glTexCoord2f(0.0, 1); glVertex3f(-13.5, 6.0, 13.5);

                glTexCoord2f(1, 1); glVertex3f(-13.5, 6.0, -6.5);
                glTexCoord2f(1, 0.0); glVertex3f(-13.5, 0.0, -6.5);
                glEnd;

                 % Front sky wall
                glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(10));
                glBegin(obj.GL.QUADS);
                glTexCoord2f(0.0, 0.0); glVertex3f(6.5, 0.0, -6.5);  
                glTexCoord2f(0.0, 1); glVertex3f(6.5, 6.0, -6.5);

                glTexCoord2f(1, 1); glVertex3f(13.5, 6.0, 6.5);     
                glTexCoord2f(1, 0.0); glVertex3f(13.5, 0.0, 6.5);
                glEnd;
                                                             
            end
            
            % Draw regular walls
            glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(1));
            glBegin(obj.GL.QUADS);
            for wallIndex = 1:maze.nNormalWalls
                
                thisWall = maze.normalWallArray(wallIndex);
                
                glTexCoord2f(0.0, 0.0); glVertex3f(thisWall.p1(1), 0.0, thisWall.p1(2));
                glTexCoord2f(0.0, 1.0); glVertex3f(thisWall.p1(1), 0.5, thisWall.p1(2));
                
                glTexCoord2f(thisWall.norm, 1.0); glVertex3f(thisWall.p2(1), 0.5, thisWall.p2(2));
                glTexCoord2f(thisWall.norm, 0.0); glVertex3f(thisWall.p2(1), 0.0, thisWall.p2(2));
                
            end
            glEnd;
            
            % Draw target walls
            glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(2));
            glBegin(obj.GL.QUADS);
            for wallIndex = 1:maze.nTargetWalls
                
                thisWall = maze.targetWallArray(wallIndex);
                
                glTexCoord2f(0.0, 0.0); glVertex3f(thisWall.p1(1), 0.0, thisWall.p1(2));
                glTexCoord2f(0.0, 1.0); glVertex3f(thisWall.p1(1), 0.5, thisWall.p1(2));
                glTexCoord2f(1.0, 1.0); glVertex3f(thisWall.p2(1), 0.5, thisWall.p2(2));
                glTexCoord2f(1.0, 0.0); glVertex3f(thisWall.p2(1), 0.0, thisWall.p2(2));
                
            end
            glEnd;

            if obj.tripwireFlag
                
                % Draw tripwires
                glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(3));
                glBegin(obj.GL.QUADS);
                for wallIndex = 1:maze.nTripWires
                      
                    thisWall = maze.tripWireArray(wallIndex);
                    
                    glTexCoord2f(0.0, 0.0); glVertex3f(thisWall.p1(1), 0.0, thisWall.p1(2));
                    glTexCoord2f(0.0, 1.0); glVertex3f(thisWall.p1(1), 0.5, thisWall.p1(2));
                    
                    glTexCoord2f(thisWall.norm, 1.0); glVertex3f(thisWall.p2(1), 0.5, thisWall.p2(2));
                    glTexCoord2f(thisWall.norm, 0.0); glVertex3f(thisWall.p2(1), 0.0, thisWall.p2(2));
                    
                end
                glEnd;
                
            end

            if obj.distalCueFlag

                % Number of slices that we wil use on our sphere (higher gives a smoother
                % surface)
                numSlices = 1000;

                % Enable the loaded model texture
                glEnable(obj.DistalCueTarget);

                % Render the sphere with a local translation that's relative to the global translation
                glPushMatrix;

                 % Translate the sphere to the desired location
                location = obj.distalCueLocation;
                glTranslatef(maze.distalQueue.x(location), 5, maze.distalQueue.y(location));

                %Draw Distall Queue
                glBindTexture(obj.DistalCueTarget, obj.DistalCueName);
                theSphere = gluNewQuadric;
                gluQuadricTexture(theSphere, obj.GL.TRUE);
                sphereRadius = 0.5;
                gluSphere(theSphere, sphereRadius, numSlices, numSlices);

                % Restore the transformation state
                glPopMatrix;
            end

            if obj.proxCueFlag
                %----------------------------------OLD------------------------------------------------%

                % % Number of slices that we wil use on our sphere (higher gives a smoother
                % % surface)
                % numSlices = 1000;
                % 
                % % Enable the loaded model texture
                % glEnable(obj.proxCueTarget);
                % 
                % % Render the sphere with a local translation that's relative to the global translation
                % glPushMatrix;
                % 
                % % Translate the sphere to the desired location
                % glTranslatef(maze.perQueue.x(1), 0.025, maze.perQueue.y(1));
                % 
                % %Draw Peripheral Queue
                % glBindTexture(obj.proxCueTarget, obj.proxCueName);
                % theSphere = gluNewQuadric;
                % gluQuadricTexture(theSphere, obj.GL.TRUE);
                % sphereRadius = .025;
                % gluSphere(theSphere, sphereRadius, numSlices, numSlices);
                % 
                % % Restore the transformation state
                % glPopMatrix;
                % 
                % %----Second peripheral queue, crate box-------
                % 
                % % Render the sphere with a local translation that's relative to the global translation
                % glPushMatrix;
                % 
                % x = maze.perQueue.x(2);
                % y = 0.075;
                % z = maze.perQueue.y(1);
                % size = 0.075;
                % 
                % % Top box
                % glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(11));
                % glBegin(obj.GL.QUADS);
                % glTexCoord2f(0.0, 0.0); glVertex3f((x - size), (2 * y), (z - size));
                % glTexCoord2f(0.0, 1); glVertex3f((x - size), (2 * y), (z + size));
                % glTexCoord2f(1, 1); glVertex3f((x + size), (2 * y), (z + size));
                % glTexCoord2f(1, 0.0); glVertex3f((x + size), (2 * y), (z - size));
                % glEnd;
                % 
                %  % Right box
                % glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(11));
                % glBegin(obj.GL.QUADS);
                % glTexCoord2f(0.0, 0.0); glVertex3f((x - size), 0.0, (z - size));  
                % glTexCoord2f(0.0, 1); glVertex3f((x - size), 2 * y, (z - size));
                % 
                % glTexCoord2f(1, 1); glVertex3f((x + size), (2 * y), (z - size));
                % glTexCoord2f(1, 0.0); glVertex3f((x + size), 0.0, (z - size));
                % glEnd;
                % 
                % % Left box
                % glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(11));
                % glBegin(obj.GL.QUADS);
                % glTexCoord2f(0.0, 0.0); glVertex3f((x + size), 0.0, (z + size));
                % glTexCoord2f(0.0, 1); glVertex3f((x + size), (2 * y), (z + size));
                % 
                % glTexCoord2f(1, 1); glVertex3f((x - size), (2 * y), (z + size));
                % glTexCoord2f(1, 0.0); glVertex3f((x - size), 0.0, (z + size));
                % glEnd;
                % 
                % % Back box
                % glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(11));
                % glBegin(obj.GL.QUADS);
                % glTexCoord2f(0.0, 0.0); glVertex3f((x - size), 0.0, (z + size));  
                % glTexCoord2f(0.0, 1); glVertex3f((x - size), 2 * y, (z + size));
                % 
                % glTexCoord2f(1, 1); glVertex3f((x - size), (2 * y), (z - size));
                % glTexCoord2f(1, 0.0); glVertex3f((x - size), 0.0, (z - size));
                % glEnd;
                % 
                %  % Front box
                % glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(11));
                % glBegin(obj.GL.QUADS);
                % glTexCoord2f(0.0, 0.0); glVertex3f((x + size), 0.0, (z - size));  
                % glTexCoord2f(0.0, 1); glVertex3f((x + size), (2 * y), (z - size));
                % 
                % glTexCoord2f(1, 1); glVertex3f((x + size), (2 * y), (z + size));     
                % glTexCoord2f(1, 0.0); glVertex3f((x + size), 0.0, (z + size));
                % glEnd;
                % 
                %  % Restore the transformation state
                % glPopMatrix;

                %----------------------------------OLD------------------------------------------------%

                %----Loaded Object peripheral cue-------
                
                % Render the sphere with a local translation that's relative to the global translation
                 glPushMatrix;

                % Initialize local transformation matrix as an identity matrix
                obj.cueProperties{1}.localTransform = eye(4);
                 
                 glTranslatef(-1, 0, 2);

                 glBindTexture(obj.GL.TEXTURE_2D, obj.texNumId(11))
                 
                 for i = 1:numel(obj.cueProperties{1}.faces(1,:))
                 
                     if numel(obj.cueProperties{1}.faces(:, 1)) == 3
                         glBegin(obj.GL.TRIANGLES);
                     else
                         glBegin(obj.GL.QUADS);
                     end
                 
                     for j = 1:numel(obj.cueProperties{1}.faces(:, 1))
                 
                         vertexIndex = obj.cueProperties{1}.faces(j, i) + 1;
                         scale = 0.1;
                 
                        if vertexIndex > 0 && vertexIndex <= numel(obj.cueProperties{1}.vertices(1,:))
                            glNormal3fv(obj.cueProperties{1}.normals(:, vertexIndex));

                            if ~isempty(obj.cueProperties{1}.texcoords)
                               glTexCoord2fv(obj.cueProperties{1}.texcoords(:, vertexIndex));
                            end 

                            %glTexCoord2fv(obj.cueProperties{1}.texcoords(:, vertexIndex));
                            glVertex3fv(obj.cueProperties{1}.vertices(:, vertexIndex) * scale);
                        else
                            fprintf('Invalid vertex index: %d\n', vertexIndex);
                        end
                     end
                     glEnd();
                 end
                 
                 % Restore the transformation state
                 glPopMatrix;

                %----Loaded Object peripheral cue-------

                %------------BoundedBox Setup----------------

                glPushMatrix;

                % Accumulate translation
                translationVector = [-1, 0, 2];
                translationMatrix = makehgtform('translate', translationVector);
                obj.cueProperties{1}.localTransform = obj.cueProperties{1}.localTransform * translationMatrix;

                % Assume obj is your 3D object structure with fields like cueProperties, localTransform, etc.
                vertices = obj.cueProperties{1}.vertices * 0.1;

                % Set up the perspective projection matrix
                projectionMatrix = perspectiveProjectionMatrix(obj.perspectiveAngle, 1/obj.screenAspectRatio, 0.08, 20.0);

                %Global Transform
                globaltranslationVector = [-player.nextPos(1), 0, -player.nextPos(2)];
                rotationAngles = [0, 0, 0]; % Angles in degrees
                
                % Create translation matrix
                T = eye(4);
                T(1:3, 4) = globaltranslationVector;
                
                % Create rotation matrix (assuming rotation is around the origin)
                R = euler2rotmat(rotationAngles);

                % Combine translation and rotation
                globalTransform = T * R;

                % Call the bounding box function
                [limits, boundingBox] = calculateBoundingBox(vertices, obj.cueProperties{1}.localTransform, globalTransform, projectionMatrix);

                %disp(limits);

                % Set up color for wireframe (e.g., red)
                glColor3f(1, 0, 0);

                % Draw the wireframe
                glBegin(obj.GL.LINES);

                scale = 0.1;

                % Bottom
                glVertex3fv(boundingBox(:, 1));
                glVertex3fv(boundingBox(:, 2));
            
                glVertex3fv(boundingBox(:, 2));
                glVertex3fv(boundingBox(:, 4));
            
                glVertex3fv(boundingBox(:, 4));
                glVertex3fv(boundingBox(:, 3));
            
                glVertex3fv(boundingBox(:, 3));
                glVertex3fv(boundingBox(:, 1));
            
                % Top
                glVertex3fv(boundingBox(:, 5));
                glVertex3fv(boundingBox(:, 6));
            
                glVertex3fv(boundingBox(:, 6));
                glVertex3fv(boundingBox(:, 8));
            
                glVertex3fv(boundingBox(:, 8));
                glVertex3fv(boundingBox(:, 7));
            
                glVertex3fv(boundingBox(:, 7));
                glVertex3fv(boundingBox(:, 5));
            
                % Vertical edges
                glVertex3fv(boundingBox(:, 1));
                glVertex3fv(boundingBox(:, 5));
            
                glVertex3fv(boundingBox(:, 2));
                glVertex3fv(boundingBox(:, 6));
            
                glVertex3fv(boundingBox(:, 3));
                glVertex3fv(boundingBox(:, 7));
            
                glVertex3fv(boundingBox(:, 4));
                glVertex3fv(boundingBox(:, 8));
                glEnd();
     
                glPopMatrix;

                %------------BoundedBox Setup----------------


           end
       
            glPopMatrix();
            Screen('EndOpenGL', obj.viewportPtr);
            Screen('Flip', obj.viewportPtr);          
            
        end
        
        function obj = set.perspectiveAngle(obj, PerspectiveAngle)
            
            if isnumeric(PerspectiveAngle) && (PerspectiveAngle >= 0) && (PerspectiveAngle <= 180)
                
                obj.perspectiveAngle = PerspectiveAngle;
                
            else
                
                error('Perspective angle must be >=0 and <= 180');
                
            end
            
        end
        
    end
    
    methods (Static)
        
        function Close()
            
            % ListenChar(0);
            ShowCursor;
            Screen('CloseAll');
            error('User aborted');
            
        end
        
    end
    
end
