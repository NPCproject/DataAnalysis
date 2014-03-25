function nameFields = parsefilename (filename)

% All file names should look like: 
% 
% sl#_d#_w#_ch.tif
%
% slide #_ day # _ well # _ ch
%
% This function will return a cell array, nameFields, with the parsed strings

% Remove '.tif' from filename
name = strrep(filename, '.tif', '');

indices = regexp(name, '_');
indices = [1,indices,length(name)];

nameFields = cell(4,1);

for i=1:(length(indices)-1)

   currField = name(indices(i):indices(i+1));
   nameFields{i} = strrep(currField,'_', '');
   
end

