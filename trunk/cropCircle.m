function [ opimg ] = cropCircle( i )
%CROPCIRCLE Summary of this function goes here
%   Detailed explanation goes here

dim=max([size(i,1),size(i,1)]);%% x/y Dimension der quadratischen Bild Matrix
r=round(dim/2);

[u v]= meshgrid(0:dim-1,0:dim-1);
raster=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.99);%% quadratische Raster Matrix mit 0/1 Einraegen

img = zeros(dim,dim,size(i,3));%% quadratische Bild Matrix img mit 0 initialisiert

dim1=round((dim-size(i,1))/2)+1:round((dim-size(i,1))/2)+size(i,1);
dim2=round((dim-size(i,2))/2)+1:round((dim-size(i,2))/2)+size(i,2);
img(dim1,dim2,:)=i(:,:,:);%% ursprungsbild in quadratisches 0-Bild einfuegen

opimg(:,:)=img(:,:).*raster;
%opimg(:,:,2)=img(:,:,2).*raster;
%opimg(:,:,3)=img(:,:,3).*raster;

end
