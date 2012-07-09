function contact_poke_recent2(v1,v2)
global Mani
global upDistance%Move AZ up by this amount (2000 units in AZ is equivalent to 900 units in Mani)
upDistance = 5000;

% --------- Tunable parameters -------------
% bit_image = 8;
% step_distance=1; % every 200um for 1
% poking=1;
diagnal_on=0;
% flag = 1;
mani_zyx = [0;0;0];
step_coarse = [-100;0;0]; % um
step_fine = [-5;0;1]; % um
% scope = 100;
% fact = 0.8;
% fact = 0.7;
% --------- Filename information -----------
% max_step_number = 35;
max_mani_z = -upDistance/2000*900;
% contact_index = 0.4649;        % To be adjusted 
% contact_index = 0.5;

% ------------------------------------------

fprintf(Mani,'C007 0+0+0 2500 2500 2500')
% pause(0.10)
% tic
% % ProsilicaCamera('setRegion', 100,412,100,412,2,2)
% ProsilicaCamera('setRegion', 0,512,0,512,2,2)
% ProsilicaCamera('setExposure', 550)
% imga = ProsilicaCamera('singleAcquire');
% [rowNum, colNum] = size(imga);
% im_ori = double(imga)/(2^bit_image-1);
% 
% %Crop
% im_ori = im_ori(((floor(rowNum-scope)/2)):floor((rowNum-scope)/2)+scope,floor((colNum-scope)/2):floor((colNum-scope)/2)+scope);
% 
% illumination = mean(mean(im_ori));
% contact_threshold = contact_index/illumination;
% im_difference_1 = im_ori-im_ori;
% delta_index = (max(max(im_difference_1)) - min(min(im_difference_1)))/illumination;
% delta_index=abs(delta_index);

% poke_value=zeros(25,1);
% figure,
% count_poke =1;

    while 1

%         img_2 = ProsilicaCamera('singleAcquire');
% %         file_name_2=['poke_image_' num2str(i)];
% %         save(file_name_2, 'img_2')
%         im_current = double(img_2)/(2^bit_image-1);
%         %Narrowing scope
%         im_current = im_current((floor((rowNum-scope)/2)):floor((rowNum-scope)/2)+scope,floor((colNum-scope)/2):floor((colNum-scope)/2)+scope);
%         im_difference = im_current-im_ori;
% 
%         delta_index_2 = (max(max(im_difference)) - min(min(im_difference)))/illumination;
%         poke_value(i)=delta_index_2; %%%%%
    %     hold on,
    %     plot(poke_value);
    %     delta_index_2=abs(delta_index_2);
    %     imshow(img_2);

%         if (delta_index_2 <= contact_threshold && ~diagnal_on)
        if ~diagnal_on;

%             disp('needle is not contacting fish, continue in veritical motion');
            mani_zyx = mani_zyx + step_coarse;

            %Stop the needle when it almost reaches the bottom plate
            if (mani_zyx(1)<= max_mani_z+1.5*abs(step_coarse(1)))
                diagnal_on = 1;
%                 disp('Go to step2: Stop to prevent needle from breaking')
                continue;
            end

            needle_location = ['C007 ',num2str(mani_zyx(1)),'+',num2str(mani_zyx(2)),'+',num2str(mani_zyx(3)),' 1500 1500 1500'];
            fprintf(Mani,needle_location);
            pause(0.10)
%             contact_location = mani_zyx;

        else
%             elseif (delta_index_2 >= delta_index*fact)
%         elseif (delta_index_2 >= delta_index*fact && flag && count_poke <=35)
%             disp ('diagonal one step down');
            diagnal_on=1;
            mani_zyx = mani_zyx + step_fine; 
%             count_poke = count_poke+1;

            %Stop the needle when it almost reaches the bottom plate
%             if (mani_zyx(1)<= max_mani_z+abs(8*step_fine(1)))%works last
%             time
            if (mani_zyx(1)<= max_mani_z+abs(8*step_fine(1)))

%                 flag = 0;
%                 disp('Stop to prevent needle from breaking (step 2)')
                break
            end

            needle_location = ['C007 ',num2str(mani_zyx(1)),'+',num2str(mani_zyx(2)),'+',num2str(mani_zyx(3)),' 1500 1500 1500'];
            fprintf(Mani,needle_location);

%             delta_index = delta_index_2;
            pause(0.10);
        end
%         else
% %             disp ('needle is inside fish brain');      
%             break;
%         end
    end
    disp ('needle is inside fish brain');  
    % retract

%         poke_location = mani_zyx;
%         injection_location = contact_location + (contact_location-poke_location)*0.5;
%         mani_zyx = injection_location;
%         needle_location = ['C007 ',num2str(mani_zyx(1)),'+',num2str(mani_zyx(2)),'+',num2str(mani_zyx(3)),' 1500 1500 1500'];
%         fprintf(Mani,needle_location);
%         pause(1)
end

        
