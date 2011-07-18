function [ Y ] = white_noise( time , FS , ch )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

t = 1 / FS ;

samples = floor( time / t ) ;
Y = zeros(samples,ch) ;



end

