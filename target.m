% Part(1) : Entering the image for MATLAB
fprintf('\n This program detects a target in an image')
fprintf('\n Entering the image for MATLAB...')
fprintf('\n Save the image or its copy in MATLAB working Directory')
imagname = input('\n Enter the name of the image file (filename.ext) : ','s');
w = imread(imagname);
w = im2double(w);
sizw = size(w);
figure
imshow(w)
title('Input Image')
pause(3.5);
close;
fprintf('\n Entering the target image for MATLAB...')
fprintf('\n Save the target image or its copy in MATLAB working Directory')
tarname = input('\n Enter the name of the target image file (filename.ext) : ','s');
t = imread(tarname);
t = im2double(t);
sizt = size(t);
figure
imshow(t)
title('Target Image')
pause(3.5);
close;
% ww = rgb2gray(w);
% tt = rgb2gray(t);
ww = w;
tt = t;
tedge = edge(tt);
wedge = edge(ww);

%%
figure,imshow(tedge)
figure,imshow(wedge)
c;
%%
out = filter2(tedge,wedge);
o = max(max(out));
output = (1/o)*out;

%%

pixel = find(output == 1);
pcolumn = fix(pixel / sizw(1));
prow = mod(pixel,sizw(1));
rdis = fix(sizt(1)/2);
cdis = fix(sizt(2)/2);
cmin = pcolumn - cdis;
cmax = pcolumn + cdis;
rmin = prow - rdis;
rmax = prow + rdis;
c = [cmin cmin cmax cmax];
r = [rmin rmax rmax rmin];
m = roipoly(ww,c,r);
m = im2double(m);
m = 0.5 * (m + 1);
mask(:,:,1) = m;
mask(:,:,2) = m;
mask(:,:,3) = m;
final = mask .* w;
figure
imshow(final)
title('Result Image')
pause(3.5);
close;
subplot(1,2,1)
imshow(w)
title('Input Image')
subplot(1,2,2)
imshow(final)
title('Result Image')
sav = input('\n Do you like to SAVE Result Image? (y/n) : ','s');
if (sav == 'y')
    fprintf('\n You choose to SAVE the Result Image')
    naming = input('\n Type the name of the new image file (filename.ext) : ','s');
    fprintf('\n Saving ...')
    imwrite(final,naming);
    fprintf('\n The new file is called %s and it is saved in MATLAB working Directory',naming)
else
    fprintf('\n You choose NOT to SAVE the Result Image')
end
clear
