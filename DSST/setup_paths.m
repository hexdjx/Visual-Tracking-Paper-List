function setup_paths()

% Add the neccesary paths

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

% video infomation
addpath(genpath([pathstr '/video_info/']));

% hog feature
addpath(genpath([pathstr '/hog_feature/']));

% mexResize
addpath(genpath([pathstr '/mexResize/']));

% implement
addpath(genpath([pathstr '/implement/']));

% show_result
addpath(genpath([pathstr '/show_result/']));





