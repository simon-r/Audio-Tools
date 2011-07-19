function [ Y ] = noise( time , FS , n_type , ch , varargin )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addOptional('gain_dB', realmax('double') ) ;
p.addOptional('gain_lin', realmax('double') ) ;
p.addOptional('rand_gen', 'uniform' , @(x)strcmpi(x,'uniform') || ... 
    strcmpi(x,'normal') ) ;
p.addOptional('sigma' , 0.2 , @(x)isnumeric(x) && x <= 0.81 && x > 0 ) ;

p.parse(varargin{:});


if p.Results.gain_dB == realmax('double') 
    gain = 0.5 ;
else
    gain = 10^( p.Results.gain_dB / 20 ) ;
end

if p.Results.gain_lin == realmax('double') 
    gain = 0.5 ;
else
    gain = p.Results.gain_lin / 20 ;
end



t = 1/FS ;
samples = floor( time/t ) ;

if strcmpi( p.Results.rand_gen , 'uniform' )
    Y = ( rand(samples,ch) - 0.5 ) * 2 ;
elseif strcmpi( p.Results.rand_gen , 'normal' )
    sigma = p.Results.sigma ;
    Y =  normrnd( 0 , sigma , [samples ch] ) ;
    Y(Y>1) = 1 ;
end



if strcmpi(n_type,'white')
    
    if FS <= 50000
        F = [0:1000:22000] ;
        dB = zeros( 1 , size(F,2) ) ;
    else
        F = [0:1000:24000] ;
        dB = zeros( 1 , size(F,2) ) ;
        dB(size(F,2)) = -80 ;
    end
    
    Y  = equalizer( Y , FS , F , dB ) ;
    
elseif strcmpi(n_type,'pink')
        
    f_max = FS / 2 - 40 ;
    F = [0:1000:22000] ; 
    
    dB = (-66 / f_max ) * F ;
    
    Y  = equalizer( Y , FS , F , dB ) ;
    
elseif strcmpi(n_type,'brownian')
    
    for i = 2:size(Y,1)
        Y(i,:) = Y(i-1,:) + Y(i,:) ;
    end
    
    m = stereo_max( Y ) ;
    Y = Y * 1/m ;
    
    F = [0 15 20  20000 22000] ; 
    dB = [ -200 -100 0 0 -100] ;
    
    Y  = equalizer( Y , FS , F , dB ) ;
    
else
    error('error: noise type not allowed') ;
end


Y = gain_set( Y , FS , gain , 'lin' ) ;

end


