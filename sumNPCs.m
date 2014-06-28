function sumNPCs(matname, pathname, wellnumber)

% SUMNPCS(matname, pathname, wellnumber) 
% 
% This function populates the numNPCs_d6 field in all the data structures
% for each well in the file designated by matname. The function also
% extends all data fields with [0] out to the maximum length. 
% 
% matname (string): name of the mat file
% pathname (string): path
% wellnumber(array): array of well numbers (i.e. 1:4)
%

load([pathname, matname]);

currWellName = [matname(1:end-4) '_w' num2str(wellnumber) '_data'];
currWell = eval(currWellName);

allfieldnames = fieldnames(currWell);
d6NPCfieldnames = {'numTuj1_d6', 'numGFAP_d6', 'numDbl_d6', 'numUnst_d6'};

currLength = length(getfield(currWell, d6NPCfieldnames{1}));

allvectors = cellfun(@(x) getfield(currWell, x), d6NPCfieldnames, 'UniformOutput', false);
allvectors = [allvectors{1:4}];

reshapedMatrix = reshape(allvectors, currLength,4)';
totalNPCs = sum(reshapedMatrix,1);
currWell.numNPCs_d6 = totalNPCs;

% Extend all other fields to maximum length

emptylist = structfun(@(x) isequal(mean(x),0), currWell); % find all frames where field = 0 or list of 0s
emptyindices = emptylist.*[1:length(emptylist)]';
emptyindices(emptyindices==0)=[];

for i=1:length(emptyindices)
    
    currWell = setfield(currWell, allfieldnames{emptyindices(i)}, zeros(1,currLength));
    
end

% Rename currWell to original well name
eval([currWellName ' = currWell;']);


% Save into original filename
save([pathname, matname], currWellName, '-append');

