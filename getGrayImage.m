function [ gray ] = getGrayImage(image,type)
% es wir ein Bild in ein gauwert-Bild umgesandelt
% image kann ein Pfad, oder ein Farbbild sein
% gray ist das gauwert-Bild
% type: 0 normales graubild, 1: rot-Kanal, 2: gruen-Kanal, 3: blau-kanal, all other: farbbild 
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