function video_taker(v1,v2)
global img
global video_taking_NO
global conversion
% 
% j=0;
% tic
% if 1<2
%     j=j+1;
%     AcumularValores(j)=sum(img(:));
%     AcumularTiempos(j)=toc;

    % center spot for tip alignment

    if conversion==1
        n=1;
        while n<=(video_taking_NO-2)
            file_name=['video_image_' num2str(n)];
            load(file_name, 'img')
            imshow(img)
            pause(0.001)
            Mov(n)=getframe;
            n=n+1
%             M(n)= im2frame(file_name);
%           mov = addframe(mov,F);
        end
        conversion=0;
        movie(Mov)
        save 'Mov.mat' Mov
        movie2avi(Mov,'Mov.avi','fps', 4)
        return
    end
    %     img = imadjust(img);
    img=ProsilicaCamera('singleAcquire');
    file_name=['video_image_' num2str(video_taking_NO)];
    save(file_name, 'img')
    video_taking_NO=video_taking_NO+1;
    imshow(img)
    pause(0.001)
    % end
    


end
