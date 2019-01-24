function setup_paths()

% Add the neccesary paths

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

% video infomation
addpath(genpath([pathstr '/video_info/']));

% correlation
addpath(genpath([pathstr '/correlation/']));

% hog feature
addpath(genpath([pathstr '/hog_feature/']));

% cn feature
addpath(genpath([pathstr '/cn_feature/']));

% mexResize
addpath(genpath([pathstr '/mexResize/']));

% implement
addpath(genpath([pathstr '/implement/']));

% scale_adaption
addpath(genpath([pathstr '/scale_adaption/']));

% show_result
addpath(genpath([pathstr '/show_result/']));





