

% input filenames from w1 to w4. order of channels doesn't matter. 

pathname = '/Users/sisichen/Dropbox/Dropbox Data Stacks/slide 47 stacks/';
filenames = {'sl47_w1_d5_Cy3_8b.tif', ...
    'sl47_w1_d5_DAPI_8b.tif', ...
    'sl47_w1_d5_FITC_8b.tif', ...
    'sl47_w2_d5_Cy3_8b.tif', ...
    'sl47_w2_d5_DAPI_8b.tif', ...
    'sl47_w2_d5_FITC_8b.tif', ...
    'sl47_w3_d5_Cy3_8b.tif', ...
    'sl47_w3_d5_DAPI_8b.tif', ...
    'sl47_w3_d5_FITC_8b.tif', ...
    'sl47_w4_d5_Cy3_8b.tif', ...
    'sl47_w4_d5_DAPI_8b.tif', ...
    'sl47_w4_d5_FITC_8b.tif'};

% input coordinates from Data Analysis Log: [w1] [w2] [w3] [w4]

coordinates = {[136,443],[350,418],[569,391],[788,366]};
 
% iterate runs of cropper
for i=1:4
    
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{3*(i-1)+1}, pathname);
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{3*(i-1)+2}, pathname);
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{3*(i-1)+3}, pathname);
end

%% input filenames from w1 to w4. order of channels doesn't matter. 

pathname = '/Users/sisichen/Dropbox/Dropbox Data Stacks/slide 47 stacks/';
filenames = {'sl47_w1_d0_TL_8b.tif', ...
    'sl47_w2_d0_TL_8b.tif', ...
    'sl47_w3_d0_TL_8b.tif', ...
    'sl47_w4_d0_TL_8b.tif'};

% input coordinates from Data Analysis Log: [w1] [w2] [w3] [w4]

coordinates = {[470,728],[695,630],[138,526],[366,427]};

% iterate runs of cropper

for i=3:3
    
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{i}, pathname);
    
end

%% input filenames from w1 to w4. order of channels doesn't matter. 

pathname = '/Users/sisichen/Dropbox/Dropbox Data Stacks/slide 47 stacks/';
filenames = {'sl47_w1_d5_TxRed2_8b.tif', ...
    'sl47_w1_d5_YFP2_8b.tif', ...
    'sl47_w2_d5_TxRed2_8b.tif', ...
    'sl47_w2_d5_YFP2_8b.tif', ...
    'sl47_w3_d5_TxRed2_8b.tif', ...
    'sl47_w3_d5_YFP2_8b.tif', ... 
    'sl47_w4_d5_TxRed2_8b.tif', ...
    'sl47_w4_d5_YFP2_8b.tif', ...
    };

% input coordinates from Data Analysis Log: [w1] [w2] [w3] [w4]

coordinates = {[691	891],[910,719],[359,551],[588,377]};

% iterate runs of cropper

for i=4:4
    
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{2*(i-1)+1}, pathname);
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{2*(i-1)+2}, pathname);
    
end