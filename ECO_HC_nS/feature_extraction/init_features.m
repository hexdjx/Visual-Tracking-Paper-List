function [features, gparams, feature_info] = init_features(features, gparams, is_color_image, img_sample_sz, size_mode)

if nargin < 3
    size_mode = 'same';
end


% Set missing global parameters to default values
if ~isfield(gparams, 'normalize_power')
    gparams.normalize_power = [];
end
if ~isfield(gparams, 'normalize_size')
    gparams.normalize_size = true;
end
if ~isfield(gparams, 'normalize_dim')
    gparams.normalize_dim = false;
end
if ~isfield(gparams, 'square_root_normalization')
    gparams.square_root_normalization = false;
end

% find which features to keep
feat_ind = false(length(features),1);
for n = 1:length(features)
    
    if ~isfield(features{n}.fparams,'useForColor')
        features{n}.fparams.useForColor = true;
    end
    
    if ~isfield(features{n}.fparams,'useForGray')
        features{n}.fparams.useForGray = true;
    end
    
    if (features{n}.fparams.useForColor && is_color_image) || (features{n}.fparams.useForGray && ~is_color_image)
        % keep feature
        feat_ind(n) = true;
    end
end

% remove features that are not used
features = features(feat_ind);

num_features = length(features);

feature_info.min_cell_size = zeros(num_features,1);


% Initialize features by
% - setting the dimension (nDim)
% - specifying if a cell array is returned (is_cell)
% - setting default values of missing feature-specific parameters
% - loading and initializing necessary data (e.g. the lookup table or the network)
for k = 1:length(features)
    if isequal(features{k}.getFeature, @get_fhog)
        if ~isfield(features{k}.fparams, 'nOrients')
            features{k}.fparams.nOrients = 9;
        end
        features{k}.fparams.nDim = 3*features{k}.fparams.nOrients+5-1;
        features{k}.is_cell = false;
        features{k}.is_cnn = false;
        
    elseif isequal(features{k}.getFeature, @get_table_feature)
        table = load(['lookup_tables/' features{k}.fparams.tablename]);
        features{k}.fparams.nDim = size(table.(features{k}.fparams.tablename),2);
        features{k}.is_cell = false;
        features{k}.is_cnn = false;
    else
        error('Unknown feature type');
    end
    
    % Set default cell size
    if ~isfield(features{k}.fparams, 'cell_size')
        features{k}.fparams.cell_size = 1;
    end
    
    % Set default penalty
    if ~isfield(features{k}.fparams, 'penalty')
        features{k}.fparams.penalty = zeros(length(features{k}.fparams.nDim),1);
    end
    
    % Find the minimum cell size of each layer
    feature_info.min_cell_size(k) = min(features{k}.fparams.cell_size);
end

% Order the features in increasing minimal cell size
[~, feat_ind] = sort(feature_info.min_cell_size);
features = features(feat_ind);
feature_info.min_cell_size = feature_info.min_cell_size(feat_ind);

% Set feature info
feature_info.dim_block = cell(num_features,1);
feature_info.penalty_block = cell(num_features,1);

for k = 1:length(features)
    % update feature info
    feature_info.dim_block{k} = features{k}.fparams.nDim;
    feature_info.penalty_block{k} = features{k}.fparams.penalty(:);
end
% Feature info for each cell block
feature_info.dim = cell2mat(feature_info.dim_block);
feature_info.penalty = cell2mat(feature_info.penalty_block);
%no cnn feature
max_cell_size = max(feature_info.min_cell_size);

if strcmpi(size_mode, 'same')
    feature_info.img_sample_sz = round(img_sample_sz);
elseif strcmpi(size_mode, 'exact')
    feature_info.img_sample_sz = round(img_sample_sz / max_cell_size) * max_cell_size;
elseif strcmpi(size_mode, 'odd_cells')
    new_img_sample_sz = (1 + 2*round(img_sample_sz / (2*max_cell_size))) * max_cell_size;

    % Check the size with the largest number of odd dimensions (choices in the
    % third dimension)
    feature_sz_choices = floor(bsxfun(@rdivide, bsxfun(@plus, new_img_sample_sz, reshape(0:max_cell_size-1, 1, 1, [])), feature_info.min_cell_size));
    num_odd_dimensions = sum(sum(mod(feature_sz_choices, 2) == 1, 1), 2);
    [~, best_choice] = max(num_odd_dimensions(:));
    pixels_added = best_choice - 1;
    feature_info.img_sample_sz = round(new_img_sample_sz + pixels_added);
else
    error('Unknown size_mode');
end
    
% Setting the feature size and support size
%     feature_info.data_sz = floor(bsxfun(@rdivide, feature_info.img_sample_sz, feature_info.min_cell_size));
feature_info.img_support_sz = feature_info.img_sample_sz;


% Set the sample size and data size for each feature
feature_info.data_sz_block = cell(num_features,1);
for k = 1:length(features)   
    % implemented classic features always have the same sample and
    % support size
    features{k}.img_sample_sz = feature_info.img_support_sz(:)';
    features{k}.img_input_sz = features{k}.img_sample_sz;

    % Set data size based on cell size
    feature_info.data_sz_block{k} = floor(bsxfun(@rdivide, features{k}.img_sample_sz, features{k}.fparams.cell_size));
end

feature_info.data_sz = cell2mat(feature_info.data_sz_block);