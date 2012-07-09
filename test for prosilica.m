%% prosilica test

pause(0.05)

ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('setExposure', 350)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)

pause(0.01)

ProsilicaCamera('Preview')

%%
global h3
global img
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('setExposure', 25)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)
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

%%
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('initialize')
pause(0.3)
ProsilicaCamera('setExposure', 70)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)
figure
pause(0.1)
AcumularValores=zeros(10,1);
AcumularTiempos=zeros(10,1);
j=0;
tic    
while 1<2
    j=j+1;
    img=ProsilicaCamera('singleAcquire');
    AcumularValores(j)=sum(img(:));
    AcumularTiempos(j)=toc;
    imshow(img)
    pause(0.001)

end

%% timer function
figure
timer_preview=timer('TimerFcn',@testtimer, 'Period', 0.5, 'ExecutionMode', 'fixedRate')
start(timer_preview)
%%
stop(timer_preview)
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
RetigaVid = videoinput('ProsilicaCamera',1,Binning);
src = getselectedsource(RetigaVid);
set(RetigaVid,'FramesPerTrigger',1);
set(RetigaVid, 'FrameGrabInterval',1)
%set(RetigaVid, 'ROIPosition',[0, 0, 2048, 2048])

%% Preview
preview(RetigaVid)