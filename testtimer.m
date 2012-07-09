function testtimer(v1,v2)
global img
global h3
% 
% j=0;
% tic
% if 1<2
%     j=j+1;

    img=ProsilicaCamera('singleAcquire');
%     AcumularValores(j)=sum(img(:));
%     AcumularTiempos(j)=toc;

    % center spot for tip alignment
    img(256,256)=255;
    img(255,256)=0;
    img(257,256)=0;
    img(256,255)=0;
    img(256,257)=0;
    
    %img = imadjust(img);
    imshow(img)
% set(h3,'cdata',img)
    pause(0.001)
% end

end