function matName = makeMatName(filename)

% MATNAME = MAKEMATNAME(filename)
%
% This function creates a name for the data mat file based on the filename: 
%
% sl#_d#_w#_ch.tif
%
% The data mat filename that is returned is of the format: 
%
% sl#.mat
%

nameFields=parsefilename(filename);
matName = [nameFields{1}, '.mat'];
matName = char(matName);