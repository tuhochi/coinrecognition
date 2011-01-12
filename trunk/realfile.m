function [v] = realfile(filename)
    v=0;
    if ~strcmp(filename,'.svn')
        if ~strcmp(filename,'.DS_Store') 
            if ~strcmp(filename,'Thumbs.db') 
                v=1;
            end
        end

    end

end
