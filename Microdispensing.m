function varargout = Microdispensing(varargin)
% MICRODISPENSING M-file for Microdispensing.fig
%      MICRODISPENSING, by itself, creates a new MICRODISPENSING or raises the existing
%      singleton*.
%
%      H = MICRODISPENSING returns the handle to a new MICRODISPENSING or the handle to
%      the existing singleton*.
%
%      MICRODISPENSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICRODISPENSING.M with the given input arguments.
%
%      MICRODISPENSING('Property','Value',...) creates a new MICRODISPENSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Microdispensing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Microdispensing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Microdispensing

% Last Modified by GUIDE v2.5 14-Jan-2012 12:49:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Microdispensing_OpeningFcn, ...
                   'gui_OutputFcn',  @Microdispensing_OutputFcn, ...
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


% --- Executes just before Microdispensing is made visible.
function Microdispensing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Microdispensing (see VARARGIN)

% Choose default command line output for Microdispensing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Microdispensing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Microdispensing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in NextFish.
function NextFish_Callback(hObject, eventdata, handles)
% hObject    handle to NextFish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ClosePort.
function ClosePort_Callback(hObject, eventdata, handles)
% hObject    handle to ClosePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ColumnArray.
function ColumnArray_Callback(hObject, eventdata, handles)
% hObject    handle to ColumnArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in WholeArray.
function WholeArray_Callback(hObject, eventdata, handles)
% hObject    handle to WholeArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in NextWell.
function NextWell_Callback(hObject, eventdata, handles)
% hObject    handle to NextWell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SetZero.
function SetZero_Callback(hObject, eventdata, handles)
% hObject    handle to SetZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FocusZoom.
function FocusZoom_Callback(hObject, eventdata, handles)
% hObject    handle to FocusZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in HotWash.
function HotWash_Callback(hObject, eventdata, handles)
% hObject    handle to HotWash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function RowX_Callback(hObject, eventdata, handles)
% hObject    handle to RowX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RowX as text
%        str2double(get(hObject,'String')) returns contents of RowX as a double


% --- Executes during object creation, after setting all properties.
function RowX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RowX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ColumnX_Callback(hObject, eventdata, handles)
% hObject    handle to ColumnX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ColumnX as text
%        str2double(get(hObject,'String')) returns contents of ColumnX as a double


% --- Executes during object creation, after setting all properties.
function ColumnX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColumnX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GoPreview.
function GoPreview_Callback(hObject, eventdata, handles)
% hObject    handle to GoPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlateHoming.
function PlateHoming_Callback(hObject, eventdata, handles)
% hObject    handle to PlateHoming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in TheNextWell.
function TheNextWell_Callback(hObject, eventdata, handles)
% hObject    handle to TheNextWell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ResetPlate.
function ResetPlate_Callback(hObject, eventdata, handles)
% hObject    handle to ResetPlate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StopPre.
function StopPre_Callback(hObject, eventdata, handles)
% hObject    handle to StopPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Find_the_Head.
function Find_the_Head_Callback(hObject, eventdata, handles)
% hObject    handle to Find_the_Head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Focusing.
function Focusing_Callback(hObject, eventdata, handles)
% hObject    handle to Focusing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Poke_the_Head.
function Poke_the_Head_Callback(hObject, eventdata, handles)
% hObject    handle to Poke_the_Head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Reset_Inj_Position.
function Reset_Inj_Position_Callback(hObject, eventdata, handles)
% hObject    handle to Reset_Inj_Position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in To_Manual.
function To_Manual_Callback(hObject, eventdata, handles)
% hObject    handle to To_Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in To_Remote.
function To_Remote_Callback(hObject, eventdata, handles)
% hObject    handle to To_Remote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in To_Inj_Zero.
function To_Inj_Zero_Callback(hObject, eventdata, handles)
% hObject    handle to To_Inj_Zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Video_take.
function Video_take_Callback(hObject, eventdata, handles)
% hObject    handle to Video_take (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Video_off.
function Video_off_Callback(hObject, eventdata, handles)
% hObject    handle to Video_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Video_convert.
function Video_convert_Callback(hObject, eventdata, handles)
% hObject    handle to Video_convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Load_Front.
function Load_Front_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Front (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Unload_Front.
function Unload_Front_Callback(hObject, eventdata, handles)
% hObject    handle to Unload_Front (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Set_Z.
function Set_Z_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Reagent_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to Reagent_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reagent_Pos as text
%        str2double(get(hObject,'String')) returns contents of Reagent_Pos as a double


% --- Executes during object creation, after setting all properties.
function Reagent_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reagent_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Water_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to Water_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Water_Pos as text
%        str2double(get(hObject,'String')) returns contents of Water_Pos as a double


% --- Executes during object creation, after setting all properties.
function Water_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Water_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Zoom_back.
function Zoom_back_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Run_Auto.
function Run_Auto_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in default_AZ.
function default_AZ_Callback(hObject, eventdata, handles)
% hObject    handle to default_AZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Focus_Needle.
function Focus_Needle_Callback(hObject, eventdata, handles)
% hObject    handle to Focus_Needle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Inject_Initialize.
function Inject_Initialize_Callback(hObject, eventdata, handles)
% hObject    handle to Inject_Initialize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ctrl_needle_keyboard.
function ctrl_needle_keyboard_Callback(hObject, eventdata, handles)
% hObject    handle to ctrl_needle_keyboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function needle_step_semi_Callback(hObject, eventdata, handles)
% hObject    handle to needle_step_semi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of needle_step_semi as text
%        str2double(get(hObject,'String')) returns contents of needle_step_semi as a double


% --- Executes during object creation, after setting all properties.
function needle_step_semi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to needle_step_semi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
