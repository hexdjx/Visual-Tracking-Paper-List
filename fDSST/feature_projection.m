function z = feature_projection(x_npca, x_pca, projection_matrix, cos_window)

% get dimensions
[height, width] = size(cos_window);
[num_pca_in, num_pca_out] = size(projection_matrix);

% do the windowing of the output
z = bsxfun(@times, cos_window, reshape(x_pca * projection_matrix, [height, width, num_pca_out]));
end