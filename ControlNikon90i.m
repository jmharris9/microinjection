function varargout = ControlNikon90i(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ControlNikon90i_OpeningFcn, ...
                   'gui_OutputFcn',  @ControlNikon90i_OutputFcn, ...
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
function ControlNikon90i_OpeningFcn(hObject, eventdata, handles, varargin)
global Microscope
%LightControl('initialize',10);
Microscope = actxserver('Nikon.IScope.Nikon90i');
handles.output = hObject;
guidata(hObject, handles);
function varargout = ControlNikon90i_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function MoveToOcular_Callback(hObject, eventdata, handles)
global Microscope
Microscope.LightPathDrive.LightPath=1;
function MoveToFront_Callback(hObject, eventdata, handles)
global Microscope
Microscope.LightPathDrive.LightPath=2;
function MoveToRear_Callback(hObject, eventdata, handles)
global Microscope
Microscope.LightPathDrive.LightPath=3;
function FilterNo1_Callback(hObject, eventdata, handles)
global Microscope
Microscope.FilterBlockCassette.position = 1;
function FilterNo2_Callback(hObject, eventdata, handles)
global Microscope
Microscope.FilterBlockCassette.position = 2;
function FilterNo3_Callback(hObject, eventdata, handles)
global Microscope
Microscope.FilterBlockCassette.position = 3;
function DiaOn_Callback(hObject, eventdata, handles)
LightControl('setintensity',100);
function DiaOff_Callback(hObject, eventdata, handles)
LightControl('setintensity',0);
function EpiOn_Callback(hObject, eventdata, handles)
global Microscope
Microscope.epiShutter.Open;
function EpiOff_Callback(hObject, eventdata, handles)
global Microscope
Microscope.epiShutter.Close;
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global Microscope
Microscope.release;
LightControl('uninitialize');
delete(hObject);