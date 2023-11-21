function RenderSingleObjectChatGPT(dotson, normalson)
% function RenderSingleObject([dotson][, normalson])
%
% RenderSingleObject -- Renders a single 3D object loaded from an OBJ file
%
% Control keys and their meaning: 'a' == Zoom out by moving object away
% from viewer. 'z' == Zoom in by moving object close to viewer. 'k' and 'l'
% == Rotate object around axis. 'ESC' == Quit demo.
%
% Options:
%
% dotson = If set to 0 (default), no reference dots or lines are displayed. 
% If set to 1, some dots are plotted to visualize the vertices of the 
% underlying mesh. If set to 2, the mesh itself is superimposed onto the shape.
% If set to 3 or 4, then the projected vertex 2D coordinates are also visualized
% in a standard Matlab figure window.
%
% normalson = If set to 1, then the surface normal vectors will get
% visualized as small green lines on the surface.

morphnormals = 0;
global win;

% Is the script running in OpenGL Psychtoolbox?
AssertOpenGL;

% Response keys: Mapping of keycodes to keynames.
KbName('UnifyKeyNames');
closer = KbName('a');
farther = KbName('z');
quitkey = KbName('ESCAPE');
rotateleft = KbName('l');
rotateright = KbName('k');

% Load OBJ:
basepath = [fileparts(which(mfilename)) '/'];
obj = LoadOBJFile([basepath 'Test Files (Banki)/texblob01.obj']);

% Find the screen to use for display:
screenid = max(Screen('Screens'));

% Disable Synctests for this simple demo:
oldskip = Screen('Preference', 'SkipSyncTests', 2);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper. We need to do this before the first call
% to any OpenGL function. Set debug level to zero -> Faster, but no error checking:
InitializeMatlabOpenGL(0, 0);

% Open a double-buffered full-screen window: Everything is left at default
% settings:
if dotson ~= 3 && dotson ~= 4
    rect = [];
else
    rect = [0 0 500 500];
end;

[win, ~] = Screen('OpenWindow', screenid, 0, rect);

% Setup texture mapping:
gltextarget = GL.TEXTURE_RECTANGLE_EXT;

% Rectangle texture: We need to rescale our texcoords as they are made for
% power-of-two textures, not rectangle textures:
texcoords = obj.texcoords;
texcoords(1, :) = texcoords(1, :) * size(texture, 1);
texcoords(2, :) = texcoords(2, :) * size(texture, 2);

% Reset moglmorpher:
moglmorpher('reset');

% Add the OBJ to moglmorpher for use as a shape:
obj.texcoords = texcoords; % Add modified texture coords.
meshid = moglmorpher('addMesh', obj);

% Setup the OpenGL rendering context of the onscreen window for use by
% OpenGL wrapper. After this command, all following OpenGL commands will
% draw into the onscreen window 'win':
Screen('BeginOpenGL', win);

if dotson == 1
    % Draw some dot-markers at positions of vertices:
    % We disable lighting for this purpose:
    glDisable(GL.LIGHTING);
    % From all polygons, only their defining vertices are drawn:
    glPolygonMode(GL.FRONT_AND_BACK, GL.POINT);

    % Ask morpher to render the last shape:
    moglmorpher('render');

    % Reset settings for shape rendering:
    glPolygonMode(GL.FRONT_AND_BACK, GL.FILL);
    glEnable(GL.LIGHTING);
end;

if dotson == 2
    % Draw connecting lines to visualize the underlying geometry:
    % We disable lighting for this purpose:
    glDisable(GL.LIGHTING);
    % From all polygons, only their connecting outlines are drawn:
    glPolygonMode(GL.FRONT_AND_BACK, GL.LINE);

    % Ask morpher to render the last shape:
    moglmorpher('render');

    % Reset settings for shape rendering:
    glPolygonMode(GL.FRONT_AND_BACK, GL.FILL);
    glEnable(GL.LIGHTING);
end;

if normalson > 0
    % Draw surface normal vectors on top of object:
    glDisable(GL.LIGHTING);
    % Green is a nice color for this:
    glColor3f(0, 1, 0);

    % Ask morpher to render the normal vectors of the shape:
    moglmorpher('renderNormals', normalson);

    % Reset settings for shape rendering:
    glEnable(GL.LIGHTING);
    glColor3f(0, 0, 1);
end;

if dotson == 3 || dotson == 4
   % Compute and retrieve projected screen-space vertex positions:
   vpos = moglmorpher('getVertexPositions', win);
   
   % Plot the projected 2D points into a Matlab figure window:
   vpos(:, 2) = RectHeight(Screen('Rect', win)) - vpos(:, 2);
	plot(vpos(:, 1), vpos(:, 2), '.');
   drawnow;
end;

% Restore OpenGL context:
Screen('EndOpenGL', win);

% Wait for a key press to quit:
while true
    [KeyIsDown, ~, KeyCode] = KbCheck;
    if KeyIsDown && KeyCode(quitkey) == 1
        break;
    end
end

% Reset moglmorpher:
moglmorpher('reset');

% Close onscreen window and release all other resources:
sca;

% Reenable Synctests after this simple demo:
Screen('Preference', 'SkipSyncTests', oldskip);

% Well done!
return
