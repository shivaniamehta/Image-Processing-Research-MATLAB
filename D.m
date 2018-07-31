classdef D
    
methods(Static)

function H = hog(I)

I=double(I);

x = 2;        % no of windows in x direction
y = 5;        % no of windows in y direction
B = 8;        % no of histogram bins

[R,C] = size(I);

H = zeros(x*y*B,1); % HOG feature vector initialisation

step_x = floor(C/(x+1));
step_y = floor(R/(y+1));

count=0;

rem_x = rem(size(I,1),step_x);
rem_y = rem(size(I,2),step_y);
if rem_x ~= 0 && rem_y == 0 
    I = padarray(I, [step_x-rem_x 0],'post');
elseif rem_x == 0 && rem_y ~= 0
    I = padarray(I, [0 step_y-rem_y],'post');
else
    I = padarray(I, [step_x-rem_x step_y-rem_y],'post');
end

% SOBEL OPERATOR
Fx = [-1,0,1];
Fy = Fx';

Gx = imfilter(double(I),Fx);          % gradient in x direction
Gy = imfilter(double(I),Fy);          % gradient in y direction

angles = atan2(Gy,Gx);             % DIRECTION
magnit = sqrt((Gy.^2)+(Gx.^2));    % MAGNITUDE

for m = 0 : x-1
    for n = 0 : y-1
        count = count+1;
        % 50% overlapping
        ang = angles( n*step_y+1:(n+2)*step_y , m*step_x+1:(m+2)*step_x ); 
        mag = magnit( n*step_y+1:(n+2)*step_y , m*step_x+1:(m+2)*step_x );
        angV = ang(:);             % converting 2-D direction matrix to a vector 
        magV = mag(:);             % converting 2-D magnitude matrix to a vector
        K = size(angV,1);            
        
        bin = 0;
        temp = zeros(B,1);
        for ang_lim = -pi+2*pi/B : 2*pi/B : pi % As angles returned is in the closed interval [-pi,pi]
            bin = bin + 1;
            for l = 1:K
                if angV(l) < ang_lim
                    angV(l) = Inf;             % So that further it can't be used
                    temp(bin) = temp(bin)+magV(l);
                end
            end
        end
        temp = temp/norm(temp);        
        H((count-1)*B+1 : count*B,1) = temp; % UPDATING HOG FEATURE VECTOR
    end
end
end
end
end