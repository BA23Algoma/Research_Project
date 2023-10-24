function SkyboxDemo
    % Initialize Psychtoolbox and open a window
    screenid = 0;
    InitializeMatlabOpenGL(1);
    [win, winRect] = Screen('OpenWindow', screenid);

    % Begin OpenGL rendering
    Screen('BeginOpenGL', win);

    % Enable texturing
    glEnable(GL_TEXTURE_2D);

    % Create texture names
    texname = glGenTextures(6);

    % Define file paths to your skybox images
    imageFiles = {'C:\Users\olude\Desktop\Research Project\Research_Project\Textures\skybox_top.jpg',...
        'C:\Users\olude\Desktop\Research Project\Research_Project\Textures\skybox_ground.jpg',...
        'C:\Users\olude\Desktop\Research Project\Research_Project\Textures\skybox_left.jpg',...
        'C:\Users\olude\Desktop\Research Project\Research_Project\Textures\skybox_right.jpg',...
        'C:\Users\olude\Desktop\Research Project\Research_Project\Textures\skybox_front.jpg',...
        'C:\Users\olude\Desktop\Research Project\Research_Project\Textures\skybox_back.jpg'
    };

    % Load and bind textures
    for i = 1:6
        glBindTexture(GL_TEXTURE_2D, texname(i));
        image = imread(imageFiles{i});
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, size(image, 2), size(image, 1), 0, GL_RGB, GL_UNSIGNED_BYTE, image);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    end

    % Set up camera and projection matrix (you can adjust these as needed)
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    ar = winRect(4) / winRect(3);
    gluPerspective(60, ar, 0.1, 100);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity;
    gluLookAt(0, 0, 0, 0, 0, -1, 0, 1, 0);

    % Rendering loop
    while ~KbCheck
        % Clear the buffer
        glClear;

        % Render the skybox
        drawSkybox(texname);

        % End OpenGL rendering and display the scene
        Screen('EndOpenGL', win);
        Screen('Flip', win);
        Screen('BeginOpenGL', win);
    end

    % Clean up
    glDeleteTextures(6, texname);
    Screen('EndOpenGL', win);
    sca;
end

function drawSkybox(texname)
    glBegin(GL_QUADS);
    
    % Draw the front face
    glBindTexture(GL_TEXTURE_2D, texname(5));
    glTexCoord2f(0, 0);
    glVertex3f(-1, -1, -1);
    glTexCoord2f(1, 0);
    glVertex3f(1, -1, -1);
    glTexCoord2f(1, 1);
    glVertex3f(1, 1, -1);
    glTexCoord2f(0, 1);
    glVertex3f(-1, 1, -1);

    % Repeat similar code for the other five faces (up, down, left, right, back)

    glEnd();
end
