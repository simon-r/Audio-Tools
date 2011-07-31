function [ dB ] = remove_complex( dB )
%[ dB ] = remove_complex( dB )
%   remove and replace the complex numbers with the minimal real from dB.
%   this function is useful with the dB vectors or matricies

im = find( imag( dB ) ) ;

if not( isempty( im ) )
    rep = min ( dB( find( not( imag( dB ) ) ) ) ) ;
    dB(im) = rep ;
end

end

