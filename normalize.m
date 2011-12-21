function [ Y ] = normalize( Y , FS , lev )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

m = max( max( abs ( Y ) ) ) ;

Y = gain_set( Y , FS , lev/m , 'lin' ) ;
end

