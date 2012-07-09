function APT_interface

%% Start up...
button = questdlg('About to launch the APT window - do not run if another APT window is open.  Do you want to open the APT window?', ...
                  'Launch APT window', 'Yes', 'No', 'No');
if isempty(button)
	return
elseif length(button) == 2
	return
end

%% Parameters
%ParamSet = 'MichaelChang'; % Name of the settings already defined using the APT User program
ParamSet = 'PaulTillberg'; % Name of the settings already defined using the APT User program

%% Create the interface
% Create the figure
fig = figure('Position', [5 35 1272 912], 'HandleVisibility', 'off', 'IntegerHandle', 'off', ...
             'Name', 'APT Interface', 'NumberTitle', 'off', 'DeleteFcn', 'APT_figure_delete_fcn');
         
set(fig, 'Name', ['APT Interface, Handle Number ' num2str(fig, '%2.20f')]);

%% Draw some annotations
annotation(fig, 'line', [0.505, 0.505], [0.05, 0.95])
annotation(fig, 'line', [0.5, 0.5], [0.05, 0.95])
annotation(fig, 'line', [0.495, 0.495], [0.05, 0.95])

%% Create the main control, ActiveX
% Consult the functions actxcontrolselect, actxcontrollist, methodsview
h_Ctrl = actxcontrol('MG17SYSTEM.MG17SystemCtrl.1', [0 0 100 100], fig);

% Start the control
h_Ctrl.StartCtrl;

% Prepare the user data
ud.h_Ctrl = h_Ctrl;
set(fig, 'UserData', ud);


%% Start the motor controls
% Verify the number of motor controls
[temp, num_motor] = h_Ctrl.GetNumHWUnits(8, 0);
if num_motor ~= 8
    fprintf(['Check the number of Motor Controls (Found' num2str(num_motor) ')!\n']);
    return
end

% Get the serial numbers
for count = 1 : 6
    [temp, SN_motor{count}] = h_Ctrl.GetHWSerialNum(6, count - 1, 0); % Get the serial number of the devices
end
SN_motor
% Check to see that these match with:
% 12345678 (Left Pitch Roll), 12345678 (Left X Yaw), 12345678 (Left Y Z)
% 12345678 (Right Pitch Roll), 12345678 (Right X Yaw), 12345678 (Right Y Z)

% Start them up
% Left Pitch and Roll
h_Motor_LPitchRoll = actxcontrol('MGMOTOR.MGMotorCtrl.1', [0 205 300 200], fig);
SetMotor(h_Motor_LPitchRoll, 12345678, ParamSet);

% Left X and Yaw
h_Motor_LXYaw = actxcontrol('MGMOTOR.MGMotorCtrl.1', [300 205 300 200], fig);
SetMotor(h_Motor_LXYaw, 12345678, ParamSet);

% Left Y and Z
h_Motor_LYZ = actxcontrol('MGMOTOR.MGMotorCtrl.1', [0 0 300 200], fig);
SetMotor(h_Motor_LYZ, 12345678, ParamSet);

% Right Pitch and Roll
h_Motor_RPitchRoll = actxcontrol('MGMOTOR.MGMotorCtrl.1', [672 205 300 200], fig);
SetMotor(h_Motor_RPitchRoll, 12345678, ParamSet);

% Right X and Yaw
h_Motor_RXYaw = actxcontrol('MGMOTOR.MGMotorCtrl.1', [972 205 300 200], fig);
SetMotor(h_Motor_RXYaw, 12345678, ParamSet);

% Left Y and Z
h_Motor_RYZ = actxcontrol('MGMOTOR.MGMotorCtrl.1', [672 0 300 200], fig);
SetMotor(h_Motor_RYZ, 12345678, ParamSet);

% Prepare the user data
ud.h_Motor_LPitchRoll = h_Motor_LPitchRoll;
ud.h_Motor_LXYaw = h_Motor_LXYaw;
ud.h_Motor_LYZ = h_Motor_LYZ;

ud.h_Motor_RPitchRoll = h_Motor_RPitchRoll;
ud.h_Motor_RXYaw = h_Motor_RXYaw;
ud.h_Motor_RYZ = h_Motor_RYZ;

set(fig, 'UserData', ud);

%% Notify the user of the figure handle
fprintf(['APT Interface Created, Handle = ' num2str(fig, '%1.20f') '\n']);