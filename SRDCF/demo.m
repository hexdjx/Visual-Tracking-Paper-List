
% This demo script runs the ECO tracker with deep features on the
% included "Crossing" video.

% Add paths
setup_paths();

base_path = 'D:\\data_seq/OTB-100/';% D://data_seq/
video_path = choose_video(base_path);
% video_path = 'sequences/Crossing';
[seq, ground_truth] = load_video_info(base_path,video_path);

% Run ECO
results = SRDCF_settings(seq);