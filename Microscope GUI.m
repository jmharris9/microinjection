function Microscope(v1,v2)




end

function testScrollWheel(gcf, event_data)
global Steppers
AngleScrollRatio =   25;
Microstepping = 50;

turn=event_data.VerticalScrollCount;
Angle= turn * AngleScrollRatio;

%Final_Angle=Step_Motor(Angle,Direction,3,0);
AZ.ZDrive.MoveRelative(Angle)
end