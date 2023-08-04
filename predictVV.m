%% This is a sample code to predict Visual Valence (VV) for a set of images
% First estimate_features for the images, then load the features and the
% trained model to predict VV.
% The predicted VV is on a 1-9 scale (1=most negative, 9=most positive)


%% 1) run estimate_features.m script

%% 2) load features
features_folder='features/large-db';

avg_sat=csvread([features_folder,'/avg_saturation.csv']);
avg_bright=csvread([features_folder,'/avg_bright.csv']);
avg_hue=csvread([features_folder,'/avg_hue.csv']);
freq_features=csvread([features_folder,'/freq_features.csv']);
colorName_features=csvread([features_folder,'/colorName_features_N11.csv']);
symmetry_features=csvread([features_folder,'/symmetry.csv']);
face_features=csvread([features_folder,'/face_features.csv']);
variance_features=csvread([features_folder,'/cnn_variance.csv']);
avg_color_features=[avg_hue', avg_sat', avg_bright'];
features_all=[
        colorName_features ,avg_color_features, symmetry_features, ...
        freq_features, variance_features
       ];


%% load the model and predict
load("trained_VVM.mat"); %loads the TreeBagger named 'mdl'
% You need to install "Statistics and Machine Learning Toolbox" to run this: 
VV=predict(mdl, features_all); %predicted visual valence (VV) for images on a 1-9 scale


