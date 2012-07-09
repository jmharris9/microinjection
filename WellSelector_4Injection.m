function WellSelector_V2(well)
% MultiwellNumber must be either 1 or 2.
% Well must be a string that goes from 1 to 96.
% This version is modified by Michael Chang

global XCoordinate
global YCoordinate
global Xactuator
global Yactuator
global Zactuator

Xactuator='01';
Yactuator='02';
Zactuator='03';

if ischar(well)
    well=WellNametoWellNumber(well);
end

if  or(well<0, well>96)
    display('Error, "well" must be between 1 and 96')
    return
end 
if  ~or(multiwellnumber==1, multiwellnumber==2)
    display('Error, "multiwellnumber" must be either 1 or 2')
    return
end 


well=round(well);
[WellName]= WellNumbertoWellName(well);
display(['Moving to well ' WellName ':'])

LocationY=floor((well)/12.01)+1;
LocationX=well-(LocationY-1)*12;


YCoordinate=['0' num2str(LocationY)];
XCoordinate=num2str(LocationX);

if max(size(XCoordinate))<2
    XCoordinate=['0', XCoordinate];
end


display('Moving Z actuator UP');
move_servo_multiplechannels4(Zactuator,'00')



pause(0.2)

YCoordinate2=str2num(YCoordinate)
YCoordinate3=dec2hex(YCoordinate2)
YCoordinate4=['0', YCoordinate3]

XCoordinate2=str2num(XCoordinate)
XCoordinate3=dec2hex(XCoordinate2)
XCoordinate4=['0', XCoordinate3]

display(['Moving X to ' XCoordinate ' and Y to ' YCoordinate])
move_servo_multiplechannels4(Xactuator,XCoordinate4)
pause(0.05)
move_servo_multiplechannels4(Yactuator,YCoordinate4)

pause(5.05)

% move_servo_multiplechannels4(Zactuator,'01')
% pause(0.05)

end

function MoveXY

global XCoordinate
global YCoordinate
global Xactuator
global Yactuator

YCoordinate2=str2num(YCoordinate)
YCoordinate3=dec2hex(YCoordinate2)
YCoordinate4=['0', YCoordinate3]

display(['Moving X to ' XCoordinate ' and Y to ' YCoordinate])
move_servo_multiplechannels4(Xactuator,XCoordinate)
pause(0.2)
move_servo_multiplechannels4(Yactuator,YCoordinate4)
end







