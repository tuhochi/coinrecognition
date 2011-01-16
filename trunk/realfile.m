function [v] = realfile(filename)
%realfile Ueberprueft ob die Datei eine moeglicheBilddatei ist.  
%
%   realfile(filename)
%                       Es wird ueberprueft ob eine Datei, die sich im
%                       Ordner 'TrainingSet' oder 'TestSet' befindet, eine
%                       moegliche Bilddatei ist.
%                       Wenn dies der Fall ist wird 'true'
%                       zurueckgeliefert, ansonst 'false'.
%
%
% I/O Spec
%   filename     Pfad der zu ueberpruefenden Datei
%               
%
%   v           1: es handelt sich um eine moegliche Bilddatei
%               0: es handelt sich um keine Bilddatei

    [pathstr,name,ext] = fileparts(filename);
    v=0;
    if ~strcmp(filename,'.svn')
        if ~strcmp(filename,'.DS_Store') 
            if ~strcmp(filename,'Thumbs.db') 
                if ~strcmp(ext,'.mat')
                    v=1;
                end
            end
        end

    end

end
