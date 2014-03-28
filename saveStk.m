function saveStk(imstack, filename, pathname)

% Saves the image stack into the appropriate stack mat file with name: 
% sl#_stks.mat

nameFields = parsefilename(filename); 
matname = strcat(nameFields{1},'.mat');
stkfilename = strcat(nameFields{1},'_stks.mat');
stkName = strcat(filename(1:end-4),'_stk');
eval([stkName '= imstack;']); 

if exist(strcat(pathname, stkfilename), 'file')
    save(strcat(pathname, stkfilename), stkName, '-append'); % This overrides existing stk variables within the sl#_stks.mat file
 else
    save(strcat(pathname, stkfilename), stkName);
end