function [ output_args ] = whitePatch( input_args )
%WHITEPATCHRETINEX Summary of this function goes here
%   Detailed explanation goes here
clear
imgName ='coin/shoot/IMG_6829_02.jpg';

%Laden des Images
image = imread(imgName);


h = fspecial('gaussian',30,30);
blur=imfilter(image,h);
figure(1)
subplot(2,1,1)
imshow(image)

% Image bluring for an average Patch
mi(1:3)=min(min(blur(:,:,:)))
% set minimum of image to min
newimage=image;
newimage(:,:,1) = newimage(:,:,1)-mi(1);
newimage(:,:,2) = newimage(:,:,2)-mi(2);
newimage(:,:,3) = newimage(:,:,3)-mi(3);


ma(1:3)=max(max(blur(:,:,:)))

subplot(2,1,2)
newimage(:,:,1) = newimage(:,:,1).*(255/double(ma(1)));
newimage(:,:,2) = newimage(:,:,2).*(255/double(ma(2)));
newimage(:,:,3) = newimage(:,:,3).*(255/double(ma(3)));
imshow(newimage)


figure(2)
imshow(newimage-image)

end

