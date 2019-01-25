function [s,current_size] = sa_dsst(im,pos,s)

    im_patch_scale = getScaleSubwindow(im, pos, s.target_sz, s.scale_factor*s.scale_factors, s.scale_window, s.scale_model_sz, s.hog_scale_cell_size);
    s.xsf = fft(im_patch_scale,[],2);
    scale_response = real(ifft(sum(s.sf_num .* s.xsf, 1) ./ (s.sf_den + s.lambda) ));
   
    recovered_scale = find(scale_response == max(scale_response(:)), 1);
        
    s.scale_factor = s.scale_factor * s.scale_factors(recovered_scale);
    if s.scale_factor < s.min_scale_factor
        s.scale_factor = s.min_scale_factor;
    elseif s.scale_factor > s.max_scale_factor
        s.scale_factor = s.max_scale_factor;
    end
    current_size = s.scale_factor;
    % use new scale to update bboxes for target, filter, bg and fg models
end