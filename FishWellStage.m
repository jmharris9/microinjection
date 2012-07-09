function FishWellStage(well)
global XCoordinate
global YCoordinate
global Xactuator
global Yactuator
global Zactuator
global zshorter  %this is for shorter waiting time
global s

Yactuator='01';
Xactuator='02';
Zactuator='03';

if well==101

    s = serial ('COM1');
    set(s,'BaudRate',115200,'Timeout',0.2);
    fopen(s)
    pause(1)
    display('Fish Stage On')
    return
end

if well==102
    fclose(s)
    display('Fish Stage Off')
    return
end

if well==100
    move_servo_multiplechannels4(Zactuator,'00')
    pause(0.1)
    move_servo_multiplechannels4(Xactuator,'00')
    move_servo_multiplechannels4(Yactuator,'00')
    return
end

if  or(well<0, well>96)
    display('Error, "well" must be between 1 and 96')
    return
end 

well=round(well);

LocationY=floor((well)/12.01)+1;
LocationX=well-(LocationY-1)*12;

YCoordinate=['0' num2str(LocationY)];
XCoordinate=num2str(LocationX);

if max(size(XCoordinate))<2
    XCoordinate=['0', XCoordinate];
end

move_servo_multiplechannels4(Zactuator,'00')

pause(0.2)

YCoordinate2=str2num(YCoordinate);
YCoordinate3=dec2hex(YCoordinate2);
YCoordinate4=['0', YCoordinate3];

XCoordinate2=str2num(XCoordinate);
XCoordinate3=dec2hex(XCoordinate2);
XCoordinate4=['0', XCoordinate3];

display(['Moving X to ' YCoordinate ' and Y to ' XCoordinate]);
move_servo_multiplechannels4(Xactuator,XCoordinate4)
move_servo_multiplechannels4(Yactuator,YCoordinate4)

if zshorter==1
    pause(0.3)
else
    pause(1)
end

move_servo_multiplechannels4(Zactuator,'01')

end