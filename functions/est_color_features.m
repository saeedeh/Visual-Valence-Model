function [color_features]=est_color_features(img_rgb, w2c, bins)

%% main

   res= im2c(double(img_rgb),w2c,-1);
   ar=squeeze(res(:,:,1)+res(:,:,2)/2+res(:,:,3)/3);
   ar=ar(:);
   for c=1:11
      dif= ((abs(ar-bins(c)))<0.01);
      feat(c)=mean(dif);
   end
   color_features= feat;
end

