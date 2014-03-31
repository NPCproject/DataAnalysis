function setupWellDataFrame(filename, pathname)

% SETUPWELLDATAFRAME(filename, pathname)
% 
% This function creates a data frame for the well specified in the
% filename (sl#_w#_d#_ch.tif) and stores in the corresponding data mat file
% (sl#.mat). 
%
% First, the function parses the filename to compose the name of the
% data frame variable to make for this well(sl#_w#_data). Then it checks
% for the existence of the data mat file for this slide. If the data mat
% file does not exist, it creates the mat file and also saves the empty
% data frame into the mat file. If the data mat file does exist, it loads
% the file and creates an empty data frame if one does not already exist. 

nameFields = parsefilename(filename);
dataFrameName = makeDataFrameName(filename);
matname = strcat(nameFields{1},'.mat');

% Check for existence of matfile storing tabulated data

matExist = exist([pathname, matname], 'file');
    
if exist([pathname, matname], 'file')
    
    % Load the data mat file and check for the existence of the data frame
    % for sl#_w#_data
    
    load([pathname, matname], '.mat');
    dataFrameExist = exist(dataFrameName, 'var');
    
    if dataFrameExist
        display(['Data frame for ', nameFields{1}, ' and well ', nameFields{2}, ' already exists.']);
        return;
    else
         dataFrame = createBlankDataFrame();
         eval([dataFrameName, '=dataFrame;']);
         save([pathname, matname], dataFrameName, '-append');
    end
        
else
    
    %If the data mat file does not exist, we should create a new one: 
    
    dataFrame = createBlankDataFrame();
    eval([dataFrameName, '=dataFrame;']);
    save([pathname, matname], dataFrameName);
    
end

