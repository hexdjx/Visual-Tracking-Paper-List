
%ʧ�ܣ�bird1(�����ڵ����µģ���Ҫ��û����Ӽ����ƺͻָ�����),sing2��
% This demo script runs the ECO tracker with hand-crafted features on the
% included "Crossing" video.
clc;clear,close all;
% Add paths
setup_paths();

% Load video information
%choose video
base_path = 'D:\\data_seq/OTB-100/';% D://data_seq/
video_path = choose_video(base_path);
% video_path = 'sequences/Crossing';
[seq, ground_truth] = load_video_info(base_path,video_path);

% Run ECO
results = testing_ECO_HC(seq);