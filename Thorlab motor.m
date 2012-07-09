%%
%load APT
fig = figure('Position',[5 35 1272 912],'HandleVisibility','off','IntegerHandle','off');
h = actxcontrol('MGMOTOR.MGMotorCtrl.1', [0 205 300 200], fig);
%%
% serial number input
h.HWSerialNum = 83828180;

%%
%start
h.StartCtrl

%%
h.Identify

%%

h.MoveAbsoluteEnc(0,5,6,5000,1)
pause(3.5)

%%
h.MoveAbsoluteEnc(0,12,6,5000,1)

%%
h.StopCtrl


%%