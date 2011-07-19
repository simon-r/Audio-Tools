function [ Y ] = noise( time , FS , n_type , ch )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

t = 1/FS ;
samples = floor( time/t ) ;

Y = ( rand(samples,ch) - 0.5 ) * 2 ;

if strcmpi(n_type,'white')
    
    if FS <= 50000
        F = [0:1000:22000] ;
        dB = zeros( 1 , size(F,2) ) ;
    else
        F = [0:1000:24000] ;
        dB = zeros( 1 , size(F,2) ) ;
        dB(size(F,2)) = -60 ;
    end
    
    Y  = equalizer( Y , FS , F , dB ) ;
    
elseif strcmpi(n_type,'pink')
        
    f_max = FS / 2 - 40 ;
    F = [0:1000:22000] ; 
    
    dB = (-60 / f_max ) * F ;
    
    Y  = equalizer( Y , FS , F , dB ) ;
    
elseif strcmpi(n_type,'brownian')
    
    for i = 2:size(Y,1)
        Y(i,:) = Y(i-1,:) + Y(i,:) ;
    end
    
    m = stereo_max( Y , ch ) ;
    Y = Y * 1/m ;
    
else
    error('error: noise type not allowed') ;
end

end



function m = stereo_max( X , channels )

for i = 1:channels
    mv(i) = max ( abs( X(:,i) ) ) ;
end

m = max( mv ) ;
end