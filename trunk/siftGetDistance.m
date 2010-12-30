function [ dist ] = siftGetDistance(frames1,frames2,matches )
% Berechnet die Abstaende der einzelnen matches
% frames1
% frames2
% matches Falls matches nicht angegeben wird muss size von frames1 und
%         frames2 gleich sein
% dist  gibt einen Abstands Vector zurueck,
%       sum(dist) ist der gesamte Abstand

if(nargin>2) 
    frames1=frames1(1:2,matches(1,:))
    frames2=frames2(1:2,matches(2,:))
else
    if sum(size(frames1)==size(frames2))~=2
        error('die Dimensionen von frames1 und frames2 muessen glech sein, oder matches angeben!')
    end
end

dist= frames1-frames2; % einzelne Abstaende
dist=  sqrt(dist(1,:).*dist(1,:)+dist(2,:).*dist(2,:));% euklidischer Abstand

end

