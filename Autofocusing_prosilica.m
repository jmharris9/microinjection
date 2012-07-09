function Autofocusing_prosilica(v1,v2)
global AZ

HPF = [-1 -1 -1;0 0 0;1 1 1];
scanning_range = 3000;
N = scanning_range / 100;
steps = 100;


% AZ=actxserver('Nikon.MzMic.NikonMZ');

pause(0.05)

ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('initialize')
pause(0.1)
ProsilicaCamera('setExposure', 200)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)

pause(0.01)

t=0;
cc = HPF;
sum_value = zeros(0,1);
tic

while t<N
    img=ProsilicaCamera('singleAcquire');
    pause(0.001)
    AZ.ZDrive.MoveRelative(-1*steps)
    pause(0.001)
%     [CC2 thres]=edge(img,'sobel');
%     CC2=edge(img,'sobel',1.5*thres);
%     CC3 = bwareaopen(CC2,5);
%     DD=sum(sum(CC3));
    CC2=imfilter(img,cc,'replicate');
    DD=sum(sum(CC2));
    sum_value=[sum_value; DD];
    
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
        if 1.035*sum_value(t) < sum_value(t-1)
            display('Focused')
            break;
        end
    end
end
toc

plot(sum_value)
figure,imshow(img)

% AZ.release;

end


