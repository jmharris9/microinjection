%% Autofocusing
% first, initiating the CCD. second, the microscope stage
global AZ
AZ = actxserver('Nikon.MzMic.NikonMZ');
cc = [-1 -1 -1;0 0 0;1 1 1];
scanning_range = 3000;
N = scanning_range / 100;

%% global AZ
global AZ
AZ = actxserver('Nikon.MzMic.NikonMZ');
AZ.ZDrive.MoveRelative(2000)

%%
AZ.release;
%% This part is used to connect the camera
cameraBinning =8;
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

%%
% Set exposure
expIn_us= 0.00001; % in milliseconds... check this.
src = getselectedsource(RetigaVid);
set(src,'Exposure',expIn_us);

%% Preview
preview(RetigaVid)


%% Acquire one image
% img = 256*rand(500,500)
Binning='MONO16_1024x1024';
RetigaVid = videoinput('qimaging',1,Binning);
pause(0.1)

%%
tic
img = uint16(getsnapshot(RetigaVid));
imagesc(img);
colormap('gray')
% imwrite(img,'img.tif')
toc

%%
img = uint16(getsnapshot(RetigaVid));
pause(0.01)
image(double(img)/2^2);
colormap('gray')

%% prosilica
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('setExposure', 350)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)

pause(0.01)

%%
ProsilicaCamera('setExposure', 1100)

%% retiga
global AZ
t=0;
cc = [-1 -1 -1;0 0 0;1 1 1];
scanning_range = 5000;
steps = 100;
N = scanning_range / steps;
sum_value = zeros(0,1);
tic
while t<N
    img = uint16(getsnapshot(RetigaVid));
    pause(0.001)
    AZ.ZDrive.MoveRelative(-1*steps)
    pause(0.001)
    [CC2 thres]=edge(img,'sobel');
    CC2=edge(img,'sobel',1.5*thres);
    CC3 = bwareaopen(CC2,5);
    DD=sum(sum(CC3));
%     CC2=imfilter(img,cc,'replicate');
    sum_value=[sum_value; DD];
    
    figure(1);
    colormap('gray');
    subplot(2,2,1);
    imagesc(img);
    subplot(2,2,2);
    imagesc(CC2);
    subplot(2,2,3);
    imagesc(CC3);
    subplot(2,2,4);
    plot(sum_value);
    
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

%% prosilica
global AZ
t=0;
cc = [-1 -1 -1;0 0 0;1 1 1];
scanning_range = 5000;
steps = 100;
N = scanning_range / steps;
sum_value = zeros(0,1);
tic
while t<N
    img=ProsilicaCamera('singleAcquire');
    pause(0.001)
    AZ.ZDrive.MoveRelative(-1*steps)
    pause(0.001)
    CC2=imfilter(img,cc,'replicate');
    DD=sum(sum(CC2));
    sum_value=[sum_value; DD];    
    
    t=t+1;
    display(t)
    if t>1
        if 1.008*sum_value(t) < sum_value(t-1)
            display('Focused')
            break;
        end
    end
end
toc

plot(sum_value)
figure,imshow(img)

%%

tic

csize = 15;
circ = zeros(csize,csize);
for i = 1:csize
    for j = 1:csize
        if sqrt((i-(csize+1)/2)^2 + (j-(csize+1)/2)^2) <= (csize+1)/2
            circ(i,j) = 1;
        end
    end
end

global AZ
    stop_points = [0 25 50] + 5922/steps;
    sharpness = zeros(1,length(stop_points));
    
    for i=1:length(stop_points)

        AZ.ZDrive.MoveAbsolute(steps*stop_points(i))
        pause(0.001)

        img = uint16(getsnapshot(RetigaVid));
        pause(0.001)

        [CC2 thres]=edge(img,'sobel');
        CC2=edge(img,'sobel',1.5*thres);
        CC3 = bwareaopen(CC2,5);
        
        CC4 = imfilter(CC3,circ);
        CC5 = bwlabel(CC4 > 0);
        num_objects = max(CC5(:));
        obj_length = zeros(num_objects,1);
        
        for j = 1:num_objects
            [r c] = find(CC5 == j);
            obj_length(j) = sqrt((max(r)-min(r))^2 + (max(c)-min(c))^2);
        end
        
        CC6 = CC5;
        fish_size = 200;
        for j = 1:num_objects
            if obj_length(j) > fish_size
                CC6 = CC6 - j*(CC6 == j);
            end
        end
        CC6 = CC6 > 0;
        
        sharpness(i) = sum(CC6(:));

        figure(1);
        colormap('gray');
        subplot(2,2,1);
        imagesc(img);
        axis equal;
        subplot(2,2,2);
        imagesc(CC5);
        axis equal;
        subplot(2,2,3);
        imagesc(CC6);
        axis equal;
        subplot(2,2,4);
        cla;
        plot(stop_points,sharpness);
    
    end
    
    subplot(2,2,4);
    hold on;
    xfit = stop_points;
    p = polyfit(xfit,sharpness,2);
    yfit = polyval(p,xfit);
    plot(xfit,yfit,'r');
    best_focus = -p(2)/(2*(p(1)));
    
    AZ.ZDrive.MoveAbsolute(steps*best_focus)

toc


%%
imagesc(img);
colormap('gray');

%%
plot(sum_value)

%%
AZ.ZDrive.MoveRelative(5000)

%%
II= imread('img.tif');
tic
CC=edge(II,'sobel');
DD=sum(sum(CC))
toc

tic
% II = medfilt2(II);
cc=[-1 -1 -1;0 0 0;1 1 1];
% cc=[-1 0 1;-1 0 1;-1 0 1];
CC2=imfilter(II,cc,'replicate');
DD2=sum(CC2(:))
toc

figure(1);
clf;
hold on;
colormap('gray');
subplot(1,2,1);
imagesc(CC);
subplot(1,2,2);
imagesc(CC2);

%%


plot(x,y,'bo')
hold on;
xfit = 0:0.01:4;
yfit = A*exp(-(xfit-mu).^2/sig^2);
plot(xfit,yfit,'r')

%%
AZ.release;

