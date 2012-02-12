function [ d ] = diff_tracks( Y , X , cut )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

m = 2^16 ;

sX = size( X ) ;

r = cut:sX(1)-cut ;

d = sum( abs(m * X(r,:)  ) - abs( m * Y(r,:) ) ) ;
end

