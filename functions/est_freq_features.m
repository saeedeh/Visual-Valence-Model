function [freq_features]=est_freq_features(img_rgb, theta, f)
  %% est freqs
    if length(size(img_rgb))==2
       imgBW=double(img_rgb);
   else
       imgBW=double(rgb2gray(img_rgb));
   end
   imgBW = imgBW-mean(imgBW(:)); % remove mean
   [n1,n2]=size(imgBW); 
    [fx,fy] = meshgrid(0:n2-1,0:n1-1);fx=fx-n2/2;fy=fy-n1/2;
    g=hamming(n1)*hamming(n2)';
    fftImg=abs(fft2(imgBW.*g)).^2; % compute power spectrum
    fftImg=fftImg/sum(fftImg(:)); % normalize to unit power
    imgFT = fftshift(fftImg);
    for kk=1:length(theta)

        t=theta(kk); fxi=-f*sin(t)*n1; fyi=f*cos(t)*n2; 
        %t is the angle, fxi and fyi are x and y (for indexing) of the 20
        %samples in the direction of t angle
        p=interp2(fx,fy,imgFT,fyi,fxi,'linear'); 

        % Fit the model spectrum = prefactor * f^slope
        lp=log10(p);
        img_feature(:,kk) = lp;
    end
    freq_features=img_feature(:);
end