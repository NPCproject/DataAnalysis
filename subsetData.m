function subDataFrame = subsetData(dataFrame, GroupName)

%
% SUBDATAFRAME = SUBSETDATA(DATAFRAME, GROUPNAME)
% 
% This function subsets the data from a dataFrame with a particular label
% (i.e. 0NPC_1CortA or 1NPC_1EfnA)
% 

indicesToKeep = strcmp(dataFrame.labels, GroupName);
maxlength=length(dataFrame.labels);
allfieldnames = fieldnames(dataFrame);

for i=1:length(allfieldnames)
    
    currFieldData = getfield(dataFrame,allfieldnames{i});
    currFieldLength = length(currFieldData);
    
    %check length of field is the same as procData
    if currFieldLength == maxlength
        
        newFieldData = currFieldData(indicesToKeep);
        dataFrame = setfield(dataFrame, allfieldnames{i}, newFieldData);

    end
    
end

subDataFrame = dataFrame;
        