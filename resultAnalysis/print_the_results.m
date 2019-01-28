
%   a simple code to compute the OP (at threshold = 0.50) and AUC (average
%   over thresholds [0,1]- 
%   Please use the following code if you want to get results of other
%   trackers and compare wirh the BACF ones. 
%   Email- hamedkg@gmail.com
%   @CopyRight- Hamed Kiani - RI, CMU 2017.


clc; close all;

mat_files = dir(fullfile(['./mat_files'], '*.mat'));
mat_files = {mat_files.name};
m = 0;
auc = 0:0.01:1;

videos = {'Basketball', 'Bolt', 'Boy', 'Car4', 'CarDark', 'CarScale', ...
    'Coke', 'Couple', 'Crossing', 'David2', 'David3', 'David', 'Deer', ...
    'Dog1', 'Doll', 'Dudek', 'Faceocc1', 'Faceocc2', 'Fish', 'Fleetface', ...
    'Football', 'Football1', 'Freeman1', 'Freeman3', 'Freeman4', 'Girl', ...
    'Ironman', 'Jogging_1', 'Jumping', 'Lemming', 'Liquor', 'Matrix', ...
    'Mhyang', 'MotorRolling', 'MountainBike', 'Shaking', 'Singer1', ...
    'Singer2', 'Skating1', 'Skiing', 'Soccer', 'Subway', 'Suv', 'Sylvester', ...
    'Tiger1', 'Tiger2', 'Trellis', 'Walking', 'Walking2', 'Woman'};


auc_aveg = 0;
op_aveg = 0;
% for OTB - 50
disp('*************************************on OTB - 50 ********************************************');

for i = 1: numel(videos)
    res = load(['./mat_files/' videos{i}], 'results');
    vid = res.results.vid;
    pd_boxes = res.results.res;
    gt_boxes = res.results.gt;
    
    pd_boxes = [pd_boxes(:,1:2), pd_boxes(:,1:2) + pd_boxes(:,3:4) - ones(size(pd_boxes,1), 2)  ];
    OP = zeros(size(gt_boxes,1),1);
    
    for j=1:size(gt_boxes,1)
        b_gt = gt_boxes(j,:);
        b_pd = pd_boxes(j,:);
        OP(j) = computePascalScore(b_gt,b_pd);
    end
    auc_result = bsxfun(@ge, OP, auc);
%     auc_result = ge(OP,auc);
    display(['video is : '  vid  '  AUC is: '  num2str(mean(mean(auc_result,2))) '  OP(0.5) is: '  num2str(mean(mean(auc_result(:,51),2)))]);
    auc_aveg = auc_aveg + mean(mean(auc_result,2));
    op_aveg = op_aveg + mean(mean(auc_result(:,51),2));
    
end
disp('--------------------------------------------------------------------------------------------------');
disp([' Average AUC on OTB-50 is: ' num2str(auc_aveg/50)  ' Average OP(0.5) is   '  num2str(op_aveg/50) ] )
disp('--------------------------------------------------------------------------------------------------');


disp('*************************************on OTB - 100 ********************************************');
% for OTB-100
auc_aveg = 0;
op_aveg = 0;
for i = 1: numel(mat_files)
    res = load(['./mat_files/' mat_files{i}], 'results');
    vid = res.results.vid;
    pd_boxes = res.results.res;
    gt_boxes = res.results.gt;
    
    pd_boxes = [pd_boxes(:,1:2), pd_boxes(:,1:2) + pd_boxes(:,3:4) - ones(size(pd_boxes,1), 2)  ];
    OP = zeros(size(gt_boxes,1),1);
    
    for j=1:size(gt_boxes,1)
        b_gt = gt_boxes(j,:);
        b_pd = pd_boxes(j,:);
        OP(j) = computePascalScore(b_gt,b_pd);
    end
    auc_result = bsxfun(@ge, OP, auc);
    disp(['video is : '  vid  '  AUC is: '  num2str(mean(mean(auc_result,2))) '  OP(0.5) is: '  num2str(mean(mean(auc_result(:,51),2)))]);
    auc_aveg = auc_aveg + mean(mean(auc_result,2));
    op_aveg = op_aveg + mean(mean(auc_result(:,51),2));
end
disp('--------------------------------------------------------------------------------------------------');
disp(['Average AUC on OTB-100 is: ' num2str(auc_aveg/100)  ' Average OP(0.5) is   '  num2str(op_aveg/100)] )
disp('--------------------------------------------------------------------------------------------------');


