function Autofocusing(v1,v2)
global AZ

HPF = [-1 -1 -1;0 0 0;1 1 1];
scanning_range = 3000;
N = scanning_range / 100;

cameraBinning =4;

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
% set(RetigaVid,'TriggerRepeat',0.5)
% set(RetigaVid, 'ROIPosition',[0, 0, 2048, 2048])
set(src, 'Cooling','on')
%logText('Camera Initialized')
pause(0.001)

expIn_us= 0.001; % in milliseconds... check this.
src = getselectedsource(RetigaVid);
set(src,'Exposure',expIn_us);

pause(0.001)

t=0;
cc = HPF;
sum_value = zeros(0,1);
tic

while t<N
    img = uint16(getsnapshot(RetigaVid));
    pause(0.001)
    AZ.ZDrive.MoveRelative(-1*steps)
    pause(0.001)
%     [CC2 thres]=edge(img,'sobel');
%     CC2=edge(img,'sobel',1.5*thres);
%     CC3 = bwareaopen(CC2,5);
%     DD=sum(sum(CC3));
    CC2=imfilter(img,cc,'replicate');
    sum_value=[sum_value; CC2];
    
%     figure(1);
%     colormap('gray');
%     subplot(2,2,1);
%     imagesc(img);
%     subplot(2,2,2);
%     imagesc(CC2);
%     subplot(2,2,3);
%     imagesc(CC3);
%     subplot(2,2,4);
%     plot(sum_value);
    
    t=t+1;
    display(t)
    if t>1
        if 10.505*sum_value(t) < sum_value(t-1)
            display('Focused')
            break;
        end
    end
end
toc


end


