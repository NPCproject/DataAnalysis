

% input filenames from w1 to w4. order of channels doesn't matter. 

pathname = '/Users/sisichen/Dropbox/Dropbox Data Stacks/slide 38 stacks/';
filenames = {'sl38_w1_d6_Cy3_8b.tif', ...
    'sl38_w1_d6_DAPI_8b.tif', ...
    'sl38_w1_d6_FITC_8b.tif', ...
    'sl38_w2_d6_Cy3_8b.tif', ...
    'sl38_w2_d6_DAPI_8b.tif', ...
    'sl38_w2_d6_FITC_8b.tif', ...
    'sl38_w3_d6_Cy3_8b.tif', ...
    'sl38_w3_d6_DAPI_8b.tif', ...
    'sl38_w3_d6_FITC_8b.tif', ...
    'sl38_w4_d6_Cy3_8b.tif', ...
    'sl38_w4_d6_DAPI_8b.tif', ...
    'sl38_w4_d6_FITC_8b.tif'};

% input coordinates from Data Analysis Log: [w1] [w2] [w3] [w4]

coordinates = {[605,334],[215,317],[364,298],[522,280]};
 
% iterate runs of cropper
for i=1:4
    
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{3*(i-1)+1}, pathname);
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{3*(i-1)+2}, pathname);
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{3*(i-1)+3}, pathname);
end

% input filenames from w1 to w4. order of channels doesn't matter. 

pathname = '/Users/sisichen/Dropbox/Dropbox Data Stacks/slide 42 stacks/';
filenames = {'sl42_w1_d0_TL_8b.tif', ...
    'sl42_w2_d0_TL_8b.tif', ...
    'sl42_w3_d0_TL_8b.tif', ...
    'sl42_w4_d0_TL_8b.tif'};

% input coordinates from Data Analysis Log: [w1] [w2] [w3] [w4]

coordinates = {[1277,479],[358,372],[1052,287],[1209,196]};

% iterate runs of cropper

for i=1:4
    
    cropper(coordinates{i}(1), coordinates{i}(2), filenames{i}, pathname);
    
end