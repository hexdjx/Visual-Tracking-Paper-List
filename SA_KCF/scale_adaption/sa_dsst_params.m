function s = sa_dsst_params(s,im,sz)
    % Code from DSST
    scale_sigma = sqrt(s.num_scales) * s.scale_sigma_factor;
    ss = (1:s.num_scales) - ceil(s.num_scales/2);
    ys = exp(-0.5 * (ss.^2) / scale_sigma^2);
    s.ysf = single(fft(ys));
    if mod(s.num_scales,2) == 0
        s.scale_window = single(hann(s.num_scales+1));
        s.scale_window = s.scale_window(2:end);
    else
        s.scale_window = single(hann(s.num_scales));
    end;

    ss = 1:s.num_scales;
    s.scale_factors = s.scale_step.^(ceil(s.num_scales/2) - ss);

    scale_model_factor = 1;
    if prod(s.target_sz) > s.scale_model_max_area
        scale_model_factor = sqrt(s.scale_model_max_area/prod(s.target_sz));
    end
    s.scale_model_sz = floor(s.target_sz * scale_model_factor);
  
    % find maximum and minimum scales
    s.min_scale_factor = s.scale_step ^ ceil(log(max(5 ./ sz)) / log(s.scale_step));
    s.max_scale_factor = s.scale_step ^ floor(log(min([size(im,1) size(im,2)] ./ s.target_sz)) / log(s.scale_step));

end
