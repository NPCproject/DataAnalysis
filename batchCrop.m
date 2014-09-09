function batchCrop(slideNum, coordinates)
% 
% BATCHCROP(slideNum, coordinates)
%  
% Take in the pathname of the image montages and the coordinates according
% to the well number. Using these data, batchCrop creates cropped stacks in
% the same folder for each well. 
%
% slideNum (number): number of the slide
% coordinates (cell array): [w1] [w2] [w3] [w4], each cell of array is a
% two number vector giving the x1 and y1 centroid coordinates of the upper
% leftmost pattern. e.g. coords={[153,133],[374,209],[599,224],[821,274]}

pathname = ['/Users/sisichen/Dropbox/Dropbox Data Stacks/slide ' num2str(slideNum) ' stacks/'];
filenames = uigetfile([pathname '.tif'], 'MultiSelect', 'on');

% iterate runs of cropper
for i=1:length(filenames)
    
    currFilename = filenames{i};
    
    %Determine which well to reference
    namefields = parsefilename(currFilename);
    currWell = str2num(namefields{2}(2:end));
    
    cropper(coordinates{currWell}(1), coordinates{currWell}(2), filenames{i}, pathname);

end