function varargout = GUI_ComparisonContainer(varargin)
% GUI_COMPARISONCONTAINER MATLAB code for GUI_ComparisonContainer.fig
%      GUI_COMPARISONCONTAINER, by itself, creates a new GUI_COMPARISONCONTAINER or raises the existing
%      singleton*.
%
%      H = GUI_COMPARISONCONTAINER returns the handle to a new GUI_COMPARISONCONTAINER or the handle to
%      the existing singleton*.
%
%      GUI_COMPARISONCONTAINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_COMPARISONCONTAINER.M with the given input arguments.
%
%      GUI_COMPARISONCONTAINER('Property','Value',...) creates a new GUI_COMPARISONCONTAINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ComparisonContainer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ComparisonContainer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ComparisonContainer

% Last Modified by GUIDE v2.5 27-Oct-2018 19:40:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ComparisonContainer_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ComparisonContainer_OutputFcn, ...
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


% --- Executes just before GUI_ComparisonContainer is made visible.
function GUI_ComparisonContainer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ComparisonContainer (see VARARGIN)

% Choose default command line output for GUI_ComparisonContainer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ComparisonContainer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global fileLUT posMediaLUT stateMediaLUT selectedCriterion selectedOption availableOptions;
% macierz z nazwami plików
fileLUT = { 'ColdEngineStart.mat' 'Pos1_Idle.mat' 'Pos1_1500.mat' 'Pos1_3000.mat' 'Pos1_Nabieg.mat';...
    'Pos2_Start.mat' 'Pos2_Idle.mat' 'Pos2_1500.mat' 'Pos2_3000.mat' 'Pos2_Nabieg.mat';...
    'Pos3_Start.mat' 'Pos3_Idle.mat' 'Pos3_1500.mat' 'Pos3_3000.mat' 'Pos3_Nabieg.mat';...
    'Pos4_Start.mat' 'Pos4_Idle.mat' 'Pos4_1500.mat' 'Pos4_3000.mat' 'Pos4_Nabieg.mat' };
posMediaLUT = { 'Pos1_Blok.jpg' 'Pos2_Uchwyt.jpg' 'Pos3_Poduszka.jpg' 'Pos4_Karoseria.jpg' };
stateMediaLUT = { 'null.jpg' 'State_Idle.jpg' 'State_1500RPM.jpg' 'State_3000RPM.jpg' 'null.jpg' };

selectedCriterion = 1;
selectedOption = 1;
availableOptions = { 'Zap³on', 'Bieg ja³owy (~900 RPM)', '1500 RPM', '3000 RPM', 'Nabieg' };


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ComparisonContainer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1_exit.
function pushbutton1_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);

% --- Executes on selection change in popupmenu1_list.
function popupmenu1_list_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1_list
global selectedOption;
selectedOption = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function popupmenu1_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global availableOptions selectedOption;
set(hObject,'String',availableOptions);
set(hObject,'Value',selectedOption);

% --- Executes on button press in pushbutton2_compare.
function pushbutton2_compare_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedCriterion selectedOption fileLUT posMediaLUT stateMediaLUT;
% formu³a do wyliczania indeksu macierzy wczytywanych plików
comparedData = selectedCriterion + selectedOption + 4*(selectedCriterion-1)-1;

dataAmount = 3+selectedCriterion;
Fs = 25000;
t = 1/Fs:1/Fs:5;
signals = zeros(dataAmount,125000);
plotRows = zeros(1,dataAmount);
for i = 1:dataAmount
    plotRows(i) = i;
end

switch comparedData
    case 1 % Stan -> Zap³on
        set(handles.text2_criterion,'String','Zap³on silnika');
        varRowNumber = true;
        columnNumber = 1;
        loadMedia = stateMediaLUT{1};
        
    case 2 % Stan -> Ja³owy
        set(handles.text2_criterion,'String','Bieg ja³owy (~900 RPM)');
        varRowNumber = true;
        columnNumber = 2;
        loadMedia = stateMediaLUT{2};
        
    case 3 % Stan -> 1500 RPM
        set(handles.text2_criterion,'String','1500 RPM');
        varRowNumber = true;
        columnNumber = 3;
        loadMedia = stateMediaLUT{3};
        
    case 4 % Stan -> 3000 RPM
        set(handles.text2_criterion,'String','3000 RPM');
        varRowNumber = true;
        columnNumber = 4;
        loadMedia = stateMediaLUT{4};
        
    case 5 % Stan -> Nabieg
        set(handles.text2_criterion,'String','Nabieg silnika');
        varRowNumber = true;
        columnNumber = 5;
        loadMedia = stateMediaLUT{5};
        
    case 6 % Punkt pomiarowy -> Blok silnika
        set(handles.text2_criterion,'String','Blok silnika');
        varRowNumber = false;
        rowNumber = 1;
        loadMedia = posMediaLUT{1};
        
    case 7 % Punkt pomiarowy -> Uchwyt silnika
        set(handles.text2_criterion,'String','Uchwyt silnika');
        varRowNumber = false;
        rowNumber = 2;
        loadMedia = posMediaLUT{2};
        
    case 8 % Punkt pomiarowy -> Za poduszk¹
        set(handles.text2_criterion,'String','Za poduszk¹');
        varRowNumber = false;
        rowNumber = 3;
        loadMedia = posMediaLUT{3};
        
    case 9 % Punkt pomiarowy -> Karoseria
        set(handles.text2_criterion,'String','Karoseria');
        varRowNumber = false;
        rowNumber = 4;
        loadMedia = posMediaLUT{4};
end

axes(handles.axes2_criterion_image);
imshow(loadMedia);

tic;
for i = 1:dataAmount
    statusBar = sprintf('Wczytywanie pliku %d z %d...',i,dataAmount);
    set(handles.text1_status,'String',statusBar);
    pause(0.01);
    if varRowNumber
%         tmpData = importfile(fileLUT{i,columnNumber});
        load(fileLUT{i,columnNumber});
    else
%         tmpData = importfile(fileLUT{rowNumber,i});
        load(fileLUT{rowNumber,i});
    end
    signals(i,:) = x;
end
loadTime = toc;
statusBar = sprintf('Wczytywanie zakoñczone (%.2f s).',loadTime);
set(handles.text1_status,'String',statusBar);

% najgorsza rzecz pod s³oñcem
pause(0.5);
set(handles.text1_status,'String','Generowanie wykresu...');
pause(0.05);
tic;
axes(handles.axes1_data_comparison);
waterfall(t,plotRows,signals);
zoom on;
genData = toc;
statusBar = sprintf('Wykres wygenerowany (%.2f s).',genData);
set(handles.text1_status,'String',statusBar);

% --- Executes when selected object is changed in uibuttongroup1_data_group.
function uibuttongroup1_data_group_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1_data_group 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedCriterion selectedOption;
isChangedFromPointToState = false;

switch eventdata.NewValue
    case handles.radiobutton1_state % stan pojazdu
        selectedCriterion = 1;
        availableOptions = { 'Zap³on', 'Bieg ja³owy (~900 RPM)', '1500 RPM', '3000 RPM', 'Nabieg' };
    case handles.radiobutton2_point % punkt pomiarowy
        selectedCriterion = 2;
        availableOptions = { 'Blok silnika', 'Uchwyt silnika', 'Za poduszk¹', 'Karoseria' };
        if selectedOption > 4 % prze³¹czanie punkt pomiarowy -> stan pojazdu
            selectedOption = 1;
            isChangedFromPointToState = true;
        end
end
handles.popupmenu1_list.String = availableOptions;
if isChangedFromPointToState
    handles.popupmenu1_list.Value = 1;
end