function [ Y ] = fade_inout( Y , FS , fade_time )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_fade_samples = floor( fade_time * FS ) + 1 ;
num_samples = length( Y ) ;

ch = min( size( Y ) ) ;

if num_fade_samples > num_samples 
    num_fade_samples = num_samples ; 
end

s=0:(num_fade_samples-1) ;

weight = 0.5 * (1 - cos( pi * s / ( num_fade_samples - 1 ) ) ) ;

r = num_samples:-1:(num_samples-num_fade_samples+1) ;

for i=1:ch
    Y(1:num_fade_samples,i) = Y(1:num_fade_samples,i) .* weight' ;
    Y(r,i) = Y(r,i) .* weight(1:num_fade_samples)' ;
end

end

