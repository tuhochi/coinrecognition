function [ r ] = siftGetRotation( matches,frames1,frames2,center)
%SIFTGETROTATION Summary of this function goes here
%   Detailed explanation goes here

if size(matches,2)==0
    error('Es wurden keine matches ermittlet');
end


f1 = frames1(1:2,matches(1,:)); % die einzelne match - Frames1
f2 = frames2(1:2,matches(2,:)); % die einzelne match - Frames2

for r=0:359


    for i = 1:size(f1,2)%Rotation der Punkte berechnen
        f2r(:,i)= rotatePoint(f2(1:2,i)',center,r)';
    end
    
        d=siftgetDistance(f1,f2r);
        d=sort(d);
        
        if(length(d)<3)
            warning('Sehr wenige Uebereinstimmungen gefunden!');
        end
        % wenn unter 12 dann alle oder 60% der Wichtisten werden herangenommenmehr  der Abstaende wird als Fehler angenommen
       
        if(length(d)<12)
            wichtige=length(d), % alle sind hoffentlich wichtig
        else
            wichtige=round(length(d)*0.6)% oder wenn viele dann 60%
        end
        
        d=sum(d(1:wichtige));
        
    dist(r+1)=d;
end

h=[1:size(dist,2)]; % Hilfs Vector
r=max((dist==min(dist)).*h)-2;% r= optimale Rotation