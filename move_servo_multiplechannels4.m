function move_servo_multiplechannels4(servo_num,POSR_value)
%POSR_value must be a string of the format 'XX' where 'XX' is the
%hexadecimal number of interest.
%servo_num must be a string of the format 'XX' where 'XX' is the servo num.

global s

% Empty=0;
% while ~Empty
%         data = dec2hex(fread(s));
%         if isempty(data)
%             Empty=1;
%         end
% end
pause(0.05)

%make sure that the home function is off..this will be a critical error
%otherwise
gotoconfig = hex2dec({servo_num,'05','04','0B','00','00'});
gotoconfig = append_crc(gotoconfig);

fwrite(s,gotoconfig, 'uint8');

%data = dec2hex(fread(s));
pause(0.05)
%set POSR position to POSR_value:
gotoconfig = hex2dec({servo_num,'06','0D','03','00',POSR_value});
gotoconfig = append_crc(gotoconfig);

fwrite(s,gotoconfig, 'uint8');

%data = dec2hex(fread(s));
pause(0.05)
%Now move the stage...:
gotoconfig = hex2dec({servo_num,'05','04','0C','FF','00'});
gotoconfig = append_crc(gotoconfig);
fwrite(s,gotoconfig, 'uint8');

%data = dec2hex(fread(s));
pause(0.05)
%Now cancel the active stage trigger:
gotoconfig = hex2dec({servo_num,'05','04','0C','00','00'});
gotoconfig = append_crc(gotoconfig);
fwrite(s,gotoconfig, 'uint8');

%data = dec2hex(fread(s));

pause(0.05)

end

