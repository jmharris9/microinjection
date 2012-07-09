clear all
close all
Ia=imread('Captured4.tif');
Ib=imread('Captured3.tif');

% th = pi/3 ;
% sc = 3;
% c = sc*cos(th) ;
% s = sc*sin(th) ;
% A = [c -s; s c] ;
% T = [- size(Ia,2) ; - size(Ia,1)]  / 2 ;
% 
% tform = maketform('affine', [A, A * T - T ; 0 0  1]') ;
% Ib = imtransform(Ia,tform,'size',size(Ia), ...
%                  'xdata', [1 size(Ia,2)], ...
%                  'ydata', [1 size(Ia,1)], ...
%                  'fill', 255);

% Ia=edge(Ia);
% Ib=edge(Ib);


Ia= single(Ia);
Ib= single(Ib);

[fa, da] = vl_sift(Ia) ;
[fb, db] = vl_sift(Ib) ;
% [matches, scores] = vl_ubcmatch(da, db,1.9) ;

%%




%%
[f,d] = vl_sift(Ia) ;
perm = randperm(size(f,2)) ; 
sel  = perm(1:50) ;
h1   = vl_plotframe(f(:,sel)) ; 

%%
h2   = vl_plotframe(f(:,sel)) ; 

%%
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

%%

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;  
set(h3,'color','g') ;

%%
[matches, scores] = vl_ubcmatch(da, db,2.1) ;

[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

figure(1) ; clf ;
imagesc(cat(2, Ia, Ib)) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(Ia,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 2, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis equal ;
axis off  ;

vl_demo_print('sift_match_1',1) ;


