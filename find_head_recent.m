function find_head_recent
    global AZ
    
    %Parameters
    ImageSize=[512 512];
    Center=ImageSize/2;
    objective_mag = 2;
    bit_image = 8; 
    gray_range = 2^bit_image - 1;
    magKnob_position=AZ.Zoom.Value.RawValue;
    pause(0.05)
    magKnob_position=double(magKnob_position);
%     level = input('Please input threshold to create bw image: ');
%     area_threshold = input('Please input threshold for an area of eye: ');
    
    level = 10;
    area_threshold = 500;
    stepSize = 10;
    zoom_mag = magKnob_position/10;
    chip_pixel_size = 5.5 ;%Unit: micron
    total_mag = objective_mag*zoom_mag*0.7*0.6;
    bin = 2;
    pixel_size = chip_pixel_size/total_mag*bin; %Unit: micron
    
    %Acquire image
    ProsilicaCamera('setExposure', 200)
    pause(0.001)
    im_fish_file=ProsilicaCamera('singleAcquire');
    pause(0.01)
    im_fish = double(im_fish_file)/gray_range;   

    %Find location to inject
    [x_new,y_new] = myFindHead(im_fish,area_threshold,level,stepSize);
    loc=[x_new,y_new];
    
    delta_xy = (Center-loc)* pixel_size; %delta in micron

    % Shift the prior stage
    MoveToCenter(delta_xy(1),-delta_xy(2));
    
    
    % Show result

%     imshow(im_fish);hold on;plot(x_new,y_new,'m+');
%     save findHeadVars.mat x_new y_new pixel_size

end

function [x_new,y_new] = myFindHead(im_fish,area_threshold,level,stepSize)
        maxIter = 20;
        count = 1;
        %Get centroids of all candidates
        [im_fish,centroids,labels,numLabels] = myGetCentroids2(im_fish,area_threshold,level);
        
        while(size(centroids,1)<2) && count<maxIter
            area_threshold = ceil(area_threshold*0.8);
            [im_fish,centroids,labels,numLabels] = myGetCentroids2(im_fish,area_threshold,level);
            count = count+1;
        end
        
        if size(centroids,1)<2 
            error('Not enough centriods...Move on to the next fish')
        end
        
        xy_region = centroids;
       
%         figure;imshow(im_fish);hold on;
%         for i = 1:size(centroids,1)
%             plot(centroids(i,1),centroids(i,2),'r+')
%         end

        %Compute distance between centroids
        dist = pdist(xy_region);
        z = squareform(dist);
        z(z==0) = inf;
        [row,col] = find(z==min(min(z)));

        %Pick two closest centroids
        cen1 = centroids(row(1),:);
        cen2 = centroids(col(1),:);
        oldCentroid = mean(centroids);
        center = (cen1+cen2)/2;

        %Find line equation connecting two centroids
        A = [cen1(1) 1
            cen2(1) 1];
        b = [cen1(2);cen2(2)];
        param = A\b;
        m = param(1);

        %Find perpendicular line passing throught the avg of two centroids:
        %y= m_perpend*x+c_perpend
        m_perpend = -1/m;
        c_perpend = center(2)+center(1)/m;

        im_fish_thresed = im_fish;
%         im_fish_thresed(im_fish_thresed >= 0.55) = 1;%Old threshold
        im_fish_thresed(im_fish_thresed >= 0.47) = 1;

%                 figure;imshow(im_fish_thresed);hold on;

%         %Plot centroids
%         plot(center(:,1),center(:,2),'r+')
%         plot(cen1(:,1),cen1(:,2),'r+')
%         plot(cen2(:,1),cen2(:,2),'r+')

        %Determine direction that we want to move the needle to
        plusDirection = inf;
        count = 1;
        while isinf(plusDirection)
            xPlus = center(1)+stepSize*count;
            xMinus = center(1)-stepSize*count;
            yPlus = m_perpend*xPlus+c_perpend;
            yMinus = m_perpend*xMinus+c_perpend;
%             %Plot tracing
%             plot(xPlus,yPlus,'ro');
%             plot(xMinus,yMinus,'b+');
            if length(centroids)>2
                if pdist([round(xPlus) round(yPlus);oldCentroid])> pdist([round(xMinus) round(yMinus);oldCentroid])
                    plusDirection = 1;
                    break
                else
                    plusDirection = 0;
                    break
                end
            end
            try  im_fish_thresed(round(yPlus),round(xPlus))
            catch err
                disp('Problem in find head...move on to the next fish');
                break;
            end
            try  im_fish_thresed(round(yMinus),round(xMinus))
            catch err
                disp('Problem in find head...move on to the next fish');
                break;
            end
            if (im_fish_thresed(round(yPlus),round(xPlus)) == 1)
                plusDirection = 1;
                break;
            elseif (im_fish_thresed(round(yMinus),round(xMinus))==1)
                plusDirection = 0;
                break;
            end
            count = count+1;
        end

        %Determine exact new location
        syms x_new;
        %Change
        desiredDist = min(min(z))/2;
        eqn = ['(' num2str(center(1)) '-x_new)^2+(' num2str(center(2)) ' -1*(' num2str(m_perpend) ')*x_new-1*(' num2str(c_perpend) '))^2 = ' num2str(desiredDist^2)];
        x_new = solve(eqn);
        if plusDirection
            x_new = min(double(x_new));
        else
            x_new = max(double(x_new));
        end
        y_new = m_perpend*x_new+c_perpend;
        
%         plot(x_new,y_new,'mo');

end

function [im_fish,centroids,labels,numLabels] = myGetCentroids2(im_fish,area_threshold,level)
    thres = (max(max(im_fish))-min(min(im_fish)))/level+min(min(im_fish));
    bw1 = im_fish<thres;

%     figure;imshow(bw1);title('before erode')
    str = strel('disk',4,6);

    imge2 = imerode(bw1,str);
%     figure;imshow(imge2);title('imge2');
    imge2 = bwareaopen(imge2,area_threshold);
    [labels,numLabels] = bwlabel(imge2,8);
    centroids = regionprops(labels,'centroid');
    centroids = cat(1,centroids.Centroid);
end

