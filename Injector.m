function Injector(delta_transfer)
%Injector(delta_transfer)
% delta_transfer is the number of units by which to change 'transfer', in
% the units displayed on the controller

%%Rainbow cable from injector control:
% brown: (green from opt encoder) GND (plug into DGND)
% orange: (yellow from opt encoder) signal A (plug into P1.4-digital in0
% green: (orange from opt encoder) signal B (plug into P1.5-digital in1
% purple: (red from opt encoder) 4.8V (not used)

%sequence: 00 10 11 01 : decrease 'transfer' by 1 on every third signal
%sequence: 00 01 11 10 : increase 'transfer' by 1 on every third signal

%this function does not keep track of current signal levels so it may be
%possible to make small mistakes if they get mixed up
%also roundign errors may be an issue

injectorControl = 'Dev3/port1';

a0 = dec2hex(bin2dec('00'));
a1 = dec2hex(bin2dec('01'));
a2 = dec2hex(bin2dec('10'));
a3 = dec2hex(bin2dec('11'));

N_cycle = round(delta_transfer/1.343);

if N_cycle > 0
    for i = 1:N_cycle
        WriteDigitalPort(injectorControl,a2);
        WriteDigitalPort(injectorControl,a3);
        WriteDigitalPort(injectorControl,a1);
        WriteDigitalPort(injectorControl,a0);
    end

elseif N_cycle < 0
    N_cycle = -N_cycle;
    for i = 1:N_cycle
        WriteDigitalPort(injectorControl,a1);
        WriteDigitalPort(injectorControl,a3);
        WriteDigitalPort(injectorControl,a2);
        WriteDigitalPort(injectorControl,a0);
    end
end
%if N_cycle == 0 do nothing



