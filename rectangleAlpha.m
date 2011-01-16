function [] = rectangleAlpha(position,alpha,color)
%classifyCoin Bereits segmentierte Muenzen werden klassifiziert und das Ergebnis wird angezeigt.  
%
%   rectangleAlpha(position,alpha,color)
%                       Zeichnet ein transparentes Rechteck mit
%                       strichpunktiertem Rand
%
%
% I/O Spec
%   position    Vektor [x,y,dx,dy] ausgehend von der linken oberen Ecke des
%               Rechteckes
%               
%
%   alpha       Transparenz des Hintergrundes
%
%
%   color       Farbe des Hintergrundes

x=position(1);
y=position(2);
dx=position(3);
dy=position(4);

p=patch([x x+dx x+dx x],[y y y+dy y+dy],color);
set(p,'FaceAlpha',alpha,'LineStyle',':');

end

