% Controls for Retiga4000DC
close all
clear all
clc
%% This part is used to connect the camera
cameraBinning =2;
if cameraBinning==2
    Binning='MONO16_1024x1024';
elseif cameraBinning==4
    Binning='MONO16_512x512';
elseif cameraBinning==8
    Binning='MONO16_256x256';
else
    Binning='MONO16_2048x2048';
end
CameraInformation = imaqhwinfo('qimaging');
RetigaVid = videoinput('qimaging',1,Binning);
src = getselectedsource(RetigaVid);
set(RetigaVid,'FramesPerTrigger',1);
set(RetigaVid, 'FrameGrabInterval',1)
%set(RetigaVid, 'ROIPosition',[0, 0, 2048, 2048])
set(src, 'Cooling','on')
%logText('Camera Initialized')

%% Preview
preview(RetigaVid)


%% Set exposure
expIn_us= 0.0001; % in milliseconds... check this.
src = getselectedsource(RetigaVid);
set(src,'Exposure',expIn_us);



%% Acquire one image
%img = 256*rand(500,500)
img = uint16(getsnapshot(RetigaVid));
imagesc(img);
colormap('gray')


%% Disconnect
stop (RetigaVid)
delete(RetigaVid)
clear RetigaVid
