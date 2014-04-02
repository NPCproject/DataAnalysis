function stksMatName = makeStksMatName(filename)

% STKSMATNAME = MAKESTKSMATNAME(filename)
%
% This function creates a name for the stk mat file based on the filename: 
%
% sl#_d#_w#_ch.tif
%
% The stks mat filename that is returned is of the format: 
%
% sl#_stks.mat
%

nameFields=parsefilename(filename);
stksMatName = [nameFields{1}, '_stks.mat'];
stksMatName = char(stksMatName);