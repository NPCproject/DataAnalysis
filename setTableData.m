function dataFrame = setTableData(tabledata, dataFrame, fieldsList)
% dataFrame=setTableData(tabledata, dataFrame, fieldsList)
%
% This function saves each column of data from tabledata into the
% corresponding field in the dataFrame structure. 
%
% dataFrame (struct): data frame structure for each slide&well
% tabledata (m x n): matrix of data from GUI
% fieldsList (cell array of char): cell array of field names that specifies each column of data in tabledata, in order  
%


numfields=size(fieldsList,2);

for i=1:numfields
    
    fieldName = fieldsList{i};
    currDataVector = tabledata(:,i)';
    eval(['dataFrame.' fieldName '= currDataVector;']);

end
