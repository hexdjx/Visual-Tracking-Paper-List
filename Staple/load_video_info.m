function [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(video_path)

% [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(video_path)

text_files = dir([video_path 'groundtruth_rect.txt']);
f = fopen([video_path text_files(1).name]);
ground_truth = textscan(f, '%f,%f,%f,%f');%[x, y, width, height]
ground_truth = cat(2, ground_truth{:});
fclose(f);

%set initial position and size
target_sz = [ground_truth(1,4), ground_truth(1,3)];
pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);
% 
% ground_truth(:,1:2) = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) / 2;
% ground_truth(:,3:4) = ground_truth(:,[4,3]);
%see if they are in the 'imgs' subfolder or not
img_files = dir([video_path 'img/*.jpg']);

%list the files
img_files = sort({img_files.name});
video_path = [video_path 'img/'];
end

