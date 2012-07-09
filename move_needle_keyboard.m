%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The number in the box below the "Keyboard Control" button represents how
% much (in um) the user want to move the needle
% Press arrows to move the needle to the desired direction
% Press + to move the needle down
% Press - to move the needle up
% Press backspace to move the needle to the initial state (i.e. where it was
% before you enter this function)
% Press enter to exit the keyboard control mode
% It may be helpful (visually) to press the "Camera Preview" button on the GUI before
%calling this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function move_needle_keyboard
global Mani
global needle_step_semiauto
    needle_step_semiauto = get(findobj(Microdispensing,'tag','needle_step_semi'),'String'); %um
    step = str2double(needle_step_semiauto);
    disp(['Step size = ' num2str(step) 'um'])
    %Set initial position: Might need to change the initial position to be
    %the current position in "contact_poke_recent"
    mani_zyx = [0;0;0];
    fprintf(Mani,'C007 0+0+0 2500 2500 2500')
    pause(0.5)

    disp('Press left/right/up/down/+/-/backspace to move the needle or press other keys to quit')
    
    while 1
        isRetracted = 0;
        disp(':')
        direction = getkey('non-ascii');
        if strcmp(direction,'leftarrow')
            mani_zyx = mani_zyx + [0;0;step];
        elseif strcmp(direction,'rightarrow')
            mani_zyx = mani_zyx + [0;0;-step];
        elseif strcmp(direction,'uparrow')
            mani_zyx = mani_zyx + [0;-step;0];
        elseif strcmp(direction,'downarrow')
            mani_zyx = mani_zyx + [0;step;0];
        elseif strcmp(direction,'add')
            mani_zyx = mani_zyx + [-step;0;0];
        elseif strcmp(direction,'subtract')
            mani_zyx = mani_zyx + [step;0;0];
        elseif strcmp(direction,'backspace')
            % Retract the needle
            fprintf(Mani,'C007 0+0+0 2500 2500 2500')
            mani_zyx = [0;0;0];
            pause(0.5)
            isRetracted = 1;
        else
            break
        end
        
        if ~isRetracted
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
        end
    end
end