
clc;
close all;
%% ���·��
setup_paths;

%% ��Ƶ֡����λ��
base_path ='D:\\data_seq\OTB-100\';

%% ��������z

feature.type = 'hog'; % hogcolor,hog,gray
features.gray = false;
features.hog = false;
features.hogcolor = false;

padding = 1.5;  %extra area surrounding the target
lambda = 1e-4;  %regularization
output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)

show_visualization = 1;
%% ����ѡ��
switch feature.type
case 'gray'
    interp_factor = 0.075;  %linear interpolation factor for adaptation

    kernel.sigma = 0.2;  %gaussian kernel bandwidth

    kernel.poly_a = 1;  %polynomial kernel additive term
    kernel.poly_b = 7;  %polynomial kernel exponent

    features.gray = true;
    cell_size = 1;

case 'hog'
    interp_factor = 0.02;

    kernel.sigma = 0.5;

    kernel.poly_a = 1;
    kernel.poly_b = 9;

    features.hog = true;
    features.hog_orientations = 9;
    cell_size = 4;
case 'hogcolor'
    interp_factor = 0.01;

    kernel.sigma = 0.5;

    kernel.poly_a = 1;
    kernel.poly_b = 9;

    features.hogcolor = true;
    features.hog_orientations = 9;
    cell_size = 4;	
otherwise
    error('Unknown feature.')
end
  
%% ������Ƶ��Ϣ
video = choose_video(base_path);
if ~isempty(video)
    [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video);
end

%% ����
%call tracker function with all the relevant parameters
[positions,time] = tracker(video_path, img_files, pos, target_sz, ...
    padding, kernel, lambda, output_sigma_factor, interp_factor, ...
    cell_size, features, show_visualization);


%% ���ٽ��
show_precision(positions, ground_truth, video)

[distance_precision, PASCAL_precision, average_center_location_error] = ...
    compute_performance_measures(positions, ground_truth);

fps = numel(img_files) / time;
   
fprintf('Center Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
    average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);
