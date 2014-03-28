function setupWellDataFrame(filename, pathname)

% This function creates a data frame for the well specified in the
% filename, which has the format sl#_w#_d#_ch.tif. 

% Parse the filename to figure out the name of the data frame variable we
% will make for this well. The name of the data frame variable should be:
% sl#_w#_data 

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

