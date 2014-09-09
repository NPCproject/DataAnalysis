function [outlierData procData] = analyzeData(pathname, procmatname, CortANames, varargin)

% [OUTLIERDATA PROCDATA] = ANALYZEDATA(PATHNAME, PROCMATNAME, CORTANAMES, VARARGIN)
% 
% This function will take in a number of dataframes from different
% wells, and filter out the outliers.  

%% Keep track of dataframes used in this analysis, store names in wellNames

n = length(varargin);

procData.wellNames = cell(1,n);
for i = 1:n
    procData.wellNames{i}=inputname(i+3);
end

%% Concatenate all data

alldata = [varargin{1:end}];
names = fieldnames(alldata);
cellData = cellfun(@(f) {horzcat(alldata.(f))},names);
alldata = cell2struct(cellData,names);


%% filter outliers

[filteredData outlierData] = filterOutliers(alldata, CortANames);


%% categorize d0 NPC/Astr condition

d0data = filteredData.numNPCs_d0;
numPatterns = size(d0data,2);

for i=CortANames

    d0data = vertcat(d0data, eval(['filteredData.num' i{1} '_d0']));

end

procData.labels = cell(1,numPatterns);

for i=1:numPatterns
    
    label=[num2str(d0data(1,i)) 'NPC'];
    
    for j=1:length(CortANames)
        
        label= [label '_' num2str(d0data(1+j, i)) CortANames{j}];
        procData.labels{i}=label;
    end
end

allCategories = unique(procData.labels);

%% calculate ratio of d0NPC/d0Astr

procData.ratio = filteredData.numNPCs_d0./eval(['filteredData.num' CortANames{1} '_d0']);


%% characterize proliferation: total NPCs at d6/NPC_d0

procData.prolif = filteredData.numNPCs_d6./filteredData.numNPCs_d0;

for i=1:length(CortANames)
    
    eval(['procData.' CortANames{i} 'prolif = filteredData.num' CortANames{i} '_d6./filteredData.num' CortANames{i} '_d0;']);
end


%% categorize patterns as [0: none] [1: all Tuj1] [2: all GFAP] [3: mixed]

procData.category = zeros(1,numPatterns);

for i = 1:numPatterns
    
    totalnum = filteredData.numNPCs_d6(i);
    numTuj1 = filteredData.numTuj1_d6(i);
    numGFAP = filteredData.numGFAP_d6(i);
    numUnst = filteredData.numUnst_d6(i);
    numDbl = filteredData.numDbl_d6(i);
    
    stainednum = totalnum - numUnst - numDbl;
    
    if totalnum==0
        
        procData.category(i)=NaN;
        
    elseif stainednum==0
        
        procData.category(i)=0;
        
    elseif stainednum == numTuj1
        
        procData.category(i)=1;
        
    elseif stainednum == numGFAP
        
        procData.category(i)=2;
        
    else
        
        procData.category(i)=3;
        
    end
    
end

procData=catstruct(procData, filteredData);


%% Save procdata, outlierdata, and filteredData

save([pathname procmatname], 'procData', 'outlierData');






