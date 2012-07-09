%%
aaa=03;
bbb=00;
ccc=03;
ddd=02;

aaa=dec2hex(aaa);
bbb=dec2hex(bbb);
ccc=dec2hex(ccc);
ddd=dec2hex(ddd);

aaa=['0' aaa];
bbb=['0' bbb];
ccc=['0' ccc];
ddd=['0' ddd];

%%
Xactuator='01';
Yactuator='02';
Zactuator='03';

%%
global s
s = serial ('COM1');
set(s,'BaudRate',115200,'Timeout',0.2);
% set(s,'BaudRate',9600,'Timeout',0.05);
fopen(s)
pause(1)
% Empty=0;
% while ~Empty
%         data = dec2hex(fread(s));
%         if isempty(data)
%             Empty=1;
%         end
% end

%%
move_servo_multiplechannels4(Zactuator,'00')

%%
move_servo_multiplechannels4(Zactuator,'01')

%%
    move_servo_multiplechannels4(Yactuator,ccc)
%     move_servo_multiplechannels4(ddd,ccc)

%%
move_servo_multiplechannels4(aaa,ccc)

%%
well=1;

%%
i=1;
while i<96
    FishWellStage(i)
    i=i+1;
end

%% Original place

move_servo_multiplechannels4(Xactuator,'00')
move_servo_multiplechannels4(Yactuator,'00')

%%
fclose(s)
delete(s)
clear s

%%
fclose(s)

%%
feof(s)

%%
delete(instrfind)