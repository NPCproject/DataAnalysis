function dataFrameName = makeDataFrameName(filename)

% Simple script that returns the dataFrameName. Acceptable filenames
% include any file name that begins with sl_w1

nameFields=parsefilename(filename);
dataFrameName = [nameFields{1},'_', nameFields{2}, '_data'];
dataFrameName = char(dataFrameName);