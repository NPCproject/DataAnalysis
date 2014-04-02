function x = fieldSizeParity(dataFrame, varargin)
% 
% X = FIELDSIZEPARITY(dataStruct, varargin);
% 
% This function checks to see whether the fields specified in varargin
% (list of strings) are equal in size. 
%
% dataFrame (structure) : data frame created by createBlankDataFrame
% varargin (cell array) : strings that specify the fields in dataFrame
% x (bool): returns true if all fields are the same size. 

sizearray=cell(nargin-1,1);

for i=1:(nargin-1)
    
    value = getfield(dataFrame, varargin{i});
    sizearray{i} = size(value);
    
end

sizearrayoffset = {sizearray{2:end}, sizearray{1}}; % shift the array by one cell
    
x = isequal(sizearray, sizearrayoffset); % if all cells are the same value, this returns true