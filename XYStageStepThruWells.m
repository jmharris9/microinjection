function XYStageStepThruWells
%Assumes serial port to XY stage is open
global Stage
global flag1
global WellNo

WellNo=13;
flag1=1;
XYStage

set(findobj(NextWell,'tag','NextWell'), 'Callback',{@Wheretogo});

%gotowell(2,2)

%StepThruCol

% for j = 1:8
%     for i = 2:12
%         fprintf(Stage,'GR,-9000,0')
%         pause(2)
%     end
% 
%     fprintf(Stage,'GR,99000,-9000')
%     pause(2)
% 
% end

end

function Wheretogo(WellNo,v2)
global Stage
WellNo

fopen(Stage)
pause(0.1)

col = ceil(WellNo/12);
if mod(WellNo,12)==0
    row=12;
else
row = mod(WellNo,12);
end

x = (row-1)*-9000;
y = (col-1)*-9000;

str = ['G,' num2str(x) ',' num2str(y)];
display(str)

fprintf(Stage,str)
fscanf(Stage)
pause(1)

fclose(Stage)

end


function GoNextWell(v1,v2)
global Stage

global flag1

if flag1

    flag1 = 0;
    rows = 5;
    cols = 2;

    xmin = -(9000*(rows-1) - 500);
    ymin = -(9000*(cols-1) - 500);

    fprintf(Stage,'PX')
    x = str2num(fscanf(Stage));
    fprintf(Stage,'PY')
    y = str2num(fscanf(Stage));
    if x > xmin
        fprintf(Stage,'GR,-9000,0')
        pause(2)
        fscanf(Stage);
    elseif y > ymin
        fprintf(Stage,['GR,' num2str((rows-1)*9000) ',-9000'])
        pause(3)
        fscanf(Stage);
    else
        ['Reached end of ' num2str(rows*cols) '-well plate']
        fprintf(Stage,'M')
        pause(2)
        fscanf(Stage);
    end
    flag1 = 1;
else
    display('Executing previous command')
end


end

function gotowell(row,col)

global Stage

x = (col-1)*-9000;
y = (row-1)*-9000;
fprintf(Stage,['G,' num2str(x) ',' num2str(y)])
fscanf(Stage);

end


function StepThruCol
global Stage

fprintf(Stage,'P')
result = fscanf(Stage); %Later: Read this to confirm starting at well 1

for i = 2:12
    fprintf(Stage,'GR,-9000,0')
%    fscanf(Stage);
    pause(0.5)
end

fprintf(Stage,'GR,99000,0')%Return to head of column
fscanf(Stage);

end


