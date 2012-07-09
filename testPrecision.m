
%%
global AZ

    %Move AZ to the desired position
    defaultPos = 3000;
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

%%

    %Move AZ to the desired position
    defaultPos = AZ.Zdrive.Value.RawValue+5000;
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
    
%%
    
global Mani
    fprintf(Mani,'C003')
    mani_zyx = [0;0;0];
    fprintf(Mani,'C007 0+0+0 2500 2500 2500')
    pause(0.5)
    
    mani_zyx = mani_zyx + [-2250;0;0];%<---Location that the needle will hit the plate
    if mani_zyx(2)<0
        str2 = num2str(mani_zyx(2));
    else
        str2 = ['+' num2str(mani_zyx(2))];
    end

    if mani_zyx(3)<0
        str3 = num2str(mani_zyx(3));
    else
        str3 = ['+' num2str(mani_zyx(3))];
    end
    needle_location = ['C007 ' num2str(mani_zyx(1)) str2 str3 ' 1500 1500 1500'];
    fprintf(Mani,needle_location);
            
            
            
            
            