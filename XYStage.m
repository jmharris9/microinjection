function XYStage
%open serial port to XYStage. Make sure well A1 is centered at (0,0)

%%
global Stage

StageCOM = 14;
Stage= serial(['COM' num2str(StageCOM)],'Terminator','CR');
set(Stage,'timeout',0.5)
set(Stage, 'BaudRate', 9600)
fopen(Stage);
%%
% pause(0.1)
% fprintf(Stage,'G,-5000,-25000,0')
% fprintf(Stage,'*IDN?')
% pause(0.1)
% out=fscanf(Stage)

%% set zero
%position instrument over well A,1 (left rear corner) before executing this
%code

fprintf(Stage,'Z')
pause(0.02)
fscanf(Stage);

%%


%%
fclose(Stage)


