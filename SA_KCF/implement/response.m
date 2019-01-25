function pos = response(im,pos,kernel,cell_size, ...
            features,window_sz,cos_window,model_xf,model_alphaf,w2c)

     patch = get_subwindow(im,pos,window_sz);
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
    response = real(ifft2(model_alphaf.*kzf));
           
    [vert_delta,horiz_delta] = find(response == max(response(:)), 1);

    if vert_delta > size(zf,1) / 2  %wrap around to negative half-space of vertical axis
        vert_delta = vert_delta - size(zf,1);
    end
    if horiz_delta > size(zf,2) / 2  %same for horizontal axis
        horiz_delta = horiz_delta - size(zf,2);
    end
    pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
end