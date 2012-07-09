%%
close all ; 
clc ; 
clear all; 

dos('"C:\Program Files\NIS-Elements\nis_ar.exe" -m "test.mac"')
% run('C:\Documents and Settings\Carlos\My Documents\MATLAB\Microinjection code\ElementsEXE.bat')
pause(0.5)

FishImage = 'temp.tif';
ImageSize=[1000 1004];
Center=ImageSize/2;
objective_mag = 2;
zoom_mag = 2;
chip_pixel_size = 8 ;%micron
total_mag = objective_mag*zoom_mag;
pixel_size = chip_pixel_size/total_mag; %micron

I = imread(FishImage) ;
Ia = double(I)/2^16 ; 

figure  ; imshow(Ia) ; 

I = edge(Ia);

% kernel = ones(20,20)/20/20 ; 
% I = conv2(I , kernel , 'same') ; 
% 
% % figure ; imshow(I)  ;
% 
% threc = 0.18 ; 
% I(I>threc) = 1 ;
% I(I<=threc) = 0 ; 
% 
% I = 1 - I ; 

figure  ; imshow(I) ; 
bb = sum(sum(I))

%%

