% Author: Patrick Wahrmann
function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 06-Jan-2015 12:48:37
% global leftpictureFileName;
% global leftpicturePathName;
% global rightpictureFileName;
% global rightpicturePathName;
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function density_Callback(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of density as text
%        str2double(get(hObject,'String')) returns contents of density as a double
density = str2double(get(hObject, 'String'));
if isnan(density)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.density = density;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function volume_Callback(hObject, eventdata, handles)
% % hObject    handle to volume (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of volume as text
% %        str2double(get(hObject,'String')) returns contents of volume as a double
% volume = str2double(get(hObject, 'String'));
% if isnan(volume)
%     set(hObject, 'String', 0);
%     errordlg('Input must be a number','Error');
% end
% 
% % Save the new volume value
% handles.metricdata.volume = volume;
% guidata(hObject,handles)

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% define global variables
global rightpictureFileName;
global rightpicturePathName;
global leftpicturePathName;
global leftpictureFileName;
global guiHandle;
guiHandle = handles;
%% create full image paths
leftpictureAbsolutePath = strcat(rightpicturePathName,rightpictureFileName);
rightpictureAbsolutePath = strcat(leftpicturePathName,leftpictureFileName);
%% give the user feedback
set(handles.text17, 'String','Calculating result...');
set(handles.calculate, 'Enable','off');
drawnow; % forces the GUI to redraw
%% read Checkboxes
if(get(handles.checkboxMRS,'Value')==1)
    MRS = true;
else
    MRS = false;
end
if(get(handles.checkboxKeypoints,'Value')==1)
    showKeyp = true;
else
    showKeyp = false;
end
if(get(handles.checkboxMatches,'Value')==1)
    showMatches = true;
else
    showMatches = false;
end
%% call main program
main(leftpictureAbsolutePath,rightpictureAbsolutePath,MRS,showKeyp,showMatches);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.density = 0;
handles.metricdata.volume  = 0;

% set(handles.density, 'String', handles.metricdata.density);
% set(handles.volume,  'String', handles.metricdata.volume);
% set(handles.mass, 'String', 0);
% 
% set(handles.unitgroup, 'SelectedObject', handles.english);
% 
% set(handles.text4, 'String', 'lb/cu.in');
% set(handles.text5, 'String', 'cu.in');
% set(handles.text6, 'String', 'lb');
% 
% % Update handles structure
% guidata(handles.figure1, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rightpicturePathName;
if(rightpicturePathName ~= 0)
    [lfn,lpn] = uigetfile({'*.jpg;*.JPG;*.PNG;*.png;*.JPEG;*.jpeg','Image files (.jpg, .png)'}, 'Select the right Image',rightpicturePathName);
else
[lfn,lpn] = uigetfile({'*.jpg;*.JPG;*.PNG;*.png;*.JPEG;*.jpeg','Image files (.jpg, .png)'}, 'Select the left Image','../pictures/');
end
'File selected:'
global leftpictureFileName;
leftpictureFileName = lfn
global leftpicturePathName;
leftpicturePathName = lpn

if(leftpicturePathName ~= 0)
set(handles.pushbutton9, 'String','Select left image...DONE');
set(handles.pushbutton9, 'BackgroundColor','green');
if(get(handles.pushbutton10, 'BackgroundColor')==[0,1,0])
    set(handles.calculate, 'Enable','on');
end
else
    set(handles.pushbutton9, 'BackgroundColor','white');
    set(handles.pushbutton9, 'String','Select left image');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton9.
function pushbutton9_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global leftpicturePathName;
if(leftpicturePathName ~= 0)
    [rfn,rpn] = uigetfile({'*.jpg;*.JPG;*.PNG;*.png;*.JPEG;*.jpeg','Image files (.jpg, .png)'}, 'Select the right Image',leftpicturePathName);
else
[rfn,rpn] = uigetfile({'*.jpg;*.JPG;*.PNG;*.png;*.JPEG;*.jpeg','Image files (.jpg, .png)'}, 'Select the right Image','../pictures/');
end
'File selected:'
global rightpictureFileName;
rightpictureFileName = rfn
global rightpicturePathName;
rightpicturePathName = rpn
if(rightpicturePathName ~= 0)
    set(handles.pushbutton10, 'BackgroundColor','green');
    set(handles.pushbutton10, 'String','Select right image...DONE');
if(get(handles.pushbutton9, 'BackgroundColor')==[0,1,0])
    set(handles.calculate, 'Enable','on');
end
else
    set(handles.pushbutton10, 'BackgroundColor','white');
    set(handles.pushbutton10, 'String','Select left image');
end

% --- Executes during object creation, after setting all properties.
function text17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkboxMRS.
function checkboxMRS_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxMRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkboxMRS
global MRS;
if(get(hObject,'Value')==1)
    MRS = true;
else
    MRS = false;
end


% --- Executes on button press in checkboxKeypoints.
function checkboxKeypoints_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxKeypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkboxKeypoints
global showKeyp;
if(get(hObject,'Value')==1)
    showKeyp = true;
else
    showKeyp = false;
end

% --- Executes on button press in checkboxMatches.
function checkboxMatches_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxMatches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkboxKeypoints
global showMatches;
if(get(hObject,'Value')==1)
    showMatches = true;
else
    showMatches = false;
end
