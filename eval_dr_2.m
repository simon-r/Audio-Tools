function [ DR DRM DR_STD ] = eval_dr_2( dyn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s = size( dyn , 1 ) ;
dyn = sort ( dyn ) ;

s = size( dyn , 1 ) ;

cut = 10 ;
a = s-cut-20 ;
b = s-cut ;

a = cut ;
b = s - cut ;

DRM = mean ( dyn(a:b) ) ;

DR = abs ( dyn(b) - dyn(a) ) ;
DR_STD = std ( dyn(a:b) ) ;

figure ;
hist( dyn(a:b) , 0:0.8:48 ) ;
xlabel( 'dinamica [dB]' ) ;

end

