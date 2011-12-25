function [ Y ] = rebuild_track( Y , FS , th )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sY = size( Y ) ;

for i = 1:sY(2) 
    indx = find( not( Y(:,i) > th | Y(:,i) < -th ) ) ;
    indxn = find( Y(:,i) > th | Y(:,i) < -th ) ;
    
    Y(indxn,i) = spline( indx , Y(indx,i) , indxn ) ;  
end
end

