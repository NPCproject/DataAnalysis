function rgbim = combine2ch(TLim, FLim)

% Combines a TL image and a FL image into a single RGB image. 

if size(TLim)==size(FLim)

    FLchannel=TLim+FLim;
    rgbim=cat(3, TLim,FLchannel,TLim);

else 
    error('Images are not the same size');
end