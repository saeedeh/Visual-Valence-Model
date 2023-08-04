# Visual-Valence-Model
Visual Valence Model (VVM) is a random forest regression model that predicts visual valence (VV) from a set of 142 low level visual features. This repositotry contains the trained model along with other data and code related to the project

## File description
**trained_VVM.mat**: The trained VVM model (TreeBagger in matlab); Takes in a matrix of N images * 142 features to predict the VV for each image.

**Estimate_features.m**: Sample code describing how to estimate the 142 low-level visual features for a set of images.
**predictVV.m**: Sample code to predict VV after saving the features with Estimate_features.m
**Synthesized images**: images synthesized to maximize/minimize VV (VV+/VV-) in the visual system using the NeuroGen model
**features**: This directory contains estimated visual features for the images in the database of N~7984 images (large-db), N~500 abstract paintings (abstract-art), and the synthesized images (synthesized).


