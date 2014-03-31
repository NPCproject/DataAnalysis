function dataFrameName = makeDataFrameName(filename)

% DATAFRAMENAME = MAKEDATAFRAMENAME(filename)
%
% This function creates a name for the dataframe based on the filename: 
%
% sl#_d#_w#_ch.tif
%
% The data frame name that is returned is of the format: 
%
% sl#_d#_data
%

nameFields=parsefilename(filename);
dataFrameName = [nameFields{1},'_', nameFields{2}, '_data'];
dataFrameName = char(dataFrameName);