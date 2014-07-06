function combineDataFrames(d0matname, d6matname, pathname)

% COMBINEDATAFRAMES(D0MATNAME, D6MATNAME, PATHNAME)
% 
% combines the two data frames from d0 and d6. 
% 


%first load the d0 matname

d0matslide = parsefilename(d0matname);
d0matslide=d0matslide{1};
d6matslide=parsefilename(d6matname);
d6matslide=d6matslide{1};

if ~isequal(d0matslide,d6matslide)
    error('Not the same slide');
end

%first load the d0 data and rename

load([pathname d0matname]);

eval([d0matslide '_w1_data_d0=' d0matslide '_w1_data;']);
eval([d0matslide '_w2_data_d0=' d0matslide '_w2_data;']);
eval([d0matslide '_w3_data_d0=' d0matslide '_w3_data;']);
eval([d0matslide '_w4_data_d0=' d0matslide '_w4_data;']);

% then load all the d6 data and retain the name

load([pathname d6matname]);

% go through all d0 fields and set them equal to d0 fields in d0.mat file

allfields=fieldnames(eval([d0matslide '_w1_data_d0']));

indices = strfind(allfields,'d0'); %find all indices for 0 fields
indices = cellfun('isempty',indices);
indices = ~indices; % creates a vector with 0 if the field has no 'd0' in it

for i = 1:length(indices)
    
    if indices(i)>0
        
        currfieldname=allfields{i};
        
        eval([d0matslide '_w1_data.' currfieldname '=' d0matslide '_w1_data_d0.' currfieldname ';']);
        eval([d0matslide '_w2_data.' currfieldname '=' d0matslide '_w2_data_d0.' currfieldname ';']);
        eval([d0matslide '_w3_data.' currfieldname '=' d0matslide '_w3_data_d0.' currfieldname ';']);
        eval([d0matslide '_w4_data.' currfieldname '=' d0matslide '_w4_data_d0.' currfieldname ';']);
        
    end
end

%save the data

save([pathname d0matslide '.mat'], [d0matslide '_w1_data'], [d0matslide '_w2_data'], [d0matslide '_w3_data'], [d0matslide '_w4_data']);


