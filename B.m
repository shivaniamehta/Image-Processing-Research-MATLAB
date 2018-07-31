classdef B
    
methods(Static)



function [ result ] = glcmf( img )
grayImage = img;  

glcmd0=graycomatrix(grayImage,'offset',[0 1]); 

glcmd45=graycomatrix(grayImage,'offset',[-1 1]); 
 glcmd90=graycomatrix(grayImage,'offset',[-1 0]); 
                                                        % 45 engle degree  
glcmd135 = graycomatrix(grayImage,'Offset',[-1 -1] ); % 135 engle degree

glcmd20=graycomatrix(grayImage,'offset',[0 2]); 

glcmd245=graycomatrix(grayImage,'offset',[-2 2]); 
 glcmd290=graycomatrix(grayImage,'offset',[-2 0]); 
                                                        % 45 engle degree  
glcmd2135 = graycomatrix(grayImage,'Offset',[-2 -2] ); % 135 engle degree


gfd0=glcmef( glcmd0);
gfd45=glcmef( glcmd45);
gfd90=glcmef( glcmd90);
gfd135=glcmef( glcmd135);
gfd20=glcmef( glcmd20);
gfd245=glcmef( glcmd245);
gfd290=glcmef( glcmd290);
gfd2135=glcmef( glcmd2135);
function [ result ] = glcmef( glcm )
[m n]=size(glcm);
  N = sum(sum(glcm));
    G = glcm/N;

 Contrast=0;
 energy=0;
 homogeneity=0;
 invdiff=0;
 absval=0;
 entropy=0;
 %cr=0;

          for i=1:m
          for j=1:n

Contrast = Contrast + ((i-j)^2)* G(i,j);
energy=energy+(G(i,j))^2;
homogeneity=homogeneity+G(i,j)/(1+abs(i-j));
maxprob=max(G(i,j));
invdiff=invdiff+G(i,j)/(1+(i-j)^2);
absval=absval+abs(i-j)*G(i,j);
entropy=entropy-sum(G(i,j)*log2(G(i,j)+ eps));
%entropy1=entropy1-nansum(G(i,j)*log2(G(i,j)));         
                 stats=graycoprops(glcm,{'correlation'});
                 result=[entropy,stats.Correlation,homogeneity,absval,Contrast,invdiff,maxprob,energy];
              end
          end
result=[entropy,stats.Correlation,homogeneity,absval,Contrast,invdiff,maxprob,energy];
                % disp(stats.Correlation );

end
   
result=[gfd0,gfd45,gfd90,gfd135,gfd20,gfd245,gfd290,gfd2135];
end
end
end
%%