classdef A

methods(Static)

function [ result  ] = fof( img )
%grayImage = rgb2gray(img); 
grayImage = img; 

%m=mean(grayImage(:));
 [pixelCounts, gls] = imhist(img);
  NM = sum(pixelCounts); % number of pixels
    %C = A.*B multiplies arrays A and B element by element and returns the result in C.

    %  mean
    meangl = sum(gls .* (pixelCounts / NM));
    
    avgcont=0;
    skewness=0;
    kurtosis=0;
   for i=0:length(pixelCounts)-1
    avgcont = avgcont + (i-meangl)^2 * (pixelCounts(i+1)/NM);
    skewness=skewness+(i-meangl)^3 * (pixelCounts(i+1)/NM);
    kurtosis=kurtosis+(i-meangl)^4 * (pixelCounts(i+1)/NM)-3;
   end
%    s1= skewness(grayImage);
%    k=kurtosis(grayImage);
    skewness = skewness * avgcont ^-3; 
    kurtosis = kurtosis * avgcont ^-4; 
    energy = sum((pixelCounts / NM) .^ 2);
    entropy1 = entropy(grayImage);
     
   result=[meangl,avgcont,skewness,kurtosis,energy,entropy1];
   
  

end
end
end