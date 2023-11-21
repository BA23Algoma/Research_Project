function DisplaySingleObject(textureon, dotson, normalson, stereomode)
% function DisplaySingleObject([textureon][, dotson][, normalson][, stereomode])
% DisplaySingleObject -- Displays a single 3D object without morphing.
%
% Options:
%
% textureon = If set to 1, the object will be textured; otherwise, it will be shaded without a texture. Defaults to zero.
% dotson = If set to 0 (default), just show the surface. If set to 1, some dots are plotted to visualize the vertices of the underlying mesh. If set to 2, the mesh itself is superimposed onto the shape. If set to 3 or 4, then the projected vertex 2D coordinates are also visualized in a standard Matlab figure window.
% normalson = If set to 1, then the surface normal vectors will get visualized as small green lines on the surface.
% stereomode = n. For n > 0, this activates stereoscopic rendering. This feature is preliminary and may not work perfectly.
%
% This demo and the OBJ shape were contributed by Dr. Quoc C. Vuong, MPI for Biological Cybernetics, Tuebingen, Germany.

global win; 

% Is the script running in OpenGL Psychtoolbox?
AssertOpenGL;

% Some default settings for rendering flags:
if nargin < 1 || isempty(textureon)
    textureon = 0;  % Turn texture mapping on (1) or off (0).
end

if nargin < 2 || isempty(dotson)
    dotson = 0;     % Turn reference dots: off(0), on (1) or show reference lines (2).
end

if nargin < 3 || isempty(normalson)
    normalson = 0;     % Turn reference dots: off(0), on (1) or show reference lines (2).
end

if nargin < 4 || isempty(stereomode)
    stereomode = 0;
end

% Response keys: Mapping of keycodes to keynames.
KbName('UnifyKeyNames');
closer = KbName('a');
farther = KbName('z');
quitkey = KbName('ESCAPE');

% Load the OBJ:
basepath = [fileparts(which(mfilename)) '/'];
obj = LoadOBJFile([basepath 'Test Files (Banki)/texblob01.obj']);

% Find the screen to use for display:
screenid = max(Screen('Screens'));

% Disable Synctests for this simple demo:
oldskip = Screen('Preference', 'SkipSyncTests', 1);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the mogl OpenGL for Matlab wrapper. We need to do this before the first call to any OpenGL function. Set debug level to zero for faster execution:
InitializeMatlabOpenGL(0, 0);

% Open a double-buffered full-screen window:
rect = [];
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', screenid, 0, rect, [], [], stereomode);

% Setup texture mapping if wanted:
if textureon == 1
    % Load and create face texture in Psychtoolbox:
    texname = [basepath 'TeapotTexture.jpg'];
    texture = imread(texname);
    texid = Screen('MakeTexture', win, texture);
    
    % Retrieve a standard OpenGL texture handle and target from Psychtoolbox for use with MOGL:
    [gltexid, gltextarget, uscale, vscale] = Screen('GetOpenGLTexture', win, texid, size(texture, 1), size(texture, 2));
    
    % Swap (u, v) <-> (v, u) to account for the transposed images read via Matlab imread():
    texcoords(2, :) = obj.texcoords(1, :);
    texcoords(1, :) = 1 - obj.texcoords(2, :);
    
    % Which texture type is provided to us by Psychtoolbox?
    if gltextarget == GL.TEXTURE_2D
        if IsGLES
            texcoords(1, :) = texcoords(1, :) * uscale;
            texcoords(2, :) = texcoords(2, :) * vscale;
        end
    else
        texcoords(1, :) = texcoords(1, :) * size(texture, 1);
        texcoords(2, :) = texcoords(2, :) * size(texture, 2);
    end
end

% Some initial parameters:
ang = 0.0;      % Initial rotation angle
zz = 20.0;      % Initial z-distance of the object
theta = 0;      % Initial rotation angle for the object

% Setup rotation vector for the object:
rotatev = [0 0 1];

% Enable regular keyboard input:
ListenChar(0);

% Retrieve duration of a single monitor flip interval:
ifi = Screen('GetFlipInterval', win);

% Initially sync us to the VBL:
vbl = Screen('Flip', win);

% Animation loop: Run until key press or one minute has elapsed...
t = GetSecs;
while (GetSecs - t) < 60
    % Setup modelview matrix and camera:
    Screen('BeginOpenGL', win);
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    gluLookAt(0, 0, zz, 0, 0, 0, 0, 1, 0);
    
    % Render object:
    drawShape(ang, theta, rotatev, dotson, normalson);
    
    % Finish OpenGL rendering into Psychtoolbox window and check for OpenGL errors:
    Screen('EndOpenGL', win);

    % Tell Psychtoolbox that drawing of this stimulus is finished:
    Screen('DrawingFinished', win);
    
    % Update frame animation:
    theta = mod(theta + 0.1, 360);
    
    % Check for keyboard press:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    if KeyIsDown
        if (KeyIsDown == 1 && KeyCode(closer) == 1)
            zz = zz - 0.1;
            KeyIsDown = 0;
        end
        if (KeyIsDown == 1 && KeyCode(farther) == 1)
            zz = zz + 0.1;
            KeyIsDown = 0;
        end
        if (KeyIsDown == 1 && KeyCode(quitkey) == 1)
            break;
        end
    end
    
    % Show rendered image:
    vbl = Screen('Flip', win, vbl + ifi);
end

vbl = Screen('Flip', win);

% Enable regular keyboard again:
ListenChar(0);

% Re-enable Synctests after this simple demo:
Screen('Preference', 'SkipSyncTests', oldskip);

% Close the onscreen window and release all other resources:
sca;

% Well done!
return;

% drawShape does the actual drawing:
function drawShape(ang, theta, rotatev, dotson, normalson)
% GL needs to be defined as "global" in each subfunction that executes OpenGL commands:
global GL
global win

% Backup modelview matrix:
glPushMatrix;

% Setup rotation around axis:
glRotatef(theta, rotatev(1), rotatev(2), rotatev(3));
glRotatef(ang, 0, 1, 0);

% Scale object by a factor of a:
a = 0.1;
glScalef(a, a, a);

glColor4f(0.8, 0.8, 0.8, 1.0);

% Render the object:
moglmorpher('render');

% Some extra visualization code for normals, mesh, and vertices:
if dotson == 1
    % Draw some dot-markers at positions of vertices:
    % We disable lighting for this purpose:
    glDisable(GL.LIGHTING);
    % From all polygons, only their defining vertices are drawn:
    glPolygonMode(GL.FRONT_AND_BACK, GL.POINT);
    glColor4f(0, 0, 1, 1);

    % Ask morpher to rerender the object:
    moglmorpher('render');

    % Reset settings for object rendering:
    glPolygonMode(GL.FRONT_AND_BACK, GL.FILL);
    glEnable(GL.LIGHTING);
end

if dotson == 2
    % Draw connecting lines to visualize the underlying geometry:
    % We disable lighting for this purpose:
    glDisable(GL.LIGHTING);
    % From all polygons, only their connecting outlines are drawn:
    glColor4f(0, 0, 1, 1);
    glPolygonMode(GL.FRONT_AND_BACK, GL.LINE);

    % Ask morpher to rerender the object:
    moglmorpher('render');

    % Reset settings for object rendering:
    glPolygonMode(GL.FRONT_AND_BACK, GL.FILL);
    glEnable(GL.LIGHTING);
end

if normalson > 0
    % Draw surface normal vectors on top of the object:
    glDisable(GL.LIGHTING);
    % Green is a nice color for this:
    glColor4f(0, 1, 0, 1);

    % Ask morpher to render the normal vectors of the object:
    moglmorpher('renderNormals', normalson);

    % Reset settings for object rendering:
    glEnable(GL.LIGHTING);
    glColor4f(0, 0, 1, 1);
end

% Restore modelview matrix:
glPopMatrix;

% Done, return to the main function:
return;
