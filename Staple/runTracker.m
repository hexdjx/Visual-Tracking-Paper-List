% RUN_TRACKER  is the external function of the tracker - does initialization and calls trackerMain

close all;
%add the necesary paths

%load video info
base_path = 'D:\data_seq\OTB-100\'; 
video_path = choose_video(base_path);

if isempty(video_name), return, end  %user cancelled
[img_files, pos, target_sz, ground_truth, video_path] = load_video_info(video_path); 

%% Read params.txt
params = readParams('params.txt');
params.visualization = 1;   
im = imread([video_path img_files{1}]);
% is a grayscale sequence ?
if(size(im,3)==1)
    params.grayscale_sequence = true;
end

params.img_files = img_files;
params.img_path = video_path;

% init_pos is the centre of the initial bounding box
params.init_pos = pos;
params.target_sz = target_sz;
[params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(im, params);
if params.visualization %调用这个matlab的videoPlayer会使整体运行速度变慢许多，因此不使用videoPlayer而使用其他tracker的显示方法
    params.videoPlayer = vision.VideoPlayer('Position', [100 100 [size(im,2), size(im,1)]-30]);%这里-30是在显示时只显示上下少30pix的中心区域
end
% in runTracker we do not output anything
params.fout = -1;
% start the actual tracking
results = trackerMain(params, im, bg_area, fg_area, area_resize_factor);

%% copy from fDSST
positions = results.res;
fps = results.fps;

% calculate precisions
[distance_precision, PASCAL_precision, average_center_location_error] = ...
    compute_performance_measures(positions, ground_truth);

fprintf('video_name : %s\nCenter Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
    video_name,average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);
%%
fclose('all');
