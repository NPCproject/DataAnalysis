function [efficiency occupancy] = calcEff (dataFrame, CortANames)

%
% EFFICIENCY = CALCEFF (DATAFRAME, CORTANAMES)
% 
% This function calculates the efficiency for a particular dataFrame. 
%


n = length(CortANames)+1;

%% Calculate efficiency statistics

d0matrix = dataFrame.numNPCs_d0;
d0occupancymatrix = d0matrix>0 & d0matrix<99;

for i=1:length(CortANames)
    
    currField = ['num' CortANames{i} '_d0'];
    currRow = getfield(dataFrame, currField);
    currOccupancyRow = currRow>0 & currRow<99;
    
    d0matrix = [d0matrix; currRow];
    d0occupancymatrix = [d0occupancymatrix; currOccupancyRow];
end

% Transpose matrix 

d0matrix = d0matrix';
d0occupancymatrix = d0occupancymatrix';

% Calculate efficiencies

if n==1
    
    effIndices = ismember(d0matrix,1,'rows');
    occIndices = ismember(d0occupancymatrix,1,'rows');
    
elseif n==2
    
    effIndices = ismember(d0matrix, [1 1], 'rows');
    occIndices = ismember(d0occupancymatrix, [1 1], 'rows');
   
elseif n==3
    
    effIndices = ismember(d0matrix,[1 1 1], 'rows');
    occIndices = ismember(d0occupancymatrix, [1 1 1], 'rows');
    
end


efficiency = sum(effIndices)/size(d0matrix,1);
occupancy = sum(occIndices)/size(d0occupancymatrix, 1);
