function sqIm=makesquare(midX,midY, sqLength, montIm)
% 
% MAKESQUARE returns a cropped square image
%
% sqIm = makesquare(midX,midY, sqLength, montIm)
%
% midX (integer):  x-coordinate of centroid of cropped area
% midY (integer):  y-coordinate of centroid of cropped area
% sqLength (integer): dimension of square being cropped
% montIm (mxn matlab matrix): matlab array of montaged image 
% 
% This function returns a cropped square from montIm. The dimension of this
% cropped image is sqLength, and the centroid is at midX and midY. If the
% square coordinates completely exceed the size of montIm, then a blank
% square is returned. However, if only one dimension of the square exceeds
% the size of montIm, the rest of the cropped image is filled in with black
% pixels (value = 0)
%

ylimit = size(montIm, 1); % need to switch if using dipimage
xlimit = size(montIm, 2);

halfSqLength=sqLength/2;

leftX = midX - halfSqLength;
rightX = midX + halfSqLength - 1; % - 1 to keep the size at (sqLength,sqLength)
upY = midY - halfSqLength;
downY = midY + halfSqLength - 1; % - 1 to keep the size at (sqLength,sqLength)

if (leftX < 1)||(upY > ylimit) || ((rightX > xlimit) && (downY > ylimit)) || ((rightX > xlimit) && (upY < 1)) || ((leftX < 1) && (downY > ylimit))
    sqIm=zeros(sqLength,sqLength);
    sqIm=double(sqIm);
else
    
    if rightX>xlimit
        rightX = xlimit;
        sqIm=montIm(upY:downY,leftX:rightX);
        
        % make missing columns
        missingcols = sqLength - size(sqIm,2);
        zeroCols = zeros(sqLength,missingcols);
        
        % combine sqIm with zero matrix
        sqIm=[sqIm, zeroCols];
        
    elseif leftX<1
        
        leftX = 1;
        
        sqIm=montIm(upY:downY,leftX:rightX);
        
        % make missing columns
        missingcols = sqLength - size(sqIm,2);
        zeroCols = zeros(sqLength,missingcols);
        
        % combine sqIm with zero matrix
        sqIm=[zeroCols, sqIm];
    
    elseif upY < 1
        
        upY = 1;
        sqIm=montIm(upY:downY,leftX:rightX);
        
        % make missing rows with zeros
        missingrows = sqLength - size(sqIm,1);
        zeroRows = zeros(missingrows, sqLength);
        
        % combine sqIm with zero matrix
        sqIm = [zeroRows ; sqIm];
        
    elseif downY > ylimit
        
        downY = ylimit;
        sqIm=montIm(upY:downY,leftX:rightX);
        
        % make missing rows with zeros
        missingrows = sqLength - size(sqIm,1);
        zeroRows = zeros(missingrows, sqLength);
        
        % combine sqIm with zero matrix
        sqIm = [sqIm ; zeroRows];
    
    else
        
        sqIm=montIm(upY:downY,leftX:rightX);
    end
    
    
end
