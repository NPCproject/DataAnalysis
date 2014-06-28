function [filteredData outlierData] = filterOutliers(dataFrame, CortANames)

% FILTEROUTLIERS returns a dataFrame that has the outliers removed
% 
% [filteredData outlierData] = filterOutlier(dataFrame, CortANames)
%
% There are three criteria for outliers: 
%
% 1. Tuj1+ field at day 6 = 99 (user says pattern is unquantifiable).
% 2. no NPCS or CortA at day 0
% 3. total NPC loss: the pattern has NPCs at day 0, but no NPCs at day 6
% 4. total CortA loss: the pattern has CortA (of any kind) at day 0, but no CortA at day 6
% 5. NPC gain: the pattern has no NPCs at day 0 but NPCs at day 6 
% 6. CortA gain: the pattern has no CortA (of any kind) at day 0, but CortA at day 6 
%
% dataFrame (struct): input data structure (i.e. sl21_w1_data);
% CortANames (cell array): specifies names of CortA in experiment. Usually 
%            one, but possibly two types of CortA
% filteredData (struct): same fields, just with outliers removed
% outlierData (struct): add these fields: 
%  unQuant_Ind: indices of patterns with 99 in numTuj1_d6
%  unQuant_num:  
%  unQuant_perc: 
%  NPCLoss_Ind: indices of patterns that lose NPCs by d6
%  NPCLoss_num: 
%  NPCLoss_perc:
%  CortALoss_Ind: indices of patterns that lose all CortA by d6
%  CortALoss_num: 
%  CortALoss_perc: 
%  NPCGain_Ind: indices of patterns that gain NPCs by d6(0 at d0)
%  NPCGain_num:     
%  NPCGain_perc:
%  CortAGain_Ind: indices of patterns gain CortA by d6(0 at d0)
%  CortAGain_num:
%  CortAGain_perc: 


totalnum = length(dataFrame.numTuj1_d6);
numCortAs = length(CortANames);

%% Find the following indices: 

unQuantIndices = find(dataFrame.numTuj1_d6==99|dataFrame.numNPCs_d0==00); % also if the day 0

d0NPCs = find(dataFrame.numNPCs_d0>0);
d0ZeroNPCs = find(dataFrame.numNPCs_d0==0);
d6NPCs = find(dataFrame.numNPCs_d6>0);
d6ZeroNPCs = find(dataFrame.numNPCs_d6==0);

for i = 1:length(CortANames)
    
    d0CortA{i} = eval(['find(dataFrame.num' CortANames{i} '_d0>0)']);
    d0ZeroCortA{i} = eval(['find(dataFrame.num' CortANames{i} '_d0==0)']); 
    d6CortA{i} = eval(['find(dataFrame.num' CortANames{i} '_d6>0)']);
    d6ZeroCortA{i} = eval(['find(dataFrame.num' CortANames{i} '_d6==0)']);

end



%% Criteria 1: user says the pattern is unquantifiable

outlierData.unQuant_Ind = unQuantIndices;
outlierData.unQuant_num = length(outlierData.unQuant_Ind);
outlierData.unQuant_perc = outlierData.unQuant_num/totalnum;


%% Criteria 2: no NPCs and no CortA at day 0 -> no cells

noCellIndices = d0ZeroNPCs;

for i=1:numCortAs
    
    noCellIndices = intersect(noCellIndices, d0ZeroCortA{i});

end

outlierData.NoCell_Ind = setdiff(noCellIndices, unQuantIndices); % remove all cases in which Criteria 1 was already applied
outlierData.NoCell_num = length(outlierData.NoCell_Ind);
outlierData.NoCell_perc = outlierData.NoCell_Ind/totalnum;


%% Criteria 3: no NPCs at day 6 -> NPC loss

NPCLossIndices = intersect(d0NPCs,d6ZeroNPCs);

outlierData.NPCLoss_Ind = setdiff(NPCLossIndices, unQuantIndices); % remove all the cases in which Criteria 1 was already applied
outlierData.NPCLoss_num = length(outlierData.NPCLoss_Ind);
outlierData.NPCLoss_perc = outlierData.NPCLoss_num/totalnum;


%% Criteria 4: no CortA at day 6 -> CortA loss 

CortALossIndices = [];

for i=1:numCortAs
    
    currCortALossIndices = intersect(d0CortA{i}, d6ZeroCortA{i});
    CortALossIndices = [CortALossIndices,currCortALossIndices];

end

outlierData.CortALoss_Ind = setdiff(CortALossIndices, unQuantIndices); % remove all the cases in which Criteria 1 was already applied
outlierData.CortALoss_num = length(outlierData.CortALoss_Ind);
outlierData.CortALoss_perc = outlierData.CortALoss_num/totalnum;


%%%%%
%%Start Editing from Here
%%%%%%%




%% Criteria 5: no NPCs at day 0 but NPCs at day 6 -> NPC gain

NPCGainIndices = intersect(d0ZeroNPCs,d6NPCs);

outlierData.NPCGain_Ind = setdiff(NPCGainIndices, unQuantIndices); % remove all the cases in which Criteria 1 was already applied
outlierData.NPCGain_num = length(outlierData.NPCGain_Ind);
outlierData.NPCGain_perc = outlierData.NPCGain_num/totalnum;


%% Criteria 6: no CortA at day 0, but CortA at day 6 -> CortA gain 

CortAGainIndices=[];

for i=numCortAs
    
    currCortAGainIndices = intersect(d0ZeroCortA{i},d6CortA{i});
    CortAGainIndices = [CortAGainIndices,currCortAGainIndices];
    
end

outlierData.CortAGain_Ind = setdiff(CortAGainIndices, unQuantIndices); % remove all the cases in which Criteria 1 was already applied
outlierData.CortAGain_num = length(outlierData.CortAGain_Ind);
outlierData.CortAGain_perc = outlierData.CortAGain_num/totalnum;

%% Combine all indices together

filterOutIndices = unique([unQuantIndices, NPCLossIndices, CortALossIndices, NPCGainIndices, CortAGainIndices]);

% remove all data with these indices

names = fieldnames(dataFrame);

for i = 1:length(names)
    
    currVector = eval(['dataFrame.' names{i}]);
    
    if any(currVector) && (max(filterOutIndices)<=totalnum) % requires currVector to at least have some nonzero values (i.e. not just 0's concatenated) 
    
        currVector(filterOutIndices)=[]; % remove all elements at these indices
        eval(['dataFrame.' names{i} ' = currVector']);

    end
    
end

filteredData = dataFrame;

    

