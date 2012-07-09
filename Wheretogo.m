%Last Updated by Itthi Chatnuntawech 11/7/2011
% The variable row and column here are swap...RowX = ColumnX in mathematic
% notation
function Wheretogo(WellNo)
global XYStage
global FirstTime
global RowX
global ColumnX

if WellNo=='help'
    display('This function move the prior stage well by well, the maximum is 96 wells')
    display('0= Reset the origin')
    return
end

if isempty(FirstTime)
    StageCOM = 14;
    XYStage= serial(['COM' num2str(StageCOM)],'Terminator','CR');
    set(XYStage,'timeout',0.5)
    set(XYStage, 'BaudRate', 9600)
    fopen(XYStage);
    pause(0.1)
    FirstTime=1;
else
    display('Stage is on')
end

if WellNo==0
   display('Reset Zero')
   fprintf(XYStage,'Z'); 
   return 
end

RowX=str2num(RowX);
ColumnX=str2num(ColumnX);

WellNo
col = ceil(WellNo/RowX);

if mod(WellNo,RowX)==0
    row=RowX;
else
    row = mod(WellNo,RowX);
end

x = (row-1)*-9000;
y = (col-1)*-9000;

str = ['G,' num2str(x) ',' num2str(y)];
% display(str)

fprintf(XYStage,str);pause(0.01)

%Provide enough delay when we proceed onto next Y-value
if WellNo~=1 && mod(WellNo-1,RowX)==0
    pause(2);
end

% fscanf(XYStage)
% pause(0.1)

% tarname = input('\n Close the Connection? (y/n) : ','s');
% if tarname=='y'
%     fclose(XYStage)
%     clear FirstTime
% end

end