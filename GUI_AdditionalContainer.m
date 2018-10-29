function varargout = GUI_AdditionalContainer(varargin)
% GUI_ADDITIONALCONTAINER MATLAB code for GUI_AdditionalContainer.fig
%      GUI_ADDITIONALCONTAINER, by itself, creates a new GUI_ADDITIONALCONTAINER or raises the existing
%      singleton*.
%
%      H = GUI_ADDITIONALCONTAINER returns the handle to a new GUI_ADDITIONALCONTAINER or the handle to
%      the existing singleton*.
%
%      GUI_ADDITIONALCONTAINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ADDITIONALCONTAINER.M with the given input arguments.
%
%      GUI_ADDITIONALCONTAINER('Property','Value',...) creates a new GUI_ADDITIONALCONTAINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_AdditionalContainer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_AdditionalContainer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_AdditionalContainer

% Last Modified by GUIDE v2.5 27-Oct-2018 11:22:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_AdditionalContainer_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_AdditionalContainer_OutputFcn, ...
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


% --- Executes just before GUI_AdditionalContainer is made visible.
function GUI_AdditionalContainer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_AdditionalContainer (see VARARGIN)

% Choose default command line output for GUI_AdditionalContainer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_AdditionalContainer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
isParam = evalin('base','exist(''AddOnParam'',''var'') == 1');
if ~isParam
    msgbox('To GUI mo¿na uruchomiæ tylko z poziomu GUI_Passat.','B³¹d','error');
    delete(handles.figure1);
else
    AddOnParam = evalin('base','AddOnParam');
    t = evalin('base','t');
    Fs = evalin('base','Fs');
    switch AddOnParam
        case 1 % rozruch zimnego silnika
            containerTitle = 'Rozruch zimnego silnika';
            file = 'ColdEngineStart.mat';
            timeViewTitle = 'Rozruch zimnego silnika - przebieg czasowy';
            
        case 2 % analiza modalna
            containerTitle = 'Analiza modalna';
            file = 'AnalizaModalna.mat';
            timeViewTitle = 'Analiza modalna - przebieg czasowy';
    end
    
    set(handles.uipanel1_container,'Title',containerTitle);
    set(handles.text1_status,'String','Wczytywanie danych...');
    
    tic;
    load(file);
    passatData = x;
    loadTime = toc;
    set(handles.text1_status,'String',sprintf('Wczytywanie zakoñczone (%.2f s).',loadTime));
    % wykresy
    % przebieg czasowy
    axes(handles.axes1_data_tv);
    plot(t,passatData);
    set(gca,'FontSize',8);
    title(timeViewTitle);
    xlabel('Czas [s]');
    ylabel('Amplituda');
    zoom on;
    xlim([ 0 length(t)/Fs ]);
    
    % FFT
    N = length(passatData);
    df = Fs/N;
    f = 0:df:Fs/2;
    passat_fft = fft(passatData);
    passat_fft = abs(passat_fft);
    passat_fft = passat_fft(1:N/2+1);
    passat_fft = passat_fft/(N/2);
    
    axes(handles.axes2_data_fft);
    plot(f,passat_fft);
    zoom on;
    title('Widmo zarejestrowanego sygna³u');
    xlabel('Czêstotliwoœæ [Hz]');
    ylabel('Amplituda');
    set(gca,'FontSize',8);
    
    % spektrogram
    axes(handles.axes3_data_spectre);
    spectrogram(passatData,[],[],[],Fs);
    zoom on;
    set(gca,'FontSize',8);
end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_AdditionalContainer_OutputFcn(hObject, eventdata, handles) 
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
evalin('base','clear AddOnParam Fs t');
delete(handles.figure1);
