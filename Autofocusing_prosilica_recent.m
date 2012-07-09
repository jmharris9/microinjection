%Last updated by Itthi Chatnuntawech
function Autofocusing_prosilica_recent(v1,v2)
    global AZ

    HPF = [-1 -1 -1;0 0 0;1 1 1];
%     HPF2 = -1*ones(3);HPF2(2,2) = 2;
%     HPF = fspecial('unsharp');
%     scanning_range = 3000;
%     maxIter = scanning_range / 100;
    stepSize = 200;

    %Move the AZ up to the default position
    defaultPos = 7000;
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

    %Initialize the camera
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
    intensity = [];
    maxIntensity = -inf;
    maxIndex = 0;
    count = 1;

    
    %Move AZ up by 1000: AZ.ZDrive.MoveRelative(-1000)->
    %AZ.Zdrive.Value.RawValue increases
    %The value of AZ.ZDrive.Value.RawValue should be from 0 to default
    %position
    while AZ.Zdrive.Value.RawValue>stepSize
        img=ProsilicaCamera('singleAcquire');
        pause(0.001)
        AZ.ZDrive.MoveRelative(-1*stepSize)
        pause(0.02)
        %Get the filtered image intensity

        img_filtered = imfilter(img,HPF,'replicate');
        intensity=[intensity; sum(sum(img_filtered))];
        
        %Get the (possible) location of the max intensity
        if intensity(count) >= maxIntensity
            maxIntensity = intensity(count); 
            maxIndex = count;
        end
        
        %If the value drops significantly, then it probably was in focus
        %before
        if intensity(count) < 0.80*maxIntensity
            break;
        end
        count= count+1;
    end
    
    %Move the AZ to the correct place (focus)
    for i = 1:(length(intensity)-maxIndex)
        AZ.ZDrive.MoveRelative(stepSize);
        pause(0.01)
    end
        
%     figure;plot(1:length(intensity),intensity);
%     title('Sum of intensity of filtered image versus iterations')
%     ylabel('Sum of Intensity of filtered image');xlabel('N');grid on;
%     pause(0.5);close

end


