
clc;
close all;
%% 添加路径
setup_paths;

%% 视频帧所在位置
base_path ='D:\\data_seq\OTB-100\';

%% 参数设置
kernel.type = 'linear';%gaussian,polynomial,linear

feature.type = 'hoggray'; % hogcolor,hog,gray hoggray
features.gray = false;
features.hog = false;
features.hogcolor = false;
features.hoggray = false;

s.adaption = 'dsst';%dsst,samf,no_scale

show_visualization = 1;
%% 特征选择
switch feature.type
case 'gray'
    interp_factor = 0.075;  %linear interpolation factor for adaptation

    kernel.sigma = 0.2;  %gaussian kernel bandwidth

    kernel.poly_a = 1;  %polynomial kernel additive term
    kernel.poly_b = 7;  %polynomial kernel exponent

    features.gray = true;
    cell_size = 1;

case 'hog'
    padding = 1.5;  %extra area surrounding the target
    lambda = 1e-4;  %regularization
    output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)

    interp_factor = 0.02;

    kernel.sigma = 0.5;

    kernel.poly_a = 1;
    kernel.poly_b = 9;

    features.hog = true;
    features.hog_orientations = 9;
    cell_size = 4;
case 'hogcolor'
    
    padding = 1.5;  %extra area surrounding the target
    lambda = 1e-4;  %regularization
    output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)

    interp_factor = 0.01;

    kernel.sigma = 0.5;

    kernel.poly_a = 1;
    kernel.poly_b = 9;

    features.hogcolor = true;
    features.hog_orientations = 9;
    cell_size = 4;	
case 'hoggray'
    
    padding = 1.0;  %extra area surrounding the target
    lambda = 1e-2;  %regularization
    output_sigma_factor = 1/16;  %spatial bandwidth (proportional to target)

    interp_factor = 0.025;  %linear interpolation factor for adaptation

    features.hoggray = true;
    cell_size = 1;
otherwise
    error('Unknown feature.')
end
%% 尺度方法选择
switch s.adaption
case 'dsst'
    s.scale_sigma_factor = 1/4;
    s.num_scales = 33;
    s.scale_model_factor = 1.0;
    s.scale_step = 1.02;
    s.scale_model_max_area = 32*16;
    s.hog_scale_cell_size = 4;
    s.learning_rate_scale = 0.025;
    s.lambda = 1e-3;
end
    
assert(any(strcmp(kernel.type, {'linear', 'polynomial', 'gaussian'})), 'Unknown kernel.')

%% 加载视频信息
video = choose_video(base_path);
if ~isempty(video)
    [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video);
end

%% 跟踪
%call tracker function with all the relevant parameters
[positions,time] = tracker(video_path, img_files, pos, target_sz, ...
    padding, kernel, lambda, output_sigma_factor, interp_factor, ...
    cell_size, features, show_visualization,s);


%% 跟踪结果
show_precision(positions, ground_truth, video)

[distance_precision, PASCAL_precision, average_center_location_error] = ...
    compute_performance_measures(positions, ground_truth);

fps = numel(img_files) / time;
   
fprintf('Center Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
    average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);
