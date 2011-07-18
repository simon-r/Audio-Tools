function [ nX ] = oversampling2(  X , FS , nFS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xs = size( X ) ;

delta_time = FS/nFS ;

cs = spline( 1:xs(1) , X' ) ;
xt = 1:delta_time:xs(1) ;
nX = ppval( cs , xt )' ;

end

