function [ m ] = freq2midi( freq )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = 440 ;

m = round ( log( 2^9 * ( freq ./ a * 32 ).^12 ) / log(2) ) ;

end

