function [v] = realfile(filename)

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
