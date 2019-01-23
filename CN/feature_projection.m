function z = feature_projection(x_npca, x_pca, projection_matrix, cos_window)

% z = feature_projection(x_npca, x_pca, projection_matrix, cos_window)
%
% Calculates the compressed feature map by mapping the PCA features with
% the projection matrix and concatinates this with the non-PCA features.
% The feature map is then windowed.

if isempty(x_pca)
    % if no PCA-features exist, only use non-PCA
    z = x_npca;
else
    % get dimensions
    [height, width] = size(cos_window);
    [num_pca_in, num_pca_out] = size(projection_matrix);
    
    % project the PCA-features using the projection matrix and reshape
    % to a window
    x_proj_pca = reshape(x_pca * projection_matrix, [height, width, num_pca_out]);
    
    % concatinate the feature windows
    if isempty(x_npca)
        z = x_proj_pca;
    else
        z = cat(3, x_npca, x_proj_pca);
    end
end

% do the windowing of the output
z = bsxfun(@times, cos_window, z);
end