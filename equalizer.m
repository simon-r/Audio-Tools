function [ Y_eq ] = equalizer( Y , FS , F , dB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[samples channels] = size(Y) ;
if channels > 10
    error( 'too many audio channels' ) ;
end

Y_eq = zeros( [samples channels] ) ;

r_dB = fliplr( dB ) ;
dB = [dB r_dB] ;

rF = FS - fliplr(F) ;
F = [F rF] ;

eq_l = 10.^(dB/20) ;
eq_spar = pchip( F , eq_l ) ;

Ft = FS/samples * [1:samples] ;

Eq = ppval( eq_spar , Ft )' ;
% 
% 
semilogy ( Ft , Eq ) ;
grid on ;
% return ;

for i=1:channels
    Y_eq(:,i) = fft( Y(:,i) ) .* Eq ;
    Y_eq(:,i) = ifft( Y_eq(:,i) ) ;
end

Y_eq = real( Y_eq ) ;

end

