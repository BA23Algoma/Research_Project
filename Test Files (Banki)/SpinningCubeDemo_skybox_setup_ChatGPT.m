function SpinningCubeDemo_skybox_setup_ChatGPT

    AssertOpenGL;

    % Find the screen to use for display:
    screenid = 0;

    % Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
    % mogl OpenGL for Matlab wrapper:
    InitializeMatlabOpenGL(1);

    % Open a double-buffered full-screen window on the main display's screen.
    [win, winRect] = Screen('OpenWindow', screenid);

    %Generate 6 textures
    cubeMapText = glGenTextures(6);

    % Load cube map images
    cubeMapImages = cell(6, 1);
    for face = 0:5
        cubeMapImages{face + 1} = imread(['cube_map_' num2str(face) '.jpg']);
        
        % Enable i'th texture by binding it:
        glBindTexture(GL_TEXTURE_2D,cubeMapText(face));

        % Assign image in matrix 'tx' to i'th texture:
        glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,256,256,0,GL_RGB,GL_UNSIGNED_BYTE,);
        % Setup texture wrapping behaviour:
        glTexParameterfv(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
        glTexParameterfv(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
        % Setup filtering for the textures:
        glTexParameterfv(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
        glTexParameterfv(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
        % Choose texture application function: It shall modulate the light
        % reflection properties of the the cubes face:
        glTexEnvfv(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
    end

    % Start OpenGL rendering
    Screen('BeginOpenGL', win);

    % Set up OpenGL
    glClearColor(0, 0, 0, 0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, [0.33 0.22 0.03 1]);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, [0.78 0.57 0.11 1]);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, 27.8);

    % Define the projection matrix
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    ar = winRect(4) / winRect(3);
    gluPerspective(25, 1 / ar, 0.1, 100);

    % Define the modelview matrix
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity;
    gluLookAt(3, 3, 5, 0, 0, 0, 0, 1, 0);

    % Initialize rotation
    theta = 0;
    rotatev = [0 0 1];

    % Animation loop
    while true
        %theta = mod(theta + 0.3, 360);
        %rotatev = rotatev + 0.1 * [sin(deg2rad(theta)), sin(deg2rad(2 * theta)), sin(deg2rad(theta / 5))];
        %rotatev = rotatev / norm(rotatev);

        glPushMatrix;
        %glRotatef(theta, rotatev(1), rotatev(2), rotatev(3));
        glClear;
        
        for face = 0:5
              v = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1]' - 0.5;
                i = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
            
              glBindTexture(GL.TEXTURE_2D, cubeMapImages{face + 1});
              glEnable(GL_TEXTURE_2D);
                
                for j = 1:6
                    glBegin(GL.QUADS);
                    n = cross(v(:, i(j, 2)) - v(:, i(j, 1)), v(:, i(j, 3)) - v(:, i(j, 2)));
                    glNormal3f(n(1), n(2), n(3));
                    for k = 1:4
                        glTexCoord2f(k == 1 || k == 4, k == 1 || k == 2);
                        glVertex3f(v(1, i(j, k)), v(2, i(j, k)), v(3, i(j, k)));
                    end
                    glEnd;
                end
        end

        glPopMatrix;
        Screen('EndOpenGL', win);
        Screen('Flip', win);

        % Switch to OpenGL rendering again for drawing of next frame:
        Screen('BeginOpenGL', win);
        
        if KbCheck
            break;
        end
    end

    % Clean up
    Screen('EndOpenGL', win);
    sca;
end

