%% Micoscope

AZ=actxserver('Nikon.MzMic.NikonMZ');

pause(2)

%%
global AZ
%%
AZ.ZDrive.MoveRelative(3000)

%%
AZ.ZDrive.MoveAbsolute(2500)

%%
AZ.Zoom.Value=5

%%

AZ.Zoom.Value=20

%%
AZ.Zoom.Value=70


%%

position=AZ.Zoom.Value.RawValue;

%%
position=AZ.ZDrive.Value.RawValue;


%%
AZ.release;

