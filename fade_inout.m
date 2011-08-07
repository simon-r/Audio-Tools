function [ Y ] = fade_inout( Y , FS , fade_time )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_fade_samples = fade_time * FS ;
num_samples = length( Y ) ;

if num_fade_samples > num_samples 
    num_fade_samples = num_samples ; 
end

s=0:(num_fade_samples-1) ;

weight = 0.5 * (1 - cos( pi * s / ( num_fade_samples - 1)));

Y(1:num_fade_samples) = Y(1:num_fade_samples) .* weight' ;

r = num_samples:-1:(num_samples-num_fade_samples+1) ;
Y(r) = Y(r) .* weight(1:num_fade_samples)' ;

end

