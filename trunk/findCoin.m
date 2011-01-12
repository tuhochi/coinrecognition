function [ output_args ] = findCoin( image )
%FINDCOIN Summary of this function goes here
%   Detailed explanation goes here

i = imread('coin/euro/1cent/euro-cent-stueck.jpg');


% 2 Euro
i2e002 = imread('coin/euro/2euro/2007.jpg');
i2e003 = imread('coin/euro/2euro/AT_2002.jpg');
% 1 Euro
i2e004 = imread('coin/euro/1euro/1999.jpg');
i2e005 = imread('coin/euro/1euro/AT_2002.png');
% 50 Cent
i2e006 = imread('coin/euro/50cent/1999.jpg');
i2e007 = imread('coin/euro/50cent/AT_2002.png');
% 10 Cent
i2e008 = imread('coin/euro/10cent/1999.jpg');
i2e009 = imread('coin/euro/10cent/AT_2002.png');
% 5 Cent
i2e010 = imread('coin/euro/5cent/1999.jpg');
i2e011 = imread('coin/euro/5cent/AT_2002.png');
% 1 Cent
i2e012 = imread('coin/euro/1cent/1999.jpg');
i2e013 = imread('coin/euro/1cent/AT_2002.png');


[img1,diff1]=rotateImageWithSIFT(i,i2e002);
[img2,diff2]=rotateImageWithSIFT(i,i2e003);
[img3,diff3]=rotateImageWithSIFT(i,i2e004);
[img4,diff4]=rotateImageWithSIFT(i,i2e005);
[img5,diff5]=rotateImageWithSIFT(i,i2e006);
[img6,diff6]=rotateImageWithSIFT(i,i2e007);
[img7,diff7]=rotateImageWithSIFT(i,i2e008);
[img8,diff8]=rotateImageWithSIFT(i,i2e009);
[img9,diff9]=rotateImageWithSIFT(i,i2e010);
[img10,diff10]=rotateImageWithSIFT(i,i2e011);
[img11,diff11]=rotateImageWithSIFT(i,i2e012);
[img12,diff12]=rotateImageWithSIFT(i,i2e013);

d=[diff1
diff2
diff3
diff4
diff5
diff6
diff7
diff8
diff9
diff10
diff12
]

end
