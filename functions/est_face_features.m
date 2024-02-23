function [face_features]=est_face_features(img)
   bbox= mtcnn.detectFaces(img);
   n_face=size(bbox, 1);
   if n_face==0
       face_features(1:3)=[0,0,0];
   else       
       size_img=size(img,1)*size(img,2);
       size_faces=(bbox(:,3)).*(bbox(:,4));
       largest_face= max(size_faces)/size_img;
       sum_face_size=sum(size_faces)/size_img;
       face_features(1:3)=[n_face, largest_face, sum_face_size];
   end
end
