function Pipeline_imaging(v1,v2)
global h3
global syr2
global NewMotors
global Steppers


hand = Screening_Platform;
set(findobj(hand,'tag','Pos90'), 'Callback',{@Pos90_Rotation});
set(findobj(hand,'tag','Neg90'), 'Callback',{@Neg90_Rotation});
set(findobj(hand,'tag','Pos25'), 'Callback',{@Pos25_Rotation});
set(findobj(hand,'tag','Neg25'), 'Callback',{@Neg25_Rotation});
set(hand, 'WindowScrollWheelFcn', {@testScrollWheel});
set(findobj(hand,'tag','ImagingR'), 'Callback',{@imagingrun});
set(findobj(hand,'tag','ImagingOn'), 'Callback',{@p_imaging});

set(findobj(hand,'tag','left'), 'Callback',{@leftone});
set(findobj(hand,'tag','right'), 'Callback',{@rightone});
set(findobj(hand,'tag','SyringeOFF'), 'Callback',{@SyringeOFF});
set(findobj(hand,'tag','SyringeON'), 'Callback',{@SyringeON});
set(findobj(hand,'tag','InitialWash'), 'Callback',{@InitialWashX});


set(findobj(hand,'tag','Ocular'), 'Callback',{@Ocular});
set(findobj(hand,'tag','FrontPort'), 'Callback',{@FrontPort});
set(findobj(hand,'tag','RearPort'), 'Callback',{@RearPort});
set(findobj(hand,'tag','EGFP'), 'Callback',{@EGFP});
set(findobj(hand,'tag','Brightfield'), 'Callback',{@Brightfield});
set(findobj(hand,'tag','Empty'), 'Callback',{@Empty});
set(findobj(hand,'tag','DiaON'), 'Callback',{@DiaON});
set(findobj(hand,'tag','DiaOFF'), 'Callback',{@DiaOFF});
set(findobj(hand,'tag','EpiON'), 'Callback',{@EpiON});
set(findobj(hand,'tag','EpiOFF'), 'Callback',{@EpiOFF});


SyringeCOM2                         = 6;
pause(0.05)
syr2= serial(['COM' num2str(SyringeCOM2)],'Terminator','CR');
set(syr2,'timeout',0.5)
fopen(syr2); 
pause(0.1)

NewMotors=1;

if NewMotors
    port='COM8';
    Steppers=serial(port, 'BaudRate',9600, 'Terminator', 'CR');
    fopen(Steppers);
    SpeedCommand = 'SPD 6000, 60000CR';
    fprintf(Steppers, SpeedCommand);
end

h2 = findobj(hand,'tag','ImageAxe')
h3 = image(zeros(320),'parent',h2)
set(h2,'xtick',[],'xticklabelmode','manual','ytick',[],'yticklabelmode','manual')
set(h3,'cdata',255*rand(320))
end

function testScrollWheel(gcf, event_data)
global NewMotors
global Steppers
AngleScrollRatio =   25;
Microstepping = 100;

turn=event_data.VerticalScrollCount;
Direction=(turn<0);
Angle= abs(turn * AngleScrollRatio);

if NewMotors
    NumberofSteps = Angle * Microstepping / 0.72;
    if Direction
        MovementCommand = ['PIC ' num2str(NumberofSteps) ',-' num2str(NumberofSteps) 'CR'];
    else
        MovementCommand = ['PIC -' num2str(NumberofSteps) ',' num2str(NumberofSteps) 'CR'];
    end
    fprintf(Steppers, MovementCommand);
else
    Final_Angle=Step_Motor(Angle,Direction,3,0);
end
end


function p_imaging(v1,v2)
global pp_imaging

pp_imaging=0;

while pp_imaging==0
    load ppimaging pp_imaging
    pause(0.055)

    if pp_imaging==1
        pp_imaging=0;
        save ppimaging pp_imaging
        Imaging_Part
        
        pp_imaging = 1;
    end    
end

end

function Imaging_Part(v1,v2)
global syr2
global pp_unloading

valvesDirections='Dev2/port0';
valve1='00000001';
valve2='00000010';
valve3='00000100';
valve12='00000011';
valve23='00000110';
valve13='00000101';
closeall='00000000';
DistanceFromFOVtoUnloading         ='200';
DistanceFromUnloadingtoWell        ='400'; 
DistanceFromCamaraDetectiontoFOV   ='27';
NumberOfImagesToCalibrateThreshold = 5;
CameraDetectionThreshold           = 0.95;

ProsilicaCamera('initialize')
pause(0.2)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('setExposure', 25)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)

display('Imaging')

WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve1)));
pause(0.05)
fprintf(syr2,'/2v300V150c80Oa3000R')
pause(1.75)
WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve3)));


SumPixels=zeros(1,NumberOfImagesToCalibrateThreshold);
for i=1:NumberOfImagesToCalibrateThreshold;
    img=ProsilicaCamera('singleAcquire');
    SumPixels(i)=sum(img(:));
end
AvgSumPixels=sum(SumPixels)/NumberOfImagesToCalibrateThreshold;
ThresholdSumPixelsValue=CameraDetectionThreshold*AvgSumPixels;

%Conditions until detection
StopLoop=0;
tic
AccumulateValues=zeros(10,1);
j=0;
while ~StopLoop
    j=j+1;
    img=ProsilicaCamera('singleAcquire');
    SumPixelsSingleAcq=sum(img(:));
    AcumulateValues(j)=SumPixelsSingleAcq;
    Time=toc;
    StopLoop=(ThresholdSumPixelsValue > SumPixelsSingleAcq)|Time>10;
end
figure, plot(AcumulateValues);

if Time>10
    display('ERROR, TOO MUCH TIME PASSED AND THE FISH WAS UNDETECTED')
    fprintf(syr2,'/2TR')
    pause(0.1)
    fprintf(syr2,'/2v1000V1600c2000Ea650R')
    pause(0.05)
    pp_unloading=1;
    save ppunload pp_unloading
else
    display('Fish Detected by the Camera')
    fprintf(syr2,'/2TR')
    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve3)));
    pause(0.15)
    fprintf(syr2,'/2v70V70c70OD20R')
    pause(0.5)
    display('Unloading') 
%     WriteDigitalPort(valvesDirections, dec2hex(bin2dec(closeall)));
    pause(0.05)
    pp_unloading=1;
    save ppunload pp_unloading
end

%---------------(Put microscope scanning here)-------------------------

set(findobj(nextimaging,'tag','AutoRotation'), 'Callback',{@AutomationRotation});

%----------------------------------------------------------------------

set(findobj(nextimaging,'tag','NextImaging'), 'Callback',{@image_status});

end

function image_status(v1,v2)
global image_operated
global syr2

image_operated=1;
save imageoperated image_operated

fprintf(syr2,'/2v300V400c400ID600R')
pause(3)
fprintf(syr2,'/2v800V1600c1600Ea150R')
set(nextimaging,'visible','off')
pause(1.5)

Imaging_Part

end

%---------(main code ends here)---------------------

function imagingrun(v1,v2)
global h3
global img
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('setExposure', 25)
ProsilicaCamera('setRegion', 150,370,0,512,2,2)
figure
pause(0.1)

AcumularValores=zeros(10,1);
AcumularTiempos=zeros(10,1);
j=0;
tic    

while 1<2
    j=j+1;
    set(h3,'cdata',img)
    img=ProsilicaCamera('singleAcquire');
    AcumularValores(j)=sum(img(:));
    AcumularTiempos(j)=toc;
    imshow(img)
    pause(0.001)

end

end

function leftone(v1,v2)
global syr2

valvesDirections='Dev2/port0';
valve1='00000001';
valve2='00000010';
valve3='00000100';
valve12='00000011';
valve23='00000110';
valve13='00000101';
closeall='00000000';

WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve1)));

% SyringeCOM2                         = 11;
% pause(0.05)
% syr2= serial(['COM' num2str(SyringeCOM2)],'Terminator','CR');
% set(syr2,'timeout',0.5)
% fopen(syr2); 
% pause(0.1)

fprintf(syr2,'/2v200V200c200IP5R')
pause(0.1)
% fclose(syr2)

pause(0.7)
WriteDigitalPort(valvesDirections, dec2hex(bin2dec(closeall)));

end

function rightone(v1,v2)
global syr2

valvesDirections='Dev2/port0';
valve1='00000001';
valve2='00000010';
valve3='00000100';
valve12='00000011';
valve23='00000110';
valve13='00000101';
closeall='00000000';

WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve1)));

% SyringeCOM2                         = 11;
% pause(0.05)
% syr2= serial(['COM' num2str(SyringeCOM2)],'Terminator','CR');
% set(syr2,'timeout',0.5)
% fopen(syr2); 
% pause(0.1)

fprintf(syr2,'/2v200V200c200ID5R')
pause(0.1)
% fclose(syr2)

pause(0.7)
WriteDigitalPort(valvesDirections, dec2hex(bin2dec(closeall)));

end

function AutomationRotation(v1,v2)

InterfaceableAutomaticRotation

end


function Pos90_Rotation(v1,v2)
Step_Motor(90,1,3,0)
end
function Neg90_Rotation(v1,v2)
Step_Motor(90,0,3,0)
end
function Pos25_Rotation(v1,v2)
Step_Motor(25,1,3,0)
end
function Neg25_Rotation(v1,v2)
Step_Motor(25,0,3,0)
end

function Ocular(v1,v2)
global Microscope
fc
pause(0.05)
Microscope.LightPathDrive.LightPath=1;
pause(0.05)
Microscope.release;
end

function FrontPort(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.LightPathDrive.LightPath=2;
pause(0.05)
Microscope.release;
end

function RearPort(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.LightPathDrive.LightPath=3;
pause(0.05)
Microscope.release;
end

function EGFP(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.FilterBlockCassette.position = 1;
pause(0.05)
Microscope.release;
end

function Brightfield(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.FilterBlockCassette.position = 2;
pause(0.05)
Microscope.release;
end

function Empty(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.FilterBlockCassette.position = 3;
pause(0.05)
Microscope.release;
end

function DiaON(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
LightControl('setintensity',100);
pause(0.05)
Microscope.release;
end

function DiaOFF(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
LightControl('setintensity',0);
pause(0.05)
Microscope.release;
end

function EpiON(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.epiShutter.Open;
pause(0.05)
Microscope.release;
end

function EpiOFF(v1,v2)
global Microscope
Microscope = actxserver('Nikon.IScope.Nikon90i');
pause(0.05)
Microscope.epiShutter.Close;
pause(0.05)
Microscope.release;
end

function SyringeOFF(v1,v2)
global syr
global syr2

% fclose(syr)
pause(0.05)
fclose(syr2)

end

function SyringeON(v1,v2)
global syr
global syr2

% fopen(syr)
fopen(syr2)

end

function InitialWashX(v1,v2)
global syr2

tic

fclose(syr2)
pause(0.1)

Initial_Wash

pause(2)
display('Washed!')

toc
end

