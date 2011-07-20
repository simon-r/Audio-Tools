function [ D ] = echo( Y , FS , varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


delay = 0.3 ;
sigma = 0.0003 ;
gain = 0.2 ;

t = 1/FS ;

c_time = delay * 2 ;
C = -c_time:t:c_time ;

X = normpdf( C , delay , sigma ) * (sigma*sqrt(2*pi)) * gain ;
X(floor(size(C,2)/2)) = 1 ;

sizeY = size(Y) ;

for ch=1:sizeY(2) 
    D(:,ch) = conv( Y(:,ch) , X , 'same' ) ;
end

my = stereo_max( Y ) ; 
m = stereo_max( D ) ;
D = D * my/m ;

end

