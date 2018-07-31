
I = (imread('LCSI.jpg'));
%I=rgb2gray(I);
[r,c,k]=size(I)
rChannel=I(:,:,1);
gChannel=I(:,:,2);
bChannel=I(:,:,3);
rArray=rChannel(:);
gArray=gChannel(:);
bArray=bChannel(:);

minArray=zeros(size(rArray));
for i=1:size(rArray)
   minArray(i)=min([rArray(i),gArray(i),bArray(i)]);
end
B=reshape(minArray,[1024,1024])
imshow(B);

fun=@(x) 1-(sqrt(sum(x(:).^2))/(98*3*3));
T = nlfilter(B,[3 3],fun)
imshow(T)

fun2=@(x) 0.3843*(1-(x));
TT=nlfilter(T,[1 1],fun2)
imshow(TT)
%TT=im2double(TT);


r=im2double(rChannel)-im2double(TT);
Jr=im2double(r)./im2double(T);
g=im2double(gChannel)-im2double(TT);
Jg=im2double(g)./im2double(T);
b=im2double(bChannel)-im2double(TT);
Jb=im2double(b)./im2double(T);
%Final(:,:,1)=Jr;
%Final(:,:,2)=Jg;
%Final(:,:,3)=Jb;
%imshow(Final)
imshow(I)
%imshow(Jr)
rgbImage = cat(3, Jr,Jg,Jb);
imshow(rgbImage)
rgbImageGray=rgb2gray(rgbImage);
entropyS=entropy(rgbImageGray)

