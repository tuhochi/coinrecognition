function [ reImg ] = reconstructImg( coeff, columns )
%RECONSTRUCTIMG Summary of this function goes here
%   Detailed explanation goes here


index=linspace(1,size(coeff,2),size(coeff,2));
index=bsxfun(@minus,index,1);

reImg=[];
for row=1:size(coeff,1)
    reImgRow=[];
    for j=0:(columns-1)
        e=exp(2j*pi/columns*index*j);
        yj=coeff(row,:)*e';
        reImgRow=[reImgRow, yj];
    end
    reImg=[reImg; reImgRow];
end

end

