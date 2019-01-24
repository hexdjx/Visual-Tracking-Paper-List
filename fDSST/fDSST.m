function results = fDSST(params)

video_path = params.video_path;
padding = params.padding;
output_sigma_factor = params.output_sigma_factor;
lambda = params.lambda;
interp_factor = params.interp_factor;
refinement_iterations = params.refinement_iterations;
translation_model_max_area = params.translation_model_max_area;
nScales = params.number_of_scales;
nScalesInterp = params.number_of_interp_scales;
scale_step = params.scale_step;
scale_sigma_factor = params.scale_sigma_factor;
scale_model_factor = params.scale_model_factor;
scale_model_max_area = params.scale_model_max_area;
interpolate_response = params.interpolate_response;
num_compressed_dim = params.num_compressed_dim;


s_frames = params.s_frames;
pos = floor(params.init_pos);
target_sz = floor(params.wsize * params.resize_factor);

visualization = params.visualization;

num_frames = numel(s_frames);

init_target_sz = target_sz;

if prod(init_target_sz) > translation_model_max_area
    currentScaleFactor = sqrt(prod(init_target_sz) / translation_model_max_area);
else
    currentScaleFactor = 1.0;
end

% target size at the initial scale
base_target_sz = target_sz / currentScaleFactor;

%window size, taking padding into account
sz = floor( base_target_sz * (1 + padding ));

featureRatio = 4;

output_sigma = sqrt(prod(floor(base_target_sz/featureRatio))) * output_sigma_factor;
use_sz = floor(sz/featureRatio);
rg = circshift(-floor((use_sz(1)-1)/2):ceil((use_sz(1)-1)/2), [0 -floor((use_sz(1)-1)/2)]);
cg = circshift(-floor((use_sz(2)-1)/2):ceil((use_sz(2)-1)/2), [0 -floor((use_sz(2)-1)/2)]);

[rs, cs] = ndgrid( rg,cg);
y = exp(-0.5 * (((rs.^2 + cs.^2) / output_sigma^2)));
yf = single(fft2(y));

interp_sz = size(y) * featureRatio;

cos_window = single(hann(floor(sz(1)/featureRatio))*hann(floor(sz(2)/featureRatio))' );


if nScales > 0
    scale_sigma = nScalesInterp * scale_sigma_factor;
    
    scale_exp = (-floor((nScales-1)/2):ceil((nScales-1)/2)) * nScalesInterp/nScales;
    scale_exp_shift = circshift(scale_exp, [0 -floor((nScales-1)/2)]);
    
    interp_scale_exp = -floor((nScalesInterp-1)/2):ceil((nScalesInterp-1)/2);
    interp_scale_exp_shift = circshift(interp_scale_exp, [0 -floor((nScalesInterp-1)/2)]);
    
    scaleSizeFactors = scale_step .^ scale_exp;
    interpScaleFactors = scale_step .^ interp_scale_exp_shift;
    
    ys = exp(-0.5 * (scale_exp_shift.^2) /scale_sigma^2);
    ysf = single(fft(ys));
    scale_window = single(hann(size(ysf,2)))';
    
    %make sure the scale model is not to large, to save computation time
    if scale_model_factor^2 * prod(init_target_sz) > scale_model_max_area
        scale_model_factor = sqrt(scale_model_max_area/prod(init_target_sz));
    end
    
    %set the scale model size
    scale_model_sz = floor(init_target_sz * scale_model_factor);
    
    im = imread([video_path,s_frames{1}]);
    
    %force reasonable scale changes
    min_scale_factor = scale_step ^ ceil(log(max(5 ./ sz)) / log(scale_step));
    max_scale_factor = scale_step ^ floor(log(min([size(im,1) size(im,2)] ./ base_target_sz)) / log(scale_step));
    
    max_scale_dim = strcmp(params.s_num_compressed_dim,'MAX');
    if max_scale_dim
        s_num_compressed_dim = length(scaleSizeFactors);
    else
        s_num_compressed_dim = params.s_num_compressed_dim;
    end
end

% initialize the projection matrix
projection_matrix = [];

rect_position = zeros(num_frames, 4);

time = 0;

for frame = 1:num_frames
    %load image
    im = imread([video_path,s_frames{frame}]);
    
    tic();
    
    %do not estimate translation and scaling on the first frame, since we 
    %just want to initialize the tracker there
    if frame > 1
        old_pos = inf(size(pos));
        iter = 1;
        
        %translation search
        while iter <= refinement_iterations && any(old_pos ~= pos)
            [xt_npca, xt_pca] = get_subwindow(im, pos, sz, currentScaleFactor);
            
            xt = feature_projection(xt_npca, xt_pca, projection_matrix, cos_window);
            xtf = fft2(xt);
            
            responsef = sum(hf_num .* xtf, 3) ./ (hf_den + lambda);
            
            % if we undersampled features, we want to interpolate the
            % response so it has the same size as the image patch
            if interpolate_response > 0
                if interpolate_response == 2
                    % use dynamic interp size
                    interp_sz = floor(size(y) * featureRatio * currentScaleFactor);
                end
                
                responsef = resizeDFT2(responsef, interp_sz);
            end
            
            response = ifft2(responsef, 'symmetric');
            
            [row, col] = find(response == max(response(:)), 1);
            disp_row = mod(row - 1 + floor((interp_sz(1)-1)/2), interp_sz(1)) - floor((interp_sz(1)-1)/2);
            disp_col = mod(col - 1 + floor((interp_sz(2)-1)/2), interp_sz(2)) - floor((interp_sz(2)-1)/2);
            
            switch interpolate_response
                case 0
                    translation_vec = round([disp_row, disp_col] * featureRatio * currentScaleFactor);
                case 1
                    translation_vec = round([disp_row, disp_col] * currentScaleFactor);
                case 2
                    translation_vec = [disp_row, disp_col];
            end
            
            old_pos = pos;
            pos = pos + translation_vec;
            
            iter = iter + 1;
        end
        
        %scale search
        if nScales > 0
            
            %create a new feature projection matrix
            [xs_pca, xs_npca] = get_scale_subwindow(im,pos,base_target_sz,currentScaleFactor*scaleSizeFactors,scale_model_sz);
            
            xs = feature_projection_scale(xs_npca,xs_pca,scale_basis,scale_window);
            xsf = fft(xs,[],2);
            
            scale_responsef = sum(sf_num .* xsf, 1) ./ (sf_den + lambda);
            
            interp_scale_response = ifft( resizeDFT(scale_responsef, nScalesInterp), 'symmetric');
            
            recovered_scale_index = find(interp_scale_response == max(interp_scale_response(:)), 1);
        
            %set the scale
            currentScaleFactor = currentScaleFactor * interpScaleFactors(recovered_scale_index);
            %adjust to make sure we are not to large or to small
            if currentScaleFactor < min_scale_factor
                currentScaleFactor = min_scale_factor;
            elseif currentScaleFactor > max_scale_factor
                currentScaleFactor = max_scale_factor;
            end
        end
    end
    
    %this is the training code used to update/initialize the tracker
    
    %Compute coefficients for the tranlsation filter
    [xl_npca, xl_pca] = get_subwindow(im, pos, sz, currentScaleFactor);
    
    if frame == 1
        h_num_pca = xl_pca;
        h_num_npca = xl_npca;
        
        % set number of compressed dimensions to maximum if too many
        num_compressed_dim = min(num_compressed_dim, size(xl_pca, 2));
    else
        h_num_pca = (1 - interp_factor) * h_num_pca + interp_factor * xl_pca;
        h_num_npca = (1 - interp_factor) * h_num_npca + interp_factor * xl_npca;
    end;
    
    data_matrix = h_num_pca;
    
    [pca_basis, ~, ~] = svd(data_matrix' * data_matrix);
    projection_matrix = pca_basis(:, 1:num_compressed_dim);
    
    hf_proj = fft2(feature_projection(h_num_npca, h_num_pca, projection_matrix, cos_window));
    hf_num = bsxfun(@times, yf, conj(hf_proj));
    
    xlf = fft2(feature_projection(xl_npca, xl_pca, projection_matrix, cos_window));
    new_hf_den = sum(xlf .* conj(xlf), 3);
    
    if frame == 1
        hf_den = new_hf_den;
    else
        hf_den = (1 - interp_factor) * hf_den + interp_factor * new_hf_den;
    end
    
    %Compute coefficents for the scale filter
    if nScales > 0
        
        %create a new feature projection matrix
        [xs_pca, xs_npca] = get_scale_subwindow(im, pos, base_target_sz, currentScaleFactor*scaleSizeFactors, scale_model_sz);
        
        if frame == 1
            s_num = xs_pca;
        else
            s_num = (1 - interp_factor) * s_num + interp_factor * xs_pca;
        end;
        
        bigY = s_num;
        bigY_den = xs_pca;
        
        if max_scale_dim
            [scale_basis, ~] = qr(bigY, 0);
            [scale_basis_den, ~] = qr(bigY_den, 0);
        else
            [U,~,~] = svd(bigY,'econ');
            scale_basis = U(:,1:s_num_compressed_dim);
        end
        scale_basis = scale_basis';
        
        %create the filter update coefficients
        sf_proj = fft(feature_projection_scale([],s_num,scale_basis,scale_window),[],2);
        sf_num = bsxfun(@times,ysf,conj(sf_proj));
        
        xs = feature_projection_scale(xs_npca,xs_pca,scale_basis_den',scale_window);
        xsf = fft(xs,[],2);
        new_sf_den = sum(xsf .* conj(xsf),1);
        
        if frame == 1
            sf_den = new_sf_den;
        else
            sf_den = (1 - interp_factor) * sf_den + interp_factor * new_sf_den;
        end;
    end
    
    target_sz = floor(base_target_sz * currentScaleFactor);
    
    %save position and calculate FPS
    rect_position(frame,:) = [pos([2,1]) - floor(target_sz([2,1])/2), target_sz([2,1])];
    
    time = time + toc();
    
    %visualization
    if visualization == 1
        rect_position_vis = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
        if frame == 1
            figure;
            im_handle = imshow(im, 'Border','tight', 'InitialMag', 100 + 100 * (length(im) < 500));
            rect_handle = rectangle('Position',rect_position_vis, 'EdgeColor','g');
            text_handle = text(10, 10, int2str(frame));
            set(text_handle, 'color', [0 1 1]);
        else
            try
                set(im_handle, 'CData', im)
                set(rect_handle, 'Position', rect_position_vis)
                set(text_handle, 'string', int2str(frame));
                
            catch
                return
            end
        end
        
        drawnow
        %pause
    end
end

fps = numel(s_frames) / time;

% disp(['fps: ' num2str(fps)])

results.type = 'rect';
results.res = rect_position;
results.fps = fps;
