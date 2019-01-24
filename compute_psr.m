

function psr = compute_psr(corrplane)
sz = size(corrplane);
corrplane = circshift(corrplane, floor(sz(1:2) / 2) - 1);
max_c = max(corrplane(:));
[y,x] = find(corrplane == max_c);
num_b=1;
if size(corrplane,1)>11 && size(corrplane,2)>11
     for i=1:size(corrplane,1)
         for j=1:size(corrplane,2)
             if ~(i>y-5&&i<y+5&&j>x-5&&j<x+5)
                temp(num_b)=corrplane(i,j);num_b=num_b+1;
             end
         end
     end
     std_c=std(temp(:));
     mean_c=mean(temp(:));
     psr=(max_c-mean_c)/std_c;
else
     psr = 50;
end
 
% comp_cor_sm=corrplane(a,b);
% corrplane_sm=comp_cor_sm((size(comp_cor_sm,1)/2-target_sz(1)/2):(size(comp_cor_sm,1)/2+target_sz(1)/2),(size(comp_cor_sm,2)/2-target_sz(2)/2):(size(comp_cor_sm,2)/2+target_sz(2)/2));
% std_c=std(corrplane_sm(:));
% mean_c=mean(corrplane_sm(:));
% std_c=std(corrplane_sm(:));
% mean_c=mean(corrplane_sm(:));

%psr = 1/(std_c*sqrt(2*pi))*exp(-(max_c - mean_c)^2/(2*std_c^2));
%psr = (max_c - mean_c)/std_c/sqrt(prod(target_sz));
%corrplane = normalize_image(corrplane);
% startpoint=[floor(size(corrplane,1)/2)-20,floor(size(corrplane,2)/2)-20];
% pce_t=corrplane(startpoint(1):startpoint(1)+40,startpoint(2):startpoint(2)+40);

