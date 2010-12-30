function [ newpoint ] = rotatePoint(p,c,a)
% Diese Funktion rotiert einen Punkt um den angegebenen Mittelpunkt
% (karthesisches Koordinatensystem) mit dem Winkel a im Uhrzeigersinn
% p ist der Punkt [x y] Zeilenvector
% c ist der Mittelpunkt [x y] Zeilenvector
% a ist der Rotationswinkel

    if p(1)== c(1) && p(2)==c(2)
        newpoint=p;
        return;
    end

    pold=p;
    cold=c;

    p=pold-cold; % Verschiebung zum Ursprung;
    r=norm(p); % Abstand zum Mittelpunkt == der Radius des Punktes
    pnorm=p./r; % Normierung auf Einheitskreis
    xsin=asin(pnorm(2))/(pi/180);
    ysin=asin(pnorm(1))/(pi/180);
    
    if pold(1)<cold(1) 
        x= sin((xsin-a)*(pi/180));
    else
        x= sin((xsin+a)*(pi/180));
    end
    
    if pold(2)<cold(2)
        y= sin((ysin+a)*(pi/180));
    else
        y= sin((ysin-a)*(pi/180));
    end

    newpoint=[y*r+cold(2),x*r+cold(1)];

end

