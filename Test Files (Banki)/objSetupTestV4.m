% Clear the workspace
clear;
close all;

% Randomly seed the random number generation
rng('shuffle');

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

%----------------------------------------------------------------------
%                   Load the object
%----------------------------------------------------------------------

% load object
obj = LoadOBJFile('paint_can.obj');

% Load the .mtl file for your object (replace 'your_materials.mtl' with the actual file name)
materialLibrary = LoadMTLFile('paint_can.mtl');

%obj = AddNormalsToOBJ(obj);
objtex.path = 'Objects'; 

%Object check
disp(obj);

% Assumed viewing distance
distanceCm = 60;

%----------------------------------------------------------------------
%                   Screen initialisation
%----------------------------------------------------------------------

% Make sure that the computer is running the OpenGL psych toolbox
AssertOpenGL;

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper
InitializeMatlabOpenGL;

% Number of samples per pixel for multisampling
multiSample = 4;

% Find the screen to use for display
screenid = max(Screen('Screens'));

% Set the black and white index
black = BlackIndex(screenid);

% Start the PsychImaging Configuration
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');

% Open an on screen window using PsychImaging to optimise drawing
[window, winRect] = PsychImaging('OpenWindow', screenid, black,...
    [], 32, 2, [], multiSample);

% Set to maximum priority
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Get the width and height of the window in pixels
[screenXpix, screenYpix] = Screen('WindowSize', window);

% Reported dimensions of the screen in cm
[widthMm, heightMm] = Screen('DisplaySize', screenid);
screenWidth = widthMm / 10;
screenHeight = heightMm / 10;

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% Fill the screen black
Screen('FillRect', window, black);
Screen('Flip', window);


%----------------------------------------------------------------------
%                       Timing information
%----------------------------------------------------------------------

% Number of frames to wait before drawing again
waitframes = 1;


%----------------------------------------------------------------------
%                   Make a checkerboard texture
%----------------------------------------------------------------------

% Load texture
%text = (GlTexture(objtex.path, 'barrel_red.mtl'));

%text.material = glGenTextures(1);

% Bind our texture and setup filtering to allow nice presentation of our
% texture
% glBindTexture(GL.TEXTURE_2D, text.material);
% glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, text.nRows, text.nCols, 0, GL.RGB, GL.UNSIGNED_BYTE, text.pixels);
% glGenerateMipmapEXT(targetFront);
% glTexParameterf(targetFront, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
% glTexParameterf(targetFront, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
% 
% % Allow the texture and lighting to interact
% glTexEnvfv(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.MODULATE);
% 
% % This gives nice texture rendering without artifacts
% maxAnisotropy = glGetFloatv(GL.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
% glTexParameterf(targetFront, GL.TEXTURE_MAX_ANISOTROPY_EXT, maxAnisotropy);
% 
% % Clamping behaviour shall be a cyclic repeat:
% glTexParameteri(targetFront, GL.TEXTURE_WRAP_S, GL.REPEAT);
% glTexParameteri(targetFront, GL.TEXTURE_WRAP_T, GL.REPEAT);

usemtl = obj{1}.usemtl{1};
materialName = usemtl.materialName;

% Find the material in the material library
material = materialLibrary.(materialName);

% Load the texture and create a texture handle (replace 'texture.png' with your texture file)
% texture = Screen('MakeTexture', window, imread('PaintCan_low_PBR StoA_Diffuse.png'));

textureImage = imread('PaintCan_low_PBR StoA_Diffuse.png');
doubleTexture = double(textureImage);

% Now create the textured
texture = Screen('MakeTexture', window, doubleTexture);
        
% Enable texturing
glEnable(GL.TEXTURE_2D);
glBindTexture(GL.TEXTURE_2D, texture);

% Set material properties
glMaterialfv(GL.FRONT_AND_BACK, GL.AMBIENT, material.Ka);
%glMaterialfv(GL.FRONT_AND_BACK, GL.DIFFUSE, material.Kd);
glMaterialfv(GL.FRONT_AND_BACK, GL.SPECULAR, material.Ks);
% Clamp Ns to the valid range [0, 128]
shininess = max(0, min(material.Ns, 128));
glMaterialf(GL.FRONT_AND_BACK, GL.SHININESS, shininess);
%----------------------------------------------------------------------
%                       OpenGL Setup
%----------------------------------------------------------------------

% Setup the OpenGL rendering context of the onscreen window for use by
% OpenGL wrapper
Screen('BeginOpenGL', window);

% Set background color to 'black'
glClearColor(0, 0, 0, 0);

% Enable depth buffer
glEnable(GL.DEPTH_TEST);


%----------------------------------------------------------------------
%                 We will use perspective projection
%----------------------------------------------------------------------

% Near and far clipping planes (these difine the rendering volume, anything
% outside of these is not rendered)
clipNear = 0.1;
clipFar = 100;

% Angular subtense of the screen
angle = 2 * atand((screenHeight / 2) / distanceCm);

% Aspect ratio of the screen
aspectRatio = screenWidth / screenHeight;

% Lets set up a projection matrix, the projection matrix defines how images
% in our 3D simulated scene are projected to the images on our 2D monitor
glMatrixMode(GL.PROJECTION);
glLoadIdentity;
gluPerspective(angle, aspectRatio, clipNear, clipFar);

% Setup modelview matrix: This defines the position, orientation and
% direction of the virtual camera that will  look at our scene with
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

% Location of the camera
cam = [0 0 0];

% Set our camera to be looking directly down the -Z axis (depth) of our
% coordinate system
fix = [0 0 -1];

% Define "up"
up = [0 1 0];

% Here we set up the attributes of our camera using the variables we have
% defined in the last three lines of code
gluLookAt(cam(1), cam(2), cam(3), fix(1), fix(2), fix(3), up(1), up(2), up(3));


%----------------------------------------------------------------------
%               Setup the lighting for the environment
%----------------------------------------------------------------------

% Enable OpenGL Lighting
glEnable(GL.LIGHTING);

% Force there to be no ambient light (OpenGL default is for there to be
% some)
glLightModelfv(GL.LIGHT_MODEL_AMBIENT, [0 0 0 1]);

% Define a local light source
glEnable(GL.LIGHT0);

% Defuse light only
glLightfv(GL.LIGHT0, GL.DIFFUSE, [1 1 1 1]);

% Point the light at the origin (this is where we will place our sphere)
glLightfv(GL.LIGHT0, GL.SPOT_DIRECTION, [0 0 -distanceCm]);

% Allow normalisation
glEnable(GL.NORMALIZE);

% Enable and bind the texture
% glEnable(targetFront);
% glBindTexture(targetFront, texNameFront);

% End the open GL wrapper for now
Screen('EndOpenGL', window);




%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Unify the keyboard names for mac and windows computers
KbName('UnifyKeyNames');

% Define the keyboard keys that are listened for
escapeKey = KbName('ESCAPE');


%----------------------------------------------------------------------
%                           Drawing Loop
%----------------------------------------------------------------------

% Set the object rotation parameters
amplitude = 30; % Adjust the rotation amplitude to your preference
angFreqX = 0.5;
angFreqY = 0.3;
angFreqZ = 0.7;
startPhaseX = 0;
startPhaseY = 0;
startPhaseZ = 0;
time = 0;

% Get a vbl for the start time
vbl = Screen('Flip', window);
startTimeFix = vbl;


while ~KbCheck

    % Orientation of the square on this frame
    angleX = amplitude * sin(angFreqX * time + startPhaseX);
    angleY = amplitude * sin(angFreqY * time + startPhaseY);
    angleZ = amplitude * sin(angFreqZ * time + startPhaseZ);

    % Begin open GL
    Screen('BeginOpenGL', window);

    % Clear the buffers
    glClear;

    % Push and pop are needed to avoid accumulations of transforms
    glPushMatrix;

    % Rotate and then translate the surface (these commands need to be
    % issued in the opposite way in which you want them applied by OpenGL)
    glTranslatef(0, 0, -distanceCm/2);
    glRotatef(angleX, 1, 0, 0);
    glRotatef(angleY, 0, 1, 0);
    glRotatef(angleZ, 0, 0, 1);

    %----Old rendering loop----

    % Loop through the object's faces and vertices and render them
    
   % glBindTexture(GL.TEXTURE_2D, text.material);
%--------------------------------------------------------------------------------------
   
    % for i = 1:size(obj{1}.faces, 2)
    % 
    %     if size(obj{1}.faces, 1) == 3
    %         glBegin(GL.TRIANGLES);
    %     else
    %         glBegin(GL.QUADS);
    %     end
    % 
    %     for j = 1:size(obj{1}.faces, 1)
    % 
    %         vertexIndex = obj{1}.faces(j, i) + 1;
    %         %texcoordIndex = obj{1}.texcoords(j, i);
    %        if vertexIndex > 0 && vertexIndex <= size(obj{1}.vertices, 2)
    %             glNormal3fv(obj{1}.normals(:, vertexIndex));
    % 
    %            if ~isempty(obj{1}.texcoords)
    %                glTexCoord2fv(obj{1}.texcoords(:, vertexIndex));
    %            end 
    % 
    %            glVertex3fv(obj{1}.vertices(:, vertexIndex));
    %            %fprintf('Valid vertex index: %d, index  i %d j %d\n', vertexIndex, i, j);
    %            %fprintf('Texture coordinates: %d and %d\n', obj{1}.texcoords(1, vertexIndex), obj{1}.texcoords(2, vertexIndex));
    %        else
    %            fprintf('Invalid vertex index: %d\n', vertexIndex);
    %        end
    %     end
    %     glEnd();
    % end
    % 
    %-----------------------------------------------------------------------------------------------
     %----Old rendering loop----
    
    % Now, for each material used in your object, set the material properties and texture.

    for k = 1:numel(obj{1}.faces(1,:))
        if numel(obj{1}.faces(:, 1)) == 3
            glBegin(GL.TRIANGLES);
        else
            glBegin(GL.QUADS);
        end

        for j = 1:numel(obj{1}.faces(:, 1))
            vertexIndex = obj{1}.faces(j, k) + 1;
            scale = 0.3;

            if vertexIndex > 0 && vertexIndex <= numel(obj{1}.vertices(1,:))
                glNormal3fv(obj{1}.normals(:, vertexIndex));
                glVertex3fv(obj{1}.vertices(:, vertexIndex) * scale);
            else
                fprintf('Invalid vertex index: %d\n', vertexIndex);
            end
        end
        glEnd();
    end
    
    % Disable texturing
    %glDisable(GL.TEXTURE_2D);

    % Ditch the matrix transforms
    glPopMatrix;

    % End the open GL context
    Screen('EndOpenGL', window);

    % Flip to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Increment time
    time = time + ifi;

end

% Close the screen
Screen('CloseAll')