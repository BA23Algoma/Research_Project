function varargout = MazeExpGUI(varargin)
    % MAZEEXPGUI MATLAB code for MazeExpGUI.fig
    %      MAZEEXPGUI, by itself, creates a new MAZEEXPGUI or raises the existing
    %      singleton*.
    %
    %      H = MAZEEXPGUI returns the handle to a new MAZEEXPGUI or the handle to
    %      the existing singleton*.
    %
    %      MAZEEXPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in MAZEEXPGUI.M with the given input arguments.
    %
    %      MAZEEXPGUI('Property','Value',...) creates a new MAZEEXPGUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before MazeExpGUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to MazeExpGUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help MazeExpGUI
    
    % Last Modified by GUIDE v2.5 31-Aug-2023 17:39:30
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @MazeExpGUI_OpeningFcn, ...
        'gui_OutputFcn',  @MazeExpGUI_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
    
end


% --- Executes just before MazeExpGUI is made visible.
function MazeExpGUI_OpeningFcn(hObject, eventdata, handles, varargin)
        
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to MazeExpGUI (see VARARGIN)
    
    % Choose default command line output for MazeExpGUI
    %     handles.output = hObject;
    
    p = varargin{1};
    handles.p = p;
    
    set(handles.participantId,      'string', num2str(p.participantId));
    set(handles.avatarLinearVel,    'string', num2str(p.playerDeltaUnitPerFrame));
    set(handles.avatarRadialVel,    'string', num2str(p.playerDeltaDegPerFrame));
    set(handles.avatarBodyRadius,   'string', num2str(p.playerBodyRadius));
    set(handles.nPracticeTrials,    'string', num2str(p.nPracticeTrials));
    set(handles.nBlocks,            'string', num2str(p.nBlocks));
    set(handles.tourLinearVel,      'string', num2str(p.tourDeltaUnitPerFrame));
    set(handles.tourRadialVel,      'string', num2str(p.tourDeltaDegPerFrame));
    set(handles.frameRate,          'string', num2str(p.frameRate));
    set(handles.perspectiveAngle,   'string', num2str(p.perspectiveAngle));
    set(handles.eyeLevel,           'string', num2str(p.eyeLevel));
    set(handles.coordPollInterval,  'string', num2str(p.coordPollInterval));
    set(handles.coordPollTimeLimit, 'string', num2str(p.coordPollTimeLimit));
    set(handles.screenWidth,        'string', num2str(p.screenWidth));
    set(handles.screenHeight,       'string', num2str(p.screenHeight));
    
    if p.tourHand == 1
        
        set(handles.tourHand, 'SelectedObject', handles.leftHandTourButton);
        handles.tourHand = 1;
        
    elseif p.inputDevice == 2
        
        set(handles.tourHand, 'SelectedObject', handles.rightHandTourButton);
        handles.tourHand = 2;
        
    else
        
        error('Unknown input device button');
        
    end
    
    if p.inputDevice == 1
        
        set(handles.inputDevice, 'SelectedObject', handles.keyboardButton);
        handles.inputDevice = 1;
        
    elseif p.inputDevice == 2
        
        set(handles.inputDevice, 'SelectedObject', handles.joystickButton);
        handles.inputDevice = 2;
        
    else
        
        error('Unknown input device button');
        
    end
    
    if p.viewPoint == 1
        
        set(handles.pov, 'SelectedObject', handles.firstPersonButton);
        handles.viewPoint = 1;
        
    elseif p.inputDevice == 2
        
        set(handles.pov, 'SelectedObject', handles.thirdPersonButton);
        handles.viewPoint = 2;
        
    else
        
        error('Unknown input device button');
        
    end
    
    handles.isExit = 1;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes MazeExpGUI wait for user response (see UIRESUME)
    uiwait(handles.MazeExpGUI, 240);
    
end

% --- Outputs from this function are returned to the command line.
function varargout = MazeExpGUI_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    
    if ~isempty(handles)
        p.participantId                 = str2double(get(handles.participantId, 'string'));
        p.playerDeltaUnitPerFrame       = str2double(get(handles.avatarLinearVel, 'string'));
        p.playerDeltaDegPerFrame        = str2double(get(handles.avatarRadialVel, 'string'));
        p.playerBodyRadius              = str2double(get(handles.avatarBodyRadius, 'string'));
        p.nPracticeTrials               = str2double(get(handles.nPracticeTrials, 'string'));
        p.nBlocks                       = str2double(get(handles.nBlocks, 'string'));
        p.tourDeltaUnitPerFrame         = str2double(get(handles.tourLinearVel, 'string'));
        p.tourDeltaDegPerFrame          = str2double(get(handles.tourRadialVel, 'string'));
        p.frameRate                     = str2double(get(handles.frameRate, 'string'));
        p.perspectiveAngle              = str2double(get(handles.perspectiveAngle, 'string'));
        p.eyeLevel                      = str2double(get(handles.eyeLevel, 'string'));
        p.coordPollInterval             = str2double(get(handles.coordPollInterval, 'string'));
        p.coordPollTimeLimit            = str2double(get(handles.coordPollTimeLimit, 'string'));
        p.screenWidth                   = str2double(get(handles.screenWidth, 'string'));
        p.screenHeight                  = str2double(get(handles.screenHeight, 'string'));
        
        p.inputDevice                   = handles.inputDevice;
        p.tourHand                      = handles.tourHand;
        p.viewPoint                     = handles.viewPoint;
        p.isExit                        = handles.isExit;                
        
        varargout{1} = p;
        
    else
        
        p.isExit = 1;
        varargout{1} = p;
        
    end
    
    delete(hObject);
    
end


% --- Executes during object creation, after setting all properties.
function participantId_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to participantId (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
    % hObject    handle to startButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    handles.isExit = 0;
    guidata(hObject, handles);
    MazeExpGUI_CloseRequestFcn(handles.MazeExpGUI, eventdata, handles);
    
    
end

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
    
    % hObject    handle to cancelButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles.isExit = 1;
    guidata(hObject, handles);
    MazeExpGUI_CloseRequestFcn(handles.MazeExpGUI, eventdata, handles);
    
end

function participantId_Callback(hObject, eventdata, handles)
    % hObject    handle to participantId (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of participantId as text
    %        str2double(get(hObject,'String')) returns contents of participantId as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.participantId));
        
    elseif mod(objectValue, 1)~=0
        
        errordlg('Input must be a integer number','Error');
        set(hObject, 'string', num2str(handles.p.participantId));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end


function tourLinearVel_Callback(hObject, eventdata, handles)
    % hObject    handle to tourLinearVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of tourLinearVel as text
    %        str2double(get(hObject,'String')) returns contents of tourLinearVel as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.tourDeltaUnitPerFrame));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end

% --- Executes during object creation, after setting all properties.
function tourLinearVel_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to tourLinearVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

% --- Executes during object creation, after setting all properties.
function avatarRadialVel_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to tourLinearVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

function avatarRadialVel_Callback(hObject, eventdata, handles)
    % hObject    handle to tourLinearVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of tourLinearVel as text
    %        str2double(get(hObject,'String')) returns contents of tourLinearVel as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.playerDeltaDegPerFrame));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
end

function tourRadialVel_Callback(hObject, eventdata, handles)
    % hObject    handle to tourRadialVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of tourRadialVel as text
    %        str2double(get(hObject,'String')) returns contents of tourRadialVel as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.tourDeltaDegPerFrame));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
end

% --- Executes during object creation, after setting all properties.
function tourRadialVel_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to tourRadialVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

function nPracticeTrials_Callback(hObject, eventdata, handles)
    % hObject    handle to nPracticeTrials (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of nPracticeTrials as text
    %        str2double(get(hObject,'String')) returns contents of nPracticeTrials as a double
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.nPracticeTrials));
        
    elseif mod(objectValue, 1)~=0
        
        errordlg('Input must be a integer number','Error');
        set(hObject, 'string', num2str(handles.p.nPracticeTrials));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
end


% --- Executes during object creation, after setting all properties.
function nPracticeTrials_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to nPracticeTrials (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


function nBlocks_Callback(hObject, eventdata, handles)
    % hObject    handle to nBlocks (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of nBlocks as text
    %        str2double(get(hObject,'String')) returns contents of nBlocks as a double
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.nBlocks));
        
    elseif mod(objectValue, 1)~=0
        
        errordlg('Input must be a integer number','Error');
        set(hObject, 'string', num2str(handles.p.nBlocks));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
    
end


% --- Executes during object creation, after setting all properties.
function nBlocks_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to nBlocks (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

function avatarLinearVel_Callback(hObject, eventdata, handles)
    % hObject    handle to avatarLinearVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of avatarLinearVel as text
    %        str2double(get(hObject,'String')) returns contents of avatarLinearVel as a double
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.playerDeltaUnitPerFrame));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
end

% --- Executes during object creation, after setting all properties.
function avatarLinearVel_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to avatarLinearVel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

function avatarBodyRadius_Callback(hObject, eventdata, handles)
    % hObject    handle to avatarBodyRadius (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of avatarBodyRadius as text
    %        str2double(get(hObject,'String')) returns contents of avatarBodyRadius as a double
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.playerBodyRadius));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end

% --- Executes during object creation, after setting all properties.
function avatarBodyRadius_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to avatarBodyRadius (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes during object deletion, before destroying properties.
function MazeExpGUI_DeleteFcn(hObject, eventdata, handles)
    % hObject    handle to MazeExpGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    delete(hObject);
    
end


% --- Executes when user attempts to close MazeExpGUI.
function MazeExpGUI_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to MazeExpGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    %     % Hint: delete(hObject) closes the figure
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, us UIRESUME
        uiresume(hObject);
        
    else
        %         The GUI is no longer waiting, just close it
        delete(hObject);
    end
    
end


% --- Executes when selected object is changed in inputDevice.
function inputDevice_SelectionChangeFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in inputDevice
    % eventdata  structure with the following fields (see UIBUTTONGROUP)
    %	EventName: string 'SelectionChanged' (read only)
    %	OldValue: handle of the previously selected object or empty if none was selected
    %	NewValue: handle of the currently selected object
    % handles    structure with handles and user data (see GUIDATA)
    
    switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
        
        case 'keyboardButton'
            
            handles.inputDevice = 1;
            
        case 'joystickButton'
            
            handles.inputDevice = 2;
            
    end
    
    guidata(hObject, handles);
    
end


% --- Executes during object creation, after setting all properties.
function tourHand_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to tourHand (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes when selected object is changed in tourHand.
function tourHand_SelectionChangeFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in tourHand
    % eventdata  structure with the following fields (see UIBUTTONGROUP)
    %	EventName: string 'SelectionChanged' (read only)
    %	OldValue: handle of the previously selected object or empty if none was selected
    %	NewValue: handle of the currently selected object
    % handles    structure with handles and user data (see GUIDATA)
    
    switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
        
        case 'leftHandTourButton'
            
            handles.tourHand = 1;
            
        case 'rightHandTourButton'
            
            handles.tourHand = 2;
            
    end
    
    guidata(hObject, handles);
    
end



function frameRate_Callback(hObject, eventdata, handles)
    % hObject    handle to frameRate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of frameRate as text
    %        str2double(get(hObject,'String')) returns contents of frameRate as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.frameRate));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
    
end

% --- Executes during object creation, after setting all properties.
function frameRate_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to frameRate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

function perspectiveAngle_Callback(hObject, eventdata, handles)
    % hObject    handle to perspectiveAngle (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of perspectiveAngle as text
    %        str2double(get(hObject,'String')) returns contents of perspectiveAngle as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.perspectiveAngle));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
end


% --- Executes during object creation, after setting all properties.
function perspectiveAngle_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to perspectiveAngle (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

function eyeLevel_Callback(hObject, eventdata, handles)
    % hObject    handle to eyeLevel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of eyeLevel as text
    %        str2double(get(hObject,'String')) returns
    %        contents of eyeLevel as a doublee
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.eyeLevel));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end


% --- Executes during object creation, after setting all properties.
function eyeLevel_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to eyeLevel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes when selected object is changed in pov.
function pov_SelectionChangeFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in pov
    % eventdata  structure with the following fields (see UIBUTTONGROUP)
    %	EventName: string 'SelectionChanged' (read only)
    %	OldValue: handle of the previously selected object or empty if none was selected
    %	NewValue: handle of the currently selected object
    % handles    structure with handles and user data (see GUIDATA)
    
    switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
        
        case 'firstPersonButton'
            
            handles.viewPoint = 1;
            
        case 'thirdPersonButton'
            
            handles.viewPoint = 2;
            
    end
    
    guidata(hObject, handles);
    
end


% --------------------------------------------------------------------
function inputDevice_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to inputDevice (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
end


function coordPollInterval_Callback(hObject, eventdata, handles)
    % hObject    handle to coordPollInterval (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of coordPollInterval as text
    %        str2double(get(hObject,'String')) returns contents of coordPollInterval as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.coordPollInterval));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end


% --- Executes during object creation, after setting all properties.
function coordPollInterval_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to coordPollInterval (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


function coordPollTimeLimit_Callback(hObject, eventdata, handles)
    % hObject    handle to coordPollTimeLimit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of coordPollTimeLimit as text
    %        str2double(get(hObject,'String')) returns contents of coordPollTimeLimit as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.coordPollTimeLimit));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end


% --- Executes during object creation, after setting all properties.
function coordPollTimeLimit_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to coordPollTimeLimit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function screenWidth_Callback(hObject, eventdata, handles)
    % hObject    handle to screenWidth (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of screenWidth as text
    %        str2double(get(hObject,'String')) returns contents of screenWidth as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.screenWidth));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
end


% --- Executes during object creation, after setting all properties.
function screenWidth_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to screenWidth (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


function screenHeight_Callback(hObject, eventdata, handles)
    % hObject    handle to screenHeight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of screenHeight as text
    %        str2double(get(hObject,'String')) returns contents of screenHeight as a double
    
    objectValue = str2double(get(hObject, 'string'));
    
    if isnan(objectValue)
        
        errordlg('Input must be a number','Error');
        set(hObject, 'string', num2str(handles.p.screenHeight));
        
    else
        
        set(hObject, 'string', num2str(objectValue));
        
    end
    
    
end


% --- Executes during object creation, after setting all properties.
function screenHeight_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to screenHeight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end
