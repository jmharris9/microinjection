function Contact_poke(v1,v2)
global Mani
global upDistance%Move AZ up by this amount (2000 units in AZ is equivalent to 900 units in Mani)


% --------- Tunable parameters -------------
bit_image = 8;
% step_distance=1; % every 200um for 1
% poking=1;
diagnal_on=0;
mani_zyx = [0;0;0];
step_coarse = [-100;0;0]; % um
step_fine = [-5;0;5]; % um
scope = 100;
mike = 0.8;

% --------- Filename information -----------
max_step_number = 35;
max_mani_z = -upDistance/2000*900;
contact_index = 0.4649;        % To be adjusted 

% ------------------------------------------

fprintf(Mani,'C007 0+0+0 2500 2500 2500')

pause(0.5)

% ProsilicaCamera('setRegion', 100,412,100,412,2,2)
ProsilicaCamera('setRegion', 0,512,0,512,2,2)
ProsilicaCamera('setExposure', 550)
imga = ProsilicaCamera('singleAcquire');
[rowNum, colNum] = size(imga);
im_ori = double(imga)/(2^bit_image-1);

%Crop
im_ori = im_ori(((floor(rowNum-scope)/2)):floor((rowNum-scope)/2)+scope,floor((colNum-scope)/2):floor((colNum-scope)/2)+scope);

illumination = mean(mean(im_ori));
contact_threshold = contact_index/illumination;
im_difference_1 = im_ori-im_ori;
delta_index = (max(max(im_difference_1)) - min(min(im_difference_1)))/illumination;
% delta_index=abs(delta_index);

poke_value=zeros(25,1);
% figure,
count_poke =1;

for i = 2:max_step_number
    
    img_2 = ProsilicaCamera('singleAcquire');
    file_name_2=['poke_image_' num2str(i)];
    save(file_name_2, 'img_2')
    im_current = double(img_2)/(2^bit_image-1);
    %Narrowing scope
    im_current = im_current((floor((rowNum-scope)/2)):floor((rowNum-scope)/2)+scope,floor((colNum-scope)/2):floor((colNum-scope)/2)+scope);
    im_difference = im_current-im_ori;
    
    
    
    delta_index_2 = (max(max(im_difference)) - min(min(im_difference)))/illumination;
    poke_value(i)=delta_index_2; %%%%%
%     hold on,
%     plot(poke_value);
%     delta_index_2=abs(delta_index_2);
%     imshow(img_2);

    if (delta_index_2 <= contact_threshold && ~diagnal_on)

        disp('needle is not contacting fish, continue in veritical motion');
        mani_zyx = mani_zyx + step_coarse;
        
        %Stop the needle when it almost reaches the bottom plate
        if (mani_zyx(1)<= max_mani_z+10)
            break;
        end
        
%       test1=['C007 ' num2str(-100*step_distance) '+0+0 1500 1500 1500'];
        needle_location = ['C007 ',num2str(mani_zyx(1)),'+',num2str(mani_zyx(2)),'+',num2str(mani_zyx(3)),' 1500 1500 1500'];
        fprintf(Mani,needle_location);
%         step_distance=step_distance+1;
        pause(0.25)
        contact_location = mani_zyx;
        
        
    elseif (delta_index_2 >= delta_index*mike && count_poke <= 5)
        count_poke = count_poke+1;
        disp ('diagonal one step down');
        diagnal_on=1;
        mani_zyx = mani_zyx + step_fine; 
        
        %Stop the needle when it almost reaches the bottom plate
        if (mani_zyx(1)<= max_mani_z+10)
            break;
        end
        
        needle_location = ['C007 ',num2str(mani_zyx(1)),'+',num2str(mani_zyx(2)),'+',num2str(mani_zyx(3)),' 1500 1500 1500'];
%         test2=['C007 ' num2str((-150*step_distance-2*poking)) '+0+' num2str(2*poking) ' 1000 1000 1000'];
        fprintf(Mani,needle_location);
        
        
        delta_index = delta_index_2;
%         poking=poking+1;
        
        pause(0.25);
        
        continue;
    else
        disp ('needle is inside fish brain');        
        diagnal_on=0;
        
        % retract
        poke_location = mani_zyx;
        injection_location = contact_location + (contact_location-poke_location)*0.5;
        mani_zyx = injection_location;
        needle_location = ['C007 ',num2str(mani_zyx(1)),'+',num2str(mani_zyx(2)),'+',num2str(mani_zyx(3)),' 1500 1500 1500'];
        fprintf(Mani,needle_location);
        
        break;
    end
    %         }
    %     else
    %         continue;
end
end

        
