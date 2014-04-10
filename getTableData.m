function tabledata = getTableData(dataFrame, fieldsList)
%
% TABLEDATA=GETTABLEDATA(dataFrame fieldsList)
%
% This function extracts data from the dataFrame and appends them together
% in a matlab matrix in the order of fields specified in fieldsList. 
%
% dataFrame (struct): data frame structure for each slide&well
% tabledata (array): matrix of cell numbers that will be displayed in GUI
% fieldsList(cell array): specifies the order that the data from dataFrame
%                         should go into the tabledata array

numfields=size(fieldsList,1);
tabledata=[];

%check that all the fields have the same length of data

if fieldSizeParity(dataFrame, fieldsList)

    for i=1:numfields
        currData = getfields(dataFrame, fieldsList{i};    
        tabledata = [tabledata, currData'];
    end
    
else % just set tabledata to blank. This erases all previous data if saved
    
    tabledata=[];
end