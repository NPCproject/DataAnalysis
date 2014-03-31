function rgbim = combine2ch(TLim, FLim)

% RGBIM = COMBINE2CH(TLim, FLim)
%
% Combines a grayscale TL image and a FL image into a single RGB image. The
% FL image is placed into the green channel. Both TLim and FLim should be
% intensity images (scaled 0 to 1). 

if size(TLim)==size(FLim)

    FLchannel=TLim+FLim;
    rgbim=cat(3, TLim,FLchannel,TLim);

else 
    error('Images are not the same size');
end