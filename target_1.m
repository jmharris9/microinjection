function Find_Head(v1,v2)
global AZ

ImageSize=[512 512];
Center=ImageSize/2;
objective_mag = 2;
zoom_mag = 2;

% --------- Tunable parameters -------------
bit_image = 8; 
gray_range = 2^bit_image - 1;
level_factor = 11;
area_threshold = 2000;
position=AZ.Zoom.Value.RawValue;
pause(0.05)
position=double(position);

zoom_mag = position/10;

chip_pixel_size = 8 ;%in micron
total_mag = objective_mag*zoom_mag;
pixel_size = chip_pixel_size/total_mag; %micron
%----------------------------------------------

% --------- Image Processing -------------
im_fish = double(imread(im_fish_file))/gray_range;

% --------- Image Thresholding -------------
gray_threshold = (max(max(im_fish))-min(min(im_fish)))/level_factor+min(min(im_fish));
bw1 = im_fish < gray_threshold; % generate binary mask 
bw2 = bwareaopen(bw1,area_threshold); % remove small regions
[region_label,region_num]=bwlabel(bw2); % label regions 

% --------- Coordinates Calculation -------------
stats = regionprops(region_label, 'Centroid'); % generate the centroid coordinate of each region
xy_region = cat(1,stats.Centroid);

cen1_regions = [sum(xy_region(:,1))/region_num, sum(xy_region(:,2))/region_num];
loc=cen1_regions;

delta_xy = (Center-round(loc))* pixel_size;

sprintf('Center(Y,X) = (%d,%d)',yc,xc)

I_orig = imread(FishImage) ;
I_orig = double(I_orig)/2^16*0.5 ; 

I_orig( round(yc) , round(xc) ) = 1 ; 

figure ; imshow(I_orig) ; 
delta_xy = (Center-[round(xc),round(yc)])* pixel_size;
MoveToCenter(2*delta_xy(1),2*delta_xy(2));

end
