
function [midX midY] = cropper(varargin)

% [MIDX MIDY] = CROPPER[midX midY]
% 
% This function produces a cropped stack from a montaged 8bit image, which
% must be correctly rotated. A ui prompt will ask the user to select the
% montaged image file. If the centroid position of the first square
% is known (midX,midY), then it should be supplied as input into the
% function. If the centroid position is not known, the user will be asked
% to select the four corners of the first square. These coordinates will be
% used to calculate the centroid. 
%
% The function crops all of the patterned islands into an aligned stack of
% squares of size sqLength.
%
% hard-coded parameters: 
% sqLength = 300;
% numRows = 19;
% numCols = 13;
% numSq = numRows*numCols;
% xpitch = 774.1; %switch for dipimage arrays
% ypitch = 770.5;
% 
% The counter will save the stacks in a sl#_stks.mat file in the same
% folder as the original montaged image. It will also create a data frame
% for this particular well (sl#_well#_data) in the corresponding sl#.mat
% file, if one does not already exist. 
% 

% Specify parameters
sqLength = 300;
numRows = 19;
numCols = 13;
numSq = numRows*numCols;
xpitch = 774.1; %switch for dipimage arrays
ypitch = 770.5;

% Ask user to select the file: 

[filename, pathname] = uigetfile('.tif', 'Select the montaged image');
if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel.');
       return;
    else
       disp(['User selected ', fullfile(pathname, filename)])
       montIm = imread([pathname,filename], 'tif');
end

% Determine the coordinates of the middle of the first square by: 
% 1. Asking the user to enter it manually. 
% 2. Crop an upper region for identification of first square

a = nargin;

if nargin<2 %if insufficient number of arguments
    
    smallMontIm = montIm(1:3000,1:1000);
    display('Pick corners in a clockwise direction starting from top left');
    
    b='N';
    while (b == 'N')||(b == 'n')
        [x, y] = ginput(4);
        b = input('Are the points correct (Y/N)? ', 's');
    end
    
    midX = round(mean(x));
    midY = round(mean(y));
    
else 
    
    midX=round(varargin{1});
    midY=round(varargin{2});
    
    if ~isnumeric(midX)&&isnumeric(midY)
        error('Please input numerical coordinates');
    end
   
end


% Populate list of x and y for centroids coordinates: 

allMidX = zeros(1, numRows); %all column coordinates
allMidY = zeros(1, numCols); %all row coordinates

for i=1:numRows
    if i==1
        allMidX(i)=midX;
    else
        allMidX(i)=allMidX(i-1) + xpitch;
    end
end

for j=1:numCols
    if j==1
        allMidY(j)=midY;
    else
        allMidY(j)= allMidY(j-1) + ypitch;
    end
end

allMidX=round(allMidX);
allMidY=round(allMidY);

% Make squares at each center coordinate and append to the image array

imstack = cell(numSq,1);
for i = 1:numRows %need to switch if using dipImage
    for j = 1:numCols
        currSq = makesquare(allMidX(i), allMidY(j), sqLength, montIm);        
        imstack{i+numCols*(j-1)} = currSq;
    end
end

% Save image data into sl#_stks.mat file:

saveStk(imstack,filename,pathname);

% Set up the data frame variable for this well. Sets up data mat file if
% one does not already exist

setupWellDataFrame(filename, pathname); 



