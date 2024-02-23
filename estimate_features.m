%% 
% All images are in one folder.
% we first resize the images and then extract features one by one
%  Note that you need to read this code feature by feature and modify it 
% according to your own needs, installe packages, run software etc. 
% The corresponding toolbox or software that may be needed for 
% extracting each feature is listed under its section.
%%

%% set the paths
img_folder='...path to original images..'
imo_folder='path to where you want to save resized images'
features_folder='...path to folder to save extracted features..'
%%
addpath(genpath('..path to "functions" directory provided in github repo'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% resize images to have a width of 400
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read images
last_im=0;
img_fNames=[];

for i=0:N_img-1
    fname=[img_folder,'/img',num2str(i),'.png'];
    if isfile(fname)
        im = imread(fname);
        im2=imresize(im,400/size(im, 1));
        out_fname=strcat(gr,'_max_',num2str(i),'.jpg');
        imwrite(im2, strcat(imo_folder,'/', out_fname))

        last_im=last_im+1;
        img_fNames{last_im}=out_fname;
    end
end
    
gen_info=table(img_fNames');
gen_info = renamevars(gen_info,"Var1","fName");
writetable(gen_info,[features_folder,'/img_info.csv']);

gen_info=readtable([features_folder,'/img_info.csv']);

%
N_img=size(gen_info,1)
%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract CNN variance features
%%%%%%%%%%%%%%%%%%%%%%%%
% download cnn-gui from: https://osf.io/xb983/
% extract the zip file
% in linux terminal run: "source activate mycaffe"
% in my files the loaction is: ~/Desktop/fMRI/Junichi-data/visualFeatures/symmetry/cnn-gui/cnn-gui
% run: python main.py
%source folder:
%%/home/saeedeh/Desktop/aclab-server/Studies/NNdata/analysis/Saeedeh/neatAnalysis/data/images/NSD/generated/Ver.2-trunc-full/images-w400
% Then once run it for symmetry, and once for variance

cnn_features_folder='/home/saeedeh/Desktop/fMRI/Junichi-data/visualFeatures/symmetry/cnn-gui/cnn-gui'


for feat=["Var","Sym"]

    if strcmp(feat,'Var')
        in_fname=[cnn_features_folder, '/variance.csv'];
        out_fname='/cnn_variance.csv';
    elseif strcmp(feat,'Sym')
        in_fname=[cnn_features_folder, '/symmetry.csv'];
        out_fname='/cnn_symmetry.csv';
    end
    img_names=gen_info.fName;
    tbl=readtable(in_fname, 'HeaderLines',1 );
    cnn_features=[];
    N_vars=size(tbl,2);
    for f=1:N_img
       fname= img_names{f}
       ind=find(strcmp(tbl.Var2, fname));
       cnn_features(f, :)=table2array(tbl(ind, 3:N_vars));
    end
    csvwrite([features_folder,out_fname],cnn_features)
end
    %[~, f_names] = cellfun(@fileparts, {img_names.name}, 'uniform', 0);
%csvwrite([features_folder,'/fnames.csv'],cell2table(f_names'))

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract color name features
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% download the color naming toolbox and add to path
% http://lear.inrialpes.fr/people/vandeweijer/code/ColorNaming.tar
% Paper:
%Learning Color Names for Real-World Applications
% J. van de Weijer, C. Schmid, J. Verbeek, D. Larlus.
% IEEE Transactions in Image Processing 2009.

% params
load('w2c.mat');
im=double(imread('colorWheel.jpg'));     
out2=im2c(im,w2c,-1);   
bins=unique(out2(:,:,1)+out2(:,:,2)/2+out2(:,:,3)/3);
   
color_features=zeros(N_img,11); % 
for i=1:N_img
    if mod(i,10)==0
       i 
    end
    imFName=strcat(imo_folder,'/', gen_info.fName{i});
    im=imread(imFName);
    color_features(i, 1:11)=est_color_features(im, w2c, bins);
end

csvwrite([features_folder,'/colorName_features_N11.csv'],color_features)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% extract freq features
%spatial frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_features=zeros(N_img,80); % 
%% parameters
fb=[0.01 0.45]; % interval of frequencies (in cycles per pixel => max value = .5)
Nangles = 4;    % Number of angles
theta=linspace(0, pi, Nangles+1); theta = theta(1:end-1);
f=logspace(log10(fb(1)), log10(fb(2)), 20); % select 20 points along a radial axis

for i=1:N_img
    if mod(i,100)==0
       i 
    end
    imFName=strcat(imo_folder,'/', gen_info.fName{i});
    im=imread(imFName);
    freq_features(i, 1:80)=est_freq_features(im, theta, f);
end
csvwrite([features_folder,'/freq_features.csv'],freq_features)


%% extract face features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% install face detection toolbox: 
% https://www.mathworks.com/matlabcentral/fileexchange/73947-mtcnn-face-detection

face_features=zeros(N_img,3); % 
%% parameters
for i=1:N_img
    if mod(i,100)==0
       i 
    end
    if mod(i,1000)==0
       i
       csvwrite([features_folder,'/face_features.csv'],face_features(1:i,:))
    end
    imFName=strcat(imo_folder,'/', gen_info.fName{i});
    im=imread(imFName);
    %imFName=strcat(out_folder,'/',string(i),'.jpg');
    %im=imread(imFName);
    face_features(i, 1:3)=est_face_features(im);
end
csvwrite([features_folder,'/face_features.csv'],face_features)

%% extract avg color features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avgHue_features=zeros(N_img,1);
avgBright_features=zeros(N_img,1);
avgSat_features=zeros(N_img,1);
%% parameters
for i=1:N_img
    imFName=strcat(imo_folder,'/', gen_info.fName{i});
    im=imread(imFName);
    [avg_hue, avg_sat, avg_bright]=est_avgColor_features(im);
    avgHue_features(i)=avg_hue;
    avgSat_features(i)=avg_sat;
    avgBright_features(i)=avg_bright;
end
csvwrite([features_folder,'/avg_hue.csv'],avgHue_features)
csvwrite([features_folder,'/avg_bright.csv'],avgBright_features)
csvwrite([features_folder,'/avg_saturation.csv'],avgSat_features)






