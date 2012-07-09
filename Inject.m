function Inject

%running this function is equivalent to pressing inject button for 0.2s

%injector triggers on upward edge of Dev2/port1 bit 2.

%orange-yellow is open when V = 0, short when V = 5V.


injectorControl = 'Dev3/port1';

standby = dec2hex(bin2dec('100'));
depressSwitch = dec2hex(bin2dec('000'));

WriteDigitalPort(injectorControl,depressSwitch);
pause(1)
WriteDigitalPort(injectorControl,standby);
