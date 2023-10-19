function skybox_test_trials

AssertOpenGL;

% Find the screen to use for display:
screenid = 0;

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper:
InitializeMatlabOpenGL(1);

% Open a double-buffered full-screen window on the main displays screen.
[win , winRect] = Screen('OpenWindow', screenid);

% Setup the OpenGL rendering context of the onscreen window for use by
% OpenGL wrapper. After this command, all following OpenGL commands will
% draw into the onscreen window 'win':
Screen('BeginOpenGL', win);

% Get the aspect ratio of the screen:
ar=winRect(4)/winRect(3);

% Turn on OpenGL local lighting model: The lighting model supported by
% OpenGL is a local Phong model with Gouraud shading.
glEnable(GL_LIGHTING);

% Enable the first local light source GL_LIGHT_0. Each OpenGL
% implementation is guaranteed to support at least 8 light sources. 
glEnable(GL_LIGHT0);

% Enable two-sided lighting - Back sides of polygons are lit as well.
glLightModelfv(GL_LIGHT_MODEL_TWO_SIDE,GL_TRUE);

% Enable proper occlusion handling via depth tests:
glEnable(GL_DEPTH_TEST);

% Define the cubes light reflection properties by setting up reflection
% coefficients for ambient, diffuse and specular reflection:
glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [ .33 .22 .03 1 ]);
glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [ .78 .57 .11 1 ]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS,27.8);

% Enable 2D texture mapping, so the faces of the cube will show some nice
% images:
glEnable(GL_TEXTURE_CUBE_MAP);
%glEnable(GL_TEXTURE_2D);

% Load textures into mapping

cubeData1 = GlTexture('Textures', 'cube_map_0.jpg');
cubeData2 = GlTexture('Textures', 'cube_map_1.jpg');
cubeData3 = GlTexture('Textures', 'cube_map_2.jpg');
cubeData4 = GlTexture('Textures', 'cube_map_3.jpg');
cubeData5 = GlTexture('Textures', 'cube_map_4.jpg');
cubeData6 = GlTexture('Textures', 'cube_map_5.jpg');

%Generate texture for Cube Mapping
cubeText = glGenTextures(1);

% Bind texture to cube map
glBindTexture(GL_TEXTURE_CUBE_MAP, cubeText);

% Build Cube Map
glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X,  0, GL_RGB,  cubeData1.nRows, cubeData1.nCols, 0, GL_RGB, GL_UNSIGNED_BYTE, cubeData1.pixels);
glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X,  0, GL_RGB,  cubeData2.nRows, cubeData2.nCols, 0, GL_RGB, GL_UNSIGNED_BYTE, cubeData2.pixels);
glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y,  0, GL_RGB,  cubeData3.nRows, cubeData3.nCols, 0, GL_RGB, GL_UNSIGNED_BYTE, cubeData3.pixels);
glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,  0, GL_RGB,  cubeData4.nRows, cubeData4.nCols, 0, GL_RGB, GL_UNSIGNED_BYTE, cubeData4.pixels);
glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z,  0, GL_RGB,  cubeData5.nRows, cubeData5.nCols, 0, GL_RGB, GL_UNSIGNED_BYTE, cubeData5.pixels);
glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,  0, GL_RGB,  cubeData6.nRows, cubeData6.nCols, 0, GL_RGB, GL_UNSIGNED_BYTE, cubeData6.pixels);

% Assign texture settings
glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);


glMatrixMode(GL_PROJECTION);
glLoadIdentity;
ar = winRect(4) / winRect(3);
% Field of view is 25 degrees from line of sight. Objects closer than
% 0.1 distance units or farther away than 100 distance units get clipped
% away, aspect ratio is adapted to the monitors aspect ratio:
gluPerspective(25,1/ar,0.1,100);

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;

% Cam is located at 3D position (3,3,5), points upright (0,1,0) and fixates
% at the origin (0,0,0) of the worlds coordinate system:
    gluLookAt(0.5, 0.5, 0.5, 0, 0, 0, 0, 1, 0);
  
% Setup position and emission properties of the light source:

% Set background color to 'black':
glClearColor(0,0,0,0);

% Point lightsource at (1,2,3)...
glLightfv(GL_LIGHT0,GL_POSITION,[ 1 2 3 0 ]);
% Emits white (1,1,1,1) diffuse light:
glLightfv(GL_LIGHT0,GL_DIFFUSE, [ 1 1 1 1 ]);

% There's also some white, but weak (R,G,B) = (0.1, 0.1, 0.1)
% ambient light present:
glLightfv(GL_LIGHT0,GL_AMBIENT, [ .1 .1 .1 1 ]);

while (1)

    % Define vertices for a unit cube
    v = [-1 -1 -1; 1 -1 -1; 1 1 -1; -1 1 -1; -1 -1 1; 1 -1 1; 1 1 1; -1 1 1];

    % Define indices for the cube's faces
    i = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];

    % Bind the cube map texture for this face
    glBindTexture(GL_TEXTURE_CUBE_MAP, cubeText);
    glEnable(GL_TEXTURE_CUBE_MAP);
    glBegin(GL.TRIANGLE_STRIP);

    % Face 0: GL_TEXTURE_CUBE_MAP_POSITIVE_X
    % Vertex 1
    glTexCoord3f(1.0, 0.5, 0.5);
    glVertex3f(1, -1, -1);
    % Vertex 2
    glTexCoord3f(0.5, 0.5, 0.5);
    glVertex3f(1, 1, -1);
    % Vertex 3
    glTexCoord3f(1.0, 1.0, 0.5);
    glVertex3f(1, -1, 1);
    % Vertex 4
    glTexCoord3f(0.5, 1.0, 0.5);
    glVertex3f(1, 1, 1);
    
    % Face 1: GL_TEXTURE_CUBE_MAP_NEGATIVE_X
    % Vertex 5
    glTexCoord3f(0.0, 0.5, 0.5);
    glVertex3f(-1, -1, -1);
    % Vertex 6
    glTexCoord3f(0.5, 0.5, 0.5);
    glVertex3f(-1, 1, -1);
    % Vertex 7
    glTexCoord3f(0.0, 1.0, 0.5);
    glVertex3f(-1, -1, 1);
    % Vertex 8
    glTexCoord3f(0.5, 1.0, 0.5);
    glVertex3f(-1, 1, 1);
    
    % Face 2: GL_TEXTURE_CUBE_MAP_POSITIVE_Y
    % Vertex 9
    glTexCoord3f(0.5, 1.0, 0.5);
    glVertex3f(-1, 1, -1);
    % Vertex 10
    glTexCoord3f(0.5, 0.5, 0.5);
    glVertex3f(1, 1, -1);
    % Vertex 11
    glTexCoord3f(1.0, 1.0, 0.5);
    glVertex3f(-1, 1, 1);
    % Vertex 12
    glTexCoord3f(1.0, 0.5, 0.5);
    glVertex3f(1, 1, 1);
    
    % Face 3: GL_TEXTURE_CUBE_MAP_NEGATIVE_Y
    % Vertex 13
    glTexCoord3f(0.5, 0.0, 0.5);
    glVertex3f(-1, -1, -1);
    % Vertex 14
    glTexCoord3f(0.5, 0.5, 0.5);
    glVertex3f(1, -1, -1);
    % Vertex 15
    glTexCoord3f(1.0, 0.0, 0.5);
    glVertex3f(-1, -1, 1);
    % Vertex 16
    glTexCoord3f(1.0, 0.5, 0.5);
    glVertex3f(1, -1, 1);
    
    % Face 4: GL_TEXTURE_CUBE_MAP_POSITIVE_Z
    % Vertex 17
    glTexCoord3f(0.5, 0.5, 1.0);
    glVertex3f(-1, -1, 1);
    % Vertex 18
    glTexCoord3f(0.5, 0.5, 0.5);
    glVertex3f(1, -1, 1);
    % Vertex 19
    glTexCoord3f(1.0, 0.5, 1.0);
    glVertex3f(-1, 1, 1);
    % Vertex 20
    glTexCoord3f(1.0, 0.5, 0.5);
    glVertex3f(1, 1, 1);
    
    % Face 5: GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
    % Vertex 21
    glTexCoord3f(0.5, 1.0, 0.5);
    glVertex3f(-1, -1, -1);
    % Vertex 22
    glTexCoord3f(0.5, 0.5, 0.5);
    glVertex3f(1, -1, -1);
    % Vertex 23
    glTexCoord3f(1.0, 1.0, 0.5);
    glVertex3f(-1, 1, -1);
    % Vertex 24
    glTexCoord3f(1.0, 0.5, 0.5);
    glVertex3f(1, 1, -1);
    
    glEnd();

        
    

    
    % Finish OpenGL rendering into PTB window and check for OpenGL errors.
    Screen('EndOpenGL', win);

    % Show rendered image at next vertical retrace:
    Screen('Flip', win);

    % Switch to OpenGL rendering again for drawing of next frame:
    Screen('BeginOpenGL', win);
    
    % Check for keyboard press and exit, if so:
    if KbCheck
        break;
    end
end


% Shut down OpenGL rendering:
Screen('EndOpenGL', win);

% Close onscreen window and release all other ressources:
sca;












