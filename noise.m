function [ Y samples time ] = noise( time , FS , n_type , ch , varargin )
%
%function [ Y ] = noise( time , FS , n_type , ch , varargin )
%
%   return a random noise.
%
% Arguments:
%   time: noise duration in seconds
%   FS: sampling freq.
%   n_type: noise type; must be 'white', 'pink' or 'brownian'
%   ch: number of channels
%   
% Otional parameters:
%   'gain_dB' : set the gain in dB (the default value is -6 dB)
%   'gain_lin' : set the linear gain
%   'rand_gen' : random generator must be 'uniform' (default) or 'normal'
%   'sigma' : the sigma for the nornal rand generator (defaul: 0.2)
%   'remove_brownian_bass' : remove the very low bass freq. from the
%                            brownian noise (default: 'yes' )
%        DANGER:    in the BROWNIAN noise there are a lot of very low and powerful
%                   bass that should damage your audio tools.
%                   by default these bass are removed, but if you set to
%                   'no' the option 'remove_brownian_bass' they are not
%                   removed.
%
% Examples:
% Y = noise( 10 , 44100 , 'pink' , 1 ) 
% Y = noise( 10 , 44100 , 'brownian', 1 , 'rand_gen' , 'normal' , 'sigma' , 0.4 ) ;
%

p = inputParser ;
gain_def = -6 ;
gain_def_lin = 10^(gain_def/20) ;

p.addParamValue('gain_dB', gain_def , @(x)isnumeric(x) && x <= 0 ) ;

p.addParamValue('gain_lin', gain_def_lin , @(x)isnumeric(x) ... 
    && x <= 1 && x >= 0 ) ;

p.addParamValue('rand_gen', 'uniform' , @(x)strcmpi(x,'uniform') || ... 
    strcmpi(x,'normal') ) ;

p.addParamValue('sigma' , 0.2 , @(x)isnumeric(x) && x <= 0.81 && x > 0 ) ;

p.addParamValue('remove_brownian_bass', 'yes' , @(x)strcmpi(x,'yes') || ... 
    strcmpi(x,'no') ) ;

p.parse(varargin{:});


gain = gain_def_lin ;

if p.Results.gain_dB ~= gain_def 
    gain = 10^( p.Results.gain_dB / 20 ) ;
end

if p.Results.gain_lin ~= gain_def_lin
    gain = p.Results.gain_lin ;
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
    
    F = [0 10 15  20000 22000] ; 
    if strcmpi( p.Results.remove_brownian_bass , 'yes' )
        dB = [ -200 -100 0 0 -100] ;
    else
        dB = [ 0 0 0 0 -100] ;
    end
    
    Y  = equalizer( Y , FS , F , dB ) ;
    
else
    error('error: noise type not allowed') ;
end


Y = gain_set( Y , FS , gain , 'lin' ) ;
time = samples*t ;

end


