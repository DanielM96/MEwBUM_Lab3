function varargout = GUI_Passat(varargin)
% GUI_PASSAT MATLAB code for GUI_Passat.fig
%      GUI_PASSAT, by itself, creates a new GUI_PASSAT or raises the existing
%      singleton*.
%
%      H = GUI_PASSAT returns the handle to a new GUI_PASSAT or the handle to
%      the existing singleton*.
%
%      GUI_PASSAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PASSAT.M with the given input arguments.
%
%      GUI_PASSAT('Property','Value',...) creates a new GUI_PASSAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Passat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Passat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Passat

% Last Modified by GUIDE v2.5 27-Oct-2018 18:09:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Passat_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Passat_OutputFcn, ...
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


% --- Executes just before GUI_Passat is made visible.
function GUI_Passat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Passat (see VARARGIN)

% Choose default command line output for GUI_Passat
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Passat wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global Fs t fileLUT posMediaLUT stateMediaLUT selectedState selectedPoint;
evalin('base','clear; clc');
Fs = 25000;
t = 1/Fs:1/Fs:5;

fileLUT = { 'ColdEngineStart.mat' 'Pos1_Idle.mat' 'Pos1_1500.mat' 'Pos1_3000.mat' 'Pos1_Nabieg.mat';...
    'Pos2_Start.mat' 'Pos2_Idle.mat' 'Pos2_1500.mat' 'Pos2_3000.mat' 'Pos2_Nabieg.mat';...
    'Pos3_Start.mat' 'Pos3_Idle.mat' 'Pos3_1500.mat' 'Pos3_3000.mat' 'Pos3_Nabieg.mat';...
    'Pos4_Start.mat' 'Pos4_Idle.mat' 'Pos4_1500.mat' 'Pos4_3000.mat' 'Pos4_Nabieg.mat' };

posMediaLUT = { 'Pos1_Blok.jpg' 'Pos2_Uchwyt.jpg' 'Pos3_Poduszka.jpg' 'Pos4_Karoseria.jpg' };
stateMediaLUT = { 'null.jpg' 'State_Idle.jpg' 'State_1500RPM.jpg' 'State_3000RPM.jpg' 'null.jpg' };
selectedState = 1;
selectedPoint = 1;

% --- Outputs from this function are returned to the command line.
function varargout = GUI_Passat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1_load_data.
function pushbutton1_load_data_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1_load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wczytywanie pliku z danymi
global passatData Fs t fileLUT posMediaLUT stateMediaLUT selectedPoint selectedState;
set(handles.text1_gui_state,'String','Wczytywanie danych...');
axes(handles.axes1_image_point);
imshow(posMediaLUT{selectedPoint});
axes(handles.axes2_image_state);
imshow(stateMediaLUT{selectedState});
% dataFile = uigetfile('*.csv','Wczytaj plik z danymi');
tic;
% passatData = importfile(dataFile);
% wczytywanie MAT
currentMat = fileLUT{selectedPoint,selectedState};
load(currentMat);
passatData = x;
loadTime = toc;
set(handles.text1_gui_state,'String',sprintf('Wczytywanie zakoñczone (%.2f s).',loadTime));

%% wykreœlanie danych

% przebieg czasowy
axes(handles.axes3_data_tv);
plot(t,passatData);
set(gca,'FontSize',8);
title('Przebieg czasowy');
xlabel('Czas [s]');
ylabel('Amplituda');
zoom on;

% FFT
N = length(passatData);
df = Fs/N;
f = 0:df:Fs/2;
passat_fft = fft(passatData);
passat_fft = abs(passat_fft);
passat_fft = passat_fft(1:N/2+1);
passat_fft = passat_fft/(N/2);

axes(handles.axes4_data_fft);
plot(f,passat_fft);
zoom on;
title('Widmo zarejestrowanego sygna³u');
xlabel('Czêstotliwoœæ [Hz]');
ylabel('Amplituda');
set(gca,'FontSize',8);

% spektrogram
axes(handles.axes5_data_spectre);
spectrogram(passatData,[],[],[],Fs);
zoom on;
set(gca,'FontSize',8);

% --- Executes on selection change in popupmenu2_state.
function popupmenu2_state_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2_state contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2_state
global selectedState;
selectedState = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function popupmenu2_state_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global selectedState;
set(hObject,'Value',selectedState);

% --- Executes on selection change in popupmenu1_point.
function popupmenu1_point_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1_point contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1_point
global selectedPoint;
selectedPoint = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function popupmenu1_point_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global selectedPoint;
set(hObject,'Value',selectedPoint);

% --------------------------------------------------------------------
function Menu_Compare_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Addons_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Addons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Matlab_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
doc;

% --------------------------------------------------------------------
function Help_AboutPassat_Callback(hObject, eventdata, handles)
% hObject    handle to Help_AboutPassat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_AboutPassatContainer;

% --------------------------------------------------------------------
function Help_AboutGUI_Callback(hObject, eventdata, handles)
% hObject    handle to Help_AboutGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'GUI_Passat','','Funkcje: ','',...
    '- wczytywanie danych pomiarowych,',...
    '- wyœwietlanie odpowiednich wykresów dla ró¿nych przypadków,',...
    '- porównywanie danych dla grupy przypadków,',...
    '- dodatkowe dane: rozruch zimnego silnika, analiza modalna,',...
    '- informacje o Passacie.',''},'GUI_Passat - informacje','help');

% --------------------------------------------------------------------
function Addons_ColdStart_Callback(hObject, eventdata, handles)
% hObject    handle to Addons_ColdStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs t;
assignin('base','AddOnParam',1); % 1 = rozruch zimnego silnika
assignin('base','t',t);
assignin('base','Fs',Fs);
GUI_AdditionalContainer;

% --------------------------------------------------------------------
function Addons_Modal_Callback(hObject, eventdata, handles)
% hObject    handle to Addons_Modal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs;
t = 1/Fs:1/Fs:20;
assignin('base','AddOnParam',2); % 2 = analiza modalna
assignin('base','t',t);
assignin('base','Fs',Fs);
GUI_AdditionalContainer;

% --------------------------------------------------------------------
function Compare_Measurements_Callback(hObject, eventdata, handles)
% hObject    handle to Compare_Measurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_ComparisonContainer;

% --- Executes on button press in pushbutton2_exit.
function pushbutton2_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
