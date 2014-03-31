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
% square coordinates exceed the size of montIm, then a blank square is
% returned. 
%

ylimit = size(montIm, 1); %need to switch if using dipimage
xlimit = size(montIm, 2);

halfSqLength=sqLength/2;

leftX = midX - halfSqLength;
rightX = midX + halfSqLength - 1; % -1 to keep the size at (sqLength,sqLength)
upY = midY - halfSqLength;
downY = midY + halfSqLength - 1; % - 1 to keep the size at (sqLength,sqLength)

if (rightX>xlimit)||(downY>ylimit)
    sqIm=zeros(sqLength,sqLength);
else
    sqIm = montIm(upY:downY,leftX:rightX); %need to change orientation if using dipimage
end
