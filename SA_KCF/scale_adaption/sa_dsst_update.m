function s = sa_dsst_update(im,pos,s,frame)
%% SCALE UPDATE
    im_patch_scale = getScaleSubwindow(im, pos, s.target_sz, s.scale_factor*s.scale_factors, s.scale_window, s.scale_model_sz, s.hog_scale_cell_size);
    s.xsf = fft(im_patch_scale,[],2);
    s.new_sf_num = bsxfun(@times, s.ysf, conj(s.xsf));
    s.new_sf_den = sum(s.xsf .* conj(s.xsf), 1);
    if frame == 1
        s.sf_den = s.new_sf_den;
        s.sf_num = s.new_sf_num;
    else
        s.sf_den = (1 - s.learning_rate_scale) * s.sf_den + s.learning_rate_scale * s.new_sf_den;
        s.sf_num = (1 - s.learning_rate_scale) * s.sf_num + s.learning_rate_scale * s.new_sf_num;
    end
end