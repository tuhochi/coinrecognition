function [matches] = testSIFT( a,b)
%TESTSIFT Summary of this function goes here
%   Detailed explanation goes here
clear
a='coin/euro/020__1999.jpg'
b='coin/euro/020__1999.jpg'

addpath('tools/sift')

I1=imread(a) ;
I1=rgb2gray(I1);

I1=imrotate(I1,45,'crop');
I1=cropCircle(I1);
I1=round(I1*255);


I2=imread(b) ;

I2=rgb2gray(I2);
I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;

fprintf('Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1 ) ;
[frames2,descr2,gss2,dogss2] = sift( I2, 'Verbosity', 1 ) ;
figure(11) ; clf ; plotss(dogss1) ; colormap gray ;
figure(12) ; clf ; plotss(dogss2) ; colormap gray ;
drawnow ;

matches=siftmatch( descr1, descr2 ) ;
fprintf('Matched in %.3f s\n', toc) ;
figure(3) ; clf ;
plotmatches(I1,I2,frames1(1:2,:),frames2(1:2,:),matches) ;
drawnow ;

end

