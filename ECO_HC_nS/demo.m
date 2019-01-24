
% This demo script runs the ECO tracker with hand-crafted features on the
clc;clear,close all;

% Utilities
addpath('./utils/');

% Load video information
%choose video
base_path = 'D:\\data_seq/OTB-100/';
video_path = choose_video(base_path);

seq = load_video_info(base_path,video_path);

% Run ECO
results = run_ECO_HC_nS(seq);