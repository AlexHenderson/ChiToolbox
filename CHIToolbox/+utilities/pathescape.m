function str = pathescape(str)

%PATHESCAPE  Replace single slash with double slash

str = strrep(str,'\','\\');

end
