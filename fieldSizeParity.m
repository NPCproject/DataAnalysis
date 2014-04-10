function x = fieldSizeParity(dataFrame, fieldsList)
% 
% X = FIELDSIZEPARITY(dataStruct, fieldsList);
% 
% This function checks to see whether the fields specified in varargin
% (list of strings) are equal in size. 
%
% dataFrame (structure) : data frame created by createBlankDataFrame
% fieldsList (cell array) : strings that specify the fields in dataFrame
% x (bool): returns true if all fields are the same size. 


numfields=size(fieldsList,2);
sizearray=cell(1, numfields);

for i=1:numfields
    
    value = getfield(dataFrame, fieldsList{i});
    sizearray{i} = size(value);
    
end

sizearrayoffset = {sizearray{2:numfields}, sizearray{1}}; % shift the array by one cell
    
x = isequal(sizearray, sizearrayoffset); % if all cells are the same value, this returns true