function Microdispensor (v1,v2)

delete(instrfind)
close all;
clear all;
clc

global syr
global h
global Photodetector
global FirstTime
global fig
global AZ
global XYStage
global RowX
global ColumnX
global Water_Pos
global Reagent_Pos
global needle_step_semiauto

global FocusorZoom
global Mani

ManipulatorCOM = 15;
Mani= serial(['COM' num2str(ManipulatorCOM)],'Terminator','CR');
set(Mani,'timeout',0.5)
set(Mani, 'BaudRate', 19200)
fopen(Mani);
pause(0.5)

SyringeCOM=12;
valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

waiting=waitbar(0,'Initiating!')

FirstTime       = 1;
ThorlabZ        = 0;
SyringePump     = 1;
Photodetectoron = 1;
PriorXY         = 1;
Microscope      = 1;
Manipulator     = 0;
CCD             = 0;
FocusorZoom     = 1;
FishWellStageOn = 1;
ProsilicaOn     = 1;

% set(findobj(Microdispensing,'tag','NextFish'), 'Callback', {@NextFish});
% set(findobj(Microdispensing,'tag','ClosePort'), 'Callback', {@ClosePort});
% set(findobj(Microdispensing,'tag','ColumnArray'), 'Callback', {@ColumnArray});
% set(findobj(Microdispensing,'tag','NextWell'), 'Callback', {@NextWell});
% set(findobj(Microdispensing,'tag','WholeArray'), 'Callback', {@WholeArray});
% set(findobj(Microdispensing,'tag','SetZero'), 'Callback', {@SetZero});
% set(findobj(Microdispensing,'tag','FocusZoom'), 'Callback', {@FocusZoom});
% 
% set(Microdispensing,'KeyPressFcn',{@MyKeyFunction})
% set(Microdispensing, 'WindowScrollWheelFcn', {@testScrollWheel});

waitbar(10/100, waiting,'Initiating syringe pump')

    if SyringePump
        syr= serial(['COM' num2str(SyringeCOM)],'Terminator','CR');
        set(syr,'timeout',0.5)
        fopen(syr);
    end
    
    if PriorXY
        waitbar(15/100, waiting,'Initiating XY stage')
        isempty(FirstTime)
        StageCOM = 14;
        XYStage= serial(['COM' num2str(StageCOM)],'Terminator','CR');
        set(XYStage,'timeout',0.5)
        set(XYStage, 'BaudRate', 9600)
        fopen(XYStage);
        pause(0.1)
    end

    %load APT
    if ThorlabZ
        waitbar(25/100, waiting,'Initiating Thorlab Z stage')
        fig = figure('Position',[5 35 1272 912],'HandleVisibility','off','IntegerHandle','off');
        h = actxcontrol('MGMOTOR.MGMotorCtrl.1', [0 205 300 200], fig);

        pause(2)
        % serial number input
        h.HWSerialNum = 83828180;
        pause(1)
        h.StartCtrl
    end
    
    if FishWellStageOn
        waitbar(35/100, waiting,'Initiating fish well stage')
        FishWellStage(101)
    end

    
    
    if Photodetectoron
        waitbar(50/100, waiting,'Initiating Photodetector')
        Photodetector=analoginput('nidaq','Dev3');
        set(Photodetector,'InputType','Differential');
        set(Photodetector,'SampleRate',2000)
        set(Photodetector,'SamplesPerTrigger',50)
        set(Photodetector,'TriggerType','Manual')
        ch=addchannel(Photodetector,1);
        set(Photodetector,'TriggerFcn',{@FishPhotodetected})
        set(Photodetector,'TriggerChannel',ch)
        set(Photodetector,'TriggerType','Software')
        set(Photodetector,'TriggerCondition','Falling')
        set(Photodetector,'TriggerConditionValue',0.79)
%         set(Photodetector,'TriggerConditionValue',0.7)
    end
    
%    pause(1)

waitbar(65/100, waiting)  

    FirstTime=0;
    save FirstTime FirstTime
    fprintf(syr,'/1v1000V1600c2000Ea200R')
 %   pause(2.5)

    
if Microscope
    waitbar(75/100, waiting,'Initiating microscope')    
    AZ=actxserver('Nikon.MzMic.NikonMZ');
end

if ProsilicaOn
    waitbar(85/100, waiting,'Initiating CCD')    
    ProsilicaPreview(0.5)
end

waitbar(100/100, waitin0)  
close(waiting)

set(findobj(Microdispensing,'tag','NextFish'), 'Callback', {@NextFish});
set(findobj(Microdispensing,'tag','ClosePort'), 'Callback', {@ClosePort});
set(findobj(Microdispensing,'tag','ColumnArray'), 'Callback', {@ColumnArray});
set(findobj(Microdispensing,'tag','NextWell'), 'Callback', {@NextWell});
set(findobj(Microdispensing,'tag','WholeArray'), 'Callback', {@WholeArray});
set(findobj(Microdispensing,'tag','SetZero'), 'Callback', {@SetZero});
set(findobj(Microdispensing,'tag','FocusZoom'), 'Callback', {@FocusZoom});
set(findobj(Microdispensing,'tag','Zoom_back'), 'Callback', {@Zoom_back});
set(findobj(Microdispensing,'tag','HotWash'), 'Callback', {@HotWash});


set(findobj(Microdispensing,'tag','GoPreview'), 'Callback', {@GoPreview});
set(findobj(Microdispensing,'tag','StopPre'), 'Callback', {@StopPreview});
set(findobj(Microdispensing,'tag','Video_take'), 'Callback', {@Video_take});
set(findobj(Microdispensing,'tag','Video_off'), 'Callback', {@Video_off});
set(findobj(Microdispensing,'tag','Video_convert'), 'Callback', {@Video_convert});

set(findobj(Microdispensing,'tag','TheNextWell'), 'Callback', {@FishStage});
set(findobj(Microdispensing,'tag','PlateHoming'), 'Callback', {@FishStageHome});
set(findobj(Microdispensing,'tag','ResetPlate'), 'Callback', {@ResetingPlate});

set(findobj(Microdispensing,'tag','Focusing'), 'Callback', {@A_Focusing});
set(findobj(Microdispensing,'tag','Find_the_Head'), 'Callback', {@Find_the_Head});
set(findobj(Microdispensing,'tag','Poke_the_Head'), 'Callback', {@Poke_the_Head});

set(findobj(Microdispensing,'tag','Reset_Inj_Position'), 'Callback', {@Reset_Inj_Position});
set(findobj(Microdispensing,'tag','To_Inj_Zero'), 'Callback', {@To_Inj_Zero});
set(findobj(Microdispensing,'tag','To_Manual'), 'Callback', {@To_Manual});
set(findobj(Microdispensing,'tag','To_Remote'), 'Callback', {@To_Remote});

set(findobj(Microdispensing,'tag','Load_Front'), 'Callback', {@Loading_Front});
set(findobj(Microdispensing,'tag','Unload_Front'), 'Callback', {@Unloading_Front});
set(findobj(Microdispensing,'tag','Set_Z'), 'Callback', {@SetZero});
set(findobj(Microdispensing,'tag','Run_Auto'), 'Callback', {@Run_Auto});

set(findobj(Microdispensing,'tag','default_AZ'), 'Callback', {@default_AZ});
set(findobj(Microdispensing,'tag','Focus_Needle'), 'Callback', {@Focus_Needle});
set(findobj(Microdispensing,'tag','Inject_Initialize'), 'Callback', {@Inject_Initialize});

set(findobj(Microdispensing,'tag','ctrl_needle_keyboard'), 'Callback', {@control_needle_keyboard});



% h2 = findobj(Microdispensing,'tag','kknd');
% h3 = imagesc(zeros(512),'parent',h2);
% set(h2,'xtick',[],'xticklabelmode','manual','ytick',[],'yticklabelmode','manual')
% set(h3,'cdata',255*rand(512))

RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');
Water_Pos=get(findobj(Microdispensing,'tag','Water_Pos'),'String');
Reagent_Pos=get(findobj(Microdispensing,'tag','Reagent_Pos'),'String');
needle_step_semiauto = get(findobj(Microdispensing,'tag','needle_step_semi'),'String');


set(Microdispensing,'KeyPressFcn',{@MyKeyFunction});
set(Microdispensing, 'WindowScrollWheelFcn', {@testScrollWheel});

%Set AZ to the default position (AZ pos = 7000)
default_AZ
pause(0.5)

%Then, the following steps are taken for initialization
%1)Move the bottom plate until the plate is in focus
%2)Move the AZ up by 5000 units by calling Focus_Needle
%3)Manually move the needle up until it is in focus. Now the distance
%between the needle and the bottom plate is 5000 units
%4) Click "Remote" and "Reset position"

end

%%
%Do everything automatically (Assume that everything is initialized)
%Currently support only one fish (not the whole well)
function Run_Auto(v1,v2)
    global AZ
    global RowX
    global ColumnX
    
    Inject_Initialize
    
    disp('Pause for now')
    pause;
    
    %Set the default well
    SetZero; %Set the default well
    
    wellIndex = 1;
    while wellIndex <= RowX*ColumnX+1

        if(wellIndex~=1)

            %Autofocus
            Autofocusing_prosilica_recent;

            %Locate the head of current fish at the center
            find_head_recent;

            %Poke the head
            Contact_poke_recent
     
        %     %Release chemical

        
        end
        
        disp('Pause for now: Press spacebar to continue')
        pause;
        
        
        %Go to next well
        NextWell;
        pause(0.5)
        
        %Move AZ to the desired position
        %ADD STH HERE
%         Set_AZ_Position(11000)

        %Move the knob on AZ back to 2.0
        Zoom_back
        
        wellIndex = wellIndex + 1;
    end
    
end
%%
%Initialization step before we can do autofocus->find head->poke head
function Inject_Initialize(v1,v2)
    global AZ
    global RowX
    global ColumnX
    
    RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
    ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');
    
    default_AZ
    To_Manual
    
    
    %Move the knob on AZ back to 2.0
    Zoom_back
    
    disp('Please move the stage until it is in focus...press enter when done')
     input('')
 
    %Click on "Reset position"
    Reset_Inj_Position
    
    %Move AZ up
    Focus_Needle
    
    %Move needle up manually
    disp('Please move the needle to make it in focus...press enter when done')
    input('')
    
    %Reset position again
    Reset_Inj_Position
    
    To_Remote
    
end
%%

%%%%%%%%%%%%%%% Moving AZ/knob on AZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%With this position, the plate must be adjusted until it is in focus
function default_AZ(v1,v2)
global AZ
global AZInitPos

    Set_AZ_Position(3000)
    AZInitPos = AZ.Zdrive.Value.RawValue;

end

%Move the AZ to the position 5000 units above the AZInitPos: AZInjectInitPos-> It will be
%the default position before injecting each fish
function Focus_Needle(v1,v2)
global AZ
global AZInitPos
global AZInjectInitPos
global upDistance

    upDistance = 5000;%Move AZ up by this amount

    %Move AZ to the desired position
    Set_AZ_Position(AZInitPos+upDistance);
    AZInjectInitPos = AZ.Zdrive.Value.RawValue;

end

%Set_AZ_Position: It sets AZ to the desired position
function Set_AZ_Position(position)
global AZ

    %Move AZ to the desired position
    defaultPos = position;
    if AZ.Zdrive.Value.RawValue<=defaultPos
        if mod(AZ.Zdrive.Value.RawValue,1000)~=0
            AZ.ZDrive.MoveRelative(-mod(AZ.Zdrive.Value.RawValue,1000));
        end
        while AZ.Zdrive.Value.RawValue<defaultPos
            AZ.ZDrive.MoveRelative(1000);
            pause(0.001);
        end
    else
        if mod(AZ.Zdrive.Value.RawValue,1000)~=0
            AZ.ZDrive.MoveRelative(-mod(AZ.Zdrive.Value.RawValue,1000));
        end
        while AZ.Zdrive.Value.RawValue>defaultPos
            AZ.ZDrive.MoveRelative(-1000);
            pause(0.001);
        end
    end
end


%Turn the knob on AZ back to the default value (2.0)
function Zoom_back(v1,v2)
    global AZ
    
    position=AZ.Zoom.Value.RawValue;
    % tic
    
    while position>20
        if position >= 40
            AZ.Zoom.DecreaseOpt(1000);
        elseif position >= 30
            AZ.Zoom.DecreaseOpt(300);
        elseif position>20
            AZ.Zoom.DecreaseOpt(300);
        end
        position=AZ.Zoom.Value.RawValue;
    end

end
%%
%Created by Itthi Chatnuntawech
function control_needle_keyboard(v1,v2)

    move_needle_keyboard
% global Mani
% %     To_Remote
%     
%     step = 100;
%     
%     %Set initial position: Might need to change the initial position to be
%     %the current position in "contact_poke_recent"
%     mani_zyx = [0;0;0];
%     fprintf(Mani,'C007 0+0+0 2500 2500 2500')
%     pause(0.5)
% 
%     disp('Press left/right/up/down/+/-/backspace to move the needle or press other keys to quit')
%     
%     while 1
%         isRetracted = 0;
%         disp(':')
%         direction = getkey('non-ascii');
%         if strcmp(direction,'leftarrow')
%             mani_zyx = mani_zyx + [0;0;step];
%         elseif strcmp(direction,'rightarrow')
%             mani_zyx = mani_zyx + [0;0;-step];
%         elseif strcmp(direction,'uparrow')
%             mani_zyx = mani_zyx + [0;-step;0];
%         elseif strcmp(direction,'downarrow')
%             mani_zyx = mani_zyx + [0;step;0];
%         elseif strcmp(direction,'add')
%             mani_zyx = mani_zyx + [-step;0;0];
%         elseif strcmp(direction,'subtract')
%             mani_zyx = mani_zyx + [step;0;0];
%         elseif strcmp(direction,'backspace')
%             % Retract the needle
%             fprintf(Mani,'C007 0+0+0 2500 2500 2500')
%             pause(0.5)
%             isRetracted = 1;
%         else
%             break
%         end
%         
%         if ~isRetracted
%             if mani_zyx(2)<0
%                 str2 = num2str(mani_zyx(2));
%             else
%                 str2 = ['+' num2str(mani_zyx(2))];
%             end
% 
%             if mani_zyx(3)<0
%                 str3 = num2str(mani_zyx(3));
%             else
%                 str3 = ['+' num2str(mani_zyx(3))];
%             end
%             needle_location = ['C007 ' num2str(mani_zyx(1)) str2 str3 ' 1500 1500 1500'];
%             fprintf(Mani,needle_location);
%         end
%     end
end

%Set the flag for zooming via mouse scroll
function FocusZoom(v1,v2)
global FocusorZoom

    if FocusorZoom
        FocusorZoom=0;
    else
        FocusorZoom=1;
    end

end

function testScrollWheel(gcf, event_data)
global AZ
global FocusorZoom

AngleScrollRatio =   300;
Microstepping = 50;

turn=event_data.VerticalScrollCount;
Angle= turn * AngleScrollRatio*-1;

if FocusorZoom
    position=AZ.Zoom.Value.RawValue;
    position=double(position);
    position=1/position;
    Angle=double(Angle);
    Angle=position*Angle*8;
    Angle=round(Angle);
    AZ.ZDrive.MoveRelative(Angle)
    pause(0.5)
else
    if Angle>0
        AZ.Zoom.IncreaseOpt(Angle/2)
        pause(0.5)
    else
        Angle=abs(Angle)
        AZ.Zoom.DecreaseOpt(Angle/2)
        pause(0.5)
    end
end
clear Angle

end



function A_Focusing(v1,v2)
global AZ

Autofocusing_prosilica_recent

end

function Find_the_Head(v1,v2)
global AZ
% tic

position=AZ.Zoom.Value.RawValue;

if position <=43 && position >=37
    AZ.Zoom.DecreaseOpt(1400)
    pause(0.1)
    AZ.Zoom.DecreaseOpt(1400)
    pause(0.1)
end

% Find_Head
find_head_recent
% pause(0.05)
% AZ.Zoom.IncreaseOpt(1400)
% pause(0.05)
% AZ.Zoom.IncreaseOpt(1400)

% toc
end

function Poke_the_Head(v1,v2)
global Mani
    contact_poke_recent2
%     contact_poke
end

function Reset_Inj_Position(v1,v2)
global Mani

fprintf(Mani,'C003')

end

function To_Inj_Zero(v1,v2)
global Mani

fprintf(Mani,'C007 0+0+0 2000 2000 2000')

end

function Loading_Front(v1,v2)
global Reagent_Pos
global RowX
global ColumnX

RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');
Reagent_Pos=get(findobj(Microdispensing,'tag','Reagent_Pos'),'String');

Reagent_Pos=str2num(Reagent_Pos);
Wheretogo(Reagent_Pos);

pause(1)
Fromt_loading(1)

end

function Unloading_Front(v1,v2)
global Water_Pos
global RowX
global ColumnX

RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');
Water_Pos=get(findobj(Microdispensing,'tag','Water_Pos'),'String');

Water_Pos=str2num(Water_Pos);
Wheretogo(Water_Pos);

pause(1)
Fromt_loading(2)

end

function To_Manual(v1,v2)
global Mani

fprintf(Mani,'C005')

end

function To_Remote(v1,v2)
global Mani

fprintf(Mani,'C004')

end


function FishStageHome(v1,v2) % for homing the fish stage
FishWellStage(100)
end

function ResetingPlate(v1,v2)
global stagewell

stagewell=1;
FishWellStage(1)

end

function GoPreview(v1,v2)

ProsilicaPreview(1)

end

function StopPreview(v1,v2)

ProsilicaPreview(2)
display('Stop Preview')

end

function Video_take(v1,v2)
ProsilicaPreview(10)
pause(2)
ProsilicaPreview(11)

end

function Video_off(v1,v2)
ProsilicaPreview(12)

end

function Video_convert(v1,v2)
ProsilicaPreview(13)

end

function NextFish (v1,v2)
global syr
global h
global Photodetector
global FirstTime
global afterPD

valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

afterPD=0;
start(Photodetector)
pause(0.5)
WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve2)));
% 300 for water 200 for agar
% fprintf(syr,'/1v300V300c300IP2500R')
fprintf(syr,'/1v200V200c200IP2500R')

end

function FishPhotodetected(v1,v2)
global syr
global Photodetector
global h
global afterPD
global columnarray_on
global counter_on

fish_detection_time=tic;

valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

display('Fish Detected by the PD')
fprintf(syr,'/1TR')
all=getdata(Photodetector);
stop (Photodetector)
clear Photodetector

% h.MoveAbsoluteEnc(0,2,6,5000,1)
pause(0.5)

WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve1)));
fprintf(syr,'/1v300V300c300OD290R')

pause(1.2)
% h.MoveAbsoluteEnc(0,10,6,5000,1)
pause(0.5)

% NextWell

pause(0.03)
fprintf(syr,'/1v250V250c250IP160R')

pause(1.7)

fprintf(syr,'/1v1000V6000c2700Ea250R')

pause(0.3)

% NextWell

toc(fish_detection_time)
afterPD=1;

if columnarray_on
    
    if counter_on
       timing=toc 
    end
    
    ColumnArraying_Conc
end

end

function NextWell(v1,v2)
global WellNo
global RowX
global ColumnX

toc
tic


RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');

if isempty(WellNo)
    WellNo=1;
end

Wheretogo(WellNo);%Move the stage to the next well
WellNo=WellNo+1;

if WellNo>RowX*ColumnX
    WellNo=1;
end

end

function ColumnArray (v1,v2)
global RowX
global ColumnX
global WellNo
global columnarraying_Num
global columnarray_on
global counter_on

% counter_on==counting the time
counter_on=1;

RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');

RowX=str2num(RowX);
ColumnX=str2num(ColumnX);

valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

columnarraying_Num=RowX*ColumnX;

if isempty(WellNo)
    WellNo=1;
end

columnarray_on=1;
ColumnArraying_Conc

end

function ColumnArraying_Conc(v1,v2)
global columnarraying_Num
global WellNo
global columnarray_on
global counter_on

if WellNo<(columnarraying_Num+1)
    
    % counter_on is for measuring the time
    if counter_on
       tic
    end
    
    FishStage
    % Move the loading stage to the next well
    pause(0.5)
    
    if WellNo==columnarraying_Num
        columnarray_on=0;
        display('last well')
    end
    
    NextWell
    % Move the prior stage to the next well
    pause(0.5)
    NextFish
    % getting the next fish process 
    pause(0.1)
    
end

end


function WholeArray (v1,v2)
global syr
global h
global Photodetector
global FirstTime
global RowX
global ColumnX
global WellNo

RowX=get(findobj(Microdispensing,'tag','RowX'),'String');
ColumnX=get(findobj(Microdispensing,'tag','ColumnX'),'String');

valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

display('Under Construction')

end


function SetZero(v1,v2)
global XYStage
global WellNo

WellNo=1;
fprintf(XYStage,'Z')
pause(0.02)

end

function MyKeyFunction(hObject, eventdata, handles)
global XYStage
global AZ


tecla=eventdata.Character;
position=AZ.Zoom.Value.RawValue;
pause(0.05)
position=double(position);
position=1/position;
stepsize=position*10000;
stepsize=round(stepsize);

switch tecla
    case 'a'
        commandx = ['GR,' num2str(stepsize) ',0,0'];

    fprintf(XYStage,commandx)
    pause(0.15)
    case 'd'
        stepsize = -1*stepsize;
        commandx = ['GR,' num2str(stepsize) ',0,0'];

    fprintf(XYStage,commandx)
    pause(0.15)    
    case 'w'
        commandx = ['GR,0,' num2str(stepsize) ',0'];

    fprintf(XYStage,commandx)
    pause(0.15)    
    case 's'
        stepsize = -1*stepsize;
        commandx =['GR,0,' num2str(stepsize) ',0'];

    fprintf(XYStage,commandx)
    pause(0.15)    
    otherwise   
        display(['Pressed: ' tecla])
        display ('Nothing done...')
end

end

function HotWash(v1,v2)
global syr

valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

for i=1:3
    fprintf(syr,'/1v800V800c800Ea4000R')
    pause(7)
    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve2)));
    fprintf(syr,'/1v600V600c600Oa500R')
    pause(6)
    fprintf(syr,'/1v600V600c600Ea3500R')
    pause(6)
    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve1)));
    fprintf(syr,'/1v600V600c600Oa500R')
    pause(6)
    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(closeall)));
    fprintf(syr,'/1v600V600c600Ea3500R')
    pause(6)
    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(valve2)));
    pause(0.2)
    fprintf(syr,'/1v600V600c600Ia500R')
    pause(6)
    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(closeall)));
    ['finish ' num2str(i) 'th cycle']
    
end

end

function Fish2Center(v1,v2)





end



function ClosePort(v1,v2)
global syr
global h
global Photodetector
global FirstTime
global fig
global AZ
global XYStage
global ttt
global Mani

valvesDirections='Dev4/port0';
valve1='00000001';
valve2='00000010';
closeall='00000000';
openall='00000011';

pause(0.1)
%h.MoveAbsoluteEnc(0,19,6,5000,1)
pause(1.5)

fclose(Mani)
fclose(syr)
fclose(XYStage)

clear Photodetector

pause(1)
%h.StopCtrl
FirstTime=1;
save FirstTime FirstTime
AZ.release;
FishWellStage(102)
close(fig)
close all

end

function FishStage(v1,v2) % for next stage well
global zshorter  %this is for shorter waiting time
global stagewell

if isempty(stagewell)
    stagewell=1;
    FishWellStage(stagewell)
else
    stagewell=stagewell+1;
    zshorter=1;
    FishWellStage(stagewell)
    zshorter=0;
end

end




