
function results=run_DSST(seq, res_path, bSaveImage)
close all

%add the neccesary paths
setup_paths;

%% ≤Œ ˝…Ë÷√
%parameters according to the paper
params.padding = 1.0;         			% extra area surrounding the target
params.output_sigma_factor = 1/16;		% standard deviation for the desired translation filter output
params.scale_sigma_factor = 1/4;        % standard deviation for the desired scale filter output
params.lambda = 1e-2;					% regularization weight (denoted "lambda" in the paper)
params.learning_rate = 0.025;			% tracking model learning rate (denoted "eta" in the paper)
params.number_of_scales = 33;           % number of scale levels (denoted "S" in the paper)
params.scale_step = 1.02;               % Scale increment factor (denoted "a" in the paper)
params.scale_model_max_area = 512;      % the maximum size of scale examples

params.init_pos = seq.init_rect(1,[2,1]) + floor(seq.init_rect(1,[4,3])/2);
params.wsize = seq.init_rect(1,[4,3]);
params.img_files = seq.s_frames;
params.video_path = [];

[positions, fps] = dsst(params,res_path, bSaveImage);

%return results to benchmark, in a workspace variable
rects = [positions(:,2) - positions(:,4)/2, positions(:,1) - positions(:,3)/2];
rects(:,3) = positions(:,4);
rects(:,4) = positions(:,3);

results.type = 'rect';
results.res = rects;
results.fps=fps;
disp(['fps: ' num2str(results.fps)]);
        
end
		

		

