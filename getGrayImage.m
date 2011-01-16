function [ gray ] = getGrayImage(image,type)
%getGrayImage Liefert einen bestimmten Farbkanal eines Bildes als Grauwertbild.  
%
%   getGrayImage(image,type)
%                       Ein Bild wird je nach Wahl in ein reines
%                       Grauwertbild oder in ein Grauwertbild eines
%                       einzelnen Farbkanales umgewandelt.
%
%
% I/O Spec
%   image       Das Bild, welches umgewandelt werden soll.
%               
%
%   type        0: Ein Grauwertbild wird zuruckgeliefert.
%               1: Der Rot-Kanal eines Bildes wird zuruckgeliefert.
%               2: Der Gruen-Kanal eines Bildes wird zuruckgeliefert.
%               3: Der Blau-Kanal eines Bildes wird zuruckgeliefert.


if nargin<2
    type=0;
end

% wenn es sich um einen Pfad handlet
if ischar(image) %Laden des Images
    image = imread(image);
end


if(size(image,3)==3)
    
    switch type
        case 0% normales Grauwertbild
            image=rgb2gray(image);
        case 1% Grauwertbild des rot-Kanals
            image=image(:,:,1);
        case 2% Grauwertbild des gruen-Kanals
            image=image(:,:,2);
        case 3% Grauwertbild des blau-Kanals
            image=image(:,:,3);
    end
            
end

gray=image;

end