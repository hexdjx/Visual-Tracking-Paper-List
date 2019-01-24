function [pos,t_max] = response(im,pos,kernel,cell_size, ...
            features,window_sz,cos_window,model_xf,model_alphaf,tmp_sz)

    patch = get_subwindow(im,pos,tmp_sz);
    patch = mexResize(patch,window_sz,'auto');  
    
    zf = fft2(get_features(patch, features, cell_size, cos_window));

    %calculate response of the classifier at all shifts
   
    kzf = gaussian_correlation(zf, model_xf, kernel.sigma);
    
    response = real(ifft2(model_alphaf.*kzf));
           
    [vert_delta,horiz_delta] = find(response == max(response(:)), 1);

    if vert_delta > size(zf,1) / 2  %wrap around to negative half-space of vertical axis
        vert_delta = vert_delta - size(zf,1);
    end
    if horiz_delta > size(zf,2) / 2  %same for horizontal axis
        horiz_delta = horiz_delta - size(zf,2);
    end
    pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
    t_max= max(response(:));
end