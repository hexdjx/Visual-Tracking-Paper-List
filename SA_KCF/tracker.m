function [positions, time] = tracker(video_path, img_files, pos, target_sz, ...
	padding, kernel, lambda, output_sigma_factor, interp_factor, cell_size, ...
	features, show_visualization,s)

    temp = load('w2crs');
    w2c = temp.w2crs;
	%if the target is large, lower the resolution, we don't need that much
	%detail
	resize_image = (sqrt(prod(target_sz)) >= 100);  %diagonal size >= threshold
    if resize_image
        pos = floor(pos / 2);
        target_sz = floor(target_sz / 2);
    end
    
	%window size, taking padding into account
    s.target_sz = target_sz;
    s.scale_factor =1;
    base_target_sz = target_sz;
	window_sz = floor(target_sz * (1 + padding));
	
    im = imread([video_path img_files{1}]);
    
    current_size = 1;
    
    switch s.adaption
    case 'dsst'
        s = sa_dsst_params(s,im,window_sz);
    end
    
%% 高斯期望输出
    output_sigma = sqrt(prod(target_sz)) * output_sigma_factor / cell_size;
    yf = fft2(gaussian_shaped_labels(output_sigma, floor(window_sz / cell_size)));
%% 余弦窗
    cos_window = hann(size(yf,1)) * hann(size(yf,2))';	
    
	time = 0;  %to calculate FPS
	positions = zeros(numel(img_files), 4);  %to calculate precision
   
    for frame = 1:numel(img_files)
        %load image
        im = imread([video_path img_files{frame}]);
        if size(im,3) > 1
            im = rgb2gray(im);
        end
        if resize_image
            im = imresize(im, 0.5);
        end

        tic()

        if frame > 1
            
        %% 尺度自适应
            switch s.adaption
                case 'dsst'
                    pos = response(im,pos,kernel,cell_size, ...
                    features,window_sz,cos_window,model_xf,model_alphaf,w2c);
                    [s,current_size] = sa_dsst(im,pos,s); 
                case 'samf'
                    [pos,current_size] = sa_samf(im,pos,kernel,cell_size, ...
            features,window_sz,cos_window,model_xf,model_alphaf,target_sz,w2c); 
                case 'no_scale'
                    pos = response(im,pos,kernel,cell_size, ...
                    features,window_sz,cos_window,model_xf,model_alphaf,w2c);
                otherwise
                    error('Unknown scale method ')
            end
        end

    %% 更新尺度和搜索窗
        switch s.adaption
            case 'dsst'
                target_sz =round(base_target_sz * current_size);
                tmp_sz = floor((target_sz * (1 + padding)));
                patch = get_subwindow(im, pos, tmp_sz);
                patch = mexResize(patch, window_sz, 'auto');
            case 'samf'
                target_sz =target_sz * current_size;
                tmp_sz = floor((target_sz * (1 + padding)));          
                param0 = [pos(2), pos(1), tmp_sz(2)/window_sz(2), 0,...
                tmp_sz(1)/window_sz(2)/(window_sz(1)/window_sz(2)),0];
                param0 = affparam2mat(param0); 
                patch = uint8(warpimg(double(im), param0, window_sz));
            case 'no_scale'
                patch = get_subwindow(im, pos, window_sz);
            otherwise
                error('Unknown scale method ')
        end
		xf = fft2(get_features(patch, features, cell_size, cos_window,w2c));
  
        %Kernel Ridge Regression, calculate alphas (in Fourier domain)
        switch kernel.type
        case 'gaussian'
            kf = gaussian_correlation(xf, xf, kernel.sigma);
        case 'polynomial'
            kf = polynomial_correlation(xf, xf, kernel.poly_a, kernel.poly_b);
        case 'linear'
            kf = linear_correlation(xf, xf);
        end
        alphaf = yf ./ (kf + lambda);   %equation for fast training
        
        if frame == 1  %first frame, train with a single image
            model_alphaf = alphaf;
            model_xf = xf;
        else
            %subsequent frames, interpolate model
            model_alphaf = (1 - interp_factor) * model_alphaf + interp_factor * alphaf;
            model_xf = (1 - interp_factor) * model_xf + interp_factor * xf;
        end
    %% 更新DSST尺度参数
        if strcmp(s.adaption,'dsst')
            s = sa_dsst_update(im,pos,s,frame);
        end  
    %% 
        positions(frame,1:2) = pos;
        positions(frame,3:4) = target_sz;
        
        time = time + toc();

    %% 可视化
        if show_visualization
            rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
            if frame == 1  %first frame, create GUI
                figure('Name',['Tracker - ' video_path]);
                im_handle = imshow(uint8(im), 'Border','tight', 'InitialMag', 100 + 100 * (length(im) < 500));
                rect_handle = rectangle('Position',rect_position, 'EdgeColor','g');
                text_handle = text(10, 10, int2str(frame));
                set(text_handle, 'color', [0 1 1]);
            else
                try  %subsequent frames, update GUI
                    set(im_handle, 'CData', im)
                    set(rect_handle, 'Position', rect_position)
                    set(text_handle, 'string', int2str(frame));
                catch
                    return
                end
            end
        end 
        drawnow
    end

	if resize_image
		positions = positions * 2;
	end
end

