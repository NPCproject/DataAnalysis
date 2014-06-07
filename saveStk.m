function saveStk(imstack, filename, pathname)

% SAVESTK(imstack,filename,pathname)
%
% Takes in a cropped image stack from the cropper() function and saves the
% image stack into the appropriate stack mat file (sl#_w#_stks.mat). The
% stkname will be sl#_w#_d#_ch_stk (which is the original filename
% concatenated with "_stk". 
%
% imstack (cell array) : cell array of sqLength sized cropped images
% filename (string) : filename of montIm selected in cropper()
% pathname (string) : pathname of montIm selected in cropper()
%

nameFields = parsefilename(filename); 
matname = strcat(nameFields{1},'.mat');
stkfilename = strcat(nameFields{1},'_', nameFields{2},'_stks.mat');
stkName = strcat(filename(1:end-4),'_stk');
eval([stkName '= imstack;']); 

if exist(strcat(pathname, stkfilename), 'file')
    save(strcat(pathname, stkfilename), stkName, '-append'); % This overrides existing stk variables within the sl#_stks.mat file
 else
    save(strcat(pathname, stkfilename), stkName);
end