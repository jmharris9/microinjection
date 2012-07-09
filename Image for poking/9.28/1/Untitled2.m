figure;

for i = 3:13
    load(['poke_image_' num2str(i) '.mat'])
    imshow(img_2);title(['i = ' num2str(i)])
    pause(1)
end