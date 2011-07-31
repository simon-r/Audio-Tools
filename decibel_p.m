function [ dB ] = decibel_p( x , ref )
%[ dB ] = decibel_p( x , ref )
%   returns the dB of power of x respect to ref

dB = 10 * log10( x ./ ref ) ;
end

