function varargout = A_Star_Search_Algorithm(varargin)
% A_STAR_SEARCH_ALGORITHM MATLAB code for A_Star_Search_Algorithm.fig
%      A_STAR_SEARCH_ALGORITHM, by itself, creates a new A_STAR_SEARCH_ALGORITHM or raises the existing
%      singleton*.
%
%      H = A_STAR_SEARCH_ALGORITHM returns the handle to a new A_STAR_SEARCH_ALGORITHM or the handle to
%      the existing singleton*.
%
%      A_STAR_SEARCH_ALGORITHM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in A_STAR_SEARCH_ALGORITHM.M with the given input arguments.
%
%      A_STAR_SEARCH_ALGORITHM('Property','Value',...) creates a new A_STAR_SEARCH_ALGORITHM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before A_Star_Search_Algorithm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to A_Star_Search_Algorithm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help A_Star_Search_Algorithm

% Last Modified by GUIDE v2.5 13-Dec-2013 21:55:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @A_Star_Search_Algorithm_OpeningFcn, ...
                   'gui_OutputFcn',  @A_Star_Search_Algorithm_OutputFcn, ...
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


% --- Executes just before A_Star_Search_Algorithm is made visible.
function A_Star_Search_Algorithm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to A_Star_Search_Algorithm (see VARARGIN)

% Choose default command line output for A_Star_Search_Algorithm
handles.output = hObject;
global grid;
% Update handles structure
guidata(hObject, handles);
[grid]=A_Star_Init();


% UIWAIT makes A_Star_Search_Algorithm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = A_Star_Search_Algorithm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StartSearch.
function StartSearch_Callback(hObject, eventdata, handles)
% hObject    handle to StartSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global grid; global init; global goal; global PathTake;

startX= get(handles.startX,'String');
startX=str2double(startX);
startY= get(handles.startY,'String');
startY=str2double(startY);
init=[startY,startX];
goalX= get(handles.goalX,'String');
goalX=str2double(goalX);
goalY= get(handles.goalY,'String');
goalY=str2double(goalY);
goal=[goalY,goalX];

if(grid(init(1),init(2)))
   h=text(0,10,strcat('Obstacle; Change Start Location'));
   set(h, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 19, 'Color', 'black'); 
   OkS=0;
else
   OkS=1;
end

if(grid(goal(1),goal(2)))
   h=text(0,20,strcat('Obstacle; Change Goal Location'));
   set(h, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 19, 'Color', 'black');
   OkG=0;
else
   OkG=1;
end

if(OkS && OkG)%search only if needed
    text(init(2)-1,init(1),strcat('Start'));
    text(goal(2),goal(1),strcat('GOAL'));
    [PathTake,Found]=A_Star_Search(grid,init,goal);
else
    Found=0;
end

if(~Found)
    h=text(0,30,strcat('NO PATH FOUND; GOAL CANNOT BE REACHED'));
    set(h, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 19, 'Color', 'black');
end


% --- Executes on button press in EditGrid.
function EditGrid_Callback(hObject, eventdata, handles)
% hObject    handle to EditGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit NewGrid; %to edit the m file for changing the Grid


function SmoothFactor_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SmoothFactor as text
%        str2double(get(hObject,'String')) returns contents of SmoothFactor as a double




% --- Executes during object creation, after setting all properties.
function SmoothFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SmoothFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in SmoothPath.
function SmoothPath_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global grid; global PathTake; 
SmoothFactor= get(handles.SmoothFactor,'String');
SmoothFactor=str2double(SmoothFactor);
SmoothPath(PathTake,size(grid), SmoothFactor);


% --- Executes on button press in ClearAll.
function ClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla();
global grid;
[grid]=A_Star_Init();


% --- Executes on button press in UpdateGrid.
function UpdateGrid_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
global grid;
[grid]=A_Star_Init();



function startX_Callback(hObject, eventdata, handles)
% hObject    handle to startX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startX as text
%        str2double(get(hObject,'String')) returns contents of startX as a double


% --- Executes during object creation, after setting all properties.
function startX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startY_Callback(hObject, eventdata, handles)
% hObject    handle to startY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startY as text
%        str2double(get(hObject,'String')) returns contents of startY as a double


% --- Executes during object creation, after setting all properties.
function startY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function goalX_Callback(hObject, eventdata, handles)
% hObject    handle to goalX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of goalX as text
%        str2double(get(hObject,'String')) returns contents of goalX as a double



% --- Executes during object creation, after setting all properties.
function goalX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goalX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function goalY_Callback(hObject, eventdata, handles)
% hObject    handle to goalY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of goalY as text
%        str2double(get(hObject,'String')) returns contents of goalY as a double


% --- Executes during object creation, after setting all properties.
function goalY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goalY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
