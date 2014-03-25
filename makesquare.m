function sqIm=makesquare(midX,midY, sqLength, montIm)
% This function returns a cropped square from montIm, whose dimension along
% each side is sqLength, and whose centroid is at midX and midY. If the
% square coordinates exceed the size of montIm, then a blank square is
% returned. 

xlimit = size(montIm, 1);
ylimit = size(montIm, 2);

halfSqLength=sqLength/2;

leftX = midX - halfSqLength;
rightX = midX + halfSqLength - 1; % -1 to keep the size at (sqLength,sqLength)
upY = midY - halfSqLength;
downY = midY + halfSqLength - 1; % - 1 to keep the size at (sqLength,sqLength)

if (rightX>xlimit)|(downY>ylimit)
    sqIm=dip_image(zeros(sqLength,sqLength));
else
    sqIm = montIm(leftX:rightX, upY:downY);
end
