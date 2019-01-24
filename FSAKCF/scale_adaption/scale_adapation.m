function current_size = scale_adapation(im,pos,kernel,cell_size, ...
            features,window_sz,cos_window,model_xf,model_alphaf,target_sz,c_max)      
        
for i=1:2
    if i ==1
        tmp_sz = floor((target_sz * (1 + 1.5))*(1-0.015));
        patch = get_subwindow(im,pos,tmp_sz);
        patch = mexResize(patch,window_sz,'auto');  
        zf = fft2(get_features(patch, features, cell_size, cos_window));
        kzf = gaussian_correlation(zf, model_xf, kernel.sigma);
        response= real(ifft2(model_alphaf .* kzf));
        l_max = max(response(:));
    else
        tmp_sz = floor((target_sz * (1 + 1.5))*(1+0.015));
        patch = get_subwindow(im,pos,tmp_sz);
        patch = mexResize(patch,window_sz,'auto');  
        zf = fft2(get_features(patch, features, cell_size, cos_window));
        kzf = gaussian_correlation(zf, model_xf, kernel.sigma);
        response= real(ifft2(model_alphaf .* kzf));
        r_max = max(response(:));
    end   
end
[t_max,index] = max([l_max,c_max,r_max]);
switch index
    case 1
        flag = 1;
        step = -0.015;
        i = 0;
        while flag&&i<=5
            i=i+1;
            tmp_sz = floor((target_sz * (1 + 1.5))*(0.985+step));

            patch = get_subwindow(im,pos,tmp_sz);
            patch = mexResize(patch,window_sz,'auto');

%             param0 = [pos(2), pos(1), tmp_sz(2)/window_sz(2), 0,...
%             tmp_sz(1)/window_sz(2)/(window_sz(1)/window_sz(2)),0];
%             param0 = affparam2mat(param0); 
%             patch = uint8(warpimg(double(im), param0, window_sz));

            zf = fft2(get_features(patch, features, cell_size, cos_window));

            kzf = gaussian_correlation(zf, model_xf, kernel.sigma);

            response = real(ifft2(model_alphaf .* kzf));

            if max(response(:))>t_max
                step = step - 0.015;
            else
                flag = 0;
            end
        end
        current_size = 0.985+step+0.015;
    case 2
        current_size = 1;
    case 3
        step = 0.015;
        flag = 1;
        i = 0;
        while flag&&i<=5
            i=i+1;
            tmp_sz = floor((target_sz * (1 + 1.5))*(1.015+step));

            patch = get_subwindow(im,pos,tmp_sz);
            patch = mexResize(patch,window_sz,'auto');

%             param0 = [pos(2), pos(1), tmp_sz(2)/window_sz(2), 0,...
%             tmp_sz(1)/window_sz(2)/(window_sz(1)/window_sz(2)),0];
%             param0 = affparam2mat(param0); 
%             patch = uint8(warpimg(double(im), param0, window_sz));

            zf = fft2(get_features(patch, features, cell_size, cos_window));

            kzf = gaussian_correlation(zf, model_xf, kernel.sigma);

            response = real(ifft2(model_alphaf .* kzf));

            if max(response(:))>t_max
                step = step +0.015;
            else
                flag = 0;
            end
        end
        current_size = 1.015+step-0.015;
end