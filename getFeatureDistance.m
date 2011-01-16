function [ dist ] = getFeatureDistance( f1,f2 )
%getFeatureDistance Ermittelt die euklidische Disatnz eines Vektors zum TrainingSet.  
%
%   getFeatureDistance( f1,f2 )
%                       Es wird die euklidische Distanz eines Vektors zeilenweise zum 
%                       TrainingsSet berechnet. Elementweise wird die
%                       Differenz gebildet, diese wird quadriert und
%                       anschliessend aufsummiert.
%                       Zuletzt wird die Wurzel aus der Summe gezogen.
%
% I/O Spec
%   f1     Vektor dessen Distanz zum TrainingsSet berechnet werden soll
%               
%
%   f2     TrainingsSet welches zur Distanzberechnung herangezogen wird
%
%
%   dist   Distanz des Vektors zu den einzelnen Zeilen der Trainingsdaten


dist=[];
for i=1:size(f2,1)
    dist=[dist; sqrt(sum((f1-f2(i,:)).^2))];
end

end

