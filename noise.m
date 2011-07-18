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
    
elseif strcmpi(n_type,'pink')
        
    f_max = FS / 2 - 40 ;
    F = [0:1000:22000] ; 
    
    dB = (-60 / f_max ) * F ;
    
    
else
    error('error: noise type not allowed') ;
end

 Y  = equalizer( Y , FS , F , dB ) ;
    
end

