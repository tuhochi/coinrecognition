function [ result ] = calculator( labeling )
%calculator Berechnet die Summe der einzelen Muenzen
%
%   calculator( labeling )
%                       Durch die einzelenen Labelings wird die Summe der
%                       Meunezen berechnet.
%
%
% I/O Spec
%   labeling    Labeling der einzelnen Muenzen           
%
%   result      Summe der Muenzen

%Labeling laden
load LabelStruct

erg=0;
for i=1:size(labelingStruct,1)
    
    %Indexing
    index=find(labeling==i);
    
    %Anzahl der einzelnen Labels
    if isempty(index)
        count=0;
    else
        count=size(index,1);
    end
    
    erg=erg+count*labelingStruct{i,2};
end

%Euro
%euro=floor(double(erg));
%Cent
%cent=(erg-euro)*100;

%result= [num2str(euro) ' Euro ' num2str(cent) ' Cent'];
result= [num2str(erg) ' Euro'];

end

