function [avg_hue, avg_sat, avg_bright]=est_avgColor_features(img_rgb)
   img=rgb2hsv(img_rgb);
   img_flat=reshape(img, [size(img,1)*size(img,2), 3]);
   H=img_flat(:,1);
   S=img_flat(:,2);
   V=img_flat(:,3);

   avg_sat=mean(S);
   avg_bright=mean(V);
   avg_hue=mean(H);
end