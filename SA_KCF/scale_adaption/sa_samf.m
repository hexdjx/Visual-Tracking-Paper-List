function [pos,current_size] = sa_samf(im,pos,kernel,cell_size, ...
            features,window_sz,cos_window,model_xf,model_alphaf,target_sz,w2c) 
    search_size =  [1  0.985 0.99 0.995 1.005 1.01 1.015]; 
    num_scale = size(search_size,2);
    size_ver = size(cos_window,1);
    size_hor = size(cos_window,2);
    response = zeros(size_ver,size_hor,num_scale);

    for i=1:size(search_size,2)
        tmp_sz = floor((target_sz * (1 + 1.5))*search_size(i));
        
        param0 = [pos(2), pos(1), tmp_sz(2)/window_sz(2), 0,...
            tmp_sz(1)/window_sz(2)/(window_sz(1)/window_sz(2)),0];
        param0 = affparam2mat(param0); 
        patch = uint8(warpimg(double(im), param0, window_sz));
    
        zf = fft2(get_features(patch, features, cell_size, cos_window,w2c));

        %calculate response of the classifier at all shifts
        switch kernel.type
            case 'gaussian'
                kzf = gaussian_correlation(zf, model_xf, kernel.sigma);
            case 'polynomial'
                kzf = polynomial_correlation(zf, model_xf, kernel.poly_a, kernel.poly_b);
            case 'linear'
                kzf = linear_correlation(zf, model_xf);
        end
        response(:,:,i) = real(ifft2(model_alphaf .* kzf));  %equation for fast detection
    end
   
    [vert_delta,tmp, ~] = find(response == max(response(:)), 1);

    szid = floor((tmp-1)/(size(cos_window,2)))+1;

    horiz_delta = tmp - ((szid -1)* size(cos_window,2));
    if vert_delta > size(zf,1) / 2 %wrap around to negative half-space of vertical axis
        vert_delta = vert_delta - size(zf,1);
    end
    if horiz_delta > size(zf,2) / 2  %same for horizontal axis
        horiz_delta = horiz_delta - size(zf,2);
    end
  
    current_size = search_size(szid);
    
    pos = pos + current_size*cell_size * [vert_delta - 1, horiz_delta - 1];
end





