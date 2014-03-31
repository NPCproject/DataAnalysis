function nameFields = parsefilename (filename)

% NAMEFIELDS = PARSEFILENAME(filename)
%
% This function parses the file name of format: 
% 
% sl#_d#_w#_ch.tif
%
% slide #_ day # _ well # _ ch
%
% This function will return a cell array, nameFields, with the strings
% between the _ delimiters. 
% 
% For example, nameFields = parsefilename('sl22_d0_w1_TL.tif') will return
%
% nameFields{1} = 'sl22'
% nameFields{2} = 'd0'
% nameFields{3} = 'w1'
% nameFields{4} = 'TL'


% Remove '.tif' from filename
name = strrep(filename, '.tif', '');

indices = regexp(name, '_');
indices = [1,indices,length(name)];

nameFields = cell(4,1);

for i=1:(length(indices)-1)

   currField = name(indices(i):indices(i+1));
   nameFields{i} = strrep(currField,'_', '');
   
end

