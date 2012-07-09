% Shake fishes, agitate fishes, so that their brain could face up.
% input: "time_in_second", the total time need vibration to stimulate fish
% input: "short_shake_num", number of short vibration in each vibration cycle

function ShakeFish(time_in_second)

n=ceil(time_in_second/10);
valvesDirections='Dev4/port0';
shake='00000100';
closeall='00000000';
openall='00000011';


for i = 1:n
%     for j=1:short_shake_num

    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(shake)));
    pause(3)

    WriteDigitalPort(valvesDirections, dec2hex(bin2dec(closeall)));
    pause(7)
%     end
% pause (7-(0.3+0.1)*short_shake_num);
end
