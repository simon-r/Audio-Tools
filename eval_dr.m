function [ DR  DRM DR_STD ] = eval_dr( dyn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[n,x] = hist( dyn , 0:0.8:48 ) ;

mn = mean( dyn ) ;
sd = std( dyn ) ;

ml = 1.5 ;

n = n( x < mn + ml*sd ) ;
x = x( x < mn + ml*sd ) ;

x = x( n > 0 ) ;
n = n( n > 0 ) ;

sx = size( x , 2 ) ;
DR = x( sx ) - x( 1 ) ;

DRM = mn ;
DR_STD = sd ;

figure ;
plot( x , n ) ;
xlabel( 'dinamica [dB]' ) ;

end

