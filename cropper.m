
function [midX midY] = cropper()

% This function takes in a montaged image and crops all of the patterned
% islands into an aligned stack of squares of size sqLength. The original 
% xpitch and ypitch that had been calibrated for sl19_w1_d0 is 770.5, and
% 774.1. 
% 
% For day 0 images and day 6 stained images, make sure to merge and
% properly adjust the scaling of multichannel images before cropping. The
% counters only display one image stack. 
% 

% Specify parameters
sqLength = 300;
numRows = 19;
numCols = 13;
numSq = numRows*numCols;
xpitch = 770.5;
ypitch = 774.1;

% Ask user to select the file: 

[filename, pathname] = uigetfile('.tif', 'Select the montaged image');
if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel.');
       return;
    else
       disp(['User selected ', fullfile(pathname, filename)])
       montIm = readim(strcat(pathname,filename), '');
end

% Determine the coordinates of the middle of the first square by: 
% 1. Asking the user to enter it manually. 
% 2. Crop an upper region for identification of first square

a = input('Can you input first square coordinates (Y/N)? ', 's');

if (a == 'y')||(a == 'Y')
    
    midX=input('Please enter the x coordinate of the first square in pixels: ');
    midY=input('Please enter the y coordinate of the first square in pixels: ');

else
    
    smallMontIm = montIm(1:3000,1:1000);
    smallMontIm
    display('Pick corners in a clockwise direction starting from top left');
    
    b='N';
    while (b == 'N')||(b == 'n')
        [x, y] = ginput(4);
        b = input('Are the points correct (Y/N)? ', 's');
    end
    
    midX = round(mean(x));
    midY = round(mean(y));
    
end


% Populate list of x and y for centroids coordinates: 

allMidX = zeros(1, numCols); %all column coordinates
allMidY = zeros(1, numRows); %all row coordinates

for i=1:numCols
    if i==1
        allMidX(i)=midX;
    else
        allMidX(i)=allMidX(i-1) + xpitch;
    end
end

for j=1:numRows
    if j==1
        allMidY(j)=midY;
    else
        allMidY(j)= allMidY(j-1) + ypitch;
    end
end

allMidX=round(allMidX);
allMidY=round(allMidY);

% Make Squares at each center coordinate and append to the image array

imstack = newimar(numSq);
for j = 1:numRows
    for i = 1:numCols
        currSq = makesquare(allMidX(i), allMidY(j), sqLength, montIm);
        imstack{i+numCols*(j-1)} = currSq;
    end
end

% Save image data and create data frame if necessary
nameFields = parsefilename(filename); 
matname = strcat(nameFields{1},'.mat');
stkName = strcat(filename(1:end-4),'_stk');
eval([stkName '= imstack;']); 
save(strcat(pathname, matname),stkName, '-append'); % This overrides existing stk variables

% check to see if a data frame has already been created for this well
createBlankDataFrame(filename, pathname, matname); 



