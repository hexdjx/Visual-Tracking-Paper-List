function results=run_CN(seq, res_path, bSaveImage)

% clear all;

%choose the path to the videos (you'll be able to choose one with the GUI)
%parameters according to the paper
params.padding = 1.0;         			   % extra area surrounding the target
params.output_sigma_factor = 1/16;		   % spatial bandwidth (proportional to target)
params.sigma = 0.2;         			   % gaussian kernel bandwidth
params.lambda = 1e-2;					   % regularization (denoted "lambda" in the paper)
params.learning_rate = 0.075;			   % learning rate for appearance model update scheme (denoted "gamma" in the paper)
params.compression_learning_rate = 0.15;   % learning rate for the adaptive dimensionality reduction (denoted "mu" in the paper)
params.non_compressed_features = {'gray'}; % features that are not compressed, a cell with strings (possible choices: 'gray', 'cn')
params.compressed_features = {'cn'};       % features that are compressed, a cell with strings (possible choices: 'gray', 'cn')
params.num_compressed_dim = 2;             % the dimensionality of the compressed features
pos = seq.init_rect(:,[2,1]);
target_sz = seq.init_rect(:,[4,3]);
params.init_pos = floor(pos) + floor(target_sz/2);
params.wsize = floor(target_sz);
params.img_files = seq.s_frames;
params.video_path = [];


[positions, fps] = color_tracker(params,res_path, bSaveImage);

%return results to benchmark, in a workspace variable
rects = [positions(:,2) - target_sz(2)/2, positions(:,1) - target_sz(1)/2];
rects(:,3) = target_sz(2);
rects(:,4) = target_sz(1);


results.type = 'rect';
results.res = rects;%each row is a rectangle
results.fps = fps;
disp(['fps: ' num2str(results.fps)]);

%show the precisions plot
% show_precision(positions, ground_truth, video_path)

