function [img_files, pos, target_sz, resize_image, ground_truth, ...
	video_path] = load_video_info(video_path)
%LOAD_VIDEO_INFO
%   Loads all the relevant information for the video in the given path:
%   the list of image files (cell array of strings), initial position
%   (1x2), target size (1x2), whether to resize the video to half
%   (boolean), and the ground truth information for precision calculations
%   (Nx2, for N frames). The ordering of coordinates is always [y, x].
%
%   The path to the video is returned, since it may change if the images
%   are located in a sub-folder (as is the default for MILTrack's videos).
%
%   João F. Henriques, 2012
%   http://www.isr.uc.pt/~henriques/

	%load ground truth from text file (MILTrack's format)
	text_files = dir([video_path 'groundtruth_rect.txt']);
	assert(~isempty(text_files), 'No initial position and ground truth (*_gt.txt) to load.')

	f = fopen([video_path text_files(1).name]);
	ground_truth = textscan(f, '%f,%f,%f,%f');  %[x, y, width, height]
	ground_truth = cat(2, ground_truth{:});
	fclose(f);
	
	%set initial position and size
	target_sz = [ground_truth(1,4), ground_truth(1,3)];
	pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);
    
    ground_truth = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) / 2;
    
	video_path = [video_path 'img/'];
    %no text file, just list all images
    img_files = dir([video_path '*.jpg']);
    img_files = sort({img_files.name});
    
	%if the target is too large, use a lower resolution - no need for so
	%much detail
	if sqrt(prod(target_sz)) >= 100
		pos = floor(pos / 2);
		target_sz = floor(target_sz / 2);
		resize_image = true;
	else
		resize_image = false;
	end
end

