function [dataframe masks]=calcNLSintensities(pathname, stksmatname, matname, imstackname, CortAName, day)

% calcNLSintensities(pathname, matname, stksmatname, imstackname, matname)
%
% This function calculates the mean (fl_mean) and integrated intensities 
% (fl_mass) of NLS-XFP expressing cortical astrocytes. THe segmentation is
% done automatically using both Otsu and MinError thresholding. I found
% that when one doesn't work, the other works. So for images where there is
% disagreement between the two methods, I prompt the user to arbitrate. 

% Make sure the matstkname and the matname are in the same folder. 
%
% pathname (string): path indicating the location of matstkname and matname
% stksmatname: name of file containing the stacks
% imstackname: name of stack we want to use
% CortAName: name of CortA type
% day: 0 or 6 (if it's not actually d6, we keep track of that separately)
% 

load ([pathname stksmatname]); % load stksmat file 
load ([pathname matname]);
imstack = eval(imstackname);
dataframe = eval(makeDataFrameName(imstackname)); % load corresponding data frame 
numCortAfieldname = ['num' CortAName '_d' num2str(day)];
flMeanFieldName = ['flMean' CortAName '_d' num2str(day)];
flMassFieldName = ['flMass' CortAName '_d' num2str(day)];
masks=cell(1,length(imstack));

for i = 1:length(imstack)
    
    display(num2str(i));
    
    % convert images to dipimage
    currIm = imstack{i};
    
    % If the image is blank, set all to 0
    if max(max(currIm))==0
        
        numCellArray(i) = 0;
        flMeanArray(i) = 0;
        flMassArray(i) = 0;
        masks{i} = mat2im(zeros(400,400));
    else
        
    currIm(:,all(currIm==0))=[]; %remove all columns that are only zeros
    currIm(all(currIm'==0),:)=[]; %remove all rows that are only zeros
    
    currDipIm = mat2im(currIm);
    
        % threshold by two methods
        
        [currOtsuIm, th_Otsu] = threshold (currDipIm, 'otsu');
        currOtsuIm = bclosing(currOtsuIm,2,-1,1);
        currOtsuIm = currOtsuIm>0;
        currOtsuIm = brmedgeobjs(currOtsuIm,2);
        [currMinEIm, th_MinE] = threshold (currDipIm, 'minerror');
        currMinEIm = bclosing(currMinEIm,2,-1,1);
        currMinEIm = currMinEIm>0;
        currMinEIm = brmedgeobjs(currMinEIm,2);
        
        
        % Count the number of segmented objects
        
        labeledOtsu = label(currOtsuIm, 2, 75, 5000); % label the individual objs
        labeledMinE = label(currMinEIm, 2, 75, 5000);
        
        numOtsu = max(max(labeledOtsu));
        numMinE = max(max(labeledMinE));
        overlapscore = sum((labeledOtsu>0).*(labeledMinE>0));
        
        if (numOtsu==0)&&(numMinE==0) || (numOtsu>10)&&(numMinE==0) || (numOtsu==0)&&(numMinE>10) || (numOtsu>10)&&(numMinE>10) 
            
            numCellArray(i) = 0;
            flMeanArray(i) = 0;
            flMassArray(i) = 0;
            
            masks{i}=mat2im(zeros(400,400));
            
        else
            
            if (numOtsu==0) && (numMinE>0)
                
                msr = measure(labeledMinE, currDipIm,{'Mean','Mass'}, [], 2);
                masks{i}=labeledMinE;
                
            elseif (numOtsu>0) && (numMinE==0)
                
                msr = measure(labeledOtsu, currDipIm,{'Mean', 'Mass'}, [], 2);
                masks{i}=labeledOtsu;
                
            elseif (numOtsu==numMinE) && (overlapscore>100)
                
                msr = measure(labeledOtsu, currDipIm,{'Mean', 'Mass'}, [], 2);
                masks{i}=labeledOtsu;
                
            else
                
                % pull up grayscale image as well as original
                
                dipshow(currDipIm,'log');
                
                dipshow(labeledOtsu, 'log');
                
                dipshow(labeledMinE, 'log');
                
                % have user srbitrate between the two segmentation methods
                
                b = 0;
                
                while b==0
                    
                    pick = input('pick either the Otsu(1) or MinError(2) method for thresholding:');
                    
                    if pick == 1
                        msr = measure(labeledOtsu, currDipIm,{'Mean','Mass'}, [], 2);
                        masks{i}=labeledOtsu;
                        b = 1;
                    elseif pick == 2
                        msr = measure(labeledMinE, currDipIm,{'Mean','Mass'}, [], 2);
                        masks{i}=labeledMinE;
                        b = 1;
                    else
                        display('You did not pick the specified value. Please pick again.');
                        b = 0;
                    end
                    
                end
                
                figHandles = get(0,'Children');
                close(figHandles(1:3));
                
            end
            
            % For each position in the index, store the average mean, and the average
            % mass. Also populate the d5_numCortAName field with the value of
            % intensities at the specified day
            
            numCells = length(msr);
            averageMean = mean(msr.mean);
            averageMass = mean(msr.mass);
            
            numCellArray(i) = numCells;
            flMeanArray(i) = averageMean;
            flMassArray(i) = averageMass;
            
        end
    end
    
end


dataframe = setfield(dataframe, numCortAfieldname, numCellArray);
dataframe = setfield(dataframe, flMeanFieldName, flMeanArray);
dataframe = setfield(dataframe, flMassFieldName, flMassArray);



