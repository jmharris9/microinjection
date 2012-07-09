%% NI DAQ for photodetector

global Photodetector
% Photodetector
Photodetector=analoginput('nidaq','Dev1');
set(Photodetector,'InputType','Differential');
set(Photodetector,'SampleRate',2000)
set(Photodetector,'SamplesPerTrigger',50)
set(Photodetector,'TriggerType','Manual')
ch=addchannel(Photodetector,0);
set(Photodetector,'TriggerFcn',{@FishPhotodetected})
set(Photodetector,'TriggerChannel',ch)
set(Photodetector,'TriggerType','Software')
set(Photodetector,'TriggerCondition','Falling')
set(Photodetector,'TriggerConditionValue',0.7)
%We start the Photodetector`
start(Photodetector)


function FishPhotodetected(v1,v2)
global IsLoadingCompleted
global syr
global Photodetector

display('Fish Detected by the PD')
all=getdata(Photodetector);
stop (Photodetector)
delete (Photodetector)
clear Photodetector
fprintf(syr,'/1TR')
pause(0.1)
fprintf(syr,'/1ZR')
pause(0.1)
fclose(syr)
% Move the MULTIWELL PLATE
%WellSelector(1, well)

IsLoadingCompleted=1;


end


%% Syringe pump

SyringeCOM=12;

syr= serial(['COM' num2str(SyringeCOM)],'Terminator','CR');
set(syr,'timeout',0.5)
fopen(syr);
pause(0.5)

fprintf(syr,'/1ZR');
pause(3.5)








