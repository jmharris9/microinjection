global Mani

ManipulatorCOM = 15;
Mani= serial(['COM' num2str(ManipulatorCOM)],'Terminator','CR');
set(Mani,'timeout',0.5)
set(Mani, 'BaudRate', 19200)
fopen(Mani);

%% activation of the prior stage
global XYStage
StageCOM = 14;
XYStage= serial(['COM' num2str(StageCOM)],'Terminator','CR');
set(XYStage,'timeout',0.5)
set(XYStage, 'BaudRate', 9600)
fopen(XYStage);
pause(0.1)


%% set to zero
fprintf(Mani,'C003')

%% switch to manual
fprintf(Mani,'C005')

%% switch to remote control
fprintf(Mani,'C004')

%%
pause(0.05)
fprintf(Mani,'C001')


%%
% pause(0.05)
   fprintf(Mani,'C007 -500+0+0 1000 1000 1000')
pause(0.05)

%%
x=1000
fprintf(Mani,'C007 0+0+0 3000 1000 1000')
   


%%
% pause(0.05)
fprintf(Mani,'C007 0+0+0 2000 2000 2000')
pause(0.05)

%% set prior stage to zero
fprintf(XYStage,'Z')


%% processes for front loading----loading

fprintf(Mani,'C007 2500+0+0 3000 3000 3000')
pause(1.5)
% Wheretogo(1)
fprintf(Mani,'C007 -500+0+0 3000 3000 3000')
pause(1.5)
Injector(-20)
pause(35)
Injector(20)
pause(1)
fprintf(Mani,'C007 2500+0+0 3000 3000 3000')

%% processes for front loading----unloading

fprintf(Mani,'C007 2500+0+0 3000 3000 3000')
pause(2)
% Wheretogo(1)
pause(1)
fprintf(Mani,'C007 -500+0+0 3000 3000 3000')
pause(2)
Injector(30)
pause(10)
Injector(-30)
pause(2)
fprintf(Mani,'C007 2500+0+0 3000 3000 3000')


%%
fclose(Mani)

