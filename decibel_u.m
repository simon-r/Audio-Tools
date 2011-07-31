function [ dB ] = decibel_u( x , ref )
%[ dB ] = decibel_p( x , ref )
%   returns the dB of amplitude of x respect to ref

dB = 20 * log10( x ./ ref ) ;

end

