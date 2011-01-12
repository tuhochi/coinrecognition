function [ dist ] = getFeatureDistance( f1,f2 )
%GETFEATUREDISTANCE Summary of this function goes here
%   Detailed explanation goes here

dist=[];
for i=1:size(f2,1)
    dist=[dist; sqrt(sum((f1-f2(i,:)).^2))];
end

end

