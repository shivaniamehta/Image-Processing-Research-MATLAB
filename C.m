classdef C
    
    methods(Static)


function [result]  = glrlm(img,quantize,mask)
% [SRE,LRE,GLN,RP,RLN,LGRE,HGRE]  = glrlm(img,quantize,mask)
% gray level run length matrix computation
%
% input:
% - img, an input grayscale image (RGB images are converted to grayscale)
% - quantize, quantization levels. Normally set to 16. Should be larger than 1.
% - mask, a binary mask to use with values of 1 at the ROI's. If whole image
%         is needed then mask = ones(size(img(:,:,1)));
%
% output: texture features
%
%    1. SHORT RUN EMPHASIS (SRE) 
%    2. LONG RUN EMPHASIS(LRE)
%    3. GRAY LEVEL NON-UNIFORMITY (GLN)
%    4. RUN PERCENTAGE (RP)
%    5. RUN LENGTH NON-UNIFORMITY (RLN)
%    6. LOW GRAY LEVEL RUN EMPHASIS (LGRE)
%    7. HIGH GRAY LEVEL RUN EMPHASIS (HGRE)
%
% example:
% I = imread('cameraman.tif');
% imshow(I)
% mask = ones(size(I(:,:,1)));
% quantize = 16;
% [SRE,LRE,GLN,RP,RLN,LGRE,HGRE]  = glrlm(I,quantize,mask)
%
% (c) Wout Oude Elferink, 13-5-2015
% University Of Twente, The Netherlands

% if color => make gray scale
if size(img,3)>1
   img = rgb2gray(img); 
end

img = im2double(img); % to double

% crop the image to the mask bounds for faster processing
stats = regionprops(mask,'BoundingBox');
bx = int16(floor(stats.BoundingBox)) + int16(floor(stats.BoundingBox)==0);
img = img(bx(2):bx(2)+bx(4)-1,bx(1):bx(1)+bx(3)-1);
mask = mask(bx(2):bx(2)+bx(4)-1,bx(1):bx(1)+bx(3)-1);

% adjust range
mini = min(img(:));   % find minimum
img = img-mini;       % let the range start at 0
maxi = max(img(:));   % find maximum

% quantize the image to discrete integer values in the range 1:quantize
levels = maxi/quantize:maxi/quantize:maxi-maxi/quantize;
img = imquantize(img,levels);

% apply the mask
img(~mask) = 0;

% initialize glrlm: p(i,j)
% -  with i the amount of bin values (quantization levels)
% -  with j the maximum run length (because yet unknown, assume maximum length
%    of image)
% -  four different orientations are used (0, 45, 90 and 135 degrees)
p0 = zeros(quantize,max(size(img)));
p45 = zeros(quantize,max(size(img)));
p90 = zeros(quantize,max(size(img)));
p135 = zeros(quantize,max(size(img)));

% initialize maximum value for j
maximgS = max(size(img));

% add zeros to the borders
img = padarray(img,[1 1]);

% initialize rotation
img45 = imrotate(img,45);

% find the run length for each quantization level
for i = 1:quantize
    % find the pixels corresponding to the quantization level
    BW = int8(img == i);
    BWr = int8(img45 == i);    
    
    % find the start and end points of the run length
    G0e = (BW(2:end-1,2:end-1) - BW(2:end-1,3:end)) == 1;
    G0s = (BW(2:end-1,2:end-1) - BW(2:end-1,1:end-2)) == 1;
    G45e = (BWr(2:end-1,2:end-1) - BWr(2:end-1,3:end)) == 1;
    G45s = (BWr(2:end-1,2:end-1) - BWr(2:end-1,1:end-2)) == 1;
    G90e = (BW(2:end-1,2:end-1) - BW(3:end,2:end-1)) == 1;
    G90s = (BW(2:end-1,2:end-1) - BW(1:end-2,2:end-1)) == 1;
    G135e = (BWr(2:end-1,2:end-1) - BWr(3:end,2:end-1)) == 1;
    G135s = (BWr(2:end-1,2:end-1) - BWr(1:end-2,2:end-1)) == 1;
    
    % find the indexes
    G0s = G0s'; G0s = find(G0s(:));
    G0e = G0e'; G0e = find(G0e(:));
    G45s = G45s'; G45s = find(G45s(:));
    G45e = G45e'; G45e = find(G45e(:));
    G90s = find(G90s(:));
    G90e = find(G90e(:));
    G135s = find(G135s(:));
    G135e = find(G135e(:));
 
    % find the lengths
    lengths0 = G0e - G0s + 1;
    lengths45 = G45e - G45s + 1;
    lengths90 = G90e - G90s + 1;
    lengths135 = G135e - G135s + 1;
    
    % fill the matrix
    p0(i,:) = hist(lengths0,1:maximgS);
    p45(i,:) = hist(lengths45,1:maximgS);
    p90(i,:) = hist(lengths90,1:maximgS);
    p135(i,:) = hist(lengths135,1:maximgS);    
end

% add all orientations
%p = p0 + p45 + p90 + p135;

% calculate the features
totSump0 = sum(p0(:));
SREp0 = sum(sum(p0,1) ./ ((1:maximgS).^2)) / totSump0;
LREp0 = sum(sum(p0,1) .* ((1:maximgS).^2)) / totSump0;
RLNp0 = sum(sum(p0,1) .^2) / totSump0;
RPp0 = totSump0 / sum(mask(:));
GLNp0 = sum(sum(p0,2) .^2) / totSump0;

totSump45 = sum(p45(:));
SREp45 = sum(sum(p45,1) ./ ((1:maximgS).^2)) / totSump45;
LREp45 = sum(sum(p45,1) .* ((1:maximgS).^2)) / totSump45;
RLNp45 = sum(sum(p45,1) .^2) / totSump45;
RPp45 = totSump45 / sum(mask(:));
GLNp45 = sum(sum(p45,2) .^2) / totSump45;

totSump90 = sum(p90(:));
SREp90 = sum(sum(p90,1) ./ ((1:maximgS).^2)) / totSump90;
LREp90 = sum(sum(p90,1) .* ((1:maximgS).^2)) / totSump90;
RLNp90 = sum(sum(p90,1) .^2) / totSump90;
RPp90 = totSump90 / sum(mask(:));
GLNp90 = sum(sum(p90,2) .^2) / totSump90;


totSump135 = sum(p135(:));
SREp135 = sum(sum(p135,1) ./ ((1:maximgS).^2)) / totSump135;
LREp135 = sum(sum(p135,1) .* ((1:maximgS).^2)) / totSump135;
RLNp135 = sum(sum(p135,1) .^2) / totSump135;
RPp135 = totSump135 / sum(mask(:));
GLNp135 = sum(sum(p135,2) .^2) / totSump135;
%LGRE = sum(sum(p,2) .* ((1:quantize)'.^2)) / totSum;
%HGRE = sum(sum(p,2) .^2) / totSum;
result=[SREp0,LREp0,GLNp0,RLNp0,RPp0,SREp45,LREp45,GLNp45,RLNp45,RPp45,SREp90,LREp90,GLNp90,RLNp90,RPp90,SREp135,LREp135,GLNp135,RLNp135,RPp135];
end
    end
end