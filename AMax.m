I =imread('LCSI.jpg');
[R,C,K]=size(I);
I=rgb2gray(I)
%image=I;
imageArray=I(:);
I=im2double(I)
kernel=ones(3)/9;
meanMatrix=conv2(double(I),kernel,'same');
varianceMatrix = stdfilt(I);
varianceArray=varianceMatrix(:);

[minKValues,Indice] = maxk(meanMatrix(:),10485)
variances=zeros(10485,2);
for i=1:10485
    variances(i,1)=varianceArray(Indice(i));
    variances(i,2)=Indice(i);
end
k=variances
minVariance=min(variances(:,1))
minIndices=[];
for i=1:10485
    if(variances(i,1)==minVariance)
        minIndices=[minIndices,variances(i,2)];
    end
end
l=minIndices
iV=[];
for i=1:numel(minIndices)
   iV=[iV,imageArray(minIndices(i))]; 
end
IV=iV
Airlight=max(IV)
AirlightIndexes=find(IV==Airlight)
for i=1:numel(AirlightIndexes)
    imageArray(l(AirlightIndexes(i)))=255;
end
B = reshape(imageArray,[R,C]);
imshow(B)


