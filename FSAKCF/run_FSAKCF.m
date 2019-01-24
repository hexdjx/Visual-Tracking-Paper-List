
function results=run_FSAKCF(seq, res_path, bSaveImage)
close all

padding = 1.5;  %extra area surrounding the target
lambda = 1e-4;  %regularization
output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)
kernel.type='gaussian';

%-----------------------------------------------
%hog feature
interp_factor = 0.02;
kernel.sigma = 0.5;

features.hog = true;
features.hog_orientations = 9;
cell_size = 4;

target_sz = seq.init_rect(1,[4,3]);
pos = seq.init_rect(1,[2,1]) + floor(target_sz/2);
img_files = seq.s_frames;

%call tracker function with all the relevant parameters
[positions,time] = tracker(img_files, pos, target_sz, ...
padding, kernel, lambda, output_sigma_factor, interp_factor, ...
cell_size, features, res_path, bSaveImage);

%return results to benchmark, in a workspace variable
rects = [positions(:,2) - target_sz(2)/2, positions(:,1) - target_sz(1)/2];
rects(:,3) = target_sz(2);
rects(:,4) = target_sz(1);

results.type = 'rect';
results.res = rects;
results.fps=numel(img_files) / time;
disp(['fps: ' num2str(results.fps)]);
        
end
		

		

