function SetMotor(h, SN, ParamSet)

% Start the control
h.StartCtrl;

% Set the serial number
set(h, 'HWSerialNum', SN); 
pause(0.1);

% Identify the device
h.Identify;

% Load the parameters
h.LoadParamSet(ParamSet); 

% h.MoveHome(0,true);

pause(0.1);